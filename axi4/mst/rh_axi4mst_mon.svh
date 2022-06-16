`ifndef rh_axi4mst_mon__svh
`define rh_axi4mst_mon__svh

class rh_axi4mst_mon extends uvm_monitor; // {


    uvm_analysis_port #(resetTr_t) resetP;
    uvm_analysis_port #(rspTr_t)   respP;

    `uvm_component_utils_begin(rh_axi4mst_mon)
    `uvm_component_utils_end

    function new(string name="rh_axi4mst_mon",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // build_phase,
    // - resetP, rspP, creating ports
    extern function void build_phase(uvm_phase phase);

    // run_phase,
    // - monitoring reset actions
    // - monitoring axi4 actions from mst ports
    extern task run_phase(uvm_phase phase);

endclass // }


function void rh_axi4mst_mon::build_phase(uvm_phase phase); // {
    resetP = new("resetP",this);
    respP   = new("respP",this);
endfunction // }

task rh_axi4mst_mon::run_phase(uvm_phase phase); // {
    // TODO
    `placeholder("start run_phase, currently has nothing")
    `placeholder("monitor reset actions")
    `placeholder("monitor axi4 mst actions")
endtask // }


`endif
