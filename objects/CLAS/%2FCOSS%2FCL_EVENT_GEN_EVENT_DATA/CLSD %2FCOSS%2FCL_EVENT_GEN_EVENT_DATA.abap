class-pool .
*"* class pool for class /COSS/CL_EVENT_GEN_EVENT_DATA

*"* local type definitions
include /COSS/CL_EVENT_GEN_EVENT_DATA=ccdef.

*"* class /COSS/CL_EVENT_GEN_EVENT_DATA definition
*"* public declarations
  include /COSS/CL_EVENT_GEN_EVENT_DATA=cu.
*"* protected declarations
  include /COSS/CL_EVENT_GEN_EVENT_DATA=co.
*"* private declarations
  include /COSS/CL_EVENT_GEN_EVENT_DATA=ci.
endclass. "/COSS/CL_EVENT_GEN_EVENT_DATA definition

*"* macro definitions
include /COSS/CL_EVENT_GEN_EVENT_DATA=ccmac.
*"* local class implementation
include /COSS/CL_EVENT_GEN_EVENT_DATA=ccimp.

*"* test class
include /COSS/CL_EVENT_GEN_EVENT_DATA=ccau.

class /COSS/CL_EVENT_GEN_EVENT_DATA implementation.
*"* method's implementations
  include methods.
endclass. "/COSS/CL_EVENT_GEN_EVENT_DATA implementation
