`ifndef CLOCKGEN_CONFIG_SVH
`define CLOCKGEN_CONFIG_SVH

class clockGen_config extends uvm_object; // {
	
	real clockFreqs[string];
	real clockSkews[string];
	real clockJitters[string];
	bit drivenClock[string];

	// TBD, clockInfo clocks[string];

	virtual clockGen_if vif;
	string intfPath="defaultClockPath";

	`uvm_object_utils_begin(clockGen_config)
	`uvm_object_utils_end
	
	
	function new (string name="clockGen_config");
		super.new(name);
	endfunction
	
	// APIs
	extern function void addClock(string name,real freq,real skew,real jitter);
	extern function void setFreq(string name,real freq);
	extern function void setSkew(string name,real skew);
	extern function void setJitter(string name,real jitter);
	extern function void elaborateConfigs;
	extern task driveClockThroughInterface(string name,real freq,real skew,real jitter);
	

	// internal methods
	extern function bit illegalClockName(string name);
	extern function void _getInterfaceHandle;


endclass // }

task clockGen_config::driveClockThroughInterface(
	string name,
	real freq,
	real skew,
	real jitter
);

	if (drivenClock.exists(name)) begin
		`uvm_error(get_type_name(),$sformatf("you are trying to drive a driven clock(%s)",name))
		return;
	end
	drivenClock[name]=1;
	vif.driveNewClock(name,freq,skew,jitter);
endtask


function void clockGen_config::_getInterfaceHandle;
	if (!uvm_config_db#(virtual clockGen_if)::get(null,intfPath,"clockGen_if",vif))
		`uvm_fatal(get_type_name(),$sformatf("cannot get interface(%s)",intfPath))
endfunction

function void clockGen_config::elaborateConfigs;
	_getInterfaceHandle;
endfunction

function void clockGen_config::addClock(string name,real freq,real skew,real jitter); // {
	if (illegalClockName(name)) return;
	if (clockFreqs.exists(name)) begin
		`uvm_warning(get_type_name(),$sformatf("try to add a clock(%s) that is previously added",name))
		return;
	end else begin // {
		clockFreqs[name] = freq;
		clockSkews[name] = skew;
		clockJitters[name] = jitter;
	end // }
endfunction // }

function void clockGen_config::setFreq(string name,real freq); // {
	if (!clockFreqs.exists(name)) begin // {
		`uvm_warning(get_type_name(),$sformatf("clock(%s) not added in the clockGen",name))
		return;
	end // }
	clockFreqs[name] = freq;
	return;
endfunction

function void clockGen_config::setSkew(string name,real skew); // {
	if (!clockSkews.exists(name)) begin // {
		`uvm_warning(get_type_name(),$sformatf("clock(%s) not added in the clockGen",name))
		return;
	end // }
	clockSkews[name] = skew;
	return;
endfunction

function void clockGen_config::setJitter(string name,real jitter); // {
	if (!clockJitters.exists(name)) begin // {
		`uvm_warning(get_type_name(),$sformatf("clock(%s) not added in the clockGen",name))
		return;
	end // }
	clockJitters[name] = jitter;
	return;
endfunction


function bit clockGen_config::illegalClockName(string name); // {
	if (name=="" || name=="*")
		return 1;
	else begin
		return 0;
	end
endfunction // }

`endif
