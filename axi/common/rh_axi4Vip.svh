`ifndef rh_axi4Vip__svh
`define rh_axi4Vip__svh


class rh_axi4Vip extends uvm_env; // {



	rh_axi4mst mst;
	// TODO, rh_axi4slv slv;

	// for master, it's master config, for slave, it's slave config
	rh_axi4_config cfg;



	`uvm_component_utils_begin(rh_axi4Vip)
	`uvm_component_utils_end

	function new(string name=="rh_axi4Vip", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	// APIs
	// set device mode, master/slave
	extern function void setDevice(rhaxi4_device_enum d);
	// TODO


	// phases
	extern function void build_phase(uvm_phase phase);



endclass // }

function void rh_axi4Vip::build_phase(uvm_phase phase); // {{{
	super.build_phase(phase);
	// TODO
endfunction // }}}


`endif
