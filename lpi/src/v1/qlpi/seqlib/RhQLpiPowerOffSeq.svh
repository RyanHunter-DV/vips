`ifndef RhQLpiPowerOffSeq__svh
`define RhQLpiPowerOffSeq__svh

class RhQLpiPowerOffSeq extends RhQLpiPReqBaseSeq;

	rand int duration;
	
	`uvm_object_utils_begin(RhQLpiPowerOffSeq)
		`uvm_field_int(duration,UVM_ALL_ON|UVM_DEC)
	`uvm_object_utils_end

	constraint durationCstDefault {
		duration inside {[10:100]};
	}

	function new(string name="RhQLpiPowerOffSeq");
		super.new(name);
	endfunction
	extern virtual task body();
endclass
task RhQLpiPowerOffSeq::body(); //##{{{
	RhQLpiReqTrans tr=new("");
	tr.randomize() with {
		powerOn==0;
		lpDuration==duration;
	};
	`RhdInfo($sformatf("send trans:\n%s",tr.sprint()))
	start_item(tr);
	finish_item(tr);
endtask // ##}}}


`endif