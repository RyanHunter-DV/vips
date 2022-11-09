`ifndef rh_ahbMstAgent__svh
`define rh_ahbMstAgent__svh

class rh_ahbMstAgent extends uvm_agent; // {

	rh_ahbMstDrv  drv;
	rh_ahbMstMon  mon;
	rh_ahbMstSeqr seqr;

	`uvm_component_utils_begin(rh_ahbMstAgent)
	`uvm_component_utils_end


endclass // }



`endif
