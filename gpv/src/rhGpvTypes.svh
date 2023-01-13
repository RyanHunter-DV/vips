`ifndef rhGpvTypes__svh
`define rhGpvTypes__svh

`define RHGPV_MAX_VECTOR_WIDTH 1024
`define RHGPV_MAX_CLOCK_WIDTH 16
`define RHGPV_MAX_RESET_WIDTH 16


typedef bit [`RHGPV_MAX_VECTOR_WIDTH-1:0] bitVector_t;
typedef logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] logicVector_t;




`endif