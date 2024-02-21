`ifndef Tb__sv
`define Tb__sv

module Tb;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	initial begin
		run_test();
	end

	initial begin
		$fsdbDumpfile("test.fsdb");
		$fsdbDumpvars(0);
	end
	
	ResetGenIf#(11) rif();

	initial begin
		uvm_config_db#(virtual ResetGenIf)::set(null,"tb.rif","ResetGenIf",rif);
	end

endmodule

`endif