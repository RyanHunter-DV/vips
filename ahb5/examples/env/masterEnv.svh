class masterEnv extends uvm_env;

	RhAhb5MstAgent mst;
	RhAhb5MstConfig config;

	`uvm_component_utils(masterEnv)

	function new(string name="masterEnv",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);

endclass

function void masterEnv::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	mst   = RhAhb5MstAgent::type_id::create("mst",this);
	config= mst.createConfig("mstConfig");
	config.interfacePath="top.vif";
endfunction // }
