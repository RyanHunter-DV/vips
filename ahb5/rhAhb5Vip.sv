`ifndef rhAhb5Vip__sv
`define rhAhb5Vip__sv

`include "rhAhb5If.sv"
package RhAhb5Vip;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	`include "rhAhb5Types.svh"
	`include "rhAhb5IfControlBase.svh"
	`include "rhAhb5IfControl.svh"
	
	`include "rhAhb5TransBase.svh"
	`include "rhAhb5ReqTrans.svh"
	`include "rhAhb5RspTrans.svh"
	
	`include "rhAhb5MstConfig.svh"
	//
endpackage

`endif
