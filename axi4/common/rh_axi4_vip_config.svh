`ifndef rh_axi4_vip_config__svh
`define rh_axi4_vip_config__svh

class rh_axi4_vip_config#(`RH_AXI4_IF_PARAM_DECL) extends rh_axi4_vip_configBase; // {

    virtual rh_axi4_if#(`RH_AXI4_IF_PARAM_MAP) vif;


    `uvm_object_utils_begin(rh_axi4_vip_config)
    `uvm_object_utils_end

    function new(string name="rh_axi4_vip_config");
        super.new(name);
    endfunction

    virtual function void getInterface(string p);
        uvm_config_db#(virtual rh_axi4_if#(`RH_AXI4_IF_PARAM_MAP))::get(null,p,"rh_axi4_if",vif);
    endfunction

    // TODO
endclass // }


`endif
