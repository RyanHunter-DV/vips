module top;

	import uvm_pkg::*;
	import ResetGenPkg::*;

	ResetGenIf rif();

	logic tbClk0,tbClk1;
	initial begin
		tbClk0=1'b0;
		tbClk1=1'b0;
	end
	always #3ns tbClk0 <= ~tbClk0;
	always #5ns tbClk1 <= ~tbClk1;
	assign rif.refClk[0] = tbClk0;
	assign rif.refClk[1] = tbClk1;

	DUT udut(
		.iReset0(rif.oReset[0]),
		.iReset1(rif.oReset[1])
	);

	initial begin
		run_test();
	end

	initial begin
		uvm_config_db#(virtual ResetGenIf)::set(null,"tb.rif","ResetGenIf",rif);
	end
endmodule
