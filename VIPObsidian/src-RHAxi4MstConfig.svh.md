This is the configure table with interface parameters, so the interface will be declared here.

# Source Code
**object** `RHAxi4MstConfig`
**param** `AW=32,DW=32,IW=32,UW=32`
**base** `RHAxi4MstConfigBase`
The base master configure table locates in [[src-RHAxi4MstConfigBase.svh]], which declares many of the virtual APIs that will be used by master components.
## interface declaration
**field**
```systemverilog
virtual RHAxi4If#(AW,DW,IW,UW) vif;
```