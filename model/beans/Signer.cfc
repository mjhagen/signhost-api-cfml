component accessors=true extends="cava.lib.cfml.signhost-api.abstracts.signhostBean" {
  property string id;
  property string email;
  property string mobile;
  property string BSN;
  property boolean requireScribble;
  property boolean requireSmsVerification;
  property boolean requireDigidVerification;
  property boolean requireKennisnetVerification;
  property boolean requireSurfnetVerification;
  property array verifications;
  property boolean sendSignRequest;
  property string signRequestMessage;
  property boolean sendSignConfirmation;
  property string language;
  property string scribbleName;
  property boolean scribbleNameFixed;
  property numeric daysToRemind;
  property string expires;
  property string reference;
  property string returnUrl;
  property array activities;
  property any context;
}