`ifndef Axi4SlaveAgent__svh
`define Axi4SlaveAgent__svh

class Axi4SlaveAgent extends Axi4AgentBase; // {

	Axi4ResponseHandlerBase rsph;

	`uvm_component_utils(Axi4SlaveAgent)

	function new(
		string name="Axi4SlaveAgent",
		uvm_component parent=null,
		uvm_active_passive_enum _active
	);
		super.new(name,parent);
		is_active = _active;
	endfunction


	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass // }

function void Axi4SlaveAgent::connect_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
	if (is_active==UVM_ACTIVE) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
		mon.reqP.connect(rsph.reqI);
		rsph.setSeqr(seqr);
	end
endfunction // }

function void Axi4SlaveAgent::build_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
	if (is_active==UVM_ACTIVE) begin
		drv = Axi4SlaveDriver::type_id::create("drv",this);
		seqr= Axi4SlaveSeqr::type_id::create("seqr",this);
		rsph= Axi4ResponseHandler::type_id::create("rsph",this);
	end
	mon = Axi4SlaveMonitor::type_id::create("mon",this);
endfunction // }

`endif
