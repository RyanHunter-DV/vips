`ifndef RhQLpiConfig__svh
`define RhQLpiConfig__svh

// object for operation on the manual response series
class DeviceRespSeries;

	function new();
		current=-1;
	endfunction

// public

	// add, to add a new response for next <times> times.
	extern function void add (resp_t rsp,int times);

	// pop, pop out for next response, the times will automatically decrese one,
	// if no item available in, then return false, else return true. The response
	// value will comming by the ref arg
	extern function bool pop (ref resp_t rsp);

// private

	typedef struct {
		resp_t rsp;
		int times;
	} DeviceRespStruct;

	local DeviceRespStruct items[$];
	local int current;

	// updateCurrentItem, local api to update the index to next since the current index
	// item's times are becoming 0, if current+1 >= items.size(), then current index
	// will be flushed to -1 and the items will be deleted.
	extern local function void updateCurrentItem ();


endclass

function void DeviceRespSeries::updateCurrentItem ();
	current++;
	if (current >= items.size()) begin
		current=-1;
		items.delete();
	end
endfunction

function bool DeviceRespSeries::pop (ref resp_t rsp);
	if (items[current].times==0) updateCurrentItem;
	if (current==-1) return false;
	rsp = items[current].rsp; items[current].times--;
	return true;
endfunction

function void DeviceRespSeries::add (resp_t rsp,int times);
	DeviceRespStruct newitem;
	newitem.rsp  =rsp;
	newitem.times=times;
	items.push_back(newitem);
	if (current==-1) current++; // current being valid if previous not valid.
endfunction

class RhQLpiConfig extends uvm_object;

	bool isDevice;
	uvm_active_passive_enum isActive;
	string interfacePath;
	state_t initState;

	// for auto power up.
	uint32_t lpMin,lpMax;
	bool autoPowerUp;

	virtual RhQLpiIf vif;


// public:

	function new(string name="RhQLpiConfig");
		super.new(name);
		// initial values.
		isDevice   =false;
		autoPowerUp=false;
		lpMin=0;lpMax=0;
		isActive=UVM_ACTIVE;
		initState=QStopped;
		devMRsp=new();
		qactive=1'bz;
		respCycleMin=1;respCycleMax=100;
		qactiveCycleMin=1;qactiveCycleMax=100;
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


	// device configurations
	extern function void setAcceptPercentage (int percent);
	extern function void setManualDeviceResp (resp_t rsp,int times);

	extern function void fixedActive (logic val);
	extern function void randomActive (int min,int max);

	// genQActive, called by driver to get the qactive value, if is fixed value,
	// then config will return a logic bit that not equal to 'bz
	extern function logic genQActive ();
	extern function int genQActiveCycle ();

	// generate manual response if it has, or else generate a random response according
	// to the acceptPercent
	extern function resp_t genResponse ();
	// response will last a random cycle of active value.
	extern function int genRespCycle ();
	extern function void driveQActive (logic val);
	extern function void driveQAcceptn (logic val);
	extern function void driveQDeny (logic val);

// private:

	// local API:  initializeInterface, to init the interface state according is device or power mode.
	extern local function void initializeInterface();
	extern local function logic signalFilterFromState(state_t s,string signame);

	local int acceptPercent = 50; // default is 50
	local DeviceRespSeries devMRsp;
	local int respCycleMin,respCycleMax;
	// the fixed value of qactive, if it's not 'bz, then means this device will use fix qactive
	// instead of random qactive.
	local logic qactive;
	// for random qactive
	local int qactiveCycleMin,qactiveCycleMax;



	`uvm_object_utils_begin(RhQLpiConfig)
		`uvm_field_enum(bool,isDevice,UVM_ALL_ON)
		`uvm_field_enum(bool,autoPowerUp,UVM_ALL_ON)
		`uvm_field_enum(uvm_active_passive_enum,isActive,UVM_ALL_ON)
		`uvm_field_int(acceptPercent,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(lpMin,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(lpMax,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(respCycleMin,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(respCycleMax,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(qactiveCycleMin,UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(qactiveCycleMax,UVM_ALL_ON|UVM_DEC)
	`uvm_object_utils_end


endclass

function void RhQLpiConfig::driveQAcceptn (logic val);
	vif.QACCEPTn = val;
endfunction

function void RhQLpiConfig::driveQDeny (logic val);
	vif.QDENY = val;
endfunction

function void RhQLpiConfig::driveQActive (logic val);
	vif.QACTIVE = val;
endfunction

function int RhQLpiConfig::genRespCycle ();
	return $urandom_range(respCycleMin,respCycleMax);
endfunction

function resp_t RhQLpiConfig::genResponse ();
	resp_t rsp;
	if (devMRsp.pop(rsp)==true) return rsp;
	else begin
		std::randomize(rsp) with {
			rsp dist {QLpiAccept := acceptPercent, QLpiDeny := (100-acceptPercent)};
		};
		return rsp;
	end
endfunction

function int RhQLpiConfig::genQActiveCycle ();
	return $urandom_range(qactiveCycleMin,qactiveCycleMax);
endfunction

function logic RhQLpiConfig::genQActive ();
	return qactive;
endfunction

function void RhQLpiConfig::randomActive (int min,int max);
	qactiveCycleMax=max;qactiveCycleMin=min;
endfunction

function void RhQLpiConfig::fixedActive (logic val);
	qactive = val;
endfunction

function void RhQLpiConfig::setManualDeviceResp (resp_t rsp,int times);
	devMRsp.add(rsp,times);
endfunction

function void RhQLpiConfig::setAcceptPercentage (int percent);
	if (percent<0) return; // not < 0 permitted.
	acceptPercent=percent;
endfunction

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
		// `uvm_warning(get_type_name(),"Vip currently not support initialize the device mode.")
		driveQAcceptn(0);driveQDeny(0);driveQActive(0);
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
	wait (vif.resetn!==t);
endtask

function logic RhQLpiConfig::getReset();
	return vif.resetn;
endfunction



`endif