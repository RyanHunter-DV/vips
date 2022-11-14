The transaction of responses information recording and storing.
# Source Code
**transaction** `RhAhb5RspTrans`
**base** `RhAhb5TransBase`
**field**
```systemverilog
bit [1:0] resp;
bit exokay;
bit [`RHAHB5_DW_MAX-1:0] rdata;
```