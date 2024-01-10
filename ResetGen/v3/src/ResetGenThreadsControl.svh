`ifndef ResetGenThreadsControl__svh
`define ResetGenThreadsControl__svh

//  Class: ResetGenThreadsControl
//
class ResetGenThreadsControl extends uvm_object;
	`uvm_object_utils(ResetGenThreadsControl);

	//  Group: Variables
	ResetGenConfig config;

	//  Group: Constraints

	//  Constructor: new
	function new(string name = "ResetGenThreadsControl");
		super.new(name);
	endfunction: new

	
	// waitCurrentResetDone(string name), 
	// wait for the given thread until it's finished
	extern task waitCurrentResetDone(string name);
	// isBusy(string name) -> bit, 
	// according to given name, check if current pool has this threads running
	extern  function bit isBusy(string name);
	// dispatch(string name,ResetPolarity target,realtime duration) -> void, 
	// A function for driver to dispath a no time consuming reset driving thread
	extern  task dispatch(string name,ResetPolarity target,realtime duration);
	// registerProcess(string name,process p), 
	// register current process into this.pool[name]
	extern local task registerProcess(string name,process p);
	// driveReset(string name,ResetPolarity t,realtime d), 
	// drive reset to signal, wait duration, drive revert reset
	extern local task driveReset(string name,ResetPolarity t,realtime d);
endclass: ResetGenThreadsControl

task ResetGenThreadsControl::waitCurrentResetDone(string name); // ##{{{
	if (!pool.exists(name)) return;
	pool[name].await();
endtask // ##}}}

function bit ResetGenThreadsControl::isBusy(string name); // ##{{{
	if (!pool.exists(name)) return 0;
	if (pool[name].status()==process::RUNNING) return 1;
	return 0;
endfunction // ##}}}

task ResetGenThreadsControl::dispatch(string name,ResetPolarity target,realtime duration); // ##{{{
	fork begin
		prcess p=process::self();
		// pool[name] = p;
		registerProcess(name,p);
		driveReset(name,target,duration);
	end join_none
	#0; // wait for thread dispatched.
endtask // ##}}}

task ResetGenThreadsControl::driveReset(string name,ResetPolarity t,realtime d); // ##{{{
	logic v=config.resets[name].getSignalValue(t);
	config.vif.drive(name,v);
	#d;
	if (config.resets[name].syncRelease) config.vif.sync(name,1);
	config.vif.drive(name,~v);
endtask // ##}}}

task ResetGenThreadsControl::registerProcess(string name,process p); // ##{{{
	pool[name]=p;
endtask // ##}}}

`endif