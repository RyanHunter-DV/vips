module top;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import RhAhb5Vip::*;
	import MasterTestPkg::*;

	initial begin
		run_test();
	end

	RhAhb5If vif();
	RhAhb5IfControl ifCtrl;

	initial begin
		ifCtrl = new("mstIfCtrl");
		ifCtrl.vif = vif;
		uvm_config_db#(RhAhb5IfControlBase)::set(null,"*","top.ifCtrl",ifCtrl);
	end

	// for waveform
	initial begin
	end

endmodule
