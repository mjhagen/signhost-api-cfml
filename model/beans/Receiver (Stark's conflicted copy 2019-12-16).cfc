component accessors=true extends="signhost-api.abstracts.signhostBean" {
  property string Id;
  property type='string' name='Name' required=true;
  property type='string' name='Email' required=true;
  property type='string' name='Language' default='nl-NL' hint='de-DE,en-US,es-ES,fr-FR,it-IT,nl-NL';
  property type='string' name='Subject' length=64;
  property type='string' name='Message' required=true;
  property string Reference;
  property string Context;
  property array Activities;
  property date CreatedDateTime;
  property date ModifiedDateTime;
}