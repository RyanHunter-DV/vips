`ifndef RhVipSeqrBase__svh
`define RhVipSeqrBase__svh

class RhVipSeqrBase #(type REQ=uvm_sequence_item,RSP=REQ) extends uvm_sequencer #(REQ,RSP);
	
	`uvm_object_utils(RhVipSeqrBase#(REQ,RSP));

	function new(string name = "RhVipSeqrBase");
		super.new(name);
	endfunction
	
endclass
`endif
