`ifndef rh_axi4_monitorBase__svh
`define rh_axi4_monitorBase__svh

class rh_axi4_monitorBase extends uvm_monitor;

	`uvm_component_utils(rh_axi4_monitorBase)

	function new(string name="rh_axi4_monitorBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass

`endif
