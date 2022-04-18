`ifndef rhaxi4_env__svh
`define rhaxi4_env__svh

import rh_axi4_pkg::*;

class rhaxi4_env extends uvm_env; // {


	rh_axi4Vip mst;
	rh_axi4Vip slv;


	`uvm_component_utils(rhaxi4_env)

	function new(string name="rhaxi4_env",uvm_component parent=null);
		super.new(name,parent);
	endfunction



endclass // }

`endif
