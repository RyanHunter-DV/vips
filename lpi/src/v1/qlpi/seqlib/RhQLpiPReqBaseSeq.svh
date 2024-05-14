`ifndef RhQLpiPReqBaseSeq__svh
`define RhQLpiPReqBaseSeq__svh

class RhQLpiPReqBaseSeq extends uvm_sequence;

	
	`uvm_object_utils_begin(RhQLpiPReqBaseSeq)
	`uvm_object_utils_end

	function new(string name="RhQLpiPReqBaseSeq");
		super.new(name);
	endfunction

	extern virtual task body();
endclass
task RhQLpiPReqBaseSeq::body(); //##{{{
	RhQLpiReqTrans tr=new("");
	tr.randomize();
	`RhdInfo($sformatf("send trans:\n%s",tr.sprint()))
	start_item(tr);
	finish_item(tr);
endtask // ##}}}


`endif