`ifndef resetGen_config__svh
`define resetGen_config__svh

typedef struct {
	resetActive_enum active;
	int activeCycles;
} resetInfo;

class resetGen_config extends uvm_object; // {
	

	virtual resetGen_if vif;
	string intfPath="defaultResetPath";
	resetInfo resets[string];


	`uvm_object_utils_begin(resetGen_config)
	`uvm_object_utils_end
	
	
	function new (string name="resetGen_config");
		super.new(name);
	endfunction
	
	// APIs
	// set reset in config table, these configs will be applied to interface when uvc calls
	// elaborate
	extern function void setreset(
		string name,
		resetActive_enum active=resetGen_activeLow,
		int defaultActiveCycle=20
	);
	// elaborate, to apply configs in config table to interface level, such as get interface
	//
	extern function void elaborate;
	extern function void updateActiveCycle(string n,int ac);
	// driveResetThroughInterface, the API to call interface tasks to drive a reset event.
	extern task driveResetThroughInterface(string n);
	extern task sync(int cyc);

	// internal methods
	extern function void _getInterfaceHandle;


endclass // }

function void resetGen_config::updateActiveCycle(string n,int ac);
	resets[n].activeCycles=ac;
endfunction

function void resetGen_config::_getInterfaceHandle;
	if (!uvm_config_db#(virtual resetGen_if)::get(null,intfPath,"resetGen_if",vif))
		`uvm_fatal(get_type_name(),$sformatf("cannot get interface(%s)",intfPath))
endfunction

function void resetGen_config::elaborate;
	_getInterfaceHandle;
endfunction

task resetGen_config::sync(int cyc);
	vif.clockSync(cyc);
endtask

task resetGen_config::driveResetThroughInterface(string n);
	vif.driveReset(
		n,
		bit'(resets[n].active),
		resets[n].activeCycles
	);
endtask

function void resetGen_config::setreset(
	string name,
	resetActive_enum active=resetGen_activeLow,
	int defaultActiveCycle=20
);
	resets[name].active=active;
	resets[name].activeCycles=defaultActiveCycle;
endfunction


`endif
