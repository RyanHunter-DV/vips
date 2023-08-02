`ifndef RhQLpiTb__sv
`define RhQLpiTb__sv

module Muxer(
	RhQLpiIf pCtrl,
	RhQLpiIf dev0,
	RhQLpiIf dev1,
	RhQLpiIf dev2,
	RhQLpiIf dev3,
);

	wire qactive = dev0.QACTIVE&dev1.QACTIVE&dev2.QACTIVE&dev3.QACTIVE;
	assign pCtrl.QACTIVE = qactive;

	assign dev0.QREQn = pCtrl.QREQn;
	assign dev1.QREQn = pCtrl.QREQn;
	assign dev2.QREQn = pCtrl.QREQn;
	assign dev3.QREQn = pCtrl.QREQn;

	wire qdeny = dev0.QDENY|dev1.QDENY|dev2.QDENY|dev3.QDENY;
	assign pCtrl.QDENY=qdeny;
	wire qaccept=dev0.QACCEPTn&dev1.QACCEPTn&dev2.QACCEPTn&dev3.QACCEPTn;
	assign pCtrl.QACCEPTn=qaccept;

endmodule

module tb;

	import uvm_pkg::*;
	import RhQLpiTests::*;

	logic pCtrlClock,pCtrlReset;
	logic [3:0] devClock,devReset;


	RhQLpiIf pCtrlIf(pCtrlClock,pCtrlReset);
	RhQLpiIf dev0If(devClock[0],devReset[0]);
	RhQLpiIf dev1If(devClock[1],devReset[1]);
	RhQLpiIf dev2If(devClock[2],devReset[2]);
	RhQLpiIf dev3If(devClock[3],devReset[3]);

	// mux logic
	Muxer mux(
		.pCtrl(pCtrlIf),
		.dev0 (dev0If ),
		.dev1 (dev1If ),
		.dev2 (dev2If ),
		.dev3 (dev3If )
	);

	initial begin
		uvm_config_db#(virtual RhQLpiIf)::set(null,"tb.pCtrlIf","RhQlpiIf",pCtrlIf);
		uvm_config_db#(virtual RhQLpiIf)::set(null,"tb.dev0If","RhQlpiIf",dev0If);
		uvm_config_db#(virtual RhQLpiIf)::set(null,"tb.dev1If","RhQlpiIf",dev1If);
		uvm_config_db#(virtual RhQLpiIf)::set(null,"tb.dev2If","RhQlpiIf",dev2If);
		uvm_config_db#(virtual RhQLpiIf)::set(null,"tb.dev3If","RhQlpiIf",dev3If);
	end

	initial begin
		run_test();
	end

endmodule

`endif