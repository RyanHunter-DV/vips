`ifndef rhAhb5Types__svh
`define rhAhb5Types__svh

`define RHAHB5_AW_MAX 32
`define RHAHB5_DW_MAX 256

typedef enum bit[1:0] {
	RHAHB5_IDLE = 2'h0,
	RHAHB5_BUSY = 2'h1,
	RHAHB5_NONSEQ = 2'h2,
	RHAHB5_SEQ = 2'h3
} rhahb5_htrans_enum;

typedef enum bit[2:0] {
	RHAHB5_SINGLE,
	RHAHB5_INCR,
	RHAHB5_WRAP4,
	RHAHB5_INCR4,
	RHAHB5_WRAP8,
	RHAHB5_INCR8,
	RHAHB5_WRAP16,
	RHAHB5_INCR16
} rhahb5_hburst_enum;

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

`endif
