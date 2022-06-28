`ifndef rh_axi4_test_env__svh
`define rh_axi4_test_env__svh

// TODO
import uvm_pkg::*;
import rh_axi4_vip::*;

class rh_axi4_test_env extends uvm_env; // {

    rh_axi4_vip mst;
    rh_axi4_vip slv;


    `uvm_component_utils(rh_axi4_test_env)

    function new(string name="rh_axi4_test_env", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        mst   = rh_axi4_vip::type_id::create("mst",this);
        mst.setInterfacePath("tb.udut.mstif");
        mst.setMode(axi4_active_master);

        slv   = rh_axi4_vip::type_id::create("slv",this);
        // @RyanH TODO,slv.setInterfacePath("tb.udut.slvif");
        slv.setMode(axi4_active_slave);
        // @RyanH,TODO,slv.slaveType(axi4_memory);
    endfunction

    function void connect_phase(uvm_phase phase);

    endfunction


endclass // }

`endif
