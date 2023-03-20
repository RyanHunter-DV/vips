`ifndef resetGenTrans__svh
`define resetGenTrans__svh
class ResetGenTrans extends uvm_sequence_item;
	logic value;
	int index;
	realtime stime;
	`uvm_object_utils_begin(ResetGenTrans)
		`uvm_field_int(value,UVM_ALL_ON)
		`uvm_field_int(index,UVM_ALL_ON)
		`uvm_field_real(stime,UVM_ALL_ON)
	`uvm_object_utils_end
	extern  function  new(string name="ResetGenTrans");
endclass



function  ResetGenTrans::new(string name="ResetGenTrans");
	super.new(name);
endfunction
`endif
