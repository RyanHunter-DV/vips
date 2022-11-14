This is the ahb5 master driver. Which receives configures, and transactions from other components, and then drive it to interface.
# base Features
This is an overall section about what and how many features the master driver has.
- full support of different burst transaction types, this is a default mode for master driver, it should be supported first.
	- [[#separately drive address and data phase]]
- [[#get configure table]]
- #TBD , more extra features will be added at later version.

*reference links:*
- [[src-rhAhb5ReqTrans.svh]]
# Source Code
**driver** `RhAhb5MstDriver`
**tparam** `REQ=RhAhb5ReqTrans,RSP=RhAhb5RspTrans`
**base** `RHDriverBase#(REQ,RSP)`
Currently we don't need to create a base driver for ahb5 master and slave, just derived from the base vip driver called `RHDriverBase`.

## get configure table
The agent will directly assign a configure table for the driver, so it won't do extra actions.
**field**
```systemverilog
RhAhb5MstConfig config;
```

## separately drive address and data phase
For each transaction, which contains both data and address information, but it will be sent to bus separately by pushing them into separate queues. First decalre two `RhAhb5ReqTrans` typed queue, to store data and address information from sequencer.
**field**
```systemverilog
REQ addressQue[$];
REQ dataQue[$];
int outstandingData;
```
Since the address and data phase has dependencies, so transaction in dataQue only comes from the thread after sending the addressQue, like:
```systemverilog
item = addressQue.pop_front();
...
// for sendAddressPhase, if outstandingData>0, the address phase should waity
// ready high, or else just wait one cycle.
config.sendAddressPhase(item.addr,item.write,..., outstandingData);
// call of sendAddressPhase will last at least one cycle.
dataQue.push_back(item);
outstandingData++;
```
### startAddressPhaseThread
As above described, can create a task that started in `mainProcess` and will process items in `addressQue`.
**task** `startAddressPhaseThread()`
**proc**
```systemverilog
forever begin
	RhAhb5TransBeat beat;
	wait(addressQue.size());
	beat = addressQue.pop_front();
	config.sendAddressPhase(beat,outstandingData);
	dataQue.push(beat);
	outstandingData++;
end
```
reference: [[src-rhAhb5MstConfig.svh#sendAddressPhase]];
In data phase driving, the `outstandingData` will be decreased when each data beat is sent (here sent means got by slave with HREADY high);
```systemverilog
data = dataQue.pop_front();
config.sendDataPhase(data.data,xxx);
// here means the data been sent with hready high.
outstandingData--;
```

### startDataPhaseThread
Per above shows, to create a task that will be triggered at `mainProcess` and In this task, a forever loop which will:
- pop item from `dataQue`;
- send data beat and detect the error response, if error occurred, the send task should return immediately for next driving process. Which will drop all current beats in `addressQue` and `dataQue`,  and drive one cycle of IDLE for current address and data bus.
- call `processError` once detect and error while sending current data beat.
**task** `startDataPhaseThread()`
**proc**
```systemverilog
forever begin
	RhAhb5TransBeat beat;
	bit isError;
	wait(dataQue.size());
	beat = dataQue.pop_front();
	config.sendDataPhase(beat,isError);
	if (isError) begin
		processError();
		outstandingData = 0;
	end else outstandingData--;
end
```
reference:
- [[#processError]];
- [[src-rhAhb5MstConfig.svh#sendDataPhase]];

## random delay before sending a transaction
For a master, only the start of an entire transaction can have delay, once the first beat is sent, the master should not insert any delay, special idle state by inserting BUSY trans should be given by the test create through a sequence, the driver itself cannot support this feature.
So for delay of the first beat will be injected once the thread gets the transaction through `get_next_item`, then a delay from the `RhAhb5ReqTrans` is used and will waited before pushing this transaction into the `addressQue`. The main thread can call `processDelay(delay)` after getting the transaction.
**task** `processDelay(input int cycle)`
**proc**
```systemverilog
config.waitCycle(cycle);
```
## process single burst transactions
By mechanisms above, sending of different BURST will not have different operations.
## process incr burst transactions
#TBD 
## process wrap burst transactions
#TBD 
## error processing
When detect an error, the master driver should process this kind of situation, to abort the original transactions in processing and drive to idle. Each time in driving the data phase, should return an error flag from interface, then will trigger the error processing thread. Procedures of error processing can be like:
```systemverilog
config.sendDataPhase(data.data,xxx,error);
if (error) begin
	stopNextDataBeats();
	driveIdleBeat();
end else continueNextDataBeats();
```
So the driver will define a task to process those kind of errors after sending each data beat.
### processError
**task** `processError()`
**proc**
```systemverilog
dataQue.delete();
addressQue.delete();
config.driveIdleBeat(1);
```
reference:
- [[src-rhAhb5MstConfig.svh#driveIdleBeat]]; #TODO 

## build_phase
Doing basic initializations for driver component as  described in above.
**build**
```systemverilog
outstandingData = 0;
```

## mainProcess
This is the main entry of driver.
**vtask** `mainProcess()`
**proc**
```systemverilog
fork
	startSeqProcess();
	startAddressPhaseThread();
	startDataPhaseThread();
join
```
reference:
- [[#startAddressPhaseThread]]; 
- [[#startDataPhaseThread]];
## startSeqProcess
This is a forever loop for waiting and processing sequence items from test level. After processed the delay action, will then push to address phase queue for address processing.
#TBD,shall add support for response later.
**task** `startSeqProcess()`
**proc**
```systemverilog
forever begin
	REQ cloned;
	RhAhb5TransBeat beats[$];
	seq_item_port.get_next_item(req);
	processDelay(req.delay);
	splitTransToBeats(req,beats);
	foreach (beats[i]) addressQue.push_back(beats[i]);
	wait (addressQue.size()==0); // only when this trans finished, can next coming in.
	seq_item_port.item_done();
end
```

reference:
- [[src-rhAhb5Types.svh#RhAhb5TransBeat]]
- [[#splitTransToBeats]]

## splitTransToBeats
A function to split the whole transaction into many beats that has one address, htrans and data etc, information.
**func** `splitTransToBeats(REQ tr,ref RhAhb5TransBeat beats[$])`
**proc**
```systemverilog
foreach (tr.trans[i]) begin
	RhAhb5TransBeat beat;
	beat.index = i;
	beat.burst = tr.burst;
	beat.trans = tr.trans[i];
	beat.write = tr.write;
	if (beat.write) beat.data = tr.wdata[i];
	beat.addr  = tr.addr;
	beat.master= tr.master;
	beat.size  = tr.size;
	beat.lock  = tr.lock;
	beat.prot  = tr.prot;
	beat.nonsec= tr.nonsec;
	beat.excl  = tr.excl;

	beats.push_back(beat);
end
```





