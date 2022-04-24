`ifndef rh_axi4_config__svh
`define rh_axi4_config__svh

class rh_axi4_config #(`RH_AXI4_IF_DEFAULT_PARAM) extends rh_axi4_configBase; // {

	// for generating random wa2wd delay
	uint32_t wa2wd_min,wa2wd_max;
	virtual rh_axi4_if#(AW,DW,IW) vif;
	string intfPath="defaultPath";


	`uvm_object_utils_begin(rh_axi4_config#(AW,DW,IW))
	`uvm_object_utils_end

	function new(string name="rh_axi4_config");
		super.new(name);
	endfunction

	// APIs
	extern function uint32_t getRandwa2wdDelay();
	extern function logic getResetValue();
	extern task driveWA(reqTr_t req);
	extern task driveWD(reqTr_t req);
	extern task driveRA(reqTr_t req);
	extern task sync (uint32_t d);
	extern task waitResetNotEqualTo(logic v);

	function void setIntfPath(string p); // ##{{{
		intfPath=p;
	endfunction // ##}}}

	// wait for write address channel valid, and store fields into req arg
	extern task waitWriteAddressValid(ref reqTr_t req);
	extern task waitWriteDataValid(ref reqTr_t req);
	extern task waitReadAddressValid(ref reqTr_t req);
	extern task waitReadDataValid(ref respTr_t req);
	extern task waitBrespValid(ref respTr_t rsp);

	// interface operation
	extern function void _getInterfaceHandle;
	extern virtual function void elaborateConfigs;


endclass // }

task rh_axi4_config::waitReadDataValid(ref respTr_t req);
	// TODO
endtask // }

task rh_axi4_config::waitBrespValid(ref respTr_t rsp);
	// TODO
endtask // }

task rh_axi4_config::waitWriteDataValid(ref reqTr_t req);
	// TODO
endtask // }

task rh_axi4_config::waitReadAddressValid(ref reqTr_t req);
	// TODO
endtask // }

task rh_axi4_config::waitWriteAddressValid(ref reqTr_t req);
	// TODO
endtask // }

task rh_axi4_config::driveRA(reqTr_t req); // {
	// TODO, call vif.driveRA
endtask // }

task rh_axi4_config::sync(uint32_t d); // {
	vif.sync(d);
endtask // }

function logic rh_axi4_config::getResetValue(); // {
	return vif.ARESETN;
endfunction // }

task rh_axi4_config::waitResetNotEqualTo(logic v); // {
	wait (vif.ARESETN !== v);
endtask // }

function uint32_t rh_axi4_config::getRandwa2wdDelay(); // {
	return $urandom_range(wa2wd_min,wa2wd_max);
endfunction // }

function void rh_axi4_config::_getInterfaceHandle;
	`uvm_info(get_type_name(),"get interface",UVM_LOW)
	if (!uvm_config_db#(virtual rh_axi4_if#(AW,DW,IW))::get(null,intfPath,"rh_axi4_if",vif))
		`uvm_fatal(get_type_name(),$sformatf("cannot get interface(%s)",intfPath))
endfunction

function void rh_axi4_config::elaborateConfigs;
	this.randomize(); // random config settings that not manually set
	_getInterfaceHandle;
endfunction

task rh_axi4_config::driveWA(reqTr_t req);
	vif.driveWA(
		req.addr,
		req.size,
		req.burst,
		req.cache,
		req.prot,
		req.region,
		req.qos,
		req.lock
	);
endtask

task rh_axi4_config::driveWD(reqTr_t req);
	// @RyanH,TODO, rhaxi4_wd_info wd=new(req);
	// @RyanH,TODO, wd.wa2wdDelay = getRandwa2wdDelay();
	// @RyanH,TODO, vif.driveWD(wd);
endtask


`endif
