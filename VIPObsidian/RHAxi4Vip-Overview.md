This VIP used to test AXI4 interface.
# Feature supports
## support master device
- [[#basic usage of master device]]
- 
## support slave device


# Using Example
## basic usage of master device
```
RHAxi4Vip dev;
RHAxi4VipConfig devConfig;
dev = RHAxi4Vip::type_id::create("mst",this);
devConfig=RHAxi4VipConfig::type_id::create("mstConfig");
devConfig.deviceMode = AXI4_MASTER;
xxx
dev.setConfig(devConfig);

// in case
RHAxi4BaseSeq seq=new("seq");
seq.randomize() with {
	xxxx
};
seq.start(dev.seqr);
```



# Architecture
