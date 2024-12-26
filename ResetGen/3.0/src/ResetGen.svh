`ifndef ResetGen__svh
`define ResetGen__svh

class ResetGen extends uvm_agent;

	parameter type TR = ResetGenTrans;

	ResetGenConfig config;

	ResetGenDriver  driver;
	ResetGenSeqr    sequencer;
	ResetGenMonitor monitor;

	uvm_analysis_export#(TR) port;

	`uvm_component_utils_begin(ResetGen)
		`uvm_field_object(config,UVM_ALL_ON)
	`uvm_component_utils_end
// public
	function new(string name="ResetGen",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);

	// init -> void, a function to
	// API called by higher ENV to init a reset signal with the given name.
	// Can specify a user defined max inactive time duration so that a random active duration
	// will be generated during 1ns~maxInactiveDuration. Or ignore this arg by giving nothing.
	// Or else, can specify a manual inactive delay by setting the manualInactiveDuration time.
	// By default, if none of above specified by the init caller, a default random active duration 1ns~200ns will be used.
	// -name -> the reset name.
	// -polarity -> the default state of the reset
	// -maxInactiveDuration -> default selection, randomly gen a duration for simulation startup
	// -manualInactiveDuration -> for manual setting the startup default stat -> invert stat. duration
	// this API shall not be called after connect_phase.
	function void init(
		int index,ResetPolarity polarity,
		int maxInactiveDuration = 200, realtime timeUnit=1ns,
		realtime manualInactiveDuration = 0ns
	); // ##{{{
		config.updateInitTable(index,polarity,maxInactiveDuration,timeUnit,manualInactiveDuration);
	endfunction // ##}}}
	// createConfig -> ResetGenConfig, called by parent env, to create a config object of
	// this field and return to caller
	extern  function ResetGenConfig createConfig;
	// setInterfacePath(string path) -> void, manually called with the interface path,
	// by which can get the virtual interface handler which set by tb.
	extern  function void setInterfacePath(string path);
	// reset(string name,realtime duration), API can be called by test,
	// to trigger a reset event by the given name and duration
	task reset(int index,realtime duration); // ##{{{
		ResetGenSanityActiveSeq seq=new("reset");
		seq.add(index,duration);
		seq.start(sequencer);
	endtask // ##}}}
	// activeValue(string name,bit val) -> void, 
	// api called by user before run_phase, to set the specified reset's active value
	extern  function void activeValue(string name,bit val);
// private
endclass
function void ResetGen::activeValue(string name,bit val); // ##{{{
	config.setActivePolarityValue(name,val);
endfunction // ##}}}


function void ResetGen::setInterfacePath(string path); // ##{{{
	if (!uvm_config_db#(virtual ResetGenIf)::get(null,path,"ResetGenIf",config.vif))
		`uvm_fatal("NOIF",$sformatf("No interface found with path(%s)",path))
endfunction // ##}}}

function ResetGenConfig ResetGen::createConfig; // ##{{{
	if (config==null) config=ResetGenConfig::type_id::create("config");
	return config;
endfunction // ##}}}


function void ResetGen::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		driver = ResetGenDriver::type_id::create("driver",this);
		sequencer = ResetGenSeqr::type_id::create("sequencer",this);
		driver.config=config;
	end
	monitor = ResetGenMonitor::type_id::create("monitor",this);
	monitor.config=config;
	port=new("mPort",this);
endfunction //##}}}
function void ResetGen::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	if (is_active==UVM_ACTIVE) begin
		driver.seq_item_port.connect(sequencer.seq_item_export);
	end
	monitor.port.connect(this.port);
endfunction //##}}}
task ResetGen::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}

`endif