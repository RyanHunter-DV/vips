`ifndef baseTest__svh
`define baseTest__svh

class baseTest extends uvm_test;

	Env env;
	`uvm_component_utils(baseTest)

	function new(string name="baseTest",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("baseTest","starting build_phase ...",UVM_LOW)
		env = Env::type_id::create("env",this);
	endfunction

	task run_phase(uvm_phase phase);
		SelfTestSeq seq=new("seq");
		`uvm_info("run_phase",$sformatf("starting run_phase ......"),UVM_LOW)
		phase.get_objection().set_drain_time(uvm_root::get(),2000ns);
		phase.raise_objection(this);
		#600ns;
		`uvm_info("run_phase",$sformatf("send sequence:\n%s",seq.sprint()),UVM_LOW)
		seq.start(env.gpv.seqr);
		phase.drop_objection(this);
		`uvm_info("run_phase",$sformatf("finish run_phase"),UVM_LOW)
	endtask
endclass

`endif
