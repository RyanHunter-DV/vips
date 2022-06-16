`ifndef rh_axi4slv_agt__svh
`define rh_axi4slv_agt__svh

class rh_axi4slv_agt extends uvm_agent; // {
    `uvm_component_utils(rh_axi4slv_agt)

    function new(string name="rh_axi4slv_agt",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // phases
    extern function void build_phase(uvm_phase phase);
endclass // }

function void rh_axi4slv_agt::build_phase(uvm_phase phase);
    `placeholder("called build_phase, currently nothing")
endfunction



`endif
