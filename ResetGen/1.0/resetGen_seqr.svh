`ifndef resetGen_seqr__svh
`define resetGen_seqr__svh

class resetGen_seqr #(type REQ=resetGen_trans,RSP=REQ) extends uvm_sequencer#(REQ,RSP);

	`uvm_component_utils_begin(resetGen_seqr#(REQ,RSP))
	`uvm_component_utils_end

	function new (string name="resetGen_seqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass



`endif
