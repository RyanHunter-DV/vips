`ifndef rhGpVip__sv
`define rhGpVip__sv

`include "uvm_macros.svh"
package RhGpVip;
	import uvm_pkg::*;
	import Rhlib::*; // required

	// type/macro definition
	`include "rhGpvTypes.svh"

	`include "rhGpvSignal.svh"
	`include "rhGpvTrans.svh"
	`include "rhGpvDataObj.svh"

	// the basic interface 
	`include "rhGpvIf.sv"
	// the interface controller, contained interface and passed to vip
	`include "rhGpvIfCtrl.svh"


	`include "rhGpvConfig.svh"
	`include "rhGpvProtocolBase.svh"
	`include "rhGpvConfig.svh"

	// the main driver object to process incoming transactions
	`include "rhGpvDriver.svh"
	`include "rhGpvMonitor.svh"
	`include "rhGpvAgent.svh"

endpackage

`endif