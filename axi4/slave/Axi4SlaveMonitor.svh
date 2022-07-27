`ifndef Axi4SlaveMonitor__svh
`define Axi4SlaveMonitor__svh

class Axi4SlaveMonitor extends Axi4MonitorBase; // {


	`uvm_component_utils(Axi4SlaveMonitor)

	function new(string name="Axi4SlaveMonitor",uvm_component parent=null);
		super.new(name,parent);
	endfunction


endclass // }

`endif
