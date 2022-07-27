`ifndef Axi4ResponseHandler__svh
`define Axi4ResponseHandler__svh

class Axi4ResponseHandler extends Axi4ResponseHandlerBase; // {


	`uvm_object_utils(Axi4ResponseHandler)

	function new(string name="Axi4ResponseHandler");
		super.new(name);
	endfunction


	extern virtual task processReq(Axi4SeqItem t);
endclass // }

task Axi4ResponseHandler::processReq(Axi4SeqItem t); // {
	// PLACEHOLDER, auto generated task, add content here
	`uvm_info(get_type_name(),"default responder, doing nothing",UVM_NONE)
endtask // }

`endif
