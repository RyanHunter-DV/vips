`ifndef rhAhb5SlvAgent__svh
`define rhAhb5SlvAgent__svh

class RhAhb5SlvAgent extends uvm_agent;

	parameter REQ=RhAhb5ReqTrans;
	parameter RSP=RhAhb5RspTrans;

	RhAhb5SlvDriver#(REQ,RSP) drv;
	RhAhb5SlvMonitor#(REQ,RSP) mon;
	RhAhb5SlvSeqr#(REQ,RSP) seqr;

	`uvm_component_utils_begin(RhAhb5SlvAgent)
		`uvm_field_object(drv,UVM_ALL_ON)
		`uvm_field_object(mon,UVM_ALL_ON)
		`uvm_field_object(seqr,UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name="RhAhb5SlvAgent",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
endclass


//-----------------------CLASS BODY-----------------------//

function void RhAhb5SlvAgent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		drv  = RhAhb5SlvDriver#(REQ,RSP)::type_id::create("drv",this);
		seqr = RhAhb5SlvSeqr#(REQ,RSP)::type_id::create("seqr",this);
	end
	mon = RhAhb5SlvMonitor#(REQ,RSP)::type_id::create("mon",this);
endfunction
function void RhAhb5SlvAgent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
	end
endfunction
task RhAhb5SlvAgent::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask

`endif
