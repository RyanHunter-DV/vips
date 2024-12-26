`ifndef ResetGenBaseSeq__svh
`define ResetGenBaseSeq__svh

class ResetGenBaseSeq#(type TR=ResetGenTrans) extends uvm_sequence;

	realtime drainTime=100us;

	`uvm_object_utils_begin(ResetGenBaseSeq#(TR))
	`uvm_object_utils_end

	function new(string name="ResetGenBaseSeq");
		super.new(name);
	endfunction

	//virtual task body(); endtask
endclass

`endif