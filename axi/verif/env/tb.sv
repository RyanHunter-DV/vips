`ifndef tb__sv
`define tb__sv

`include "uvm_macros.svh"
module tb_top; // {


	import uvm_pkg::*;

	logic tb_clk;
	logic tb_rstn;

	rh_axi4_if mif(tb_clk,tb_rstn);
	rh_axi4_if sif(tb_clk,tb_rstn);


	initial begin
		tb_clk = 1'b0;
		tb_rstn = 1'b0;
		#100ns;
		tb_rstn = 1'b1;
	end

	always #5ns tb_clk <= ~tb_clk;

	initial begin
		run_test();
	end

	initial begin
		uvm_config_db#(virtual rh_axi4_if#(32,32,16))::set(null,"testPathOfAXI","rh_axi4_if",mif);
	end

	dumpctrl dumper();

endmodule // }


`endif
