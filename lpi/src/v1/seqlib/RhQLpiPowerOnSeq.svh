`ifndef RhQLpiPowerOnSeq__svh
`define RhQLpiPowerOnSeq__svh

class RhQLpiPowerOnSeq extends RhQLpiPReqBaseSeq;
	`uvm_object_utils_begin(RhQLpiPowerOnSeq)
	`uvm_object_utils_end
	function new(string name="RhQLpiPowerOnSeq");
		super.new(name);
	endfunction
	extern virtual task body();
endclass

task RhQLpiPowerOnSeq::body(); //##{{{
	RhQLpiReqTrans tr=new("");
	tr.randomize() with {powerOn==1;};
	`RhdInfo($sformatf("send trans:\n%s",tr.sprint()))
	start_item(tr);
	finish_item(tr);
endtask // ##}}}


`endif