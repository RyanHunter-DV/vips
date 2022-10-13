`ifndef Axi4MasterAgent__svh
`define Axi4MasterAgent__svh

class Axi4MasterAgent extends Axi4AgentBase; // {

	`uvm_component_utils(Axi4MasterAgent)

	function new(
		string name="Axi4MasterAgent",
		uvm_component parent=null,
		uvm_active_passive_enum _active=UVM_ACTIVE
	);
		super.new(name,parent);
		is_active = _active;
	endfunction


	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass // }

function void Axi4MasterAgent::connect_phase(uvm_phase phase); // {
	super.connect_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
		mon.rspP.connect(drv.rspI);
	end
endfunction // }

function void Axi4MasterAgent::build_phase(uvm_phase phase); // {
	if (is_active==UVM_ACTIVE) begin
		drv = Axi4MasterDriver::type_id::create("drv",this);
		seqr= Axi4MasterSeqr::type_id::create("seqr",this);
	end
	mon = Axi4MasterMonitor::type_id::create("mon",this);
endfunction // }

`endif
