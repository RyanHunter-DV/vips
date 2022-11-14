`ifndef clockGen_monitor__svh
`define clockGen_monitor__svh

class clockGen_monitor #(type REQ=clockGen_trans) extends uvm_monitor#(REQ);

	clockGen_config cfg;

	`uvm_component_utils_begin(clockGen_monitor#(REQ))
	`uvm_component_utils_end

	function new (string name="clockGen_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

endclass


`endif
