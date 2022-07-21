`ifndef rh_axi4slv_agt__svh
`define rh_axi4slv_agt__svh

class rh_axi4slv_agt extends rh_axi4_agentBase; // {

	rh_axi4_resp_handlerBase respH;

    `uvm_component_utils(rh_axi4slv_agt)

    function new(string name="rh_axi4slv_agt",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // phases
    extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass // }



function void rh_axi4slv_agt::connect_phase(uvm_phase phase); // {
	`debug("calling connect_phase...")
	super.connect_phase(phase);
	// if active mode, connect seq ports
	if (config.isActive()) begin
		mon.reqP.connect(respH.reqI);
		respH.rspP.connect(drv.rspI);
		drv.seq_item_port.connect(seqr.seq_item_export);
	end
endfunction // }

function void rh_axi4slv_agt::build_phase(uvm_phase phase);
	`debug("calling build_phase...")
	super.build_phase(phase);
	mon = rh_axi4slv_mon::type_id::create("mon",this);
	if (config.isActive()) begin
		drv = rh_axi4slv_drv::type_id::create("drv",this);
		seqr= rh_axi4slv_seqr::type_id::create("seqr",this);
		// only when in active mode, then the reseth is needed
		drv.reseth = reseth;
		mon.reseth = reseth;
		// create response handler, which available only in active
		respH = rh_axi4_resp_handlerBase::type_id::create("respH",this);
	end

endfunction



`endif
