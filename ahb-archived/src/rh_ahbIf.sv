interface rh_ahbIf #(AW=32,DW=32)(
	input logic HCLK,
	input logic HRESETN
); // {

	logic HSEL;
	logic HMASTER;
	logic HMASTERLOCK;

	logic HTRANS;
	logic HBURST;
	logic [AW-1:0] HADDR;




	modport master(
	);


endinterface // }
