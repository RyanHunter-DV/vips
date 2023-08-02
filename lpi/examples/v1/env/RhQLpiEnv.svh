`ifndef RhQLpiEnv__svh
`define RhQLpiEnv__svh

class RhQLpiEnv extends uvm_env;

	int devnum = 4;
	RhQLpiVip pCtrl;
	RhQLpiVip dev[];
	RhQLpiScoreboard scb;
	
	`uvm_component_utils_begin(RhQLpiEnv)
	`uvm_component_utils_end
// public
	function new(string name="RhQLpiEnv",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
// private
	extern function void buildDevices ();
	extern function void buildPowerControl ();
endclass

function void RhQLpiEnv::buildPowerControl ();
	pCtrl = RhQLpiVip::type_id::create("pCtrl",this);
	pCtrl.mode(ActivePowerControl);
	pCtrl.setIf("tb.pCtrlIf");
	// configs, TODO
endfunction

function void RhQLpiEnv::buildDevices ();
	dev=new[devnum];
	foreach (dev[index]) begin
		dev[index] = RhQLpiVip::type_id::create($sformatf("dev[%0d]",index),this);
		dev[index].mode(ActiveDevice);
		dev[index].setIf($sformatf("tb.dev%0dIf",index));
		// configs, TODO
	end
endfunction

function void RhQLpiEnv::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	buildPowerControl;
	buildDevices;
	scb = RhQLpiScoreboard::type_id::create("scb",this);
endfunction //##}}}
function void RhQLpiEnv::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
	pCtrl.in.connect(scb.pcIn);
	pCtrl.out.connect(scb.pcOut);
	dev[0].in.connect(scb.dev0In);
	dev[0].out.connect(scb.dev0Out);
	dev[1].in.connect(scb.dev1In);
	dev[1].out.connect(scb.dev1Out);
	dev[2].in.connect(scb.dev2In);
	dev[2].out.connect(scb.dev2Out);
	dev[3].in.connect(scb.dev3In);
	dev[3].out.connect(scb.dev3Out);
endfunction //##}}}
task RhQLpiEnv::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
endtask //##}}}


`endif