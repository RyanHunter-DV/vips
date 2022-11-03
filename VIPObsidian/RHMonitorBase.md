# Source Code
**monitor** RHMonitorBase
## support for monitoring reset actions
We'll use a report port to send the reset change event through the TLM port, after detecting by a subclass's API `waitResetStateChanged`
**ap-port** `RHResetTransBase resetP`
**field**
```systemverilog
RHResetState_enum currentResetState;
```
## build_phase
**build**
```
currentResestState = RHResetUnknow;
```
## waitResetStateChanged
A virtual task to wait and get the changed reset state, this task will be overidden by sub-class.
**vtask** `waitResetStateChanged(output RHResetState_enum s)`
```systemverilog
// subclass should override this task
```

## run_phase
In run_phase, the monitor will spawn two parallel threads, one is for reset monitoring, which is common for all monitors that derived from this base, and the other thread is a mainProcess that can be used by subclasses
**run**
```systemverilog
fork
	resetMonitor();
	mainProcess();
join
```

## mainProcess
virtual task without doing anything
**vtask** `mainProcess()`
```systemverilog
// subclass should override this task
```
## resetMonitor
This is a forever task one run_phase started, this will wait the reset state changed by subclass, and then assemble a reset transaction and send through reset port.
**task** `resetMonitor()`
```systemverilog
RHResetTransBase _t = new("initReset");
_t.state = currentResetState;
resetP.send(_t);
forever begin
	RHResetTransBase updatedTrans = new("updatedReset");
	waitResetStateChanged(currentResetState);
	updatedTrans.state = currentResetState;
	resetP.send(updatedTrans);
end
```