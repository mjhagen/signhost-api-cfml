component accessors=true extends="cava.lib.cfml.signhost-api.abstracts.signhostBean" {
  property string id;
  property struct files;
  property boolean seal;
  property array signers;
  property array receivers;
  property string reference;
  property string postbackUrl;
  property numeric signRequestMode;
  property numeric daysToExpire;
  property boolean sendEmailNotifications;
  property numeric context;
  property any status;
}