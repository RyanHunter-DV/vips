`ifndef rh_axi4_configBase__svh
`define rh_axi4_configBase__svh

class rh_axi4_configBase extends uvm_object; // {


	`uvm_object_utils_begin(rh_axi4_configBase)
	`uvm_object_utils_end


	function new(string name="rh_axi4_configBase");
		super.new(name);
	endfunction

	virtual function void elaborateConfigs;endfunction
	virtual function uint32_t getRandwa2wdDelay();endfunction
	virtual function logic getResetValue();endfunction
	virtual function void setIntfPath(string p);endfunction
	virtual task driveWA(reqTr_t req);endtask
	virtual task driveWD(reqTr_t req);endtask
	virtual task driveRA(reqTr_t req);endtask
	virtual task sync (uint32_t d);endtask
	virtual task waitResetNotEqualTo(logic v);endtask
	virtual task waitWriteAddressValid(ref reqTr_t req);endtask
	virtual task waitWriteDataValid(ref reqTr_t req);endtask
	virtual task waitReadAddressValid(ref reqTr_t req);endtask
	virtual task waitReadDataValid(ref respTr_t req);endtask
	virtual task waitBrespValid(ref respTr_t rsp);endtask


endclass // }


`endif
