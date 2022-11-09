# Source Code
**field**
```systemverilog
`define RHAHB5_AW_MAX 32
`define RHAHB5_DW_MAX 256
```

**field**
```systemverilog
typedef enum bit[2:0] {
	AHB5_SINGLE,
	AHB5_INCR,
	AHB5_WRAP4,
	AHB5_INCR4,
	AHB5_WRAP8,
	AHB5_INCR8,
	AHB5_WRAP16,
	AHB5_INCR16
} rhahb5_burst_enum;
```
## RhAhb5TransBeat
**field**
```systemverilog
typedef struct {
	bit[2:0] burst;
	bit write;
	bit[`RHAHB5_AW_MAX-1:0] addr;
	int index;
	bit[`RHAHB5_DW_MAX-1:0] data;
	bit[2:0] size;
	bit[1:0] trans;
	bit[3:0] master;
	bit[6:0] prot;
	bit lock;
	bit nonsec;
	bit excl;
	
} RhAhb5TransBeat;
```