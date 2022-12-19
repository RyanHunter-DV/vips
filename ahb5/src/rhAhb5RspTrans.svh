`ifndef rhAhb5RspTrans__svh
`define rhAhb5RspTrans__svh

class RhAhb5RspTrans extends RhAhb5TransBase;
	bit [1:0] resp;
	bit exokay;
	bit iswrite;
	bit [`RHAHB5_DW_MAX-1:0] rdata;
	`uvm_object_utils_begin(RhAhb5RspTrans)
	`uvm_object_utils_end
	extern function  new(string name="RhAhb5RspTrans");
endclass
function  RhAhb5RspTrans::new(string name="RhAhb5RspTrans");
	super.new(name);
endfunction

`endif
