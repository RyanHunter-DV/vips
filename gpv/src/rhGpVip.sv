`ifndef rhGpVip__sv
`define rhGpVip__sv

`include "uvm_macros.svh"
package RhGpVip;
	import uvm_pkg::*;
	import Rhlib::*; // required

	// type/macro definition
	`include "rhGpvTypes.svh"

	// the basic interface 
	`include "rhGpvIf.sv"
	// the interface controller, contained interface and passed to vip
	`include "rhGpvIfCtrl.svh"
	// the main driver object to process incoming transactions
	`include "rhGpvDriver.svh"

endpackage

`endif
