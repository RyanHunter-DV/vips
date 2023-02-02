`ifndef rhAhb5SeqBase__svh
`define rhAhb5SeqBase__svh

class RhAhb5SeqBase extends uvm_sequence;

	//RhAhb5MstConfig config;
	
	`uvm_object_utils(RhAhb5SeqBase);

	function new(string name = "RhAhb5SeqBase");
		super.new(name);
	endfunction
	
endclass

`endif
