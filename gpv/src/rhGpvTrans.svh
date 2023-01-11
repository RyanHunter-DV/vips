`ifndef rhGpvTrans__svh
`define rhGpvTrans__svh

class RhGpvTrans extends uvm_seequence_item;

	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector[];
	bit   [`RHGPV_MAX_VECTOR_WIDTH-1:0]   mask[];
	
	int clockIndex; // using which clock index

	`uvm_object_utils_begin(RhGpvTrans)
	`uvm_object_utils_end

	function new(string name="RhGpvTrans");
		super.new(name);
	endfunction



endclass


`endif