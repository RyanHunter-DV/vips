This VIP used to test AXI4 interface.
# Feature supports
## support master device
- [[#basic usage of master device]]
- 
## support slave device

## transactions
Support [[class-RHAxi4ReqTrans]], [[class-RHAxi4RspTrans]] for request/response respectively.
And [[class-RHAxi4ReqMonTrans]], [[class-RHAxi4RspMonTrans]], for monitored request/response transactions, which has additional transID, time as the base req/rsp trans.
#MARKER
## configurations
**for master device**
- sendReqDelay, specify a min/max range to send the next request.
- sendDataDelay, specify a min/max range to send the next wdata beat.
- sendBReadyDelay, specify a min/max range of the high level of BReady signal.
- sendRReadyDelay, specify a min/max range of the high leval of RReady signal.
**for slave device**
- sendAWReadyDelay,
- sendARReadyDelay,
- sendWReadyDelay,
**for both device**
#TBD

## slave responder mechanism
To support the response behavior of a slave device, any incoming request will be monitored through a monitor, and the responder can trigger a user-defined sequence item automatically to [[class-RHAxi4SlvDriver]].
Through uvm_factory's override feature to override the created responder.
[[strategy-slaveResponder]]
## protocol checker
#TBD this is an advance feature, not supported yet.
## declare VIP without interface parameter
When defining an interface, a parameter fo address is necessary, while in VIP instantiation, we want that being transparent to users. 
declaring an override in interface class, which will call uvm factory to override the basic config named RHAxi4VipConfig 
in interface:
```
interface
	RHAxi4InterfaceControl ctrl = new("ctrl)";
```
[[strategy-createInterfaceParameteredComponent]]

# Using Example
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

# File Structure
declaring a package for this VIP, named RHAxi4VipPackage;
```
package RHAxi4VipPackage;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "RHAxi4Types.svh"
	`include "RHAxi4If.sv"

	`include "RHAxi4ConfigBase.svh"
	`include "RHAxi4MonitorBase.svh"
	...
	`include "RHAxi4Config.svh"

	`include "RHAxi4MstDriver.svh"
	
endpackage
```
# Architecture

[[RHAxi4VipPackage.sv]]
[[RHAxi4MstDriver]]
