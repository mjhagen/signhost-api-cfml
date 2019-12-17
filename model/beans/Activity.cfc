component accessors=true extends="signhost-api.abstracts.signhostBean" {
  property Id;
  property Code;
  property Info;
  property CreatedDateTime;

  /*

    Code:
    101 - Invitation sent
    102 - Received
    103 - Opened
    104 - Reminder sent
    105 - Document opened, Info property contains the file id of the opened document.
    201 - Cancelled
    202 - Rejected
    203 - Signed
    301 - Signed document sent
    302 - Signed document opended
    303 - Signed document downloaded
    401 - Receipt sent
    402 - Receipt opened
    403 - Receipt downloaded

   */
}