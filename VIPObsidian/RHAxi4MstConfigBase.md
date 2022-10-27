This is the base configure table of master device, which will be overridden in interface, and created by interface with specific parameters

# BCycleConfig
This is a type of configures that reflects how a master will drive the BReady signal. The driver uses this config to randomly generate a low/high level signal.
**field**
```
int lowBCycleMin=0,lowBCycleMax=100;
int highBCycleMin=0,highBCycleMax=100;
```
Driver will randomly generate a low/high value separately according to those limits. And then holding the low/high value with the valued cycles. Then it will regenerate the low/high pair again. Forever loop these steps.

# Source Code
## class base and fields
**object** RHAxi4MstConfigBase
**field**
```
```

