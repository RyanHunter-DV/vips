`ifndef rh_axi4_ifcontrol__svh
`define rh_axi4_ifcontrol__svh


class rh_axi4_ifcontrol extends rh_axi4_ifcontrol_base; // {

    function new(string name="rh_axi4_ifcontrol");
        uvm_pkg::uvm_config_db#(rh_axi4_ifcontrol_base)::set(uvm_pkg::uvm_root::get(),"",name,this);
    endfunction

    function rh_axi4_vip_configBase createConfig(string name="cfg");
        createConfig = rh_axi4_vip_config#(AW,DW,IW,UW)::type_id::create("cfg");
        return createConfig;
    endfunction

endclass // }


`endif
