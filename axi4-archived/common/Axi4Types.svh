`ifndef Axi4Types__svh
`define Axi4Types__svh

`define RH_AXI4_MAX_IW 32
`define RH_AXI4_MAX_AW 128
`define RH_AXI4_MAX_UW 64
`define RH_AXI4_MAX_DW 2048
`define RH_AXI4_MAX_SW $clog2(`RH_AXI4_MAX_DW)
`define RH_AXI4_INTF_PARAM_DECL AW=32,DW=32,IW=16,UW=32
`define RH_AXI4_INTF_PARAM_MAP  .AW(AW),.DW(DW),.IW(IW),.UW(UW)


typedef struct {
	// ready signals
	logic awready;
	logic wready;
	logic arready;
	logic rready;
	logic bready;

	// common channel
	logic [`RH_AXI4_MAX_IW-1:0] id;
	logic [`RH_AXI4_MAX_UW-1:0] user;

	// address channel
	logic [`RH_AXI4_MAX_AW-1:0] address;
	logic lock;
	logic [3:0] cache;
	logic [3:0] region;
	logic [7:0] protect;
	logic [3:0] qos;
	logic [1:0] burst;
	logic [1:0] resp;
	logic [7:0] len;
	logic [2:0] size;

	// data channel
	logic [`RH_AXI4_MAX_DW-1:0] data[];

	// wdata channel
	logic [`RH_AXI4_MAX_SW-1:0] strobe[];

}Axi4ChannelInfo ;

typedef enum {
	RHAxi4WriteReq,
	RHAxi4ReadReq,
	RHAxi4WriteRsp,
	RHAxi4ReadRsp
}Axi4SeqType;



`endif
