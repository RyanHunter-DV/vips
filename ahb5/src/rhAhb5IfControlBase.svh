`ifndef rhAhb5IfControlBase__svh
`define rhAhb5IfControlBase__svh
/************************************************************************************/
// Author: RyanHunter
// Created: 2022-12-22 06:29:20 -0800
// Description:
// This file is automatically generated by MDC-v2, any issues found
// here should be modified in its source markdown document the same
// dir structure in Git/Obsidian/...
/************************************************************************************/

class RhAhb5IfControlBase extends uvm_object;
	`uvm_object_utils_begin(RhAhb5IfControlBase)
	`uvm_object_utils_end
	extern virtual task driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
	extern virtual task driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern virtual task waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern virtual task getResetChanged(output logic s);
	extern virtual task sync(int cycle);
	extern virtual function uvm_bitstream_t getSignal(string signame);
	extern function  new(string name="RhAhb5IfControlBase");
	virtual task clock(int cycle=1); endtask
	virtual task randomHRDATA(); endtask

	// suppose driver never drives a signal by 'hz value
	virtual function logic HREADY(logic val='bz); endfunction
	virtual function logic HRESP(logic val='bz); endfunction
	virtual function logic HEXOKAY(logic val='bz); endfunction
	virtual function logic HMASTLOCK(logic val='bz);endfunction
	virtual function logic HNONSEC  (logic val='bz);endfunction
	virtual function logic HEXCL    (logic val='bz);endfunction
	virtual function logic HWRITE   (logic val='bz);endfunction
	virtual function logic[2:0] HBURST(logic[2:0] val='hz); endfunction
	virtual function logic[1:0] HTRANS(logic[1:0] val='hz); endfunction
	virtual function logic[3:0] HMASTER(logic[3:0] val='hz); endfunction
	virtual function logic[2:0] HSIZE(logic[2:0] val='hz); endfunction
	virtual function logic[7:0] HPROT(logic[7:0] val='hz); endfunction
	virtual function logic[`RHAHB5_DW_MAX-1:0] HWDATA(logic[`RHAHB5_DW_MAX-1:0] val='hz); endfunction
	virtual function logic[`RHAHB5_AW_MAX-1:0] HADDR(logic[`RHAHB5_AW_MAX-1:0] val='hz); endfunction
	virtual function logic[`RHAHB5_DW_MAX-1:0] HRDATA(logic[`RHAHB5_DW_MAX-1:0] val='hz);endfunction
endclass
task RhAhb5IfControlBase::driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
endtask
task RhAhb5IfControlBase::driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
endtask
task RhAhb5IfControlBase::waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
endtask
task RhAhb5IfControlBase::getResetChanged(output logic s);
endtask
task RhAhb5IfControlBase::sync(int cycle);
	// overridden by sub class
endtask
function uvm_bitstream_t RhAhb5IfControlBase::getSignal(string signame);
endfunction
function  RhAhb5IfControlBase::new(string name="RhAhb5IfControlBase");
	super.new(name);
endfunction

`endif
