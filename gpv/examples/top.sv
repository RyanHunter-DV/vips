`include "uvm_macros.svh"
module top;

	import uvm_pkg::*;
	import RhGpVip::*;
	import test_pkg::*;


	RhGpvIf rif0();

	DUT udut (
		.clk_i  (rif0.clock[0]),
		.rstn_i (rif0.reset[0]),
		.valid_i(rif0.vector[0]),
		.data_i (rif0.vector[32:1]),
		.ack_o  (rif0.vector[33])
	);


	initial begin
		run_test();
	end

	initial begin
		RhGpvIfCtrl ifCtrl = new("rif0Ctrl");
		ifCtrl.vif = rif0;
		uvm_config_db#(RhGpvIfCtrl)::set(null,"*","tb.rif0",ifCtrl);
	end

endmodule