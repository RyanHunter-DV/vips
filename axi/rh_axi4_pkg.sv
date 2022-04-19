`ifndef rh_axi4_pkg__sv
`define rh_axi4_pkg__sv

`include "common/rh_axi4_global_macros.svh"
`include "rh_axi4_if.sv"
package rh_axi4_pkg; // {

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "common/rh_axi4_types.svh"
	`include "common/rh_axi4_trans.svh"
	`include "common/rh_axi4_config.svh"
	`include "common/rh_axi4_drvBase.svh"
	`include "common/rh_axi4_monBase.svh"

	// mst
	`include "mst/rh_axi4mst_drv.svh"
	`include "mst/rh_axi4mst_mon.svh"
	`include "mst/rh_axi4mst_seqr.svh"
	`include "mst/rh_axi4mst.svh"


	// vip container
	`include "common/rh_axi4Vip.svh"

endpackage // }

`endif
