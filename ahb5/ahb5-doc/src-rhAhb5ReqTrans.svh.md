# Source Code
**transaction** `RhAhb5ReqTrans`
**base** `RhAhb5TransBase`
**field**
```systemverilog
bit [2:0] burst;
bit [`RHAHB5_AW_MAX-1:0] addr;
bit [6:0] prot;
bit lock;
bit [2:0] size;
bit nonsec;
bit excl;
bit [3:0] master;
bit [1:0] trans[];
bit [`RHAHB5_DW_MAX=1:0] wdata[];
bit write;
```
macros defined in [[src-rhAhb5Types.svh]].
The wdata is part of the request transaction, while the resp and data are in response transaction.
The base transaction defined in [[src-rhAhb5TransBase.svh]].
