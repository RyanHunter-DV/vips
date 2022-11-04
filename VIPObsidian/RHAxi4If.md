# Source Code
**interface**
```systemverilog
RHAxi4If#(AW=32,DW=32,IW=32,UW=32) (
	input logic ACLK,
	input logic ARESETN
)
```

## write address channel
**field**
```systemverilog
logic AWVALID;
logic AWREADY;
logic AWLOCK;
logic [3:0] AWSIZE;
logic [1:0] AWBURST;
logic [3:0] AWCACHE;
logic [7:0] AWPROT;
logic [3:0] AWREGION;
logic [AW-1:0] AWADDR;
logic [UW-1:0] AWUSER;
logic [IW-1:0] AWID;
logic [7:0] AWLEN;
```
## write data channel
**field**
```systemverilog
logic [IW-1:0] WID;
logic WVALID;
logic WREADY;
logic WLAST;
logic [DW-1:0] WDATA;
logic [DW/8-1:0] WSTRB;
```
## read address channel
**field**
```systemverilog
logic ARVALID;
logic ARREADY;
logic ARLOCK;
logic [3:0] ARSIZE;
logic [1:0] ARBURST;
logic [3:0] ARCACHE;
logic [7:0] ARPROT;
logic [3:0] ARREGION;
logic [AW-1:0] ARADDR;
logic [UW-1:0] ARUSER;
logic [IW-1:0] ARID;
logic [7:0] ARLEN;
```
## read data channel
**field**
```systemverilog
logic [IW-1:0] RID;
logic RVALID;
logic RREADY;
logic RLAST;
logic [DW-1:0] RDATA;
logic [1:0] RRESP;
```
## write response channel
**field**
```systemverilog
logic [IW-1:0] BID;
logic BVALID;
logic BREADY;
logic [1:0] BRESP;
```
## waitValids
wait for arvalid and awvalid synchronized by ACLK clock.
**task** `waitValids()`
**proc**
```systemverilog
fork
	waitAWValid();
	waitARValid();
join_any
disable fork;
```
## waitAWValid
wait for the AWVALID signal to be 1 synchronizly by ACLK
**task** `waitAWValid()`
**proc**
```systemverilog
while (AWVALID !== 1'b1)
	@(posedge ACLK);
```
## waitARValid
wait for the ARVALID signal synchronized by ACLK
**task** `waitARValid()`
**proc**
```systemverilog
while (ARVALID !== 1'b1)
	@(posedge ACLK);
```
