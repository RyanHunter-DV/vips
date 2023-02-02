`ifndef rhAhb5SlvAgent__svh
`define rhAhb5SlvAgent__svh

class RhAhb5SlvAgent #(type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans)
	extends uvm_agent;

	// parameter type REQ=RhAhb5ReqTrans;
	// parameter type RSP=RhAhb5RspTrans;

	RhAhb5SlvDriver#(REQ,RSP) drv;
	RhAhb5SlvMonitor#(REQ,RSP) mon;
	RhAhb5SlvSeqr#(REQ,RSP) seqr;
	RhAhb5ResponderBase  responder;
	RhAhb5SlvConfig config;

	uvm_analysis_export#(REQ) reqCtrlP;
	uvm_analysis_export#(REQ) reqDataP;
	uvm_analysis_export#(RSP) rspP;

	`uvm_component_utils_begin(RhAhb5SlvAgent)
		`uvm_field_object(drv,UVM_ALL_ON)
		`uvm_field_object(mon,UVM_ALL_ON)
		`uvm_field_object(seqr,UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name="RhAhb5SlvAgent",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// phases ##{{{
	// method group: build phase // ##{{{
	extern function void build_phase (uvm_phase phase);
	extern local function void __setupActiveComponent__ ();
	extern function void __localFieldsInitial__ ();
	// ##}}}
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	// ##}}}

endclass


//-----------------------CLASS BODY-----------------------//
function void RhAhb5SlvAgent::__localFieldsInitial__(); // ##{{{
	reqCtrlP = new("reqCtrlP",this);
	reqDataP = new("reqDataP",this);
	rspP     = new("rspP",this);
endfunction // ##}}}
function void RhAhb5SlvAgent::__setupActiveComponent__(); // ##{{{
	drv  = RhAhb5SlvDriver#(REQ,RSP)::type_id::create("drv",this);
	seqr = RhAhb5SlvSeqr#(REQ,RSP)::type_id::create("seqr",this);
	responder = RhAhb5ResponderBase#(REQ,RSP)::type_id::create("responder");
	responder.config = config;
	drv.config= config;
	drv.responder = responder;
endfunction // ##}}}
function void RhAhb5SlvAgent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) `rhudbgCall("agent is active",__setupActiveComponent__)
	mon = RhAhb5SlvMonitor#(REQ,RSP)::type_id::create("mon",this);
	mon.config= config;
	`rhudbgCall("call to init local fields",__localFieldsInitial__)
endfunction
function void RhAhb5SlvAgent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
		mon.reqCtrlP.connect(drv.reqCtrlI);
		mon.resetP.connect(drv.resetI);
	end
	mon.reqCtrlP.connect(reqCtrlP);
	mon.reqDataP.connect(reqDataP);
	mon.rspP.connect(rspP);
endfunction
task RhAhb5SlvAgent::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask

`endif
