A base transaction that stores common fields and some APIs such as time recording, this will is a parent class both for request and response transaction.
# Source Code
**transaction** `RhAhb5TransBase`
**field**
```systemverilog
realtime stime,etime; // record time for the trans start/end
bit started = 0;
```
**func** `void record(realtime t)`
**proc**
```systemverilog
if (started) etime = t;
else begin
	stime = t;
	started = 1;
end
```