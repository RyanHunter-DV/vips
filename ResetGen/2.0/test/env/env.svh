class Env extends uvm_env;
	ResetGen rg;
	ResetGenConfig rgc;

	`uvm_component_utils(Env)

	function new(string name="Env",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase (uvm_phase phase);
endclass

function void Env::build_phase(uvm_phase phase); // ##{{{
	rg=ResetGen::type_id::create("rg",this);
	rgc=rg.createConfig("tb.rif");
endfunction // ##}}}
