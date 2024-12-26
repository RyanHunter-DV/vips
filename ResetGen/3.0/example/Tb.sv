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

	logic[10:0] clk;

	initial begin
		clk ='h0;
	end
	always #1ns clk[0]<= ~clk[0];
	always #2ns clk[1]<= ~clk[1];
	
	ResetGenIf#(11) rif(.clk(clk));

	initial begin
		uvm_config_db#(virtual ResetGenIf)::set(null,"tb.rif","ResetGenIf",rif);
	end

endmodule

`endif