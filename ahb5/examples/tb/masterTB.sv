module utTB;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	initial begin
		run_test();
	end

	rhAhb5If vif();
	rhAhb5IfControl ifCtrl;

	initial begin
		ifCtrl = new("mstIfCtrl");
		ifCtrl.vif = vif;
		uvm_config_db#(rhAhb5IfControlBase)::set(null,"*","utTB.ifCtrl",ifCtrl);
	end

	// for waveform
	initial begin
	end

endmodule
