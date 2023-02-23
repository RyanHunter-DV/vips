`ifndef rhAhb5ReqTrans__svh
`define rhAhb5ReqTrans__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-22 06:29:20 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5ReqTrans extends RhAhb5TransBase;
	time stime,etime;
	rand logic [2:0] burst;
	rand logic [`RHAHB5_AW_MAX-1:0] addr;
	rand logic [6:0] prot;
	rand logic lock;
	rand logic [2:0] size;
	rand logic nonsec;
	rand logic excl;
	rand logic [3:0] master;
	rand logic [1:0] trans;
	rand logic [`RHAHB5_DW_MAX-1:0] wdata;
	rand logic write;
	rand int delay;
	
	constraint delay_cst {
		if (trans==2'h2) {
			delay inside {[0:100]};
		} else {
			delay == 0; // for IDLE/SEQ/BUSY, delay is disabled by default
		}
	};
	`uvm_object_utils_begin(RhAhb5ReqTrans)
		`uvm_field_int(burst,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(prot,UVM_ALL_ON)
		`uvm_field_int(lock,UVM_ALL_ON)
		`uvm_field_int(size,UVM_ALL_ON)
		`uvm_field_int(nonsec,UVM_ALL_ON)
		`uvm_field_int(excl,UVM_ALL_ON)
		`uvm_field_int(master,UVM_ALL_ON)
		`uvm_field_int(write,UVM_ALL_ON)
		`uvm_field_int(delay,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(trans,UVM_ALL_ON)
		`uvm_field_int(wdata,UVM_ALL_ON)
	`uvm_object_utils_end
	extern function  new(string name="RhAhb5ReqTrans");
endclass
function  RhAhb5ReqTrans::new(string name="RhAhb5ReqTrans");
	super.new(name);
	// wdata = 'h0; // init
endfunction

`endif
