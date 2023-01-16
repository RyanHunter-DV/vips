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
		env = Env::type_id::create("env",this);
	endfunction

	task run_phase(uvm_phase phase);
		SelfTestSeq seq=new("seq");
		phase.phase_done.set_drain_time(2000ns);
		phase.raise_objection(this);
		seq.start(env.gpv.seqr);
		phase.drop_objection(this);
	endtask
endclass

`endif
