need a common base transaction for recording time features, [[RHAxi4TransBase]]
# Source Code
**transaction** RHAxi4ReqTrans
**base** `RHAxi4TransBase`
**field**
```
rand bit [1:0] burst;
rand bit [2:0] size;
rand bit [7:0] len;
rand bit lock;
rand bit [7:0] prot;
rand bit [3:0] cache;
rand bit [3:0] region;
rand bit [3:0] qos;
rand bit [`AW_MAX-1:0] addr;
rand bit [`UW_MAX-1:0] user;
rand bit [`IW_MAX-1:0] id;
rand bit [`UW_MAX-1:0]   duser[$];
rand bit [`DW_MAX-1:0]   data[$];
rand bit [`DW_MAX/8-1:0] strobe[$];
rhaxi4_transT_enum type;

```
macros used in field are declared in [[RHAxi4Types]].

