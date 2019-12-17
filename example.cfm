<cfscript>
bf = application.beanFactory;

APPNAME = '';
APPKEY = '';
APIKEY = '';

signhost = bf.getBean( 'signhostService' ).getInstance( apiKey = '#APIKEY#', appKey = '#APPNAME# #APPKEY#' );
writeDump(signhost);abort;
new_transaction = signhost.createTransaction( createSampleTransaction() );

signhost.addOrReplaceFile( new_transaction.Id, 'First Document', 'PathToFile' );
signhost.addOrReplaceFile( new_transaction.Id, 'General Agreement', 'PathOtherFile' );

// When everything is setup we can start the transaction flow
signhost.startTransaction( new_transaction.Id );

function createSampleTransaction() {
  var signer = bf.injectProperties( 'SignerBean', { Email = 'john.doe@example.com' } );

  signer.setScribbleName( "John Doe" );
  signer.setSignRequestMessage( "Could you please sign this document?" );
  signer.setSendSignRequest( true );

  return bf.injectProperties( 'TransactionBean', { Signers = [ signer ] } );
}

</cfscript>