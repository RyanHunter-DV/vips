`ifndef rh_axi4_types__svh
`define rh_axi4_types__svh

// define of maximum bit width that axi4 protocol can support
`define RH_AXI4_MAX_DW 1024
`define RH_AXI4_MAX_SW `RH_AXI4_MAX_DW/8
`define RH_AXI4_MAX_AW 128
`define RH_AXI4_MAX_UW 64
`define RH_AXI4_MAX_IW 32

typedef class rh_reset_trans;
typedef class rh_axi4_trans;
typedef class rh_axi4_vip_config;

typedef rh_reset_trans resetTr_t;
typedef rh_axi4_trans rspTr_t;

`uvm_analysis_imp_decl(_reset)
`uvm_analysis_imp_decl(_resp)


typedef enum {
	rhaxi4_write_req,
	rhaxi4_read_req,
	rhaxi4_write_rsp,
	rhaxi4_read_rsp
} rh_axi4_trans_e;

typedef enum bit[1:0] {
	rhaxi4_fixed,
	rhaxi4_incr,
	rhaxi4_wrap
} rh_axi4_burst_e;

typedef enum {
	axi4_master,
	axi4_slave
} rh_axi4_master_slave_enum;

typedef enum logic {
    rh_reset_unkown   = 1'bx,
    rh_reset_noconnect= 1'bz,
    rh_reset_active   = 1'b0,
    rh_reset_inactive = 1'b1
}rh_reset_status_e;


typedef enum {
	axi4_active_master,
	axi4_active_slave,
	axi4_passive_master,
	axi4_passive_slave
}rh_axi4_device_enum;

typedef struct {
	bit       lock;
	bit[2:0]  size;
	bit[7:0]  len;
	bit[1:0]  burst;
	bit[3:0]  qos;
	bit[7:0]  prot;
	bit[3:0]  cache;
	bit[3:0]  region;
	bit[`RH_AXI4_MAX_IW-1:0] id;
	bit[`RH_AXI4_MAX_UW-1:0] user;
	bit[`RH_AXI4_MAX_AW-1:0] addr;
}rh_axi4_achnl_t;

typedef struct {
	bit[`RH_AXI4_MAX_DW-1:0] data;
	bit[`RH_AXI4_MAX_SW-1:0] strobe;
	bit[`RH_AXI4_MAX_IW-1:0] id;
	bit[`RH_AXI4_MAX_UW-1:0] user;
	bit is_last;
}rh_axi4_dchnl_t;



`define placeholder(MSG) `uvm_info("PLACEHOLDER",MSG,UVM_NONE)
`define RH_AXI4_IF_PARAM_DECL AW=32,DW=32,IW=16,UW=32
`define RH_AXI4_IF_PARAM_MAP .AW(AW),.DW(DW),.IW(IW),.UW(UW)


typedef rh_axi4_master_slave_enum rh_axi4_device_t;

`endif
