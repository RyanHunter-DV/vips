`ifndef rhGpvIf__sv
`define rhGpvIf__sv

interface RhGpvIf();
	// @RyanH, TODO, need separate the vector out and vector in, for
	// vector out, interface drive by driver component; vector in, interface
	// only used to be collected by monitor and DUT will drive the signals
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector_in;
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector;
	logic [`RHGPV_MAX_CLOCK_WIDTH-1:0] clock;
	logic [`RHGPV_MAX_RESET_WIDTH-1:0] reset;


	function void driveVector(int spos,logic bits[]);
		int size = bits.size();
		for (int pos=spos;pos<spos+size;pos++) begin
			vector[pos] = bits[pos-spos];
		end
	endfunction

	function getVector (int s,int e);
		logic[`RHGPV_MAX_VECTOR_WIDTH-1:0] rtn;
		for (int pos=0;pos<e-s+1;pos++) rtn[pos]=vector[pos+s];
		return rtn;
	endfunction

	task sync(int pos,int cycle);
		repeat (cycle) @(posedge clock[pos]);
	endtask

endinterface

`endif
