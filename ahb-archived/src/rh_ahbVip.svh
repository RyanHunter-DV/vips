`ifndef rh_ahbVip__svh
`define rh_ahbVip__svh

// this is the main vip component for users to instantiate and configure
class rh_ahbVip #(AW=32,DW=32) extends uvm_env; // {

	typedef rh_ahbVip#(AW,DW) RH_AHBVIP;

	rh_ahbMstAgent mst;
	rh_ahbSlvAgent slv;
	rh_ahbVipCfg   config;
	rh_ahbVipProto proto;

	`uvm_component_utils_begin(RH_AHBVIP)
		`uvm_field_object(mst,UVM_DISPLAY|UVM_LOG)
		`uvm_field_object(slv,UVM_DISPLAY|UVM_LOG)
	`uvm_component_utils_end


	function new(string name="rh_ahbVip", uvm_component parent=null);
		super.new(name,parent);
	endfunction


	extern function void build_phase(uvm_phase phase);



	// configurable APIs
	extern function bit configVip (
		rh_ahbVip_mode dMode,
		string ifPath,
		uvm_active_passive_enum drvMode
		// TODO
	);


endclass // }

function void rh_ahbVip::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	mst = rh_ahbMstAgent::type_id::create("mst",this);
	slv = rh_ahbSlvAgent::type_id::create("slv",this);

	mst.config(); // TODO
	slv.config(); // TODO
endfunction // }

function bit rh_ahbVip::configVip(
	rh_ahbVip_mode dMode,
	string ifPath,
	uvm_active_passive_enum drvMode
	// TODO
); // {

	bit rtn = 1'b0;

	config = rh_ahbVipCfg::type_id::create("config");
	uvm_config_db#(rh_ahbVipCfg)::set(this,"","configTable",config);

	rtn |= config.setIntf(ifPath);
	config.setActivePassive(drvMode);

	// TODO


	return rtn;

endfunction // }



`endif
