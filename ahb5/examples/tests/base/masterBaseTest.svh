class MasterBaseTest extends uvm_test;

	MasterEnv env;

	`uvm_component_utils(MasterBaseTest)


	function new(string name="MasterBaseTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	extern virtual task test_sim();
endclass

task MasterBaseTest::test_sim();
	RhAhb5SingleBurstSeq seq=new("single");
	seq.randomize();
	seq.start(env.ahb.mst.seqr);
endtask

function void MasterBaseTest::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = MasterEnv::type_id::create("env",this);
endfunction

task MasterBaseTest::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"starting run_phase ...",UVM_NONE)
	test_sim();
	#200ns;
	`uvm_info(get_type_name(),"finishing run_phase ...",UVM_NONE)
	phase.drop_objection(this);
endtask
