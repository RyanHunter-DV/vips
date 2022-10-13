`ifndef Axi4AgentBase__svh
`define Axi4AgentBase__svh

class Axi4AgentBase extends VipAgentBase; // {

	Axi4ConfigBase config;

	`uvm_component_utils_begin(Axi4AgentBase)
	`uvm_component_utils_end

	function new(string name="Axi4AgentBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void connect_phase(uvm_phase phase);
endclass // }

function void Axi4AgentBase::connect_phase(uvm_phase phase); // {
	super.connect_phase(phase);
endfunction // }

`endif
