`ifndef RspChannelProcessor__svh
`define RspChannelProcessor__svh

//  Class: RspChannelProcessor
//
class RspChannelProcessor extends uvm_object;
	`uvm_object_utils(RspChannelProcessor);

	//  Group: Variables
	uvm_component container;


	//  Group: Constraints


	//  Group: Functions

	//  Constructor: new
	function new(string name = "RspChannelProcessor");
		super.new(name);
	endfunction: new
	
	// parent(uvm_component o) -> void, set parent of this processor
	extern  function void parent(uvm_component o);

endclass: RspChannelProcessor

function void RspChannelProcessor::parent(o); // ##{{{
	//TODO
	container=o;
endfunction // ##}}}


`endif