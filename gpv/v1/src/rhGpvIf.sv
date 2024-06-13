`ifndef rhGpvIf__sv
`define rhGpvIf__sv

interface RhGpvIf();
	// @RyanH, TODO, need separate the vector out and vector in, for
	// vector out, interface drive by driver component; vector in, interface
	// only used to be collected by monitor and DUT will drive the signals
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector_in;
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector_out;
	logic [`RHGPV_MAX_CLOCK_WIDTH-1:0] clock;
	logic [`RHGPV_MAX_RESET_WIDTH-1:0] reset;


	function automatic void driveVector(int spos,logic bits[]);
		foreach (bits[i]) begin
			automatic int pos = spos+i;
			// $display("vector_out, pos: %0d, val: %0b",pos,bits[pos]);
			vector_out[pos] = bits[pos-spos];
		end
	endfunction

	function automatic logic[`RHGPV_MAX_VECTOR_WIDTH-1:0] getVectorOut (int s,int e);
		automatic logic[`RHGPV_MAX_VECTOR_WIDTH-1:0] rtn;
		automatic int pos;
		for (pos=0;pos<e-s+1;pos++) rtn[pos]=vector_out[pos+s];
		return rtn;
	endfunction
	function automatic logic[`RHGPV_MAX_VECTOR_WIDTH-1:0] getVectorIn(int s,int e);
		automatic logic[`RHGPV_MAX_VECTOR_WIDTH-1:0] rtn;
		automatic int pos;
		for (pos=0;pos<e-s+1;pos++) begin
			// $display($time,", get pos: %0d,pos+s: %0d",pos,pos+s);
			// $display($time,",vector_in[%0d]=>%0h",pos+s,vector_in[pos+s]);
			rtn[pos]=vector_in[pos+s];
			// $display($time,",rtn[%0d]=>%0h",pos,rtn[pos]);
		end
		// $display($time,"call getVectorIn, s:%0d,e:%0d,return: %0h",s,e,rtn[0]);
		// $display($time,"get vector_in[33]: %0h",vector_in[33]);
		return rtn;
	endfunction
	function automatic logic getReset(int s);
		return reset[s];
	endfunction

	task sync(int pos,int cycle);
		repeat (cycle) @(posedge clock[pos]);
	endtask

endinterface

`endif
