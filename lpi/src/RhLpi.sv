`ifndef RhLpi__sv
`define RhLpi__sv

`include "RhQLpiIf.sv"
package RhLpi;
	`include "uvm_macro.svh"
	`include "rhlib.svh"
	`include "RhVipBase.svh"
	`include "RhLpiType.svh"

	import uvm_pkg::*;
	import RhDebugger::*;
	import lpi::*;

	`include "RhQLpiTrans.svh"
	`include "RhQLpiConfig.svh"
	`include "RhQLpiDriver.svh"
	`include "RhQLpiMonitor.svh"
	`include "RhQLpiSeqr.svh"
	`include "RhQLpi.svh"

endpackage


`endif