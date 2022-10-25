declare a class named [[class-RHAxi4IfControl]] in [[interface-RHAxi4If]], which will contain the interface parameters declaration, like:
```
interface RHAxi4If#(`interface_parameter_declare)();
	`include "RHAxi4IfControl.sv"
	RHAxi4IfControl ctrl = new();
endinterface
```
# createConfig
An API named createConfig is declared within the RHAxi4IfControl class, which will declare the interface parameters, and can be used directly by this API, like:
```
function RHAxi4VipConfigBase createConfig(string name,uvm_component parent);
	RHAxi4VipConfigBase config =
		RHAxi4VipConfig#(`interface_parameter_map)::type_id::create(name,parent);
	return config;
endfunction
```