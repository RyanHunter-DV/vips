`ifndef tb__sv
`define tb__sv

`include "uvm_macros.svh"
module tb_top; // {


	import uvm_pkg::*;

	rh_axi4_if mif();
	rh_axi4_if sif();


	initial begin
		run_test();
	end


endmodule // }


`endif
