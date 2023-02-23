`ifndef rhAhb5MstDriver__svh
`define rhAhb5MstDriver__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-22 06:29:21 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5MstDriver #( type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends RhDriverBase#(REQ,RSP);
	uvm_analysis_port #(REQ) reqP;
	RhAhb5MstConfig config;
	RhAhb5TransBeat addressQue[$];
	RhAhb5TransBeat dataQue[$];
	int outstandingData;

	`uvm_component_utils_begin(RhAhb5MstDriver#(REQ,RSP))
	`uvm_component_utils_end
	extern task startAddressPhaseThread();
	extern task startDataPhaseThread();
	extern task processDelay(input int cycle);
	extern task processError();
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task mainProcess();
	extern task startSeqProcess();
	extern local task __sendIdleBeat__();
	extern function void convertTransToBeats(REQ tr,ref RhAhb5TransBeat beat);
	extern function  new(string name="RhAhb5MstDriver",uvm_component parent=null);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass
task RhAhb5MstDriver::startAddressPhaseThread();
	forever begin
		RhAhb5TransBeat beat;
		wait(addressQue.size());
		beat = addressQue.pop_front();
		`rhudbg($sformatf("driving beat to address phase:\n%p",beat))
		config.sendAddressPhase(beat,outstandingData);
		dataQue.push_back(beat);
		outstandingData++;
	end
endtask
task RhAhb5MstDriver::startDataPhaseThread();
	forever begin
		RhAhb5TransBeat beat;
		bit isError;
		wait(dataQue.size());
		beat = dataQue.pop_front();
		config.sendDataPhase(beat,isError);
		if (isError) begin
			processError();
			outstandingData = 0;
		end else outstandingData--;
	end
endtask
task RhAhb5MstDriver::processDelay(input int cycle);
	bit processidle = 1'b0;
	if (outstandingData==0) `rhudbgCall("driving idle beat",__sendIdleBeat__())
	else processidle=1'b1;
	for (int i=0;i<cycle;i++) begin
		config.waitCycle(1);
		if (processidle) begin
			if (outstandingData==0) `rhudbgCall("driving idle beat",__sendIdleBeat__())
		end
	end
endtask
task RhAhb5MstDriver::processError();
	dataQue.delete();
	addressQue.delete();
	config.driveIdleBeat(1,outstandingData);
endtask
function void RhAhb5MstDriver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	outstandingData = 0;
	reqP=new("reqP",this);
endfunction
task RhAhb5MstDriver::mainProcess();
	fork
		startSeqProcess();
		startAddressPhaseThread();
		startDataPhaseThread();
	join
endtask
task RhAhb5MstDriver::startSeqProcess();
	forever begin
		RhAhb5TransBeat beat;
		REQ _reqClone;
		seq_item_port.try_next_item(req);
		if (req==null) begin
			`rhudbgCall("driving idle beat",__sendIdleBeat__())
			seq_item_port.get_next_item(req);
		end
		$cast(_reqClone,req.clone());
		`rhudbg($sformatf("sending exp trans to monitor:\n%s",_reqClone.sprint()))
		reqP.write(_reqClone); // send to monitor for self check
		processDelay(req.delay);
		// @RyanH,TODO, to be deleted, splitTransToBeats(req,beats);
		// @RyanH,TODO, to be deleted, foreach (beats[i]) addressQue.push_back(beats[i]);
		// @RyanH,TODO, to be deleted, wait (addressQue.size()==0); // only when this trans finished, can next coming in.
	
		// new added steps
		convertTransToBeats(req,beat);
		addressQue.push_back(beat);
		// @RyanH wait(addressQue.size()==0);
		// need wait at least one cycle before geting next sequence
		config.waitCycle();
		seq_item_port.item_done();
	end
endtask
task RhAhb5MstDriver::__sendIdleBeat__();
	RhAhb5TransBeat beat;
	beat.burst = 0;
	beat.trans = 0;
	beat.write = 0;
	beat.data  = 0;
	beat.addr  = 0;
	beat.master= 0;
	beat.size  = 0;
	beat.lock  = 0;
	beat.prot  = 0;
	beat.nonsec= 0;
	beat.excl  = 0;
	// @RyanH assume this drive will not take any sim time.
	`rhudbg($sformatf("idle beat:\n%p",beat))
	config.sendAddressPhase(beat,0);
endtask
function void RhAhb5MstDriver::convertTransToBeats(REQ tr,ref RhAhb5TransBeat beat);
	// @RyanH beat.index = i;
	beat.burst = tr.burst;
	beat.trans = tr.trans;
	beat.write = tr.write;
	if (beat.write) beat.data = tr.wdata;
	beat.addr  = tr.addr;
	beat.master= tr.master;
	beat.size  = tr.size;
	beat.lock  = tr.lock;
	beat.prot  = tr.prot;
	beat.nonsec= tr.nonsec;
	beat.excl  = tr.excl;
endfunction
function  RhAhb5MstDriver::new(string name="RhAhb5MstDriver",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void RhAhb5MstDriver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhAhb5MstDriver::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask

`endif
