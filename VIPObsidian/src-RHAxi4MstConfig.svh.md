This is the configure table with interface parameters, so the interface will be declared here.

# Source Code
**object** `RhAxi4MstConfig`

~~The base master configure table locates in [[src-RhAxi4MstConfigBase.svh]], which declares many of the virtual APIs that will be used by master components.~~

### interfacePath
The string typed path for getting interface controller from TB. It's been set by the container who wants to use the master device.
**field**
```systemverilog
string interfacePath;
```
### deviceMode
master/slave mode for this agent, this is a enum typed variable, the definition of enum is common for master and slave, and it'll be declared in the type file.
Details, see [[src-rhAxi4Types.svh#device mode]]
**field**
```systemverilog
rhaxi4_device_enum deviceMode;
```
# BCycleConfig
This is a type of configures that reflects how a master will drive the BReady signal. The driver uses this config to randomly generate a low/high level signal.
**field**
```systemverilog
int lowBCycleMin=0,lowBCycleMax=100;
int highBCycleMin=0,highBCycleMax=100;
```
Driver will randomly generate a low/high value separately according to those limits. And then holding the low/high value with the valued cycles. Then it will regenerate the low/high pair again. Forever loop these steps.