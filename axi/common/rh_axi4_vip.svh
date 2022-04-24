`ifndef rh_axi4_vip__svh
`define rh_axi4_vip__svh


class rh_axi4_vip extends uvm_env; // {



	rh_axi4mst mst;
	// TODO, rh_axi4slv slv;

	// for master, it's master config, for slave, it's slave config
	rh_axi4_configBase cfg;



	`uvm_component_utils_begin(rh_axi4_vip)
	`uvm_component_utils_end

	function new(string name="rh_axi4_vip", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	// APIs

	// phases
	extern function void build_phase(uvm_phase phase);

	function void end_of_elaboration_phase(uvm_phase phase);
		cfg.elaborateConfigs;
	endfunction

endclass // }

function void rh_axi4_vip::build_phase(uvm_phase phase); // {{{
	super.build_phase(phase);
	mst=rh_axi4mst::type_id::create("mst",this);
	mst.cfg=cfg;
	// TODO
endfunction // }}}


`endif
