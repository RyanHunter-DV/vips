`ifndef RhQLpiVip__sv
`define RhQLpiVip__sv

`include "RhQLpiIf.sv"

package RhQLpiVip;
	`include "uvm_macros.svh"
	`include "rhlib.svh"
	// `include "RhVipBase.svh"
	`include "RhQLpiType.svh"

	import uvm_pkg::*;
	import RhDebugger::*;
	//import lpi::*;

	`include "RhQLpiTrans.svh"
	`include "RhQLpiConfig.svh"

	`include "seqlib/RhQLpiPReqBaseSeq.svh"
	`include "seqlib/RhQLpiPowerOnSeq.svh"
	`include "seqlib/RhQLpiPowerOffSeq.svh"

	`include "RhQLpiDriver.svh"
	`include "RhQLpiMonitor.svh"
	`include "RhQLpiSeqr.svh"
	`include "RhQLpiVip.svh"


endpackage


`endif