**agent** `RhQLpi`
**field**
```
RhQLpiDriver  drv;
RhQLpiSeqr    seqr;
RhQLpiMonitor mon;
RhQLpiConfig  config;
```

[[RhQLpiDriver.svh]]
[[RhQLpiConfig.svh]]


# Public APIs
**new**
```systemverilog
config = RhQLpiConfig::type_id::create("config");
```
**build**
```systemverilog
if (is_active) begin
	drv = RhQLpiDriver::type_id::create("drv",this);
	seqr= RhQLpiSeqr::type_id::create("seqr",this);
end
mon = RhQLpiMonitor::type_id::create("mon",this);

```

**connect**
```systemverilog
// TODO
```

**func** `void mode(RhQLpiMode m)`
This API to set the mode of the vip, shall be decided once the vip is created
```systemverilog
this.is_active = uvmActiveFilter(m);
config.isDevice= lpiDeviceFilter(m);
```
**func** `void initState(RhQLpiState s)`
A function for PowerControl mode that to specify the initial qreqn value.
```systemverilog
// TODO
```

**func** `void lpDuration(int min=-1,int max=-1)`
The API to set the automatic power up feature, by default it's disabled, but users can enable it by calling this duration with values larger than 0.
```systemverilog
if (min>0 && max>0) config.enableAutoPowerUp(min,max);
else config.disableAutoPowerUp();
```

# Private functions
**func** `uvm_active_passive_enum uvmActiveFilter(RhQLpiMode m)`
```systemverilog
// TODO
```
**func** `bool lpiDeviceFilter(RhQLpiMode m)`
```systemverilog
// TODO
```