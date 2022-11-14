`ifndef clockGen_pkg__sv
`define clockGen_pkg__sv

`include "clockGen_if.sv"
package clockGen_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	`include "clockGen_trans.svh"
	`include "clockGen_config.svh"
	`include "clockGen_seqr.svh"
	`include "clockGen_driver.svh"
	`include "clockGen_monitor.svh"
	`include "clockGen_uvc.svh"


endpackage


`endif
