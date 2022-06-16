`ifndef rh_axi4mst_bseq__svh
`define rh_axi4mst_bseq__svh

class rh_axi4mst_bseq extends uvm_sequence; // {


    `uvm_object_utils(rh_axi4mst_bseq)

    function new(string name="rh_axi4mst_bseq");
        super.new(name);
    endfunction

    virtual task body();
        rh_axi4_trans btr=new("btr");
        btr.randomize();
        start_item(btr);
        finish_item(btr);
    endtask

endclass // }

`endif
