managed implementation in class /COSS/BP_R_EVENT000 unique;
strict ( 2 );
with draft;
extensible;
define behavior for /COSS/R_EVENT000 alias /coss/rEvent000
persistent table /COSS/EVENT
extensible
draft table /COSS/EVENT_D
etag master LocalLastChangedAt
lock master total etag LastChangedAt
authorization master( global )
{
  field ( numbering : managed, readonly )
    EventUUID;

  field ( readonly )
   CreatedBy,
   ChangedBy,
   LocalLastChangedAt,
   LastChangedAt;


  create;
  update;
  delete;

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

  mapping for /COSS/EVENT corresponding extensible
  {
    EventUUID = EVENT_UUID;
    EventID = EVENT_ID;
    EventName = EVENT_NAME;
    Location = LOCATION;
    IsOnline = IS_ONLINE;
    DateFrom = DATE_FROM;
    DateTo = DATE_TO;
    CreatedBy = CREATED_BY;
    ChangedBy = CHANGED_BY;
    LocalLastChangedAt = LOCAL_LAST_CHANGED_AT;
    LastChangedAt = LAST_CHANGED_AT;
  }

}