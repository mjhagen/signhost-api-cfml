component accessors=true {
  public component function init() {
    structAppend( variables, arguments );
    this.md = getMetadata( this );
    variables.all_properties = getInheritedProperties();
    return this;
  }

  public struct function getMemento( boolean skipEmptyFields = false ) {
    var result = structNew( 'ordered' );

    // Type key must be first for verification objects:
    if ( this.md.fullname contains '.verifications.' ) {
      var tmpProps = structNew( 'ordered' );
      tmpProps[ 'Type' ] = variables.all_properties.type;
      variables.all_properties.each(function(key){
        if ( key == 'Type' ) continue;
        tmpProps[ key ] = variables.all_properties[ key ];
      });
      variables.all_properties = tmpProps;
    }

    for ( var key in variables.all_properties ) {
      var field = variables.all_properties[ key ];

      param field.type="string";

      if ( !structKeyExists( variables, field.name ) || isNull( variables[ field.name ] ) ) {
        variables[ field.name ] = '';
      }

      if ( skipEmptyFields && isEmptyValue( variables[ field.name ] ) ) {
        continue;
      }

      var value = variables[ field.name ];

      if ( isArray( value ) ) {
        result[ field.name ] = [];
        for ( var item in value ) {
          if ( isObject( item ) ) {
            result[ field.name ].append( item.getMemento( skipEmptyFields ) );
          } else {
            result[ field.name ].append( item );
          }
        }
      } else if ( isObject( value ) ) {
        result[ field.name ] = value.getMemento( skipEmptyFields );
      } else {
        if ( isNull( value ) || isObject( value ) ) {
          switch ( field.type ) {
            case 'struct' : value = {}; break;
            case 'array' : value = []; break;
            default: value = ''; break;
          }
        }
        result[ field.name ] = value;
      }
    }

    return result;
  }

  public struct function getInheritedProperties() {
    var md = this.md;
    var result = {};

    do {
      var properties = [];

      if ( !isNull( md.properties ) ) {
        var numberOfProperties = arrayLen( md.properties );

        for ( var i = 1; i <= numberOfProperties; i++ ) {
          arrayAppend( properties, md.properties[ i ] );
        }
      }

      for ( var property in properties ) {
        if ( skipProperty( property.name ) ) {
          continue;
        }

        if ( !structKeyExists( result, property.name ) ) {
          result[ property.name ] = {};
        }

        structAppend( result[ property.name ], property, false );
      }

      md = md.extends;
    } while ( structKeyExists( md, 'extends' ) );

    return result;
  }

  private boolean function skipProperty( required string propertyName ) {
    var skipPropertiesThatEndIn = [ 'Factory', 'Service' ];
    var skipPropertiesNamed = [ 'framework', 'beanfactory', 'config' ];

    for ( var word in skipPropertiesNamed ) {
      if ( propertyName == word ) {
        return true;
      }
    }

    for ( var word in skipPropertiesThatEndIn ) {
      if ( right( propertyName, len( word ) ) == word ) {
        return true;
      }
    }

    return false;
  }

  private boolean function isEmptyValue( any value ) {
    if ( isNull( value ) ) {
      return true;
    }

    if ( isSimpleValue( value ) && !len( trim( value ) ) ) {
      return true;
    }

    if ( isArray( value ) && arrayIsEmpty( value ) ) {
      return true;
    }

    if ( isStruct( value ) && structIsEmpty( value ) ) {
      return true;
    }

    return false;
  }
}