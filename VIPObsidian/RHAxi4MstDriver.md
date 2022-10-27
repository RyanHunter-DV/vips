RHAxi4MstDriver is a uvm_driver, based on [[RHAxi4DriverBase]].

# Source Code
**codeType** `systemverilog`

**driver** RHAxi4MstDriver
The transaction of this master driver is pre-defined in [[RHAxi4DriverBase]].
**base** RHAxi4DriverBase
**field**
```systemverilog
// TODO
semaphore wdControl;
semaphore outstandingControl;
RHAxi4MstConfigBase config;
```
## build_phase
To build the basic internal fields
**build**
```systemverilog
wdControl = new(1);
outstandingControl = new(16); // fix to 16 for now.
```
## mainProcess
**vtask** `mainProcess()`
It's the main process.
**proc**
```systemverilog
__initInterface();
fork
	startBChannel();
	startRDChannel();
	startAWChannel();
	startWDChannel();
	startTransProcessor();
join
```
## init the interface to default value
To set the idle value of the interface, or other initialization if necessary.
**ltask** `__initInterface()`
**proc**
```systemverilog
config.vif.setDefault(config.defaultSignalValue);
```
## startTransProcessor
**task** `startTransProcess()`
A taks to get next item and process AXI4 requests.
**proc**
```systemverilog
seq_item_port.get_next_item(req);
REQ _r = req.clone();
if (req.type==AXI4_WRITE) begin
	awReqs.push_back(_r);
	wdReqs.push_back(_r);
end
if (req.type==AXI4_READ)
	arReqs.push_back(_r);
seq_item_port.item_done(req);
```

## startAWChannel
**ltask** `startAWChannel()`
The task to detect reqs from `awReqs`, and drive it onto write address channel.
**proc**
```systemverilog
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
**ltask** `startWDChannel()`
The task to detect reqs from `wdReqs`, and drive it onto write data channel.
**proc**
```systemverilog
// TODO
forever begin
	REQ _r;
	wait (wdReqs.size());
	_r = wdReqs.pop_front();
	__applyForOutstanding();
	fork // use this to enable the out-of-order sending
		for (int i=0;i<_r.size();i++) begin
			bit last = (i+1==_r.size())? 1'b1:1'b0;
			sendDataBeat(_r.id,_r.duser[i],_r.data[i],_r.strobe[i],last);
			if (last) __releaseOutstanding();
		end
	join_none
```
## apply/release outstanding mechanism
Before throwing the join_none thread to send a write data burst, the thread will first wait for available outstanding semaphore, only current outstanding number is not full, can current thread being thown, or else it should wait for one outstanding thread done.
**ltask** `__applyForOutstanding()`
This task will wait a value semaphore to throw the write data sending thread.
**proc**
```systemverilog
outstandingControl.get(1);
```
**ltask** `__releaseOutstanding()`
After sending the last beat of the wdata channel, the thread is going to be finished, then will release a new semaphore.
**proc**
```systemverilog
outstandingControl.put(1);
```
## sendDataBeat
This is a task to send one beat of data for the granted transaction. This task will use the `__accessed__` task to access the interface API to drive signals for write data channel.
**ltask**
```systemverilog
sendDataBeat(
	logic[`IW_MAX-1:0] id,
	logic[`UW_MAX-1:0] user,
	logic[`DW_MAX-1:0] data,
	logic[`DW_MAX/8-1:0] strobe,
	bit last
)
```
**proc**
```systemverilog
__access__();
config.vif.driveWDSignals(id,user,data,strobe,last);
__release__();
```
## control for sending data beat
We use `__access__` and `__release__` mechanism to control a semaphore flag, so that we can control only one thread can drive the write data channel at once.
**ltask** `__access__()`
**proc**
```systemverilog
wdControl.get(1);
```
**ltask** `__release__()`
**proc**
```systemverilog
wdControl.put(1);
```
## startARChannel
**ltask** `startARChannel()`
**proc**
```systemverilog
// TODO
forever begin
	REQ _r;
	wait (arReqs.size());
	_r = arReqs.pop_front();
	config.vif.driveARSignals(
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
## startBChannel
**task** `startBChannel()`
This task will be started once the run_phase started, and will forever active to drive the `BREADY` signal of a master randomly according to the `lowBCycleMin,lowBCycleMax` and `highBCycleMin, highBCycleMax` in config table.
**ref**
[[RHAxi4MstConfigBase#BCycleConfig]]
**proc**
```systemverilog
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
**task** `startRDChannel()`
This task starts a thread to drive `RREADY`, which is similar as driving BREADY isgnal, configures use `lowRDCycleMin, lowRDCycleMax` and `highRDCycleMin, highRDCycleMax`.
**proc**
```systemverilog
forever begin
	int low = $urandom_range(config.lowRDCycleMin,config.lowRDCycleMax);
	int high= $urandom_range(config.highRDCycleMin,config.highRDCycleMax);
	config.vif.drive("RREADY",0);
	config.vif.sync(low);
	config.vif.drive("RREADY",1);
	config.vif.sync(high);
end
```



