`ifndef selfTestSeq__svh
`define selfTestSeq__svh

class SelfTestSeq extends uvm_sequence;

	`uvm_object_utils(SelfTestSeq)


	function new(string name="SelfTestSeq");
		super.new(name);
	endfunction

	task body();
		RhGpvTrans tr=new("trans");
		tr.vector[0][32:1] = $urandom();
		tr.vector[0][0] = 1'b1;
		start_item(tr);
		finish_item(tr);
	endtask

endclass

`endif
