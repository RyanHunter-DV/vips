A transaction stores response information for write response channel, read data channel
# Source Code
**transaction** `RHAxi4RspTrans`
**base** `RHAxi4TransBase`
**field**
```systemverilog
rand bit[1:0] resp[$];
rand bit[`RHAXI4_IW_MAX-1:0] id;
rand bit[`RHAXI4_DW_MAX-1:0] data[$];
rhaxi4_transT_enum type;
```