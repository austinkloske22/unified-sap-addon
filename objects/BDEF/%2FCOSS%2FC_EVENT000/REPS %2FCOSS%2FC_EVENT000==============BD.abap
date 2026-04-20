projection implementation in class /COSS/BP_C_EVENT000 unique;
strict ( 2 );
extensible;
use draft;
use side effects;
define behavior for /COSS/C_EVENT000 alias /coss/cEvent000
extensible
use etag
{
  use create;
  use update;
  use delete;

  use action Edit;
  use action Activate;
  use action Discard;
  use action Resume;
  use action Prepare;

}