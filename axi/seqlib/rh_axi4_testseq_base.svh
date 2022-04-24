`ifndef rh_axi4_testseq_base__svh
`define rh_axi4_testseq_base__svh

class rh_axi4_testseq_base extends uvm_sequence; // {

	`uvm_object_utils(rh_axi4_testseq_base)

	function new(string name="rh_axi4_testseq_base");
		super.new(name);
	endfunction

	virtual task body(); // {
		rh_axi4_trans tr=new("tr");
		tr.addr='h20;
		tr.randomize();
		`uvm_info(get_type_name(),$sformatf("send tr:\n%s",tr.sprint()),UVM_LOW)
		start_item(tr);
		finish_item(tr);
	endtask // }


endclass // }


`endif
