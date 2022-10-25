RHAxi4MstDriver is a uvm_driver, based on [[RHAxi4DriverBase]].

# Source Code
**driver** RHAxi4MstDriver
**param** type REQ=RHAxi4ReqTrans,RSP=RHAxi4RspTrans
request transaction [[RHAxi4ReqTrans]], used for all AXI4 VIPs, as a request transaction. 
**base** RHAxi4DriverBase#(REQ,RSP)
**field**
```
// TODO
```

## mainProcess
**vtask** `mainProcess()`
It's the main process.
**proc**
fork
	startBChannel();
	startRDChannel();
	startAWChannel();
	startWDChannel();
	startTransProcessor();
join

## startTransProcessor
**task** `startTransProcess()`
A taks to get next item and process AXI4 requests.
**proc**
```
seq_item_port.get_next_item(req);
REQ _r = req.clone();
if (req.type==AXI4_WRITE) begin
	awReqs.push_back(_r);
	wdReqs.push_back(_r);
end
if (req.type==AXI4_READ)
	arReqs.push_back(_r);
```

## startAWChannel
**ltask** startAWChannel()
The task to detect reqs from `awReqs`, and drive it onto write address channel.
**proc**
```
forever begin
	REQ _r;
	wait (awReqs.size());
	_r = awReqs.pop_front();
	config.vif.driveAWSignals(
		_r.burst,
		_r.addr,
		_r.size,
		_r.len,
		_r.lock,
		_r.cache,
		_r.prot,
		_r.region,
		_r.user,
		_r.id,
		_r.qos
	);
end
```
## startWDChannel
**ltask** startWDChannel()
The task to detect reqs from `wdReqs`, and drive it onto write data channel.
**proc**
```
// TODO
```
## startARChannel
**ltask** startARChannel()
**proc**
```
// TODO
```
#TBD 
## startBChannel
**task** `startBChannel()`
This task will be started once the run_phase started, and will forever active to drive the `BREADY` signal of a master randomly according to the `lowBCycleMin,lowBCycleMax` and `highBCycleMin, highBCycleMax` in config table.
**ref**
[[RHAxi4MstConfigBase#BCycleConfig]]
**proc**
```
forever begin
	int low = $urandom_range(config.lowBCycleMin,config.lowBCycleMax);
	int high= $urandom_range(config.highBCycleMin,config.highBCycleMax);
	config.vif.drive("BREADY",0);
	config.vif.sync(low);
	config.vif.drive("BREADY",1);
	config.vif.sync(high);
end
```
## startRDChannel
**task** startRDChannel()
This task starts a thread to drive `RREADY`, which is similar as driving BREADY isgnal, configures use `lowRDCycleMin, lowRDCycleMax` and `highRDCycleMin, highRDCycleMax`.
**proc**
```
forever begin
	int low = $urandom_range(config.lowRDCycleMin,config.lowRDCycleMax);
	int high= $urandom_range(config.highRDCycleMin,config.highRDCycleMax);
	config.vif.drive("RREADY",0);
	config.vif.sync(low);
	config.vif.drive("RREADY",1);
	config.vif.sync(high);
end
```



