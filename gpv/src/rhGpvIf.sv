`ifndef rhGpvIf__sv
`define rhGpvIf__sv

interface RhGpvIf();
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector;
	logic [`RHGPV_MAX_CLOCK_WIDTH-1:0] clock;
endinterface