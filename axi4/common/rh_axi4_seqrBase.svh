`ifndef rh_axi4_seqrBase__svh
`define rh_axi4_seqrBase__svh

class rh_axi4_seqrBase#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_sequencer#(REQ,RSP); // {

    `uvm_component_utils(rh_axi4_seqrBase#(REQ,RSP))

    function new(string name="rh_axi4_seqrBase",uvm_component parent=null);
        super.new(name,parent);
    endfunction
    
endclass // }

`endif
