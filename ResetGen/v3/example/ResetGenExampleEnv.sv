`ifndef ResetGenExampleEnv__sv
`define ResetGenExampleEnv__sv

package ResetGenExampleEnv;
/* Description, ResetGenExampleEnv, 
*/
	import uvm_pkg::*;
	`include "rhlib.svh"
	

	`include "ResetGenExampleEnv.svh"
	`include "ResetGenExampleBaseTest.svh"

	// tests
	// TODO, need build tests
	// to init resets with manual duration to change from active to inactive.
	`include "tests/InitWithManualDurationTest.svh"
	// to init resets that active value is 1
	// drive active after init done.
	`include "tests/ActiveHighResetTest.svh"

	// start an active sequence with random duration.
	`include "tests/ActiveResetWithRandomDuration.svh"

endpackage


`endif