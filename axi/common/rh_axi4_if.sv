`ifndef rh_axi4_if__sv
`define rh_axi4_if__sv

interface rh_axi4_if #(`RH_AXI4_IF_PARAM) (
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
	logic [7:0] AWPROT;
	// TODO

	clocking mstClock @(posedge ACLK);
	endclocking

	typedef class rh_axi4_trans;
	class rhaxi4_wa_info; // {{{
		// TODO.
		bit[1:0] awburst;
		bit[IW-1:0] awid;
		bit[2:0] awsize;
		bit[7:0] awlen;
		bit[AW-1:0] awaddr;
		...
		function new(rh_axi4_trans tr);
			copy(tr);
		endfunction
		function void copy(rh_axi4_trans tr); // {{{
			awburst=tr.burst;
			awid   =tr.id[IW-1:0];
			awsize =tr.size[2:0];
			awlen  =tr.len[7:0];
			awaddr =tr.addr[AW-1:0];
			...
		endfunction // }}}
	endclass // }}}

	class rhaxi4_wd_info; // {{{
	endclass // }}}

	task driveWA(rhaxi4_wa_info wa); // {{{
		// TODO
		@mstClock;
		// raise wa info
		AWVALID<=1'b1;
		AWADDR<=wa.awaddr;
		AWSIZE<=wa.awsize;
		AWBURST<=wa.awburst;
		...
		do
			@mstClock;
		while (AWREADY != 1'b1);
		// drop wa info
		AWVALID<=1'b0;
		...
	endtask // }}}

	task driveWD(rhaxi4_wd_info wd); // {{{
		// TODO.
	endtask // }}}



endinterface


`endif
