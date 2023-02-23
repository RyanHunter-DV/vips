`ifndef omosBaseTest__svh
`define omosBaseTest__svh

// uvm_test: omosBaseTest
// This class generated by snippet: 'test', if has any issue, pls report to RyanHunter
class omosBaseTest extends uvm_test;
	omosEnv env;
	`uvm_component_utils_begin(omosBaseTest)
	`uvm_component_utils_end
	function new(string name="omosBaseTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	// phases ##{{{
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	// ##}}}
	extern virtual task test_sim ();
endclass

task omosBaseTest::test_sim();
	RhAhb5SingleBurstSeq seq=new("single");
	seq.randomize();
	seq.start(env.mst.seqr);
endtask

function void omosBaseTest::build_phase(uvm_phase phase); // ##{{{
	// omosEnvConfig eConfig;
	super.build_phase(phase);
	//TODO,add code here
	env = omosEnv::type_id::create("env",this);
	void'(env.createConfig());
	env.setDebugComp("mst");
	env.setDebugComp("slv");
	env.setDebugComp("env");
endfunction // ##}}}
function void omosBaseTest::connect_phase(uvm_phase phase); // ##{{{
	super.connect_phase(phase);
endfunction // ##}}}
task omosBaseTest::run_phase(uvm_phase phase); // ##{{{
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"starting run_phase ...",UVM_NONE)
	#100ns;
	`uvm_info(get_type_name(),$sformatf("mst's seqr: %0d",env.mst.seqr),UVM_LOW)
	test_sim();
	#200ns;
	`uvm_info(get_type_name(),"finishing run_phase ...",UVM_NONE)
	phase.drop_objection(this);
endtask // ##}}}

`endif
