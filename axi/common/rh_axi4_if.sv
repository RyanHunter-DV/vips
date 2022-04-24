`ifndef rh_axi4_if__sv
`define rh_axi4_if__sv

interface rh_axi4_if #(`RH_AXI4_IF_DEFAULT_PARAM) (
	input ACLK,
	input ARESETN
);

	// wa channel
	logic AWVALID,AWREADY,AWLOCK;
	logic [IW-1:0] AWID;
	logic [AW-1:0] AWADDR;
	logic [2:0] AWSIZE;
	logic [7:0] AWLEN;
	logic [1:0] AWBURST;
	logic [3:0] AWCACHE;
	logic [2:0] AWPROT;
	logic [3:0] AWREGION;
	logic [3:0] AWQOS;

	clocking mstClock @(posedge ACLK);
	endclocking


	task sync(int unsigned d=1);
		repeat (d) @mstClock;
	endtask

	task driveWA(
		bit [255:0] addr,
		bit [2:0] size,
		bit [1:0] burst,
		bit [3:0] cache,
		bit [3:0] prot,
		bit [3:0] region,
		bit [3:0] qos,
		bit lock
	); // {{{
		@mstClock;
		// raise wa info
		AWVALID <=1'b1;
		AWADDR  <=addr;
		AWSIZE  <=size;
		AWBURST <=burst;
		AWCACHE <=cache;
		AWREGION<=region;
		AWPROT  <=prot;
		AWQOS   <=qos;
		AWLOCK  <=lock;
		do
			@mstClock;
		while (AWREADY != 1'b1);
		// drop wa info
		AWVALID <=1'b0;
		AWADDR  <='h0;
		AWSIZE  <='h0;
		AWBURST <='h0;
		AWCACHE <='h0;
		AWREGION<='h0;
		AWPROT  <='h0;
		AWQOS   <='h0;
		AWLOCK  <='h0;
	endtask // }}}

	// @RyanH task driveWD(rh_axi4_trans wd); // {{{
	// @RyanH 	// TODO.
	// @RyanH endtask // }}}



endinterface


`endif
