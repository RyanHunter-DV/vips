# Source Code
**driver** RHDriverBase
**tparam** REQ=uvm_sequence_item,RSP=REQ
**ap-imp** `reset RHResetTransBase resetI`
```
// extra code in write_reset, the input trans argument is _tr
resetState = _tr.state;
```
[[RHResetTransBase]] is the reset transaction in [[RHVipBase]] package.
**field**
```
RHResetState_enum resetState;
```
RHResetState_enum is a type defined in [[RHTypes]].
**field**
```
process proc;
```
## mainProcess
**vtask** `mainProcess()`
**proc**
```
// override in sub classes
```

## build_phase
- init resetI imp
**build**
```
resetI = new("resetI");
```
## run_phase
**run**
```
// extra run code here
fork
	__resetDetector();
	forever begin
		wait(resetState == RHResetInactive);
		proc = process::self();
		mainProcess();
	end
join
```
## reset detection
**task** `__resetDetector()`
**proc**
```
forever begin
	wait(resetState == RHResetActive);
	if (proc.status != process::FINISHED) proc.kill();
	wait(resetState == RHResetInactive);
end
```
