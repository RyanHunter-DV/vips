# Source Code
## macros for bus width
**field**
```systemverilog
`define RHAXI4_AW_MAX 32
`define RHAXI4_DW_MAX 32
`define RHAXI4_IW_MAX 16
`define RHAXI4_UW_MAX 32
```
## device mode
**field**
```systemverilog
typedef enum {
	RHAXI4_MASTER,
	RHAXI4_SLAVE
} rhaxi4_device_enum;
```