`ifndef resetGen_monitor__svh
`define resetGen_monitor__svh

class resetGen_monitor #(type REQ=resetGen_trans) extends uvm_monitor;

	resetGen_configBase cfg;

	`uvm_component_utils_begin(resetGen_monitor#(REQ))
	`uvm_component_utils_end

	function new (string name="resetGen_monitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

endclass


`endif
