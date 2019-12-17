component accessors=true extends="cava.lib.cfml.signhost-api.abstracts.signhostBean" {
  property string displayname; // string
  property numeric displayorder; // integer
  property string description; // string
  property struct signers; // map of <string,formsets>
  property struct formsets; // map of <string,map of <string,formsetfield>>
}
