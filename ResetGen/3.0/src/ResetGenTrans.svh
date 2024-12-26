`ifndef ResetGenTrans__svh
`define ResetGenTrans__svh

typedef enum int {
	ResetActive,
	ResetInactive,
	ResetUnknown
} ResetPolarity;

//  Class: ResetGenTrans
//
class ResetGenTrans extends uvm_sequence_item;

	//  Group: Variables
	// indicates the what the stat is when triggering this transaction.
	// Usually for triggering a reset stimulus, the stat will be ResetActive
	rand ResetPolarity stat;
	// the target reset name, which must be specified
	int index;
	realtime duration;
	realtime stime,etime;

	//  Group: Constraints


	`uvm_object_utils_begin(ResetGenTrans);
		`uvm_field_enum(ResetPolarity,stat,UVM_ALL_ON)
		`uvm_field_int(index,UVM_ALL_ON|UVM_DEC)
		`uvm_field_real(duration,UVM_ALL_ON)
	`uvm_object_utils_end
	//  Group: Functions

	//  Constructor: new
	function new(string name = "ResetGenTrans");
		super.new(name);
		stime=$realtime;
		etime=0ns;
	endfunction: new
	
endclass: ResetGenTrans



`endif