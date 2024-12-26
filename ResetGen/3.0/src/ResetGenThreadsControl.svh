`ifndef ResetGenThreadsControl__svh
`define ResetGenThreadsControl__svh

//  Class: ResetGenThreadsControl
//
class ResetGenThreadsControl extends uvm_object;
	`uvm_object_utils(ResetGenThreadsControl);

	//  Group: Variables
	ResetGenConfig config;
	process pool[int];

	//  Group: Constraints

	//  Constructor: new
	function new(string name = "ResetGenThreadsControl");
		super.new(name);
	endfunction: new

	
	// waitCurrentResetDone(string name), 
	// wait for the given thread until it's finished
	task waitCurrentResetDone(int name); // ##{{{
		if (!pool.exists(name)) return;
		pool[name].await();
	endtask // ##}}}
	// isBusy(string name) -> bit, 
	// according to given name, check if current pool has this threads running
	function bit isBusy(int name); // ##{{{
		if (!pool.exists(name)) return 0;
		if (pool[name].status()==process::RUNNING) return 1;
		return 0;
	endfunction // ##}}}
	// dispatch(string name,ResetPolarity target,realtime duration) -> void, 
	// A function for driver to dispath a no time consuming reset driving thread
	task dispatch(int name,ResetPolarity target,realtime duration); // ##{{{
		fork begin
			process p=process::self();
			// pool[name] = p;
			registerProcess(name,p);
			driveReset(name,target,duration);
		end join_none
		#0; // wait for thread dispatched.
	endtask // ##}}}
	// registerProcess(string name,process p), 
	// register current process into this.pool[name]
	task registerProcess(int name,process p); // ##{{{
		pool[name]=p;
	endtask // ##}}}
	// driveReset(string name,ResetPolarity t,realtime d), 
	// drive reset to signal, wait duration, drive revert reset
	local task driveReset(int name,ResetPolarity t,realtime d); // ##{{{
		logic v=config.resets[name].getSignalValue(t);
		config.vif.drive(name,v);
		#d;
		if (config.resets[name].syncRelease) config.vif.sync(name,1);
		config.vif.drive(name,~v);
	endtask // ##}}}
endclass: ResetGenThreadsControl

`endif