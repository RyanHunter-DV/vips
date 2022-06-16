`ifndef rh_axi4_vip_configBase__svh
`define rh_axi4_vip_configBase__svh

class rh_axi4_vip_configBase extends uvm_object;

    uvm_active_passive_enum is_active;
    // string interface_path;
    rh_axi4_master_slave_enum is_master;
    bit respEn = 1'b0;

    `uvm_object_utils_begin(rh_axi4_vip_configBase)
    `uvm_object_utils_end

    function new(string name="rh_axi4_vip_configBase");
        super.new(name);
    endfunction

    virtual function void getInterface(string p);
        `uvm_fatal("NOOVRD","getInterface not override")
    endfunction

endclass


`endif
