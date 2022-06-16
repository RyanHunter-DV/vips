`ifndef rh_axi4_if__sv
`define rh_axi4_if__sv


interface rh_axi4_if #(`RH_AXI4_IF_PARAM_DECL) (); // {

    logic ACLK,ARESETN;

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




    `include "common/rh_axi4_protocol_check.sv"
    `include "common/rh_axi4_ifcontrol.svh"

    rh_axi4_ifcontrol ifcontrol=new("ifcontrol");
endinterface // }

`endif
