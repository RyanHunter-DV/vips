
The agent of master is a container storing all master components, such as driver, monitor, coverage etc. For current version: #AXI4-v1, the coverage is not supported.
# base Features
#AXI4-v1 
Supports:
- port connection;
- driver, sequencer setup if `is_active` is activated;
- monitor setup;
- [[#setup configure table]];
- [[#configurable API/fields]]

## configurable API/fields
### is_active
The UVM built-in field in this agent, using standard uvm fields to indicate this agent is active/passive.

For configures in configure table, see [[src-rhAxi4MstConfig.svh]]

---
# Source Code
## sub components
**field**
```systemverilog
RhAxi4MstDriver  drv;
RhAxi4MstMonitor mon;
RhAxi4MstSeqr    seqr;
```
## TLM ports for req/rsp trans
**tlm-ae** `RhAxi4ReqTrans reqP`
**tlm-ae** `RhAxi4RspTrans rspP`
## setup configure table
The configure table is a master specific configure which derives from a base configure, it contains a base interface controller that been set through `uvm_config_db` at tb level.
**field**
```systemverilog
RhAxi4MstConfig config;
```

## createConfig
**this is a reusable part, will moved to axi4 base agent later** #TBD 
This API called by the agent's container when setting up this agent. The API will create a new `RhAxi4MstConfig` typed object for field `config`, and return to the caller, so that the caller can directly set values through the configure table.
**func** `RhAxi4MstConfig createConfig(string name)`
**proc**
```systemverilog
config = RhAxi4MstConfig::type_id::create(name);
return config;
```
## setupConfigure
This function will get the interface controller according to the interface path from upper level.
**lfunc** `void __setupConfigure__()`
**proc**
```systemverilog
if (!uvm_config_db#(RhAxi4IfControlBase)::get(null,"*",config.interfacePath,config.ifCtrl))
	`uvm_fatal("NIFC","no interface controller get")
```

## build_phase
In build phase, do the following actions mentioned above:
- setup configure table;
- create sub components and assign some of the key information such as config;
**build**
```systemverilog
__setupConfigure__();
if (is_active==UVM_ACTIVE) begin
	drv = RhAxi4MstDriver::type_id::create("drv",this);
	seqr= RhAxi4MstSeqr::type_id::create("seqr",this);
end
```

## connect_phase
This phase to connect TLMs with different components.
**connect**
```systemverilog
if (is_active==UVM_ACTIVE) begin
	drv.seq_item_port.connect(seqr.seq_item_export);
	mon.resetP.connect(drv.resetI);
end
mon.reqP.connect(reqP);
mon.rspP.connect(rspP);
```