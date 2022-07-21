`ifndef rh_axi4_agentBase__svh
`define rh_axi4_agentBase__svh

virtual class rh_axi4_agentBase extends uvm_agent;

	rh_axi4_monitorBase    mon;
	rh_axi4_driverBase     drv;
	rh_axi4_seqrBase       seqr;
	rh_axi4_vip_configBase config;
	rh_reset_handler       reseth;

	uvm_analysis_export #(rh_axi4_trans) reqP;
	uvm_analysis_export #(rh_axi4_trans) rspP;

	function new(string name="rh_axi4_agentBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction


	extern function void build_phase(uvm_phase phase);
	extern function void connect_phases(uvm_phase phase);
	extern function rh_axi4_seqrBase getSeqr( );
	extern function void setConfig(rh_axi4_configBase cfg);
endclass

function void rh_axi4_agentBase::setConfig(rh_axi4_configBase cfg); // {
	// PLACEHOLDER, auto generated function, add content here
	config = cfg;
endfunction // }


function rh_axi4_seqrBase rh_axi4_agentBase::getSeqr( ); // {
	// PLACEHOLDER, auto generated function, add content here
	return seqr;
endfunction // }


function void rh_axi4_agentBase::connect_phases(uvm_phase phase); // {
	mon.reqP.connect(reqP);
	mon.rspP.connect(rspP);
endfunction // }

function void rh_axi4_agentBase::build_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
	reqP = new("reqP",this);
	rspP = new("rspP",this);
	if (config.isActive())
		reseth = rh_reset_handler::type_id::create("reseth",this);
endfunction // }

`endif
