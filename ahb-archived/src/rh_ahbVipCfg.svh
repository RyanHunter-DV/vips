`ifndef rh_ahbVipCfg__svh
`define rh_ahbVipCfg__svh

class rh_ahbVipCfg extends uvm_object; // {

	virtual rh_ahbIf intf;
	string intfPath = "";
	rh_ahbVip_mode dM = AHB_MST;
	uvm_active_passive_enum isActive;


	extern function bit setIntf (string path);
	extern function void setActivePassive (uvm_active_passive_enum m);



endclass // }

function void rh_ahbVipCfg::setActivePassive(uvm_active_passive_enum m);
	isActive = m;
endfunction

function bit rh_ahbVipCfg::setIntf(string path); // {
	intfPath = path;
	setIntf = uvm_config_db #(virtual rh_ahbIf)::get(null,"*",intfPath,intf);
	return setIntf;
endfunction // }

`endif
