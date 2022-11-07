The driver base is a typical driver component directly derived from uvm_driver, which will automatically add the reset feature by MDC tool.

# Source Code
**driver** RHAxi4DriverBase
**tparam** REQ=RHAxi4ReqTrans,RSP=RHAxi4RspTrans
request transaction [[RHAxi4ReqTrans]], used for all AXI4 VIPs, as a request transaction. 
**base** RHDriverBase#(REQ,RSP)
[[RHDriverBase]] is the base driver component for VIPs.
**field**
```
RHAxi4ConfigBase config;
```

## build_phase
nothing in build phase.
**build**
```
// if extra code, then add here, similar for connect_phase etc.
```

