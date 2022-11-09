# base features
- [[#Base Architecture]], indicates the basic vip package and file structures.
- [[#Master Device]], act as an ahb master.
- [[#Slave Device]], act as an ahb slave.

# Base Architecture
#TBD 
## file structure
The `RHAhb5Vip` locates in ahb5 of vips project, it has file structures:
-   `./common/`, dir for common files that will be used both by master or slave
-   `./mst/`, dir for master device only files.
-   `./slv/`, dir for slave device only files
-   `./rhAhb5Vip.sv`, the package file of the whole axi4 vip, for details, see [[src-rhAhb5Vip.sv]]
-   `./test/`, dir for self tests, mostly tested by self connection between master and slave.

# Master Device
#TBD #High
Using examples are located in [[#Using Masters]].
A master devices contains following components/objects:
- [[src-rhAhb5MstAgent.svh]], this is the basic master agent where this master device actually defined.
- [[src-rhAhb5MstDriver.svh]], the driver component specifically for master.
- [[src-rhAhb5MstSeqr.svh]], the master sequencer.
- [[src-rhAhb5MstMonitor.svh]], the monitor component.
- [[src-rhAhb5MstConfig.svh]], the master configure table.
## configure a master device
#TBD 

The master device uses interface control to get a parameterized interface, the control is created at TB level, and will be passed through uvm_config_db as type of a base controller, so the master configure table can receive it without concerning the parameter. Example:
```systemverilog
class xxxController#(AW,xxx) extends xxxControlBase
	virtual If#(AW,xxx)

// tb
ahbif#(PARAM) vif(xxx);
controller#(PARAM) = new;
controller.If = vif
uvm_config_set(controlBase)::set(xxx);

// get in vip config
uvm_config_get(controlBase)::get(xxx);
```
~~The master device provides an API called `createConfig`, which will create a bases master configure table for users to add configurations in build phase, and then in VIP's build phase, the VIP will get that virtual interface through  the given configurations, and create a parameterized master configure table through interface controller (see [[src-rhAhb5If.sv]]), and the user configures will be cloned to the newly created configure table, and delete the old ones. Detailed information see [[src-rhAhb5MstAgent.svh#build_phase]].~~

# Slave Device
#TBD #Low

# Using Masters
## basic setup
```systemverilog
RHAhb5Vip dev;
RHAhb5VipConfigBase devConfig;
dev = RHAhb5Vip::type_id::create("mst",this);
dev.is_active = UVM_ACTIVE;
devConfig = dev.createConfig("mstConfig");
// setup configures directly use devConfig, no extra operation needed.
devConfig.deviceMode = AHB5_MASTER;
devConfig.setInterfacePath("tb.path.ahb5If");
...

// to trigger a sequence
RHAhb5BaseSeq seq=new("seq");
seq.randomize() with {
	xxxx
};
seq.start(dev.seqr);
```