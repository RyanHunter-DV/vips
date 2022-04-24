`ifndef rh_axi4_pkg__sv
`define rh_axi4_pkg__sv

`include "common/rh_axi4_global_macros.svh"
`include "common/rh_axi4_if.sv"
package rh_axi4_pkg; // {

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "common/rh_axi4_types.svh"
	`include "common/rh_axi4_trans.svh"
	`include "common/rh_axi4_configBase.svh"
	`include "common/rh_axi4_config.svh"
	`include "common/rh_axi4_drvBase.svh"
	`include "common/rh_axi4_monBase.svh"

	// seqlib
	`include "seqlib/rh_axi4_testseq_base.svh"

	// mst
	`include "mst/rh_axi4mst_drv.svh"
	`include "mst/rh_axi4mst_mon.svh"
	`include "mst/rh_axi4mst_seqr.svh"
	`include "mst/rh_axi4mst.svh"


	// vip container
	`include "common/rh_axi4_vip.svh"

endpackage // }

`endif
