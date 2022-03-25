`ifndef rh_axi4_config__svh
`define rh_axi4_config__svh

class rh_axi4_config extends uvm_object; // {

	// for generating random wa2wd delay
	uint32_t wa2wd_min,wa2wd_max;
	virtual rh_axi4_if vif;
	string intfPath="defaultPath";


	`uvm_object_utils_begin(rh_axi4_config)
	`uvm_object_utils_end

	function new(string name="rh_axi4_config");
		super.new(name);
	endfunction

	// APIs
	extern function uint32_t getRandwa2wdDelay();
	extern task driveWA(reqTr_t req);

	// interface operation
	extern function void _getInterfacehandle;
	extern function void elaborateConfigs;



endclass // }

function uint32_t rh_axi4_config::getRandwa2wdDelay(); // {
	return $urandom_range(wa2wd_min,wa2wd_max);
endfunction // }

function void rh_axi4_config::_getInterfaceHandle;
	if (!uvm_config_db#(virtual rh_axi4_if)::get(null,intfPath,"rh_axi4_if",vif))
		`uvm_fatal(get_type_name(),$sformatf("cannot get interface(%s)",intfPath))
endfunction

function void rh_axi4_config::elaborateConfigs;
	_getInterfaceHandle;
endfunction

task rh_axi4_config::driveWA(reqTr_t req);
	rhaxi4_wa_info wa=new(req);
	vif.driveWA(wa)
endtask

task rh_axi4_config::driveWD(reqTr_t req);
	rhaxi4_wd_info wd=new(req);
	wd.wa2wdDelay = getRandwa2wdDelay();
	vif.driveWD(wd);
endtask


`endif
