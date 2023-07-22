`ifndef RhQLpiTrans__svh
`define RhQLpiTrans__svh

class RhQLpiReqTrans extends uvm_sequence_item;

	rand int delay;
	// value of lp duration, if is -1, then will generate a random one according
	// to the config, or else use this field.
	rand int lpDuration;
	rand bit active;
	rand bit ignoreQActive;

	constraint delayCst{delay inside {[0:1000]};}
	constraint lpDurationDefaultCst {soft lpDuration == -1;}

	`uvm_object_utils_begin(RhQLpiReqTrans)
		`uvm_field_int(delay,UVM_ALL_ON)
		`uvm_field_int(lpDuration,UVM_ALL_ON)
		`uvm_field_int(ignoreQActive,UVM_ALL_ON)
		`uvm_field_int(active,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="RhQLpiReqTrans");
		super.new(name);
	endfunction

endclass

// This trans used to record a state change of the power, from is current state
// while to is the next changed to state.
class RhQLpiStateTrans extends uvm_sequence_item;

	state_t from,to;

	`uvm_object_utils_begin(RhQLpiStateTrans)
		`uvm_field_enum(from,RhQLpiState,UVM_ALL_ON)
		`uvm_field_enum(to,RhQLpiState,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="RhQLpiStateTrans");
		super.new(name);
	endfunction

endclass



`endif