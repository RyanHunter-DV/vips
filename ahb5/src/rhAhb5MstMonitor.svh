`ifndef rhAhb5MstMonitor__svh
`define rhAhb5MstMonitor__svh

class RhAhb5MstMonitor extends RHMonitorBase;
	uvm_analysis_port #(RhAhb5ReqTrans) reqP;
	uvm_analysis_port #(RhAhb5ReqTrans) wreqP;
	uvm_analysis_port #(RhAhb5RspTrans) rspP;
	RhAhb5MstConfig config;
	bit reqWriteInfo[$];
	`uvm_component_utils_begin(RhAhb5MstMonitor)
	`uvm_component_utils_end
	extern virtual task waitResetStateChanged(output RHResetState_enum s);
	extern virtual task mainProcess();
	extern local task reqMonitor();
	extern local task __waitRequestValid();
	extern local function void __collectAddressPhaseInfo(ref RhAhb5ReqTrans r);
	extern local function void __collectWriteData(ref RhAhb5ReqTrans r);
	extern local task rspMonitor();
	extern local task __waitReadyHigh();
	extern function  new(string name="RhAhb5MstMonitor",uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass
task RhAhb5MstMonitor::waitResetStateChanged(output RHResetState_enum s);
	logic sig;
	config.getResetChanged(sig);
	s = RHResetState_enum'(sig);
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
		reqP.send(req);
		if (req.write==1) begin
			__collectWriteData(req);
			wreqP.send(req);
		end
	end
endtask
task RhAhb5MstMonitor::__waitRequestValid();
	bit done = 1'b0;
	do begin
		if (config.getHTRANS() and config.getHREADY()) done = 1'b1;
		else config.waitCycle();
	end while (!done);
endtask
function void RhAhb5MstMonitor::__collectAddressPhaseInfo(ref RhAhb5ReqTrans r);
	r.trans = new[1]; // only 1 trans each for monitor
	r.trans = config.getHTRANS();
	r.burst = config.getHBURST();
	r.addr  = config.getHADDR();
	r.size  = config.getHSIZE();
	r.prot  = config.getHPROT();
	r.master= config.getHMASTER();
	r.lock  = config.getHLOCK();
	r.write = config.getHWRITE();
endfunction
function void RhAhb5MstMonitor::__collectWriteData(ref RhAhb5ReqTrans r);
	config.waitCycle();
	r.wdata = new[1];
	r.wdata[0] = config.getHWDATA();
endfunction
task RhAhb5MstMonitor::rspMonitor();
	forever begin
		RhAhb5RspTrans rsp=new("rsp");
		wait(reqWriteInfo.size()); // need wait last cycle has request.
		__waitReadyHigh();
		rsp.resp = config.getHRESP();
		rsp.iswrite = reqWriteInfo.pop_front();
		if rsp.iswrite==0 && rsp.resp==0 rsp.rdata = config.getHRDATA();
		rspP.write(rsp);
	end
endtask
task RhAhb5MstMonitor::__waitReadyHigh();
	bit done=1'b0;
	while (!done) begin
		done = (config.getHREADY()===1'b1)? 1'b1 : 1'b0;
	end
endtask
function  RhAhb5MstMonitor::new(string name="RhAhb5MstMonitor",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void RhAhb5MstMonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
function void RhAhb5MstMonitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhAhb5MstMonitor::run_phase(uvm_phase phase);
endtask

`endif
