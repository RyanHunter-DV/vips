`ifndef rhAhb5If__sv
`define rhAhb5If__sv

interface RhAhb5If #( AW=32,DW=32)(input logic HCLK,input logic HRESETN);
	logic [AW-1:0] HADDR;
	logic [1:0] HTRANS;
	logic [2:0] HBURST;
	logic [3:0] HMASTER;
	logic [2:0] HSIZE;
	logic [7:0] HPROT;
	logic [DW-1:0] HWDATA;
	logic HMASTLOCK;
	logic HNONSEC;
	logic HEXCL;
	logic HWRITE;
	logic [1:0] HRESP;
	logic [DW-1:0] HRDATA;
	logic HREADYOUT;
	logic HEXOKAY;
endinterface

`endif
