`ifndef RhQLpiTestBase__svh
`define RhQLpiTestBase__svh

class RhQLpiTestBase extends uvm_test;
	RhQLpiEnv topEnv;
	
	`uvm_component_utils_begin(RhQLpiTestBase)
		`uvm_field_object(topEnv,UVM_ALL_ON)
	`uvm_component_utils_end
// public
	function new(string name="RhQLpiTestBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual task testRun ();
	extern virtual task testConfig ();
// private
endclass

task RhQLpiTestBase::testConfig ();
endtask

task RhQLpiTestBase::testRun ();
	RhQLpiPowerOnSeq  on=new("seq");
	RhQLpiPowerOffSeq off=new("seq");
	#1us;
	on.randomize();
	`uvm_info(get_type_name(),$sformatf("powerOn seq\n%s",on.sprint()),UVM_LOW)
	on.start(topEnv.pCtrl.seqr);

	off.randomize();
	`uvm_info(get_type_name(),$sformatf("powerOff seq\n%s",off.sprint()),UVM_LOW)
	#1us;
endtask

function void RhQLpiTestBase::build_phase(uvm_phase phase); //##{{{
	super.build_phase(phase);
	topEnv = RhQLpiEnv::type_id::create("topEnv",this);
endfunction //##}}}
function void RhQLpiTestBase::connect_phase(uvm_phase phase); //##{{{
	super.connect_phase(phase);
endfunction //##}}}
task RhQLpiTestBase::run_phase(uvm_phase phase); //##{{{
	super.run_phase(phase);
	`uvm_info(get_type_name(),$sformatf("testRun started, raise objection"),UVM_LOW)
	phase.raise_objection(this);
	testConfig();
	testRun();
	`uvm_info(get_type_name(),$sformatf("testRun finished, drop objection"),UVM_LOW)
	phase.drop_objection(this);
endtask //##}}}



`endif