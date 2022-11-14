`ifndef clockGen_trans__svh
`define clockGen_trans__svh

class clockGen_trans extends uvm_sequence_item;

	string name;
	real freq;
	real skew;
	real jitter;

	`uvm_object_utils_begin(clockGen_trans)
	`uvm_object_utils_end

	function new (string name="clockGen_trans");
		super.new(name);
	endfunction

endclass


`endif
