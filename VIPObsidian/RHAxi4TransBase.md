

# Source Code
**transaction** RHAxi4TransBase

**field**
```systemverilog
realtime startTime,endTime;
```
## APIs recording time
**func** void start(realtime t)
A function to record the start time of this transaction.
**proc**
```
startTime = t;
```
**func** void finish(realtime t)
A function to record the end time of this transaction.
**proc**
```
endTime =t;
```