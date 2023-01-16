`ifndef rhGpvTrans__svh
`define rhGpvTrans__svh

class RhGpvTrans extends uvm_sequence_item;

	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector[];
	bit   [`RHGPV_MAX_VECTOR_WIDTH-1:0]   mask[];
	
	int clockIndex; // using which clock index

	`uvm_object_utils_begin(RhGpvTrans)
		`uvm_field_array_int(vector,UVM_ALL_ON)
		`uvm_field_array_int(mask,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="RhGpvTrans");
		super.new(name);
		// at least one cycle is available while this transaction is created
		vector = new[1];
		mask   = new[1];
	endfunction

	// to add one more index for the vector and mask dynamic array
	extern function void nextCycle();
endclass
function void RhGpvTrans::nextCycle();
	int csize = vector.size();
	csize++;
	vector = new[csize] (vector);
	mask   = new[csize] (mask);
	return;
endfunction


`endif
