`ifndef resetGen_pkg__sv
`define resetGen_pkg__sv

`include "resetGen_if.sv"
package resetGen_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	// typedef within this package
	typedef enum bit {
		resetGen_activeLow=1'b0,
		resetGen_activeHigh=1'b1
	} resetActive_enum;

	`include "resetGen_trans.svh"
	`include "resetGen_config.svh"
	`include "resetGen_seqr.svh"
	`include "resetGen_seqlib.svh"
	`include "resetGen_driver.svh"
	`include "resetGen_monitor.svh"
	`include "resetGen_uvc.svh"


endpackage


`endif
