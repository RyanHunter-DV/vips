`ifndef rh_axi4_test_base__svh
`define rh_axi4_test_base__svh

class rh_axi4_test_base extends uvm_test; // {

    rh_axi4_test_env env;

    `uvm_component_utils(rh_axi4_test_base)

    function new(string name="rh_axi4_test_base",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = rh_axi4_test_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        rh_axi4mst_bseq seq=new("seq");
		phase.phase_done.set_drain_time(uvm_root::get(),10000);
        phase.raise_objection(this);
        `uvm_info("TESTRUN","starting base test",UVM_LOW)
        seq.randomize();
        seq.start(env.mst.seqr);
        phase.drop_objection(this);
    endtask
endclass // }

`endif
