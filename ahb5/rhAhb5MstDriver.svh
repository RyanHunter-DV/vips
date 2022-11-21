`ifndef rhAhb5MstDriver__svh
`define rhAhb5MstDriver__svh

class RhAhb5MstDriver #( type REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans) extends RHDriverBase#(REQ,RSP);
	RhAhb5MstConfig config;
	REQ addressQue[$];
	REQ dataQue[$];
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
	extern function void splitTransToBeats(REQ tr,ref RhAhb5TransBeat beats[$]);
	extern function  new(string name="RhAhb5MstDriver",uvm_component parent=null);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass
task RhAhb5MstDriver::startAddressPhaseThread();
	forever begin
		RhAhb5TransBeat beat;
		wait(addressQue.size());
		beat = addressQue.pop_front();
		config.sendAddressPhase(beat,outstandingData);
		dataQue.push(beat);
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
	config.waitCycle(cycle);
endtask
task RhAhb5MstDriver::processError();
	dataQue.delete();
	addressQue.delete();
	config.driveIdleBeat(1);
endtask
function void RhAhb5MstDriver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	outstandingData = 0;
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
		REQ cloned;
		RhAhb5TransBeat beats[$];
		seq_item_port.get_next_item(req);
		processDelay(req.delay);
		splitTransToBeats(req,beats);
		foreach (beats[i]) addressQue.push_back(beats[i]);
		wait (addressQue.size()==0); // only when this trans finished, can next coming in.
		seq_item_port.item_done();
	end
endtask
function void RhAhb5MstDriver::splitTransToBeats(REQ tr,ref RhAhb5TransBeat beats[$]);
	foreach (tr.trans[i]) begin
		RhAhb5TransBeat beat;
		beat.index = i;
		beat.burst = tr.burst;
		beat.trans = tr.trans[i];
		beat.write = tr.write;
		if (beat.write) beat.data = tr.wdata[i];
		beat.addr  = tr.addr;
		beat.master= tr.master;
		beat.size  = tr.size;
		beat.lock  = tr.lock;
		beat.prot  = tr.prot;
		beat.nonsec= tr.nonsec;
		beat.excl  = tr.excl;
	
		beats.push_back(beat);
	end
endfunction
function  RhAhb5MstDriver::new(string name="RhAhb5MstDriver",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void RhAhb5MstDriver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction
task RhAhb5MstDriver::run_phase(uvm_phase phase);
endtask

`endif
