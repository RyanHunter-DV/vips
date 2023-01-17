`ifndef env__svh
`define env__svh

class Env extends uvm_env;

	`uvm_analysis_imp_decl(_oCome)
	`uvm_analysis_imp_decl(_iCome)

	RhGpvAgent  gpv;
	RhGpvConfig gpvc;
	uvm_analysis_imp_oCome#(RhGpvTrans,Env) oComeI;
	uvm_analysis_imp_iCome#(RhGpvTrans,Env) iComeI;
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
		oComeI = new("oComeI",this);
		iComeI = new("iComeI",this);
		`uvm_info(get_type_name(),"finish build_phase ...",UVM_LOW)
	endfunction
		

	extern virtual function void connect_phase(uvm_phase phase);
	extern function void write_oCome (RhGpvTrans _tr);
	extern function void write_iCome (RhGpvTrans _tr);
endclass
function void Env::connect_phase(uvm_phase phase); // ##{{{
	super.connect_phase(phase);
	gpv.mon.apOutcome.connect(oComeI);
	gpv.mon.apIncome.connect(iComeI);
endfunction // ##}}}
function void Env::write_oCome(RhGpvTrans _tr); // ##{{{
	`uvm_info("OTRANS",$sformatf("get outCome trans from monitor:\n%s",_tr.sprint()),UVM_LOW)
endfunction // ##}}}
function void Env::write_iCome(RhGpvTrans _tr); // ##{{{
	`uvm_info("ITRANS",$sformatf("get inCome trans from monitor:\n%s",_tr.sprint()),UVM_LOW)
endfunction // ##}}}



`endif
