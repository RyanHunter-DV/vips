`uvm_analysis_imp_decl(_mstReqImp)
`uvm_analysis_imp_decl(_mstRspImp)
class MasterEnv extends uvm_env;

	RhAhb5MstAgent mst;
	RhAhb5MstConfig config;
	RhuDebugger debug;


	uvm_analysis_imp_mstReqImp#(RhAhb5ReqTrans,MasterEnv) reqI;
	uvm_analysis_imp_mstRspImp#(RhAhb5RspTrans,MasterEnv) rspI;

	`uvm_component_utils(MasterEnv)

	function new(string name="MasterEnv",uvm_component parent=null);
		super.new(name,parent);
		debug = new(this,"component");
	endfunction

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void write_mstReqImp(RhAhb5ReqTrans _tr);
	extern function void write_mstRspImp(RhAhb5RspTrans _tr);

endclass

function void MasterEnv::write_mstReqImp(RhAhb5ReqTrans _tr);
	`debug($sformatf("get req tr:\n%s",_tr.sprint))
endfunction
function void MasterEnv::write_mstRspImp(RhAhb5RspTrans _tr);
	`debug($sformatf("get rsp tr:\n%s",_tr.sprint))
endfunction

function void MasterEnv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	mst.reqP.connect(reqI);
	mst.rspP.connect(rspI);
endfunction

function void MasterEnv::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	mst   = RhAhb5MstAgent::type_id::create("mst",this);
	config= mst.createConfig("mstConfig");
	config.interfacePath="top.ifCtrl";
	reqI=new("mst.reqI",this);
	rspI=new("mst.rspI",this);
endfunction // }
