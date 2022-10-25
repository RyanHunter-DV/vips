The driver base is a typical driver component directly derived from uvm_driver, which will automatically add the reset feature by MDC tool.

# Source Code
**driver** RHAxi4DriverBase
**field**
```
RHAxi4ConfigBase config;
```

## mainProcess
This is the main process for processing actions
**vtask**
```
mainProcess() 
```

## build_phase
nothing in build phase.
**build**
```
// if extra code, then add here, similar for connect_phase etc.
```

