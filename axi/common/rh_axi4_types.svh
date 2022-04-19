`ifndef rh_axi4_types__svh
`define rh_axi4_types__svh

// new imp types
`define rh_axi4_imp_decl(SFX) \
class uvm_analysis_imp_rhaxi4_``SFX #(type T=int,type IMP=int) \
	extends uvm_port_base#(uvm_tlm_if_base#(T,T)); \
	`UVM_IMP_COMMON(`UVM_TLM_ANALYSIS_MASK,`"uvm_analysis_imp_rhaxi4_``SFX`",IMP) \
	function void write(T t); \
		m_imp.write_``SFX(t); \
	endfunction \
endclass

`rh_axi4_imp_decl(reset)
`rh_axi4_imp_decl(resp)


typedef class rh_axi4_resetTrans;
typedef class rh_axi4_trans;

typedef rh_axi4_resetTrans resetTr_t;
typedef rh_axi4_trans respTr_t;
typedef rh_axi4_trans reqTr_t;


typedef enum bit[4:0] {
	WAChannel = 5'b00001,
	WDChannel = 5'b00010,
	BChannel  = 5'b00100,
	RAChannel = 5'b01000,
	RDChannel = 5'b10000
} rhaxi4_channel_enum;
typedef bit[4:0] rhaxi4_channel_bit;

typedef enum {
	rhaxi4_write_req,
	rhaxi4_read_req,
	rhaxi4_write_rsp,
	rhaxi4_read_rsp
} rhaxi4_trans_enum;

typedef int unsigned uint32_t;

typedef enum bit[1:0] {
	rhaxi4_fixed,
	rhaxi4_incr,
	rhaxi4_wrap
} rhaxi4_burst_enum;

typedef enum {
	master,
	slave
} rhaxi4_device_enum;


`endif
