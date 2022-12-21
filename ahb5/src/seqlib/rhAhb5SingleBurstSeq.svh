`ifndef rhAhb5SingleBurstSeq__svh
`define rhAhb5SingleBurstSeq__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-21 07:27:08 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5SingleBurstSeq extends uvm_sequence;
	rand bit[2:0] __size;
	rand bit[3:0] __prot;
	rand bit [`RHAHB5_AW_MAX-1:0] __addr;
	rand bit __lock;
	rand bit __nonsec;
	rand bit __excl;
	rand bit [3:0] __master;
	rand bit [`RHAHB5_DW_MAX-1:0] __wdata;
	rand bit __write;
	rand int __delay;
	// TODO
	`uvm_object_utils_begin(RhAhb5SingleBurstSeq)
		`uvm_field_int(__size,UVM_ALL_ON)
	`uvm_object_utils_end
	extern function void setSize(bit[2:0] s);
	extern virtual task body();
	extern function  new(string name="RhAhb5SingleBurstSeq");
endclass
function void RhAhb5SingleBurstSeq::setSize(bit[2:0] s);
	__size.rand_mode(0);
	__size = s;
endfunction
task RhAhb5SingleBurstSeq::body();
	RhAhb5ReqTrans _req=new("req");
	_req.randomize() with {
		trans == RHAHB5_NONSEQ;
		burst == RHAHB5_SINGLE;
		size  == __size  ;
		prot  == __prot  ;
		addr  == __addr  ;
		lock  == __lock  ;
		nonsec== __nonsec;
		excl  == __excl  ;
		master== __master;
		wdata == __wdata ;
		write == __write ;
		delay == __delay ;
	};
	`rhudbg("body",$sformatf("start item:\n%s",_req.sprint()))
	start_item(_req);
	`rhudbg("body",$sformatf("item(%0d) finished",_req.get_inst_id()))
	finish_item(_req);
endtask
function  RhAhb5SingleBurstSeq::new(string name="RhAhb5SingleBurstSeq");
	super.new(name);
endfunction

`endif
