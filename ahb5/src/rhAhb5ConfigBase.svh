`ifndef rhAhb5ConfigBase__svh
`define rhAhb5ConfigBase__svh

class RhAhb5ConfigBase extends uvm_object;

	// if is master mode, then master=1'b1, else master=1'b0
	bit master = 1'b0;
	// if is active mode, then active=1'b1, else active=1'b0
	bit active = 1'b0;

	RhAhb5IfCtrlBase ifCtrl;

	`uvm_object_utils_begin(RhAhb5ConfigBase)
		`uvm_field_int(master,UVM_ALL_ON)
		`uvm_field_int(active,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="RhAhb5ConfigBase");
		super.new(name);
	endfunction

	extern function void setActivePassive(uvm_active_passive_enum v);
	extern function void setMasterSlave(RhAhb5MS_t m);
	extern function void getInterface(string ifpath);
	extern function bit isActive();
	extern function bit isMaster();
	// extern task sync(string signal,logic[`RHAHB5_DW_MAX-1:0] target);
endclass
// task RhAhb5ConfigBase::sync(string signal,logic[`RHAHB5_DW_MAX-1:0] target);
// 	// This method is auto generated by cmd:Func
// 	ifCtrl.vif.sync(signal,target);
// endtask
function void RhAhb5ConfigBase::getInterface(string ifpath);
	// This method is auto generated by cmd:Func
	if (!uvm_config_db#(RhAhb5IfCtrlBase)::get(null,"*",ifpath,ifCtrl))
		`uvm_fatal("NOIFC",$sformatf("cannot get interface through path(%s)",ifpath))
endfunction
function bit RhAhb5ConfigBase::isMaster();
	// This method is auto generated by cmd:Func
	return master;
endfunction
function void RhAhb5ConfigBase::setMasterSlave(RhAhb5MS_t m);
	// This method is auto generated by cmd:Func
	master = (m==RHAHB5_MASTER);
endfunction
function bit RhAhb5ConfigBase::isActive();
	// This method is auto generated by cmd:Func
	return active;
endfunction
function void RhAhb5ConfigBase::setActivePassive(uvm_active_passive_enum v);
	// This method is auto generated by cmd:Func
	active = (v==UVM_ACTIVE);
endfunction

`endif
