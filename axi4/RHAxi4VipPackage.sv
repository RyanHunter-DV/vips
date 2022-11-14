`ifndef RHAxi4VipPackage__sv
`define RHAxi4VipPackage__sv

package RHAxi4VipPackage;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// common
	`include "common/RHAxi4If.sv"
	`include "common/RHAxi4ConfigBase.sv"
	`include "common/RHAxi4MonitorBase.sv"


	// master
	`include "master/RHAxi4MstDriver.svh"
	`include "master/RHAxi4MstMonitor.svh"
	`include "master/RHAxi4MstSeqr.svh"
	`include "master/RHAxi4MstAgent.svh"

endpackage

`endif
