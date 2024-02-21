`ifndef ResetGen__sv
`define ResetGen__sv

`include "ResetGenIf.sv"

package ResetGen;
/* Description, ResetGen, 
*/
	import uvm_pkg::*;
	`include "rhlib.svh"


	`include "ResetGenTrans.svh"

	`include "ResetGenConfig.svh"

	`include "ResetGenDriver.svh"
	`include "ResetGenMonitor.svh"

	`include "ResetGen.svh"

	// seqlib
	`include "seqlib/ResetGenBaseSeq.svh"
	`include "seqlib/ResetGenSanityActiveSeq.svh"
	`include "seqlib/ResetGenRandomActiveSeq.svh"

endpackage

`endif