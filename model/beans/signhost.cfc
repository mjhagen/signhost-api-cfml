component accessors=true {
  property beanFactory;
  property unirestService;
  property jsonJavaService;
  property fileService;
  property logService;

  property struct credentials;
  // property string sharedSecret;

  this.apiUrl = 'https://api.signhost.com/api';
  this.enum = {
    'TransactionStatus' = {
        '5' = 'Waiting for document',
       '10' = 'Waiting for signer',
       '20' = 'In progress',
       '30' = 'Signed',
       '40' = 'Rejected',
       '50' = 'Expired',
       '60' = 'Cancelled',
       '70' = 'Failed'
    },
    'SignerActivity' = {
      '101' = 'Invitation sent',
      '102' = 'Received',
      '103' = 'Opened',
      '104' = 'Reminder sent',
      '105' = 'Document opened',
      '201' = 'Cancelled',
      '202' = 'Rejected',
      '203' = 'Signed',
      '301' = 'Signed document sent',
      '302' = 'Signed document opended',
      '303' = 'Signed document downloaded',
      '401' = 'Receipt sent',
      '402' = 'Receipt opened',
      '403' = 'Receipt downloaded',
      '500' = 'Finished',
      '600' = 'Deleted',
      '700' = 'Expired',
      '999' = 'Failed'
    }
  };

  public component function init( beanFactory, fileService ) {
    structAppend( variables, arguments );
    variables.unirestService.contentType = 'json';
    variables.allVerificationTypes = __getAllVerificationTypes();
    return this;
  }

  public component function getInstance( required string appKey, required string apiKey ) {
    variables.credentials = {
      'Application' = 'APPKey #appKey#',
      'Authorization' = 'APIKey #apiKey#'
    };
    return this;
  }

  public string function getStatusText( required numeric status ) {
    if ( structKeyExists( this.enum.TransactionStatus, status ) ) return this.enum.TransactionStatus[ status ];
    if ( structKeyExists( this.enum.SignerActivity, status ) ) return this.enum.SignerActivity[ status ];
    return 'unknown';
  }



  // API Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  public struct function createTransaction( required component transactionObject ) {
    return __post( 'transaction', transactionObject.getMemento( true ) );
  }

  public struct function addOrReplaceFile( required string transactionId, required string fileName, required string filePath, string displayName ) {
    var payload = {
      'file' = createObject( 'java', 'java.io.File' ).init( filePath )
    };

    var headers = variables.credentials;

    // headers[ 'Digest' ] = 'SHA-256=' & fileService.getDigest( payload.file );
    headers[ 'Content-Type' ] = 'application/pdf';

    if ( !isNull( displayName ) ) {
      headers[ 'SH-DisplayName' ] = displayName;
    }

    var endpoint = '/transaction/' & transactionId & '/file/' & encodeForURL( hash( fileName ) );

    return __put( endpoint, payload, headers, 'multipart/form-data' );
  }

  public struct function startTransaction( required string transactionId ) {
    return __put( 'transaction/#transactionId#/start' );
  }

  public component function getTransaction( transactionId ) {
    return __toBean( __get( 'transaction/#transactionId#' ), 'Transaction' );
  }

  public struct function deleteTransaction( transactionId ) {
    return __delete( 'transaction/#transactionId#' );
  }

  public struct function getTransactionFile( required string transactionId, required string fileId ) {
    return __get( endpoint = 'transaction/#transactionId#/file/#fileId#', type = 'file' );
  }

  public any function getReceipt( required string transactionId ) {
    return __get( endpoint = 'file/receipt/#transactionId#', type = 'file' );
  }



  // INTERNAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  private any function __post( endpoint, any payload = {}, headers = variables.credentials ) {
    var result = unirestService.post( this.apiUrl & '/' & endpoint, payload, 0, 'json', headers );

    if ( !unirestService.isOK( result.statusCode ) ) return __reportError( result );

    if ( isJson( result.fileContent ) ) {
      return jsonJavaService.deserialize( result.fileContent );
    }
    return result;
  }

  private any function __get( endpoint, headers = variables.credentials, type = 'json' ) {
    var result = unirestService.get( this.apiUrl & '/' & endpoint, {}, 0, type, headers );

    if ( !unirestService.isOK( result.statusCode ) ) return __reportError( result );

    if ( isJson( result.fileContent ) ) {
      return jsonJavaService.deserialize( result.fileContent );
    }

    return result;
  }

  private any function __delete( endpoint, headers = variables.credentials ) {
    var result = unirestService.delete( this.apiUrl & '/' & endpoint, {}, 0, 'json', headers );
    if ( !unirestService.isOK( result.statusCode ) ) return __reportError( result );
    return result;
  }

  private any function __put( endpoint, any payload = {}, headers = variables.credentials, string type = 'json' ) {
    try {
      var result = unirestService.put( this.apiUrl & '/' & endpoint, payload, 0, type, headers );
      if ( !unirestService.isOK( result.statusCode ) ) return __reportError( result );
      return result;
    } catch ( any e ) {
      writeDump( e );
      abort;
    }
  }



  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  private component function __toVerificationBean( verificationType ) {
    return variables.allVerificationTypes[ verificationType ];
  }

  private component function __toBean( input, type ) {
    if ( type == 'Verification' ) {
      param input.Type='unknown';
      var asBean = __toVerificationBean( input.Type );
    } else {
      var asBean = beanFactory.getBean( type & 'Bean' );
    }
    var props = asBean.getInheritedProperties();

    var result = {};
    for ( var key in props ) {
      if ( !structKeyExists(input, key) || isNull( input[ key ] ) ) continue;

      var definition = props[ key ];
      param definition.type='string';
      param definition.cfc='unknown';

      switch ( definition.type ) {
        case 'struct':
          result[ key ] = {};
          for ( var id in input[ key ] ) {
            result[ key ][ id ] = __toBean( input[ key ][ id ], definition.cfc );
          }
          break;

        case 'array':
          result[ key ] = [];
          for ( var item in input[ key ] ) {
            arrayAppend( result[ key ], __toBean( item, definition.cfc ) );
          }
          break;

        default:
          result[ key ] = input[ key ];
      }
    }

    return beanFactory.injectProperties( asBean, result );
  }

  private struct function __getAllVerificationTypes() {
    var result = {};
    var tmp = directoryList( getDirectoryFromPath( getCurrentTemplatePath() ) & '../beans/verifications', false, 'name', '*.cfc' );
    tmp.each( function( file ) {
      var verificationBean = beanFactory.getBean( replace( file, '.cfc', '' ) & 'Verification' );
      result[ verificationBean.getType() ] = verificationBean;
    } );
    return result;
  }

  private void function __reportError( result ) {
    if ( !isNull( result ) ) {
      logService.dumpToFile( result, true, true );
    } else {
      result = '';
    }

    if ( !isStruct( result ) || !structKeyExists( result, 'fileContent' ) || !isJson( result.fileContent ) ) {
      throw( 'Invalid response', 'nativeError.reportError.signhostService' );
    }

    var asStruct = jsonJavaService.deserialize( result.fileContent );

    param asStruct.message='unspecified error';

    throw( 'API Native error: #asStruct.message#', 'apiNativeError.reportError.signhostService' );
  }
}