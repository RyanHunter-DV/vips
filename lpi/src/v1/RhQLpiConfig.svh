`ifndef RhQLpiConfig__svh
`define RhQLpiConfig__svh

class RhQLpiConfig extends uvm_object;

	bool isDevice;
	uvm_active_passive_enum isActive;
	string interfacePath;
	state_t initState;

	// for auto power up.
	uint32_t lpMin,lpMax;
	bool autoPowerUp;

	virtual RhQLpiIf vif;

	`uvm_object_utils_begin(RhQLpiConfig)
		`uvm_field_enum(bool,isDevice,UVM_ALL_ON)
		`uvm_field_enum(bool,autoPowerUp,UVM_ALL_ON)
		`uvm_field_enum(uvm_active_passive_enum,isActive,UVM_ALL_ON)
		`uvm_field_int(lpMin,UVM_ALL_ON)
		`uvm_field_int(lpMax,UVM_ALL_ON)
	`uvm_object_utils_end



// public:

	function new(string name="RhQLpiConfig");
		super.new(name);
		// initial values.
		isDevice   =false;
		autoPowerUp=false;
		lpMin=0;lpMax=0;
		isActive=UVM_ACTIVE;
		initState=QStopped;
	endfunction

	// to set the lpMin,lpMax, and set autoPowerUp to true
	extern function void enableAutoPowerUp(uint32_t min,uint32_t max);
	// set the autoPowerUp to false, don't process the lpMin/lpMax
	extern function void disableAutoPowerUp();


	// API: sync, sync specified cycles with the vif.clock
	extern task sync(int cycle=0);

	// API: driveQReqn, to drive the signal value QReqn to specified value
	// input arg supports x
	extern task driveQReqn(logic v=1'bx);

	// API: getQReqn, get current signal value,
	extern function logic getQReqn();
	// API: waitQreqnNotEqualTo, wait syncd QReqn not equal to the given value
	extern task waitQReqnNotEqualTo(logic t=1'bx);
	extern function logic getQAcceptn();
	extern task waitQAcceptnNotEqualTo(logic t=1'bx);
	extern function logic getQDeny();
	extern task waitQDenyNotEqualTo(logic t=1'bx);

	// API: waitQActiveEqualTo, wait signal value from vif to reach the target value,
	// this value will be syncd waiting.
	extern task waitQActiveEqualTo(logic t=1'bx);

	// API: waitResetNotEqualTo, wait the reset signal until not equal to given value
	extern task waitResetNotEqualTo(logic t=1'bx);
	// API: getReset, get current logical reset value.
	extern function logic getReset();

	// API: applyInterface, to apply interface handler, set initial state if actived etc.
	extern function void applyInterface();

	// Generate the lpDuration according to the set lpMin,lpMax.
	// only available when autoPowerUp is true, or else will return -1
	extern function int genLpDuration ();

// private:

	// local API:  initializeInterface, to init the interface state according is device or power mode.
	extern local function void initializeInterface();
	extern local function logic signalFilterFromState(state_t s,string signame);
endclass

function int RhQLpiConfig::genLpDuration ();
	int duration = -1;
	if (autoPowerUp==true)
		std::randomize(duration) with {duration inside {[lpMin:lpMax]};};
	return duration;
endfunction

function logic RhQLpiConfig::signalFilterFromState(state_t s,string signame);
	case (s)
		QExit: begin
			if (signame=="QREQn") return 1'b1;
		end
		QStopped: begin
			if (signame=="QREQn") return 1'b0;
		end
	endcase
	`uvm_warning(get_type_name(),$sformatf("not support for signal(%s) in state(%s)",signame,s.name()))
	return 1'bx;
endfunction

function void RhQLpiConfig::initializeInterface();
	if (isDevice) begin
		// TODO,
		`uvm_warning(get_type_name(),"Vip currently not support initialize the device mode.")
	end else begin
		vif.QREQn = signalFilterFromState(initState,"QREQn");
	end
endfunction

function void RhQLpiConfig::applyInterface();
	if (!uvm_config_db#(virtual RhQLpiIf)::get(null,interfacePath,"RhQLpiIf",vif)) begin
		`uvm_fatal("NOIFC",$sformatf("Cannot get interface by path:(%s),name:(RhQLpiIf)",interfacePath));
		return;
	end

	if (isActive==UVM_ACTIVE) begin
		initializeInterface();
	end
	return;
endfunction

function void RhQLpiConfig::enableAutoPowerUp(uint32_t min,uint32_t max);
	autoPowerUp=true;
	lpMin=min; lpMax=max;
endfunction

function void RhQLpiConfig::disableAutoPowerUp();
	autoPowerUp=false;
endfunction

task RhQLpiConfig::sync(int cycle=0);
	repeat (cycle) @(posedge vif.clock);
endtask
task RhQLpiConfig::driveQReqn(logic v=1'bx);
	vif.QREQn <= v;
endtask
function logic RhQLpiConfig::getQReqn();
	return vif.QREQn;
endfunction
task RhQLpiConfig::waitQReqnNotEqualTo(logic t=1'bx);
	do begin
		@(posedge vif.clock);
	end while (vif.QREQn===t);
endtask
function logic RhQLpiConfig::getQAcceptn();
	return vif.QACCEPTn;
endfunction
task RhQLpiConfig::waitQAcceptnNotEqualTo(logic t=1'bx);
	do begin
		@(posedge vif.clock);
	end while (vif.QACCEPTn===t);
endtask
function logic RhQLpiConfig::getQDeny();
	return vif.QDENY;
endfunction
task RhQLpiConfig::waitQDenyNotEqualTo(logic t=1'bx);
	do begin
		@(posedge vif.clock);
	end while (vif.QDENY===t);
endtask

task RhQLpiConfig::waitQActiveEqualTo(logic t=1'bx);
	do begin
		@(posedge vif.clock);
	end while (vif.QACTIVE!==t);
endtask

task RhQLpiConfig::waitResetNotEqualTo(logic t=1'bx);
	logic c=vif.resetn;
	// wait reset value changed async
	wait (c!==t);
endtask

function logic RhQLpiConfig::getReset();
	return vif.resetn;
endfunction



`endif