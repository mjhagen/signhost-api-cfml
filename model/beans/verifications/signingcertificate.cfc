component accessors=true extends="signhost-api.model.beans.verification" {
  property Issuer;
  property Subject;
  property Thumbprint;
  variables.Type = 'SigningCertificate';
}