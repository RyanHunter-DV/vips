`ifndef rhAhb5SlvSeqr__svh
`define rhAhb5SlvSeqr__svh

class RhAhb5SlvSeqr#(type REQ=uvm_sequence_item,RSP=REQ) extends uvm_sequencer #(REQ,RSP);

	`uvm_component_utils(RhAhb5SlvSeqr#(REQ,RSP));

	function new(string name = "RhAhb5SlvSeqr", uvm_component parent);
		super.new(name, parent);
	endfunction
	
endclass

`endif
