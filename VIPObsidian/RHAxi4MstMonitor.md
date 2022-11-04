The monitor used to collect requests/response of AXI protocol, besides, it monitors the reset events according to the [[RHMonitorBase]].
## reference
- [[RHAxi4If]]
- 
# Source Code
**monitor** RHAxi4MstMonitor
**tparam** `REQ=RHAxi4ReqTrans,RSP=RHAxi4RspTrans`
**base** RHMonitorBase
**field**
```

logic currentResetSignal;
RHAxi4MstConfigBase config;
```
## reqP
A TLM port for sending all request channel information when detected, both for AW/AR channel, that means once the write address valid and ready detected, the transaction will be sent through this port.
**tlm-ap** `RHAxi4ReqTrans reqP`
## wreqP
A specific TLM for write request, collected both the write address and write data information.
**tlm-ap** `RHAxi4ReqTrans wreqP`
## rspP
The response TLM, for sending write/read response information, read response means the read data channel information, while the write response means the bresp channel. No request information will be recorded.
**tlm-ap** `RHAxi4RspTrans rspP`

## build phase
**build**
```systemverilog
currentResetSignal = 'bx;
reqP = new("reqP");
wreqP= new("wreqP");
rspP = new("rspP");
```
## waitResetStateChanged
A virtual task from super class to wait reset signal from config and then output a changed reset state.
**vtask** `waitResetStateChanged(output RHResetState_enum s)`
```systemverilog
wait(config.vif.ARESETN !== currentResetSignal);
currentResetSignal = config.vif.ARESETN;
s = RHResetState_enum'(currentResetSignal);
```
## mainProcess
**vtask** `mainProcess()`
**proc**
```systemverilog
fork
	startAWChannel();
	startARChannel();
	startWDChannel();
	startRDChannel();
	startBChannel();
join
```

## startAWChannel
A task to monitor write address channel, collect the signal information into request transaction, and push to write request queue, which will be poped by write data channel when that channel collected write data channel.
This task can send a request of AW channel information only, by reqP.
**task** `startAWChannel()`
**proc**
```systemverilog
REQ aw = new("aw");
config.vif.waitAWValid(); // wait awvalid and arvalid synchronized
aw.burst = config.vif.AWBURST;
aw.id    = config.vif.AWID;
aw.lock  = config.vif.AWLOCK;
aw.addr  = config.vif.AWADDR;
// TODO
```

## startWDChannel
Monitoring write data channel information from signal to transaction. When detecting the first beat of a write data, then searching in the write request queue, and pop that transaction. Then collect the remaining write data beats until all beats monitored, and then send this transaction through port. This transaction will be sent by wreqP.
**task** `startWDChannel()`
**proc**
```systemverilog
// TODO
```
## startARChannel
#TBD 
## startRDChannel
#TBD 
## startBChannel
#TBD 
