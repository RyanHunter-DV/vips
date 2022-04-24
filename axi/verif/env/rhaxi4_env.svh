`ifndef rhaxi4_env__svh
`define rhaxi4_env__svh

`include "uvm_macros.svh"
import uvm_pkg::*;
import rh_axi4_pkg::*;

class rhaxi4_env extends uvm_env; // {


	rh_axi4_vip axim;
	rh_axi4_config#(32,32,16) aximCfg;
	// TODO, rh_axi4_vip axis;
	// TODO, rh_axi4_config axisCfg;


	`uvm_component_utils(rhaxi4_env)

	function new(string name="rhaxi4_env",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void setupConfig;
		aximCfg.setIntfPath("testPathOfAXI");
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		axim=rh_axi4_vip::type_id::create("axim",this);
		aximCfg=rh_axi4_config#(32,32,16)::type_id::create("aximCfg");
		axim.cfg=aximCfg;
		setupConfig;
	endfunction

endclass // }

`endif
