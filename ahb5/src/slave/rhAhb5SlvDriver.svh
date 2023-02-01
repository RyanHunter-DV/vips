`ifndef rhAhb5SlvDriver__svh
`define rhAhb5SlvDriver__svh

class RhAhb5SlvDriver #(type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends RhDriverBase#(REQ,RSP);
	`uvm_analysis_imp_decl(_reqCtrl)

	RhuDebugger debug; // object from agent

	RhAhb5SlvConfig config;
	RhAhb5ResponderBase responder;
	uvm_event#(REQ) reqEvent;

	uvm_analysis_imp_reqCtrl#(REQ,RhAhb5SlvDriver) reqCtrlI;

	`uvm_component_utils(RhAhb5SlvDriver#(REQ,RSP))

	function new(string name="RhAhb5SlvDriver",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern virtual task mainProcess();

	// method group: random responses ##{{{
	// abstract: randomly drive the hrdata and hready by fields in config table,
	// which can be specified by user before the driving begins.
	// FIXME, hresp always kept OKAY, by version: v1.x
	extern local task __randomResponder__;
	// ##}}}

	// method group: custom responses ##{{{
	extern local task __customResponder__;
	extern local task __sendOkayResponse__ (RSP rsp);
	extern local task __sendErrorResponse__(RSP rsp);
	extern local task __driveBusyCycles__ (int cycle);
	// ##}}}

	// phases ##{{{
	extern virtual function void build_phase (uvm_phase phase);
	extern virtual function void connect_phase (uvm_phase phase);
	// ##}}}

	extern function void write_reqCtrl(REQ _tr);

endclass

//-----------------------CLASS BODY-----------------------//
task RhAhb5SlvDriver::__randomResponder__; // ##{{{
	// This method is auto generated by cmd:Func
	forever begin
		int lowDuration,highDuration;
		int min = config.lowDurationMin("HREADY");
		int max = config.lowDurationMax("HREADY");
		lowDuration = $urandom_range(max,min);
		`debug($sformatf("drive HREADY=1'b0 for %0d cycles",lowDuration))
		`debug("driving slave response by random mode, in this mode, HRESP/HEXOKAY are always 0")
		config.ifCtrl.HRESP(1'b0);
		config.ifCtrl.HEXOKAY(1'b0);
		config.ifCtrl.HREADY(1'b0);
		config.ifCtrl.clock(lowDuration);

		min = config.highDurationMin("HREADY");
		max = config.highDurationMax("HREADY");
		highDuration = $urandom_range(max,min);
		`debug($sformatf("drive HREADY=1'b1 for %0d cycles",highDuration))
		config.ifCtrl.HREADY(1'b1);
		config.ifCtrl.randomHRDATA();
		config.ifCtrl.clock(highDuration);
		`debug($sformatf("__randomResponder__ one loop finished"))
	end
endtask // ##}}}
task RhAhb5SlvDriver::__customResponder__; // ##{{{
	// This method is auto generated by cmd:Func
	forever begin
		reqEvent.wait_trigger_data(req);
		reqEvent.reset();
		`debugCall("",rsp = responder.generateResponse(req))
		`debug($sformatf("generate rsp from responder\n%s",rsp.sprint()))
		// This code generated by snippet: 'if', if has any issue, pls report to RyanHunter
		if (RhAhb5Resp_enum'(rsp.resp)==RHAHB5_OKAY) begin
			`debugCall("get resp=>RHAHB5_OKAY",__sendOkayResponse__(rsp))
		end else begin
			RhAhb5Resp_enum _resp = rsp.resp;
			`debugCall($sformatf("get resp=>%s",_resp.name()),__sendErrorResponse__(rsp))
		end
		`debug("custom responder processed done, start next loop, waiting request event")
	end
endtask // ##}}}
task RhAhb5SlvDriver::__sendErrorResponse__(RSP rsp);
	if (rsp.busyCycle) __driveBusyCycles__(rsp.busyCycle);
	`debug($sformatf("slave driver 2-cycle based error, cycle(1), drive HREADY=>0,HRESP=>%0h",rsp.resp))
	void'(config.ifCtrl.HRESP(rsp.resp));
	config.ifCtrl.clock(1);
	`debug($sformatf("slave driver 2-cycle based error, cycle(2), drive HREADY=>1,HRESP=>%0h",rsp.resp))
	void'(config.ifCtrl.HREADY(1));
	void'(config.ifCtrl.HRESP(rsp.resp));
	`debug("slave drive error response done, signal released")
endtask
task RhAhb5SlvDriver::__sendOkayResponse__(RSP rsp);
	if (rsp.busyCycle) __driveBusyCycles__(rsp.busyCycle);
	`debug($sformatf("slave drive response,HREADY=>1,HRESP=>%0h,HEXOKAY=>%0h",rsp.resp,rsp.exokay))
	if (!rsp.iswrite) begin
		`debug($sformatf("is read request,drive HRDATA=>%0d",rsp.rdata))
		void'(config.ifCtrl.HRDATA(rsp.rdata));
	end
	void'(config.ifCtrl.HREADY(1));
	void'(config.ifCtrl.HRESP(rsp.resp));
	void'(config.ifCtrl.HEXOKAY(rsp.exokay));
	`debug("slave drive okay response done, signal released")
endtask
task RhAhb5SlvDriver::__driveBusyCycles__(int cycle);
	`debug($sformatf("slave drive to busy for %0d cycles",rsp.busyCycle))
	config.ifCtrl.HREADY(1'b0);
	config.ifCtrl.clock(rsp.busyCycle);
endtask

function void RhAhb5SlvDriver::write_reqCtrl(REQ _tr); // ##{{{
	// This method is auto generated by cmd:Func
	`debug($sformatf("get req control from monitor,trans:\n%s",_tr.sprint()))
	reqEvent.trigger(_tr);
endfunction // ##}}}
task RhAhb5SlvDriver::mainProcess(); // ##{{{
	// This method is auto generated by cmd:Func
	`debug("device starting mainProcess")
	if (config.israndom()) `debugCall("config.israndom is 1",__randomResponder__)
	else `debugCall("config.israndom is 0",__customResponder__)
endtask // ##}}}

function void RhAhb5SlvDriver::build_phase(uvm_phase phase); // ##{{{
	super.build_phase(phase);
	reqCtrlI = new("reqCtrlI",this);
	reqEvent = new("reqEvent");
	`debug("build_phase done ......")
endfunction // ##}}}
function void RhAhb5SlvDriver::connect_phase(uvm_phase phase); // ##{{{
	super.connect_phase(phase);
	`debug("connect_phase done ......")
endfunction // ##}}}

`endif
