`ifndef clockGen_seqr__svh
`define clockGen_seqr__svh

class clockGen_seqr #(type REQ=clockGen_trans,RSP=REQ) extends uvm_sequencer#(REQ,RSP);

	`uvm_component_utils_begin(clockGen_seqr#(REQ,RSP))
	`uvm_component_utils_end

	function new (string name="clockGen_seqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass



`endif
