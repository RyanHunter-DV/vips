`ifndef ChiProtocolTrans__svh
`define ChiProtocolTrans__svh

//
class ChiProtocolTrans extends uvm_sequence_item;
	typedef ChiProtocolTrans this_type_t;
	`uvm_object_utils(ChiProtocolTrans);

	//  Group: Variables
	int channelIndex; // indicates which channel this protocol is for when in multi-channel
	ChiTransType_t transType;


	//  Group: Constraints


	//  Group: Functions

	//  Constructor: new
	function new(string name = "ChiProtocolTrans");
		super.new(name);
	endfunction: new

	//  Function: do_copy
	// extern function void do_copy(uvm_object rhs);
	//  Function: do_compare
	// extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	//  Function: convert2string
	// extern function string convert2string();
	//  Function: do_print
	// extern function void do_print(uvm_printer printer);
	//  Function: do_record
	// extern function void do_record(uvm_recorder recorder);
	//  Function: do_pack
	// extern function void do_pack();
	//  Function: do_unpack
	// extern function void do_unpack();
	
endclass: ChiProtocolTrans


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/


`endif