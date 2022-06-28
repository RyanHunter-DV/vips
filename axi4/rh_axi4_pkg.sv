`ifndef rh_axi4_pkg__sv
`define rh_axi4_pkg__sv


package rh_axi4_vip; // {

    `include "uvm_macros.svh"   
    import uvm_pkg::*;

    `include "rh_stdint.svh"

	// global types & macros
    `include "common/rh_axi4_types.svh"

    `include "common/rh_reset_handler.svh"
    `include "common/rh_axi4_trans.svh"
    `include "common/rh_axi4_baseSeqr.svh"
    `include "common/rh_axi4_vip_configBase.svh"
    `include "common/rh_axi4_ifcontrol_base.svh"
	`include "common/rh_axi4_driverBase.svh"


    // seqlib
    `include "seqlib/rh_axi4mst_bseq.svh"

    // mst
    `include "mst/rh_axi4mst_drv.svh"
    `include "mst/rh_axi4mst_mon.svh"
    `include "mst/rh_axi4mst_seqr.svh"
    `include "mst/rh_axi4mst_agt.svh"

    // slv
    `include "slv/rh_axi4slv_agt.svh"

    `include "common/rh_axi4_vip_config.svh"
    `include "common/rh_axi4_vip.svh"

endpackage // }
`include "common/rh_axi4_if.sv"

`endif
