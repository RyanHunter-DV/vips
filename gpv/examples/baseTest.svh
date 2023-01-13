`ifndef baseTest__svh
`define baseTest__svh

class baseTest extends uvm_test;

	Env env;
	`uvm_component_utils(baseTest)

	function new(string name="baseTest",uvm_component parent=null);
		super.new(name);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = Env::type_id::create("env",this);
	endfunction

	task run_phase(uvm_phase phase);
		SelfTestSeq seq=new("seq");
		seq.start(env.gpv.seqr);
	endtask
endclass

`endif