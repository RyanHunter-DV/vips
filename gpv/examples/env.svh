`ifndef env__svh
`define env__svh

class Env extends uvm_env;

	RhGpvAgent  gpv;
	RhGpvConfig gpvc;
	`uvm_component_utils(Env)

	function new(string name="Env",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(),"starting build_phase ...",UVM_LOW)
		uvm_object_registry#(RhGpvProtocolBase,"RhGpvProtocolBase")::set_inst_override(RwaccessProtocol::get_type(),"gpv.protocol",this);
		// RhGpvProtocolBase::get_type()
		gpv = RhGpvAgent::type_id::create("gpv",this);
		gpvc = gpv.createConfig("tb.rif0");
		gpvc.enableReset();
		`uvm_info(get_type_name(),"finish build_phase ...",UVM_LOW)
	endfunction
		

endclass




`endif
