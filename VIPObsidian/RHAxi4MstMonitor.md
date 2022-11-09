The monitor used to collect requests/response of AXI protocol, besides, it monitors the reset events according to the [[RHMonitorBase]].
## reference
- [[RHAxi4If]]
- [[RHAxi4Types]]
- [[RHAxi4ReqTrans]]
- [[RHAxi4RspTrans]]
- 
# Source Code
**monitor** RHAxi4MstMonitor
**tparam** `REQ=RHAxi4ReqTrans,RSP=RHAxi4RspTrans`
**base** RHMonitorBase
**field**
```

logic currentResetSignal;
RHAxi4MstConfigBase config;
REQ awQue[$];
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
forever begin
	REQ aw = new("aw");
	config.vif.waitAWValid(); // wait awvalid and arvalid synchronized
	aw.type  = rhaxi4_writeReq;
	aw.burst = config.vif.AWBURST;
	aw.id    = config.vif.AWID;
	aw.lock  = config.vif.AWLOCK;
	aw.addr  = config.vif.AWADDR;
	aw.user  = config.vif.AWUSER;
	aw.prot  = config.vif.AWPROT;
	aw.cache = config.vif.AWCACHE;
	aw.qos   = config.vif.AWQOS;
	aw.region= config.vif.AWREGION;
	aw.len   = config.vif.AWLEN;
	//aw.data  = new[aw.len];
	//aw.strobe= new[aw.len];
	//aw.duser = new[aw.len];
	awQue.push_back(aw);
	reqP.write(aw);
end
```

## startWDChannel
Monitoring write data channel information from signal to transaction. When detecting the first beat of a write data, then searching in the write request queue, and pop that transaction. Then collect the remaining write data beats until all beats monitored, and then send this transaction through port. This transaction will be sent by wreqP.
**task** `startWDChannel()`
**proc**
```systemverilog
int id;
forever begin
	// - get the wvalid signal
	// - start a parallel thread to collect all wdata beats for matched aw
	config.vif.waitWValid();
	last = pushWDBeatToMatchedReq(id);
	if (last) sendWriteReq(id);
end
```
## pushWDBeatToMatchedReq
This function will search the ID in awQue, if the ID is matched between current interface and item in awQue, then push the write data information to that item, if current beat is the last beat, then return 1 and modify the id to current AWID
**func** `bit pushWDBeatToMatchedReq(ref int id)`
**proc**
```systemverilog
bit last = config.vif.WLAST;
id = config.vif.WID;
foreach (awQue[i]) begin
	if (id == awQue[i].id) begin
		awQue[i].data.push_back(config.vif.WDATA);
		awQue[i].duser.push_back(config.vif.WUSER);
		awQue[i].strobe.push_back(config.vif.WSTRB);
		break;
	end
end
return last;
```
## sendWriteReq
A function to pop out the target id of transaction in awQue, and send by wreqP.
**func** `void sendWriteReq(int id)`
**proc**
```systemverilog
REQ tr;
foreach (awQue[i]) begin
	if (awQue[i].id == id) begin
		tr = awQue[i];
		awQue.delete(i);
		break;
	end
end
if (tr!=null) wreqP.write(tr);
```
## startARChannel
a task similar to startAWChannel
**task** `startARChannel()`
**proc**
```systemverilog
forever begin
	REQ ar = new("ar");
	config.vif.waitARValid(); // wait awvalid and arvalid synchronized
	ar.type  = rhaxi4_readReq;
	ar.burst = config.vif.ARBURST;
	ar.id    = config.vif.ARID;
	ar.lock  = config.vif.ARLOCK;
	ar.addr  = config.vif.ARADDR;
	ar.user  = config.vif.ARUSER;
	ar.prot  = config.vif.ARPROT;
	ar.cache = config.vif.ARCACHE;
	ar.qos   = config.vif.ARQOS;
	ar.region= config.vif.ARREGION;
	ar.len   = config.vif.ARLEN;
	reqP.write(ar);
end
```
## startRDChannel
read data channel is regarded as a response channel, so it will be sent through rspP.
**task** `startRDChannel()`
**proc**
```systemverilog
int index = -1;
RSP rspQue[$];
forever begin
	config.vif.waitRValid();
	index = matchedIDOfQueue(config.vif.RID,rspQue);
	if (index<0) begin
		RSP rd=new("rd");
		rd.id = config.vif.RID;
		rspQue.push_back(rd);
		index = rspQue.size()-1;
	end
	collectRDChannel(rspQue[index]);
	if (config.vif.RLAST===1'b1) begin
		rspP.send(rspQue[index]);
		rspQue.delete(index);
	end
end
```
## matchedIDOfQueue
#TBD 
## collectRDChannel
#TBD 
## startBChannel
#TBD 
