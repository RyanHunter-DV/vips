Page to describe the features supported by project: ResetGen Vip the third version.

# Features
- Support rsim-v1 tool, with the generic IP-XACT protocol.
- Support multiple reset generating with standalone threads.



## Building and connecting with a reset name
```systemverilog
// tb.sv
ResetGenIf rif();
initial begin
	rif.addReset("NameA")
	uvm_config_db...
end
DUT dut(
	.resetNameA(rif.reset["NameA"]),
	.resetNameB(rif.reset["NameB"])
	...
);
// env.svh
ResetGen rg;
function void build_phase();
	rg=ResetGen::type_id::create("rg",this);
endfunction

function void connect_phase();
	rg.setInterfacePath("tb.rif");
endfunction

```
As above example shows, calling api `rg.setInterfacePath("tb.rif")` can add a path for the interface and will try to get the interface set in tb level as well.
Meanwhile, the interface is set by call from interface: `addReset`. Users who want to trigger a reset can only call a sequence with following key fields:
1. delay time, use direct simulation time, after this time then the driver will drive it to active state.
2. duration of active time, using direct simulation time, how low the active state will keep.


## Setup init features with resets
By default, the active polarity of a reset is low active, if a certain reset has special configurations, then users need to update it at build_phase, the driver will check at run_phase if user has manually specified a special init. Example like:
```systemverilog
function void connect_phase();
	rg.setInterfacePath("tb.rif");
	rg.init("NameB",ActiveHigh,.maxInactiveDuration(200ns));
endfunction
```
### Support random startup or manually specified
The startup for reset generator can be configured in two modes, randomly with a fixed configure: maxInactiveDuration or manually specify the startup time.
**maxInactiveDuration**
This configure used for setting a max time duration for UVC to random from 1 to this value, it can be set by user with a larger or smaller time duration. This configure changed along with the UVC's init api, which has a default value is 500ns.
```systemverilog
function init(name,polarity,maxInactiveDuration=200ns,manualInactiveDuration=0ns)
```
link: [[src/ResetGen.svh]] 
**manualInactiveDuration**
A configure to trigger the reset into the inactive state by a fixed time delay after startup. This config is 0 by default, but can be changed by the init api as well, with a default parameter: `manualInactiveDuration`

### Support setting interface
Users can set the interface path by the api: setInterfacePath, by calling which the ResetGen will call a config_db to read the virtual interface, and the virtual interface is declared at the config table.

## Triggering a host reset during simulation
#TBD
## Monitoring reset events
#TBD