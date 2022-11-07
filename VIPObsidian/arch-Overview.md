# base features
- [[#Base Architecture]], indciates the basic vip package and file structures.
- [[#Master Device]], supports axi master behavior
- [[#Slave Device]], supports axi slave device behavior.

# Base Architecture
#TBD 
## file structure
The `RHAxi4Vip` locates in axi4 of vips project, it has file structures:
- `./common/`, dir for common files that will be used both by master or slave
- `./mst/`, dir for master device only files.
- `./slv/`, dir for slave device only files
- `./rhaxi4vip.sv`, the package file of the whole axi4 vip, for details, see [[src-rhaxi4vip.sv]]
- `./test/`, dir for self tests, mostly tested by self connection between master and slave.
# Master Device
#TBD 
using examples are in [[#Using example of master]]
master device is part of the `RHAxi4Vip`, which will be activated by configurations of the `RHAxi4Vip`.
The device itself is declared by a `uvm_agent` called `RHAxi4MstAgent`, which locates in [[src-RHAxi4MstAgent.svh]]. It has following components/objects:
- [[src-RHAxi4MstDriver.svh]], the driver of master device, instantiated in the agent
- [[src-RHAxi4MstConfig.svh]], the config table of master.
- [[src-RHAxi4MstMonitor.svh]], the monitor of the master
- [[src-RHAxi4If.sv]], the common interface both for master and slave
- [[src-RHAxi4MstSeqr.svh]], the sequencer.

# Slave Device
#TBD 

# Using example of master
## basic usage of master device
```
RHAxi4Vip dev;
RHAxi4VipConfigBase devConfig;
dev = RHAxi4Vip::type_id::create("mst",this);
devConfig=RHAxi4VipConfigBase::type_id::create("mstConfig");
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

**send a random axi trans**
```
RHAxi4Vip mst;
mst = RHAxi4Vip::type_id::create(xxx);
mst.setup(AXI4_ACTIVE_MASTER,"tb.mst_if");
/* optional configs
mst.sendDelay(<min>,<max>);
*/
-------------------------
RHAxi4SeqBase seq=new(xx); seq.randomize();
seq.start(mst.seqr);
```
