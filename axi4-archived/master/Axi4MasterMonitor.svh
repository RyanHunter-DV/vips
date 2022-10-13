`ifndef Axi4MasterMonitor__svh
`define Axi4MasterMonitor__svh

class Axi4MasterMonitor extends Axi4MonitorBase; // {

	`uvm_component_utils(Axi4MasterMonitor)

	function new(string name="Axi4MasterMonitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction


endclass // }

`endif
