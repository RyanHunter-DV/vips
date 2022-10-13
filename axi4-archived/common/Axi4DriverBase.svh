`ifndef Axi4DriverBase__svh
`define Axi4DriverBase__svh

virtual class Axi4DriverBase #(type REQ=Axi4SeqItem,RSP=REQ)
	extends VipDriverBase#(REQ,RSP); // {

	local Axi4ConfigBase config;

	// `uvm_component_utils_begin(Axi4DriverBase#(REQ,RSP))
	// `uvm_component_utils_end

	function new(string name="Axi4DriverBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);
endclass // }

function void Axi4DriverBase::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
endfunction // }

`endif
