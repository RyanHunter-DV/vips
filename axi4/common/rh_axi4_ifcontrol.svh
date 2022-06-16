`ifndef rh_axi4_ifcontrol__svh
`define rh_axi4_ifcontrol__svh


import rh_axi4_vip::*;
class rh_axi4_ifcontrol extends rh_axi4_ifcontrol_base; // {

    function new(string name="rh_axi4_ifcontrol");
        uvm_pkg::uvm_config_db#(rh_axi4_ifcontrol)::set(uvm_pkg::uvm_root::get(),"","rh_axi4_ifcontrol",this);
    endfunction

    function rh_axi4_vip_configBase createConfig(string name="cfg");
        createConfig = rh_axi4_vip_config#(`RH_AXI4_IF_PARAM_MAP)::type_id::create("cfg");
        return createConfig;
    endfunction

endclass // }


`endif
