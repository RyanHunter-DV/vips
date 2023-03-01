`ifndef omosTestPkg__sv
`define omosTestPkg__sv
package omosTestPkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RhAhb5Vip::*;
	import omosEnvPkg::*;

	`include "omosBaseTest.svh"
	`include "omosSingleTest.svh"
	`include "omosIncr4Test.svh"
	`include "omosIncr8Test.svh"
	`include "omosIncr16Test.svh"
	`include "omosIncrTest.svh"
endpackage
`endif
