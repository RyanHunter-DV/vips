`ifndef resetGenConfig__svh
`define resetGenConfig__svh
class ResetGenConfig extends uvm_object;
	bit enabled[int];
	logic inactive[int];
	ResetGenIf vif;
	`uvm_object_utils_begin(ResetGenConfig)
		`uvm_field_aa_int_int(enabled,UVM_ALL_ON)
		`uvm_field_aa_int_int(inactive,UVM_ALL_ON)
	`uvm_object_utils_end
	extern  function  new(string name="ResetGenConfig");
	extern  function void enable(int index,logic ia);
endclass



function  ResetGenConfig::new(string name="ResetGenConfig");
	super.new(name);
endfunction
function void ResetGenConfig::enable(int index,logic ia);
	enabled[index]=1;
	inactive[index]=ia;
endfunction
`endif
