`ifndef resetGen_trans__svh
`define resetGen_trans__svh

class resetGen_trans extends uvm_sequence_item;

	string name;
	rand resetActive_enum active;
	rand int activeCycles;
	rand int delayCycles;
	constraint activeCyclesDefault_cst {
		activeCycles inside {[0:200]};
	};
	constraint delayCyclesDefault_cst {
		delayCycles inside {[0:200]};
	};

	`uvm_object_utils_begin(resetGen_trans)
	`uvm_object_utils_end

	function new (string name="resetGen_trans");
		super.new(name);
	endfunction

endclass


`endif
