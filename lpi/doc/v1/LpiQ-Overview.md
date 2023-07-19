# Features

## Project compliant to rsim-5 flow

## Support device mode and PowerControl mode
By the same vip but has different configure, can config vip into Device/PowerControl mode.
This is a static configuration that can only be specified at elaboration phase, and once it's set, the mode is fixed.

## Support async clock

## Device mode
### Support accept/deny configuration
- Dynamic configuration of random accept, with a certain percentage.
	- By default, the accept is randomly with 50%.
example:
```systemverilog
device.acceptRandomly(90) // 90 percent to accept while receiving a req
```
- Manually set next response of req, will override the random response for times according to user set.
example:
```systemverilog
device.acceptManually(QLpiAccept,10);
device.acceptManually(QLpiDeny,1);
```

### Support active configuration
- Supports random active output of a device, by specifying a min-max range of high level.
	- if random active is enabled, then the reset value will be 0.
example:
```systemverilog
device.activeRandomly(1,20); // duration of active is 1, min cycle 1, max cycle 20
```
- Supports manually set active, this can only set the active to a certain value and keep it during the whole simulation.
example:
```systemverilog
device.activeManually(0); // or device.activeManually(1);
```


## PowerControl mode
### Support sequences
- Support sequence that to drive qreq available when detect qactive is low.
- Support sequence that drive qreq nomatter what qactive is.
- Support sequence been driven after a certain delay.

### Support configurations
- Support default state after reset, QStopped or QExit state.
Example:
```systemverilog
controller.initState(QStopped);
controller.initState(QExit);
```
- Support automatic power up after a certain duration of the power low.
Users can set the lpDuration with a min,max gap so that the power control will randomly select a value between min,max and drive the qreqn up after it's been driven to low.
Set min,max to -1 will disable the auto power up feature.
Example:
```systemverilog
controller.lpDuration(2,20); // randomly powered up between 2,20 cycles
controller.lpDuration(-1,-1);controller.lpDuration(); // manually disable the auto power up feature
```

## Support trans monitoring
- TLM trans will be monitored every time the QState has been changed.
- no req/rsp concepts.
- The trans has contents that depicts currentQState, and nextQState.
- 

# Usage examples

## Setup example
To setup a power control mode:
```systemverilog
class IPEnv // Env
	RhQLpi lpi;

build:
	lpi = create
	lpi.mode(ActivePowerControl); // PassivePowerControl
	lpi.initState(QStopped);
connect:
	lpi.out.connect(refm.ai);
	lpi.in.connect(scb.ai);

```

To setup a device mode:
```systemverilog
class IPEnv
	RhQLpi lpi;
build:
	lpi = create
	lpi.mode(ActiveDevice); // PassiveDevice
	lpi.activeRandomly(1,100);
	lpi.acceptRandomly(90);
connect:
	lpi.out.connect(refm.ai);
	lpi.in.connect(scb.ai);
```

## Sequence example
To send a low power sequence:
```systemverilog
class Test
run:
	RhQLpiPowerControlSeq s=new(xxx);
	s.randomize() with {
		delay inside {[0:20]};
		ignoreQActive == 1;
		lpDuration inside {[2:200]}; // low power duration specifically for this sequence, by default will use the configurations.
	};
	s.start(env.controller.seqr);
```

To set next acceptance as device:
```systemverilog
class Test
run:
	...
	lpi.acceptManually(QLpiAccept,10);
```