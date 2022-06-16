`ifndef rh_axi4_baseSeqr__svh
`define rh_axi4_baseSeqr__svh

class rh_axi4_baseSeqr#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_sequencer#(REQ,RSP); // {

    `uvm_component_utils(rh_axi4_baseSeqr#(REQ,RSP))

    function new(string name="rh_axi4_baseSeqr",uvm_component parent=null);
        super.new(name,parent);
    endfunction
    
endclass // }

`endif
