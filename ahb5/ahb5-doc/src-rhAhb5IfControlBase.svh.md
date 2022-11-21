This is a base class defined for place holder of an interface controller definition, it's parameterized subclass is defined: [[src-rhAhb5IfControl.svh]].
# Source Code
**object** `RhAhb5IfControlBase`

## driveAddressPhase
Here's a virtual task that will be overridden by `RhAhb5IfControl`.
The arg `waitReady` 
**vtask** `driveAddressPhase(RhAhb5TransBeat b, bit waitReady)`
**proc**
```
```

## driveDataPhase
A virtual task for write requests, to drive write data, will be overridden by `RhAhb5IfControl`.
Which will directly call interface's signal to drive. Such as:
```systemverilog
vif.HWDATA <= beat.wdata[DW-1:0];
```
**vtask** `driveDataPhase(RhAhb5TransBeat b,output bit isError)`
**proc**
```
```
## waitDataPhase
This is similar with `driveDataPhase`, but it won't drive any wdata, instead, it waits the ready and gets the `HRDATA`, which reserved for getting response.
**vtask** `waitDataPhase(ref RhAhb5TransBeat b,bit isError)`
**proc**
```
```

## getResetChanged
A virtual task in base controller. In controller, it will wait the reset signal changed asynchronizely and return to current value to caller
**vtask** `getResetChanged(output logic s)`
```systemverilog
```