managed implementation in class /COSS/BP_R_EVENT unique;
strict ( 2 );
extensible;
define behavior for /COSS/R_EVENT alias /coss/rEvent
persistent table /COSS/EVENT
extensible
etag master LocalLastChangedAt
lock master
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