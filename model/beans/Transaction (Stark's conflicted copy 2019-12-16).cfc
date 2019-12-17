component accessors=true extends="signhost-api.abstracts.signhostBean" {
  property string Id;
  property type="struct" name="Files" cfc="FileEntry";
  property type="boolean" name="Seal" default=false;
  property type="array" name="Signers" cfc="Signer";
  property type="array" name="Receivers" cfc="Receiver";
  property type="string" name="Reference";
  property type="string" name="PostbackUrl";
  property type="numeric" name="SignRequestMode" default=2 hint="Set to 1 for sending at once, to 2 for sequential. Ignored if SendSignRequest is set to false.";
  property type="numeric" name="DaysToExpire" default=60 hint="Amount of days before expiration. Max 90 days.";
  property type="boolean" name="SendEmailNotifications" default=false;
  property any Status;
  property date CanceledDateTime;
  property date CreatedDateTime;
  property date ModifiedDateTime;
  property string CancelationReason;
  property type="boolean" name="SendSignRequest" default=false;
  property string SignRequestSubject;
  property string SignRequestMessage;
  property type="string" name="Context" hint="Any valid json object which we will return back to you when doing a GET on the transaction or when we send a postback.";
  /*
    Status

    5 - Waiting for document
    10 - Waiting for signer
    20 - In progress
    30 - Signed (end state)
    40 - Rejected (end state)
    50 - Expired (end state)
    60 - Cancelled (end state)
    70 - Failed (end state)

   */
}