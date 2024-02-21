`ifndef ResetGenDriver__svh
`define ResetGenDriver__svh

class ResetGenDriver #(type REQ=ResetGenTrans,RSP=REQ) extends uvm_driver#(REQ,RSP);

	ResetGenConfig config; // manually assigned from agent.
	
	`uvm_component_utils_begin(ResetGenDriver#(REQ,RSP))
	`uvm_component_utils_end
// public
	function new(string name="ResetGenDriver",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
// private
	ResetGenThreadsControl threads;

	// initThread, 
	// task when first entering run_phase, this driver will drive a startup reset sequence
	// from the default stat to an inverted stat
	// 1.loop all resets set in config, drive to unknown stat. Using fork-join_none threads
	// 2.according to default stat, driving the signal to default stat value.
	// 3.genInitDuration from config, and delay the sim time.
	// 4.if the reset has syncRelease feature, then to posedge a reference clock
	// 5.drive to revert stat according to the default stat.
	// 6.return
	extern task initThread;

endclass

task ResetGenDriver::initThread; // ##{{{
	foreach (config.resets[name]) begin
		ResetAttributes r=config.resets[name];
		config.vif.drive(name,'bx); // init to unknown value.
		threads.dispatch(name,r.defaultStat,r.genInitDuration());
	end
	foreach (config.resets[name]) begin
		threads.waitCurrentResetDone(name);
	end
endtask // ##}}}

function void ResetGenDriver::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	threads = ResetGenThreadsControl::type_id::create("threads");
	threads.config = config;
endfunction //##}}}
function void ResetGenDriver::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task ResetGenDriver::run_phase(uvm_phase phase); //##{{{
	// 1.first time entering the run_phase, start initialize programming
	initThread;
	// 2.after init process done, then entering the sequence processing threads
	while (1) begin
		seq_item_port.get_next_item(req);
		if (threads.isBusy(req.name)) threads.waitCurrentResetDone(req.name);
		threads.dispatch(req.name,req.stat,req.duration);
		seq_item_port.item_done();
	end

endtask //##}}}

`endif