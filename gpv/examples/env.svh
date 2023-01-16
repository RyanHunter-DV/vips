`ifndef env__svh
`define env__svh

class Env extends uvm_env;

	RhGpvAgent gpv;
	`uvm_component_utils(Env)

	function new(string name="Env",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_object_registry#(RhGpvProtocolBase)::set_inst_override(RwaccessProtocol::get_type(),"gpv.protocol",this);
		gpv = RhGpvAgent::type_id::create("gpv",this);
	endfunction
		

endclass




`endif
