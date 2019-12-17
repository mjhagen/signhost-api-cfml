component accessors=true extends="cava.lib.cfml.signhost-api.abstracts.signhostBean" {
  property Type;
}

/*
  Types:
  - Consent
  - DigiD
  - eHerkenning
  - eIDAS Login
  - iDeal
  - iDIN
  - itsme Identification
  - Kennisnet
  - PhoneNumber
  - Scribble
  - SigningCertificate
  - SURFnet

  Type of the verification object. The Type property must be the first property
  in the json!

  The order in which the verifications are provided determine in which order the
  signer will have to perform the specified method. You must use one of the
  following verifications as the last method:
  - Consent
  - PhoneNumber
  - Scribble
  - SigningCertificate
 */