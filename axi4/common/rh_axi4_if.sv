`ifndef rh_axi4_if__sv
`define rh_axi4_if__sv


interface rh_axi4_if #(`RH_AXI4_IF_PARAM_DECL) (
	input logic ACLK,
	input logic ARESETN
); // {

	import rh_axi4_vip::*;

    logic AWVALID;
    logic AWREADY;
    logic AWLOCK;
    logic [1:0] AWBURST;
    logic [7:0] AWLEN;
    logic [7:0] AWPROT;
    logic [3:0] AWCACHE;
    logic [2:0] AWSIZE;
    logic [AW-1:0] AWADDR;
    logic [IW-1:0] AWID;
    logic [UW-1:0] AWUSER;
    logic [3:0] AWREGION;
    logic [3:0] AWQOS;

    logic [IW-1:0] WID;
    logic [DW-1:0] WDATA;
    logic [$clog2(DW)-1:0] WSTRB;
    logic WVALID,WREADY,WLAST;
    logic [UW-1:0] WUSER;

    logic [IW-1:0] BID;
    logic [1:0] BRESP;
    logic [UW-1:0] BUSER;
    logic BVALID,BREADY;

    logic ARVALID;
    logic ARREADY;
    logic ARLOCK;
    logic [1:0] ARBURST;
    logic [7:0] ARLEN;
    logic [7:0] ARPROT;
    logic [3:0] ARCACHE;
    logic [2:0] ARSIZE;
    logic [AW-1:0] ARADDR;
    logic [IW-1:0] ARID;
    logic [UW-1:0] ARUSER;
    logic [3:0] ARREGION;
    logic [3:0] ARQOS;

    logic [IW-1:0] RID;
    logic [DW-1:0] RDATA;
    logic RVALID,RREADY,RLAST;
    logic [UW-1:0] RUSER;
    logic [1:0] RRESP;

	task sync(input int c=1);
		repeat (c) @(posedge ACLK);
	endtask

	task _initMasterWA;
		AWVALID <= 'hx;
		AWCACHE <= 'hx;
		AWADDR  <= 'hx;
		AWBURST <= 'hx;
		AWLEN   <= 'hx;
		AWLOCK  <= 'hx;
		AWSIZE  <= 'hx;
		AWPROT  <= 'hx;
		AWID    <= 'hx;
		AWUSER  <= 'hx;
		AWUSER  <= 'hx;
		AWREGION<= 'hx;
		AWQOS   <= 'hx;
		sync();
	endtask

	task _initSlaveWA;
		$display("PLACEHOLDER, no action, _initSlaveWA");
	endtask

	task _initMasterWD;
		WID   <= 'hx;
		WDATA <= 'hx;
		WSTRB <= 'hx;
		WVALID<= 'hx;
		WUSER <= 'hx;
		WLAST <= 'hx;
		sync();
	endtask
	task _initSlaveWD;
		$display("PLACEHOLDER, no action, _initSlaveWA");
	endtask
	task _initMasterRA;
		ARVALID <= 'hx;
		ARLOCK  <= 'hx;
		ARBURST <= 'hx;
		ARLEN   <= 'hx;
		ARCACHE <= 'hx;
		ARSIZE  <= 'hx;
		ARADDR  <= 'hx;
		ARID    <= 'hx;
		ARUSER  <= 'hx;
		ARREGION<= 'hx;
		ARQOS   <= 'hx;
		sync();
	endtask
	task _initSlaveRA;
		$display("PLACEHOLDER, no action, _initSlaveWA");
	endtask

	task releaseDriver(input string dev);
		$display($time,", releaseDriver called");
		case (dev)
			"axi4_master": _initMasterWA;
			"axi4_slave" : _initSlaveWA;
		endcase
	endtask

	task initWA(input string dev);
		$display($time,", init WA called");
		sync();
		case (dev)
			"axi4_master": _initMasterWA;
			"axi4_slave" : _initSlaveWA;
		endcase
	endtask
	task initWD(input string dev);
		sync();
		case(dev)
			"axi4_master": _initMasterWD;
			"axi4_slave" : _initSlaveWD;
		endcase
	endtask
	task initRA(input string dev);
		sync();
		case(dev)
			"axi4_master": _initMasterRA;
			"axi4_slave" : _initSlaveRA;
		endcase
	endtask

	function bit[2:0] _translateToAXISize(int unsigned size);
		// translate size of byte into awsize/arsize
		return $clog2(size);
	endfunction

	task driveMasterWA(rh_axi4_achnl_t wa);
		$display($time,", calling driveMasterWA, addr: 0x%x",wa.addr[AW-1:0]);
		sync();
		AWVALID <= 1'b1;
		AWADDR  <= wa.addr[AW-1:0];
		AWBURST <= wa.burst;
		AWLEN   <= wa.len;
		AWPROT  <= wa.prot;
		AWCACHE <= wa.cache;
		AWSIZE  <= _translateToAXISize(wa.size);
		AWID    <= wa.id[IW-1:0];
		AWUSER  <= wa.user[UW-1:0];
		AWQOS   <= wa.qos;
		AWREGION<= wa.region;
		AWLOCK  <= wa.lock;
		do
			sync();
		while (AWREADY!==1'b1);
		$display($time,", calling _initMasterWA");
		_initMasterWA;
	endtask

	task automatic driveMasterRA(ref rh_axi4_achnl_t ra);
		sync();
		ARVALID <= 1'b1;
		ARADDR  <= ra.addr[AW-1:0];
		ARBURST <= ra.burst;
		ARLEN   <= ra.len;
		ARPROT  <= ra.prot;
		ARCACHE <= ra.cache;
		ARSIZE  <= _translateToAXISize(ra.size);
		ARID    <= ra.id[IW-1:0];
		ARUSER  <= ra.user[UW-1:0];
		ARQOS   <= ra.qos;
		ARREGION<= ra.region;
		ARLOCK  <= ra.lock;
		do
			sync();
		while (ARREADY!==1'b1);
		_initMasterRA;
	endtask
	task automatic driveMasterWDBeat(ref rh_axi4_dchnl_t wd);
		sync();
		// TODO
		$display("TBD, driveMasterWDBeat do nothing");
	endtask


    `include "common/rh_axi4_protocol_check.sv"
    `include "common/rh_axi4_ifcontrol.svh"

    rh_axi4_ifcontrol ifcontrol=new("rh_axi4_ifcontrol");
endinterface // }

`endif
