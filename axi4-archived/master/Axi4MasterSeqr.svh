`ifndef Axi4MasterSeqr__svh
`define Axi4MasterSeqr__svh

class Axi4MasterSeqr extends Axi4SeqrBase; // {

	`uvm_component_utils(Axi4MasterSeqr)

	function new(string name="Axi4MasterSeqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass // }

`endif
