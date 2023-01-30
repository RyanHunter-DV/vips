module top;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RhAhb5Vip::*;
	import omosTestPkg::*;

	initial begin
		run_test();
	end

	logic TB_HRESETN;
	logic TB_HCLK;

	RhAhb5If vif(TB_HCLK,TB_HRESETN);
	RhAhb5IfControl ifCtrl;

	initial begin
		TB_HRESETN = 1'b0;
		TB_HCLK = 1'b0;
		#100ns;
		TB_HRESETN = 1'b1;
	end
	always #5ns TB_HCLK <= ~TB_HCLK;

	initial begin
		vif.HREADY = 1'b1;
	end

	initial begin
		ifCtrl = new("mstIfCtrl");
		ifCtrl.vif = vif;
		uvm_config_db#(RhAhb5IfControlBase)::set(null,"*","top.ifCtrl",ifCtrl);
	end

	// for waveform
	initial begin
		$shm_open("test.shm");
		$shm_probe("AS",top);
	end

endmodule
