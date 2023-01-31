`ifndef rhAhb5MstMonitor__svh
`define rhAhb5MstMonitor__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-22 06:29:21 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5MstMonitor extends RhMonitorBase;
	uvm_analysis_port #(RhAhb5ReqTrans) reqP;
	uvm_analysis_port #(RhAhb5ReqTrans) wreqP;
	uvm_analysis_port #(RhAhb5RspTrans) rspP;
	uvm_analysis_imp_selfcheckExp #(RhAhb5ReqTrans,RhAhb5MstMonitor) reqI;
	RhAhb5MstConfig config;
	bit reqWriteInfo[$];
	RhAhb5ReqTrans expReqQue[$];
	RhuDebugger debug;
	`uvm_component_utils_begin(RhAhb5MstMonitor)
	`uvm_component_utils_end
	extern virtual task waitResetStateChanged(input RhResetState_enum c,output RhResetState_enum s);
	extern virtual task mainProcess();
	extern local task reqMonitor();
	extern local function void __reqSelfCheck__(RhAhb5ReqTrans act);
	extern local task __waitRequestValid();
	extern local function void __collectAddressPhaseInfo(ref RhAhb5ReqTrans r);
	extern local task __collectWriteData(ref RhAhb5ReqTrans r);
	extern local task rspMonitor();
	extern local task __waitReadyHigh();
	extern virtual function void build_phase(uvm_phase phase);
	extern function  new(string name="RhAhb5MstMonitor",uvm_component parent=null);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual function void write_selfcheckExp(RhAhb5ReqTrans _tr);
endclass
task RhAhb5MstMonitor::waitResetStateChanged(input RhResetState_enum c,output RhResetState_enum s);
	logic sig = logic'(c);
	config.getResetChanged(sig);
	s = RhResetState_enum'(sig);
endtask
task RhAhb5MstMonitor::mainProcess();
	
	fork
		reqMonitor();
		rspMonitor();
	join
endtask
task RhAhb5MstMonitor::reqMonitor();
	forever begin
		RhAhb5ReqTrans req=new("req");
		__waitRequestValid();
		__collectAddressPhaseInfo(req);
		reqWriteInfo.push_back(req.write);
		`debug($sformatf("send packet to reqP\n%s",req.sprint()))
		reqP.write(req);
		if (req.write==1) begin
			__collectWriteData(req);
			`debug($sformatf("send packet to wreqP,with wdata\n%s",req.sprint()))
			wreqP.write(req);
		end else config.waitCycle();
		__reqSelfCheck__(req);
	end
endtask
function void RhAhb5MstMonitor::__reqSelfCheck__(RhAhb5ReqTrans act);
	RhAhb5ReqTrans exp;
	`debug("starting ...")
	if (expReqQue.size()==0) begin
		`uvm_fatal("SELFCHECK","no expected transaction should be sent by this VIP")
		return;
	end
	exp = expReqQue.pop_front();
	if (exp.compare(act))
		`uvm_fatal("SELFCHECK",$sformatf("driver/monitor req compare failed, trans to be sent is\n%s\ntrans collected is\n%s",exp.sprint(),act.sprint()))
	else
		`debug("driver/monitor req compare passed, driver has sent an expected transaction")
	return;
endfunction
task RhAhb5MstMonitor::__waitRequestValid();
	bit done = 1'b0;
	do begin
		// if (config.getSignal("HTRANS") && config.getSignal("HREADY")) done = 1'b1;
		if (config.ifCtrl.HTRANS && config.ifCtrl.HREADY) done = 1'b1;
		else config.waitCycle();
	end while (!done);
endtask
function void RhAhb5MstMonitor::__collectAddressPhaseInfo(ref RhAhb5ReqTrans r);
	r.trans = config.ifCtrl.HTRANS;
	r.burst = config.ifCtrl.HBURST;
	r.addr  = config.ifCtrl.HADDR;
	r.size  = config.ifCtrl.HSIZE;
	r.prot  = config.ifCtrl.HPROT;
	r.master= config.ifCtrl.HMASTER;
	r.lock  = config.ifCtrl.HMASTLOCK;
	r.write = config.ifCtrl.HWRITE;
	r.nonsec= config.ifCtrl.HNONSEC;
	r.excl  = config.ifCtrl.HEXCL;
endfunction
task RhAhb5MstMonitor::__collectWriteData(ref RhAhb5ReqTrans r);
	config.waitCycle();
	// r.wdata = config.getSignal("HWDATA");
	r.wdata = config.ifCtrl.HWDATA;
endtask
task RhAhb5MstMonitor::rspMonitor();
	forever begin
		RhAhb5RspTrans rsp=new("rsp");
		wait(reqWriteInfo.size()); // need wait last cycle has request.
		__waitReadyHigh();
		// rsp.resp = config.getSignal("HRESP");
		rsp.resp = config.ifCtrl.HRESP;
		rsp.iswrite = reqWriteInfo.pop_front();
		// if (rsp.iswrite==0 && rsp.resp==0) rsp.rdata = config.getSignal("HRDATA");
		if (rsp.iswrite==0 && rsp.resp==0) rsp.rdata = config.ifCtrl.HRDATA;
		rspP.write(rsp);
	end
endtask
task RhAhb5MstMonitor::__waitReadyHigh();
	bit done=1'b0;
	while (!done) begin
		// done = (config.getSignal("HREADY")[0]==1'b1)? 1'b1 : 1'b0;
		done = (config.ifCtrl.HREADY==1'b1)? 1'b1 : 1'b0;
	end
endtask
function void RhAhb5MstMonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	reqP = new("reqP",this);
	rspP = new("rspP",this);
	wreqP= new("wreqP",this);
	reqI = new("reqI",this);
endfunction
function  RhAhb5MstMonitor::new(string name="RhAhb5MstMonitor",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void RhAhb5MstMonitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhAhb5MstMonitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
function void RhAhb5MstMonitor::write_selfcheckExp(RhAhb5ReqTrans _tr);
	`debug($sformatf("get the exp req:\n%s",_tr.sprint()))
	expReqQue.push_back(_tr);
endfunction

`endif
