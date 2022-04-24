`ifndef rhaxi4_testBase__svh
`define rhaxi4_testBase__svh

class rhaxi4_testBase extends uvm_test; // {

	rhaxi4_env env;

	`uvm_component_utils(rhaxi4_testBase)

	function new(string name="rhaxi4_testBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(),"build_phase ...",UVM_LOW)
		env=rhaxi4_env::type_id::create("env",this);
	endfunction

	task run_phase(uvm_phase phase);
		rh_axi4_testseq_base seq=new("seq");
		phase.raise_objection(this);
		`uvm_info(get_type_name(),"run_phase ...",UVM_LOW)
		seq.start(env.axim.mst.seqr);
		#100ns;
		phase.drop_objection(this);
	endtask

endclass // }

`endif
