`ifndef RhQLpiVip__svh
`define RhQLpiVip__svh

// An agent class for qchannel lpi protocol.
class RhQLpiVip extends uvm_agent;

	RhQLpiDriver  drv;
	RhQLpiMonitor mon;
	RhQLpiSeqr    seqr;
	RhQLpiConfig  config;

	uvm_analysis_port #(stateTrans_t) in;
	uvm_analysis_port #(stateTrans_t) out;

	`uvm_component_utils_begin(RhQLpiVip)
		`uvm_field_object(drv,UVM_ALL_ON)
		`uvm_field_object(mon,UVM_ALL_ON)
		`uvm_field_object(seqr,UVM_ALL_ON)
		`uvm_field_object(config,UVM_ALL_ON)
	`uvm_component_utils_end

// public
	function new(string name="RhQLpiVip",uvm_component parent=null);
		super.new(name,parent);
		config = RhQLpiConfig::type_id::create("config");
	endfunction

	// build
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

	// Phase to apply the HDL related config values, get interface object, set interface init state etc.
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);

	// API: initState
	// Support default state after reset, QStopped or QExit state.
	extern function void initState(state_t s);

	// API: lpDuration
	// Users can set the lpDuration with a min,max gap so that the power control
	// will randomly select a value between min,max and drive the qreqn up after
	// it's been driven to low. Set min,max to -1 will disable the auto power up feature.
	extern function void lpDuration(int min=-1,int max=-1);

	// API: mode
	// By the same vip but has different configure, can config vip into Device/PowerControl
	// mode. This is a static configuration that can only be specified at elaboration phase,
	// and once it's set, the mode is fixed.
	extern function void mode(mode_t m);

	// API: setIf(string path)
	// Set the interface with given path.
	extern function void setIf(string path);

	// APIs for device mode.
	// acceptRandomly, set a random percent that a device will accept the power off request
	extern function void acceptRandomly (int percent);

	// acceptManually, set next response while incoming the power request.
	// rsp -> the state for next response
	// times->how many times for the response will be produced.
	// call of manual aaceptance will override the random setting for the next <times>
	// times.
	extern function void acceptManually (resp_t rsp,int times);

	// activeRandomly, randomly setup the active output, with the specified min,max cycle.
	// this api will be overridden by activeManually.
	extern function void activeRandomly (int min,int max);

	// activeManually, set permanently a fixed value for QACTIVE.
	extern function void activeManually (logic val);


// private
	// private APIs qualifier with local
	extern local function uvm_active_passive_enum uvmActiveFilter(mode_t m);

	// filter isDevice from the device mode, if is device mode, then return true
	// else return false.
	extern local function bool lpiDeviceFilter(mode_t m);

	extern local function void declarePorts();
	// private: connectPorts 
	// A function to connect in/out ports of this agent to monitor according to different
	// device mode.
	extern local function void connectPorts();


	extern local function void updateConfigFullname ();
endclass

function void RhQLpiVip::updateConfigFullname ();
	string orig = config.get_full_name();
	config.set_name($sformatf("%s.%s",this.get_full_name(),orig));
endfunction

function void RhQLpiVip::activeManually (logic val);
	config.fixedActive(val);
endfunction

function void RhQLpiVip::activeRandomly (int min,int max);
	config.randomActive(min,max);
endfunction

function void RhQLpiVip::acceptManually (resp_t rsp,int times);
	config.setManualDeviceResp(rsp,times);
endfunction

function void RhQLpiVip::acceptRandomly (int percent);
	config.setAcceptPercentage(percent);
endfunction

function void RhQLpiVip::end_of_elaboration_phase(uvm_phase phase);
	config.applyInterface();
	`RhdInfo($sformatf("Topology info print"))
	`RhdInfo($sformatf("-- configure table setup:\n%s",config.sprint()))
endfunction

function void RhQLpiVip::setIf(string path);
	config.interfacePath=path;
endfunction
function void RhQLpiVip::initState(state_t s);
	config.initState=s;
endfunction

function bool RhQLpiVip::lpiDeviceFilter(mode_t m);
	int mi=int'(m);
	bool device = (mi[0]==1)? true : false;
	return device;
endfunction

function uvm_active_passive_enum RhQLpiVip::uvmActiveFilter(mode_t m);
	int mi = int'(m);
	uvm_active_passive_enum active = (mi[1]==1)? UVM_ACTIVE : UVM_PASSIVE;
	return active;
endfunction

function void RhQLpiVip::lpDuration(int min=-1,int max=-1);
	if (min>0 && max>0) config.enableAutoPowerUp(min,max);
	else config.disableAutoPowerUp();
endfunction

function void RhQLpiVip::mode(mode_t m);
	config.isDevice=lpiDeviceFilter(m);
	is_active = uvmActiveFilter(m);
	config.isActive = is_active;
endfunction

function void RhQLpiVip::declarePorts();
	in = new("in",this);
	out= new("out",this);
endfunction

function void RhQLpiVip::build_phase(uvm_phase phase);
	super.build_phase(phase);
	// TODO, `RhdInfo("Entering build ... ...");
	// TODO, `RhdInfo($sformatf("device active mode: %s",is_active.name()));
	if (is_active) begin
		drv = RhQLpiDriver::type_id::create("drv",this);
		seqr= RhQLpiSeqr::type_id::create("seqr",this);
		drv.config = config;
	end
	mon=RhQLpiMonitor::type_id::create("mon",this);
	mon.config = config;
	// TODO, `RhdCall(declarePorts());
	declarePorts();
	updateConfigFullname();
	// TODO, `RhdInfo("Leaving build ... ...");
endfunction

function void RhQLpiVip::connect_phase(uvm_phase phase);
	// TODO, `RhdInfo("Entering connect ... ...");
	if (is_active) begin
		drv.seq_item_port.connect(seqr.seq_item_export);
		mon.resetP.connect(drv.resetI);
	end
	this.connectPorts();
	// TODO, `RhdInfo("Leaving connect ... ...");
endfunction

function void RhQLpiVip::connectPorts();
	if (config.isDevice) begin
		mon.reqPort.connect(this.in);
		mon.rspPort.connect(this.out);
	end else begin
		mon.reqPort.connect(this.out);
		mon.rspPort.connect(this.in);
	end
endfunction

`endif