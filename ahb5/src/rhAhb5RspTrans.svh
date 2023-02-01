`ifndef rhAhb5RspTrans__svh
`define rhAhb5RspTrans__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-22 06:29:20 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5RspTrans extends RhAhb5TransBase;
	rand logic resp;
	rand logic exokay;
	rand logic iswrite;
	rand logic [`RHAHB5_DW_MAX-1:0] rdata;
	// indicates how many cycles the slave drives the
	// HREADY to low
	rand int busyCycle; 
	`uvm_object_utils_begin(RhAhb5RspTrans)
		`uvm_field_int(resp,UVM_ALL_ON)
		`uvm_field_int(iswrite,UVM_ALL_ON)
		`uvm_field_int(exokay,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_int(busyCycle,UVM_ALL_ON)
	`uvm_object_utils_end
	extern function  new(string name="RhAhb5RspTrans");
endclass
function  RhAhb5RspTrans::new(string name="RhAhb5RspTrans");
	super.new(name);
endfunction

`endif
