`ifndef omosMemoryResponder__svh
`define omosMemoryResponder__svh

class OmosMemoryResponder extends RhAhb5SlvResponderBase;
	
	
	`uvm_object_utils(OmosMemoryResponder);

	function new(string name = "OmosMemoryResponder");
		super.new(name);
	endfunction

	
endclass



`endif
