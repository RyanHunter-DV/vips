class Testbase extends uvm_test;
	Env env;

	`uvm_component_utils(Testbase)

	extern function  new (string name="testbase",uvm_component parent=null);
	extern function void build_phase (uvm_phase phase);
endclass


function void Testbase::build_phase(uvm_phase phase); // ##{{{
	super.build_phase(phase);
	env=Env::type_id::create("env",this);
endfunction // ##}}}

function  Testbase::new(string name="testbase",uvm_component parent=null); // ##{{{
	super.new(name,parent);
endfunction // ##}}}
