`ifndef rh_axi4_vip__svh
`define rh_axi4_vip__svh

class rh_axi4_vip extends uvm_env;

	rh_axi4_agentBase agt;
	rh_axi4_vip_configBase cfg;


	`uvm_component_utils(rh_axi4_vip)

	function new(string name="rh_axi4_vip",uvm_component parent=null);
		rh_axi4_ifcontrol_base ifctrl;
		super.new(name,parent);
		uvm_config_db#(rh_axi4_ifcontrol_base)::get(uvm_root::get(),"","rh_axi4_ifcontrol",ifctrl);
		if (ifctrl==null)
			`uvm_fatal("NOIFCTRL","cannot get ifctrl from interface")
		cfg = ifctrl.createConfig("cfg");
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

	// local APIs
	extern local function void setReferenceSeqr;

	// public APIs
	extern function void setMode(rh_axi4_device_enum m);
	extern function void setInterfacePath(string p);
	extern function rh_axi4_baseSeqr seqr( );

endclass

function rh_axi4_baseSeqr rh_axi4_vip::seqr( ); // {
	return agt.getSeqr();
endfunction // }

function void rh_axi4_vip::setInterfacePath(string p);
	cfg.getInterface(p);
endfunction

function void rh_axi4_vip::setMode(rh_axi4_device_enum m);
	case (m)
		axi4_active_master: begin
			cfg.is_master = axi4_master;
			cfg.is_active = UVM_ACTIVE;
		end
		axi4_active_slave: begin
			cfg.is_master = axi4_slave;
			cfg.is_active = UVM_ACTIVE;
		end
		axi4_passive_master: begin
			cfg.is_master = axi4_master;
			cfg.is_active = UVM_PASSIVE;
		end
		axi4_passive_slave: begin
			cfg.is_master = axi4_slave;
			cfg.is_active = UVM_PASSIVE;
		end
	endcase
endfunction

function void rh_axi4_vip::build_phase(uvm_phase phase);

	if (cfg.is_master==axi4_master)
		agt = rh_axi4mst_agt::type_id::create("mstAgent",this);
	else
		agt = rh_axi4slv_agt::type_id::create("slvAgent",this);
	agt.setConfig(cfg);
endfunction

function void rh_axi4_vip::connect_phase(uvm_phase phase);
endfunction



`endif
