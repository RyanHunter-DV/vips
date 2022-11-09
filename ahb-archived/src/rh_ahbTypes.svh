`ifndef rh_ahbTypes__svh
`define rh_ahbTypes__svh

typedef enum bit {
	AHB_MST,
	AHB_SLV
} rh_ahbVip_mode;

typedef enum {
	resetActive,
	resetInActive,
	resetUnknown
} rh_resetAction_enum;

`endif
