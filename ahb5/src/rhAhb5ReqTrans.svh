`ifndef rhAhb5ReqTrans__svh
`define rhAhb5ReqTrans__svh

class RhAhb5ReqTrans extends RhAhb5TransBase;
	bit [2:0] burst;
	bit [`RHAHB5_AW_MAX-1:0] addr;
	bit [6:0] prot;
	bit lock;
	bit [2:0] size;
	bit nonsec;
	bit excl;
	bit [3:0] master;
	bit [1:0] trans[];
	bit [`RHAHB5_DW_MAX-1:0] wdata[];
	bit write;
	`uvm_object_utils_begin(RhAhb5ReqTrans)
	`uvm_object_utils_end
	extern function  new(string name="RhAhb5ReqTrans");
endclass
function  RhAhb5ReqTrans::new(string name="RhAhb5ReqTrans");
	super.new(name);
endfunction

`endif
