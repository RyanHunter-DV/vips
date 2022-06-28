`ifndef rh_axi4mst_agt__svh
`define rh_axi4mst_agt__svh

class rh_axi4mst_agt extends uvm_agent; // {

    parameter type REQ=rh_axi4_trans;
    parameter type RSP=rh_axi4_trans;

    rh_axi4mst_drv  drv;
    rh_axi4mst_mon  mon;
    rh_axi4mst_seqr seqr;
    rh_axi4_vip_configBase cfg;

    `uvm_component_utils_begin(rh_axi4mst_agt)
    `uvm_component_utils_end


    function new(string name="rh_axi4mst_agt",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);



endclass // }


function void rh_axi4mst_agt::build_phase(uvm_phase phase); // {
    super.build_phase(phase);

    // TODO, need enhance for active/passive
    if (cfg.is_active) begin
        drv = rh_axi4mst_drv::type_id::create("drv",this);
        seqr= rh_axi4mst_seqr::type_id::create("seqr",this);
        drv.cfg = cfg;
    end
    mon = rh_axi4mst_mon::type_id::create("mon",this);
	mon.cfg = cfg;


endfunction // }

function void rh_axi4mst_agt::connect_phase(uvm_phase phase); // {
    if (cfg.is_active) begin
        mon.resetP.connect(drv.resetI);
        mon.respP.connect(drv.respI);
        drv.seq_item_port.connect(seqr.seq_item_export);
    end

endfunction // }

`endif
