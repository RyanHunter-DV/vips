`ifndef rhGpvDriver__svh
`define rhGpvDriver__svh

class RhGpvDriever #(type REQ=uvm_sequence_item,RSP=REQ) extends RhDriverBase#(REQ,RSP);

	RhGpvProtocolBase protocol;

	`uvm_component_utils(RhGpvDriever#(REQ,RSP))

	function new(string name="RhGpvDriever",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task mainProcess();
endclass


//-----------------------CLASS BODY-----------------------//
task RhGpvDriever::mainProcess();
	forever begin
		seq_item_port.get_next_item(req);
		protocol.driveTransaction(req);
	end
endtask

function void RhGpvDriever::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void RhGpvDriever::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhGpvDriever::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


`endif