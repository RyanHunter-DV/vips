`ifndef rhAhb5IfControlBase__svh
`define rhAhb5IfControlBase__svh

class RhAhb5IfControlBase extends uvm_object;
	`uvm_object_utils_begin(RhAhb5IfControlBase)
	`uvm_object_utils_end
	extern virtual task driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
	extern virtual task driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern virtual task waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern virtual task getResetChanged(output logic s);
	extern function  new(string name="RhAhb5IfControlBase");
endclass
task RhAhb5IfControlBase::driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
endtask
task RhAhb5IfControlBase::driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
endtask
task RhAhb5IfControlBase::waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
endtask
task RhAhb5IfControlBase::getResetChanged(output logic s);
endtask
function  RhAhb5IfControlBase::new(string name="RhAhb5IfControlBase");
	super.new(name);
endfunction

`endif
