interface rh_ahbIf #(AW=32,DW=32)(
	input logic HClk,
	input logic HResetN
); // {

	logic HSel;
	logic HMaster;
	logic HMasterLock;

	logic HTrans;
	logic HBurst;
	logic [AW-1:0] HAddr;





endinterface // }
