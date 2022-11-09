The agent component named `RhAhb5MstAgent`
# Source Code
**agent** `RhAhb5MstAgent`

## sub components
**field**
```systemverilog
RhAhb5MstDriver  drv;
RhAhb5MstMonitor mon;
RhAhb5MstSeqr    seqr;
```
## configure table
#TBD 
**field**
```systemverilog
RhAhb5MstConfig config;
```
## supply TLM ports
#TBD 
**tlm-ae** `RhAhb5ReqTrans reqP`
**tlm-ae** `RhAhb5RspTrans rspP`
## build_phase
#TBD 
### setup parameterized configure table
In build_phase, the agent will get the interface according to the user entered base configure table which is created by `createConfig` (see [[#createConfig]]). Agent will clone the configured information and create a new parameterized configure table through the interface controller.
For details, see [[#setupConfigureTable]].
### setup sub components
The driver, sequencer, and monitor will be setup according to the `is_active` field of agent.
For details, see [[#setupSubComponents]].
**build**
```systemverilog
setupConfigureTable();
setupSubComponents();
```
## createConfig
This function will create a new base master configure, then assign it to field `config` and return to the caller, so that caller can directly set configures to the base configure table.
**func** `RhAhb5MstConfig createConfig(string name)`
**proc**
```systemverilog
config = RhAhb5MstConfig::type_id::create(name);
return config;
```
## setupConfigureTable
called when in `build_phase`, re-create the `config` field according to the existing one.
**func** `void setupConfigureTable()`
**proc**
```systemverilog
if (!uvm_config_db#(RhAhb5IfControlBase)::get(null,"*",config.interfacePath,config.ifCtrl))
	`uvm_fatal("NIFC","no interface controller get")
```
For `config.ifCtrl`, refer to [[src-rhAhb5MstConfig.svh#Interface Controller]].
## setupSubComponents
A function to create sub components.
**func** `void setupSubComponents()`
**proc**
```systemverilog
if (is_active==UVM_ACTIVE) begin
	drv = RhAhb5MstDriver::type_id::create("drv",this);
	drv.config = config;
	seqr= RhAhb5MstSeqr::type_id::create("seqr",this);
end
mon = RhAhb5MstMonitor::type_id::create("mon",this);
mon.config = config;
```
## connect_phase
In connect phase, following ports will be connected:
- reset ports from monitor to driver
- req ports from monitor to agent
- rsp ports from monitor to agent
**connect**
```systemverilog
if (is_active==UVM_ACTIVE) begin
	mon.resetP.connect(drv.resetI);
	drv.seq_item_port.connect(seqr.seq_item_export);
end
mon.reqP.connect(reqP);
mon.rspP.connect(rspP);
```
