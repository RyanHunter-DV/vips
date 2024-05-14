`ifndef ChiSnDriver__svh
`define ChiSnDriver__svh

//  Class: ChiSnDriver
//
class ChiSnDriver#(reqchn=1,rspchn=1,txdatchn=1,rxdatchn=1) extends uvm_driver#(REQ,RSP);
	`uvm_component_utils(ChiSnDriver);

	//  Group: Configuration Object(s)


	//  Group: Components
	RspChannelProcessor rsp;


	//  Group: Variables


	//  Group: Functions

	//  Constructor: new
	function new(string name = "ChiSnDriver", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	
	extern virtual task run_phase(uvm_phase phase);

	// main, description
	extern local task main;
	// creditProcessor, description
	extern local task creditProcessor;
	

	`define channelCreditThread(chn) \
		local task ``chn``CreditThread(); \
			for(int index=0;index<``chn``chn;index++) fork \
				forever begin \
					credit[`"chn`"].waitReadyToRelease(index,creditnum); \
					//TODO, return a random credit delay from config's min/max config.
					vif.sync(config.creditDelay(`"chn`")); \
					vif.``chn``lcrdv("drive",1,index); \
					vif.sync(creditnum); \
					vif.``chn``lcrdv("drive",0,index); \
				end \
			join_none \
			wait fork; \
		endtask
	`channelCreditThread(req)
	`channelCreditThread(rsp)
	`channelCreditThread(txdat)
	`channelCreditThread(rxdat)

	// build_phase(uvm_phase phase) -> void, description
	extern virtual function void build_phase(uvm_phase phase);

endclass: ChiSnDriver

function void ChiSnDriver::build_phase(uvm_phase phase); // ##{{{
	//TODO
	super.build_phase(phase);
	rsp=RspChannelProcessor::type_id::create("rspc");
	rsp.parent(this);
	rsp.channels(rspchn);
endfunction // ##}}}


task ChiSnDriver::creditProcessor; // ##{{{
	//TODO
	fork
		reqCreditThread;
		rspCreditThread;
		txdatCreditThread;
		rxdatCreditThread;
	join
endtask // ##}}}
local task ChiSnDriver::main; // ##{{{
	//TODO
	fork
		rsp.start;
		creditProcessor;
	join
endtask // ##}}}

task ChiSnDriver::run_phase(uvm_phase phase);
	`uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_LOW)

	`uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_LOW)
endtask: run_phase



`endif