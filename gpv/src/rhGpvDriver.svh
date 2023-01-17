`ifndef rhGpvDriver__svh
`define rhGpvDriver__svh

class RhGpvDriver #(type REQ=uvm_sequence_item,RSP=REQ) extends RhDriverBase#(REQ,RSP);

	RhGpvProtocolBase protocol;
	RhGpvConfig config;
	RhuDebugger debug;

	`uvm_component_utils(RhGpvDriver#(REQ,RSP))

	function new(string name="RhGpvDriver",uvm_component parent=null);
		super.new(name,parent);
		debug = new(this,"component");
	endfunction
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task mainProcess();
endclass


//-----------------------CLASS BODY-----------------------//
task RhGpvDriver::mainProcess();
	forever begin
		seq_item_port.get_next_item(req);
		`uvm_info("DRIVER",$sformatf("getting req:\n%s",req.sprint()),UVM_LOW)
		protocol.driveTransaction(req);
		`uvm_info("DRIVER",$sformatf("procotol.driveTransaction done"),UVM_LOW)
		seq_item_port.item_done();
	end
endtask

function void RhGpvDriver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`debug($sformatf("build_phase starting"))
	if (!config.resetFeature) resetDisable();
endfunction
function void RhGpvDriver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhGpvDriver::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


`endif
