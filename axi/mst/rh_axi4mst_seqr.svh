`ifndef rh_axi4mst_seqr__svh
`define rh_axi4mst_seqr__svh

class rh_axi4mst_seqr #(type REQ=rh_axi4_trans,RSP=REQ)
	extends uvm_sequencer#(REQ,RSP);

	`uvm_component_utils(rh_axi4mst_seqr)

	function new(string name="rh_axi4mst_seqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	

endclass

`endif
