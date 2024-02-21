`ifndef ResetGenBaseSeq__svh
`define ResetGenBaseSeq__svh

class ResetGenBaseSeq extends uvm_sequence;
	parameter type TR=ResetGenTrans;

	realtime drainTime=100us;

	`uvm_object_utils_begin(ResetGenBaseSeq#(TR))
	`uvm_object_utils_end

	function new(string name="ResetGenBaseSeq");
		super.new(name);
	endfunction

	extern virtual task body();
endclass
task ResetGenBaseSeq::body(); //##{{{
endtask // ##}}}

`endif