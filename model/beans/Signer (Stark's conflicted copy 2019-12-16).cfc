component accessors=true extends="signhost-api.abstracts.signhostBean" {
  property string Id;
  property type='string' name='Email' required=true;
  property string IntroText;
  property type='array' name='Verifications' cfc='Verification';
  property type='boolean' name='SendSignRequest' default=false;
  property string SignUrl;
  property string SignRequestSubject;
  property string SignRequestMessage;
  property boolean SendSignConfirmation;
  property type='string' name='Language' default='nl-NL' hint='de-DE,en-US,es-ES,fr-FR,it-IT,nl-NL';
  property string ScribbleName;
  property numeric DaysToRemind;
  property string Expires;
  property string Reference;
  property string RejectReason;
  property string ReturnUrl;
  property any Context;
  property type='array' name='Activities' cfc='Activity';

  property string Mobile;
  property string Iban;
  property string BSN;

  property boolean RequireEmailVerification;
  property boolean RequireSmsVerification;
  property boolean RequireDigidVerification;
  property boolean RequireKennisnetVerification;
  property boolean RequireSurfnetVerification;
  property boolean RequireScribble;

  property boolean ScribbleNameFixed;
}