`ifndef rhAhb5SeqBase__svh
`define rhAhb5SeqBase__svh

class RhAhb5SeqBase extends uvm_sequence;
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

	//RhAhb5MstConfig config;
	constraint wdata_cst {
		__write==0 -> {__wdata=='h0};
	};
	
	`uvm_object_utils_begin(RhAhb5SeqBase);
		`uvm_field_int(__size,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "RhAhb5SeqBase");
		super.new(name);
	endfunction
	
endclass

`endif
