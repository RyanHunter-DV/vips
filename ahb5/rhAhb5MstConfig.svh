`ifndef rhAhb5MstConfig__svh
`define rhAhb5MstConfig__svh

class RhAhb5MstConfig extends uvm_object;
	RhAhb5IfControlBase ifCtrl;
	`uvm_object_utils_begin(RhAhb5MstConfig)
	`uvm_object_utils_end
	extern task sendAddressPhase(RhAhb5TransBeat b,int outstanding);
	extern task sendDataPhase(RhAhb5TransBeat b,output isError);
	extern task waitResetChanged(output logic s);
	extern function  new(string name="RhAhb5MstConfig");
endclass
task RhAhb5MstConfig::sendAddressPhase(RhAhb5TransBeat b,int outstanding);
	bit busy = outstanding? 1'b1 : 1'b0;
	ifCtrl.driveAddressPhase(b,busy);
endtask
task RhAhb5MstConfig::sendDataPhase(RhAhb5TransBeat b,output isError);
	if (b.write)
		ifCtrl.driveDataPhase(b,isError);
	else ifCtrl.waitDataPhase(b,isError);
endtask
task RhAhb5MstConfig::waitResetChanged(output logic s);
	ifCtrl.getResetChanged(s);
endtask
function  RhAhb5MstConfig::new(string name="RhAhb5MstConfig");
	super.new(name);
endfunction

`endif
