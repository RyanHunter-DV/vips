`ifndef ChiVipTypedef__svh
`define ChiVipTypedef__svh

typedef enum{
	CHI_REQ,
	CHI_RSP,
	CHI_DAT
} ChiTransType_t;

// type of enum and req channel opcode bits.
typedef enum bit[5:0] {
	//TODO

} ChiReqType_t;

`endif