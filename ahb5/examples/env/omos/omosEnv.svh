`ifndef omosEnv__svh
`define omosEnv__svh

class omosEnvConfig extends uvm_object;
	RhuDebugger debug;
	
	`uvm_object_utils(omosEnvConfig)
	function new(string name="omosEnvConfig");
		super.new(name);
	endfunction
	function void setupDebug(uvm_component obj);
		debug = new(obj);
	endfunction
endclass : omosEnvConfig

// uvm_env: omosEnv
// This class generated by snippet: 'env', if has any issue, pls report to RyanHunter
`uvm_analysis_imp_decl(_mstReqImp)
`uvm_analysis_imp_decl(_mstReqDataImp)
`uvm_analysis_imp_decl(_mstRspImp)
`uvm_analysis_imp_decl(_slvReqImp)
`uvm_analysis_imp_decl(_slvReqDataImp)
`uvm_analysis_imp_decl(_slvRspImp)
class omosEnv extends uvm_env;
	RhAhb5Vip mst,slv;
	RhAhb5MstConfig mstc;
	RhAhb5SlvConfig slvc;
	omosEnvConfig config;

	RhAhb5ReqTrans mstReq;
	RhAhb5ReqTrans slvReq;
	RhAhb5RspTrans mstRsp;
	RhAhb5RspTrans slvRsp;

	uvm_analysis_imp_mstReqImp    #(RhAhb5ReqTrans,omosEnv) mreqI;
	uvm_analysis_imp_mstReqDataImp#(RhAhb5ReqTrans,omosEnv) mreqDataI;
	uvm_analysis_imp_mstRspImp    #(RhAhb5RspTrans,omosEnv) mrspI;
	uvm_analysis_imp_slvReqImp    #(RhAhb5ReqTrans,omosEnv) sreqI;
	uvm_analysis_imp_slvReqDataImp#(RhAhb5ReqTrans,omosEnv) sreqDataI;
	uvm_analysis_imp_slvRspImp    #(RhAhb5RspTrans,omosEnv) srspI;

	`uvm_component_utils_begin(omosEnv)
	`uvm_component_utils_end

	function new(string name="omosEnv",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	// phases ##{{{
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
	// ##}}}

	extern function void write_mstReqImp(RhAhb5ReqTrans _tr);
	extern function void write_mstReqDataImp(RhAhb5ReqTrans _tr);
	extern function void write_mstRspImp(RhAhb5RspTrans _tr);
	extern function void write_slvReqImp(RhAhb5ReqTrans _tr);
	extern function void write_slvReqDataImp(RhAhb5ReqTrans _tr);
	extern function void write_slvRspImp(RhAhb5RspTrans _tr);
	extern function omosEnvConfig createConfig ();
	bit debugComps[string];
	extern function void setDebugComp (string comp);
	extern function void __setupDebugComp__ ();
endclass
function omosEnvConfig omosEnv::createConfig(); // ##{{{
	config = omosEnvConfig::type_id::create("config");
	config.setupDebug(this);
endfunction // ##}}}
function void omosEnv::setDebugComp(string comp); // ##{{{
	if (comp=="env") config.debug.enable();
	else debugComps[comp] = 1;
endfunction // ##}}}
function void omosEnv::__setupDebugComp__(); // ##{{{
	foreach (debugComps[comp]) begin
		if (comp=="mst") mst.option("debug");
		else if (comp=="slv") slv.option("debug");
	end
endfunction // ##}}}
function void omosEnv::write_mstReqImp(RhAhb5ReqTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get master's reqCtrl tr:\n%s",_tr.sprint),UVM_LOW)
	if (slvReq!=null) begin
		if (!_tr.compare(slvReq)) begin
			`uvm_error("CHECK","request trans compare failed")
			`uvm_info("CHECK",$sformatf("master req:\n%s\nslave req:\n%s",_tr.sprint(),slvReq.sprint()),UVM_LOW)
		end else begin
			`uvm_info("CHECK","request compare success",UVM_LOW)
		end
		slvReq=null;
	end else begin
		mstReq=_tr;
	end
endfunction
function void omosEnv::write_mstReqDataImp(RhAhb5ReqTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get master's reqData tr:\n%s",_tr.sprint),UVM_LOW)
endfunction
function void omosEnv::write_mstRspImp(RhAhb5RspTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get master's rsp tr:\n%s",_tr.sprint),UVM_LOW)
	if (slvRsp!=null) begin
		if (!_tr.compare(slvRsp)) begin
			`uvm_error("CHECK","request trans compare failed")
			`uvm_info("CHECK",$sformatf("master req:\n%s\nslave req:\n%s",_tr.sprint(),slvRsp.sprint()),UVM_LOW)
		end else begin
			`uvm_info("CHECK","response compare success",UVM_LOW)
		end
		slvRsp=null;
	end else begin
		mstRsp=_tr;
	end
endfunction

function void omosEnv::write_slvReqImp(RhAhb5ReqTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get slave's reqCtrl tr:\n%s",_tr.sprint),UVM_LOW)
	if (mstReq!=null) begin
		if (!_tr.compare(mstReq)) begin
			`uvm_error("CHECK","request trans compare failed")
			`uvm_info("CHECK",$sformatf("master req:\n%s\nslave req:\n%s",_tr.sprint(),mstReq.sprint()),UVM_LOW)
		end else begin
			`uvm_info("CHECK","request compare success",UVM_LOW)
		end
		mstReq=null;
	end else begin
		slvReq = _tr;
	end
endfunction
function void omosEnv::write_slvReqDataImp(RhAhb5ReqTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get slave's reqData tr:\n%s",_tr.sprint),UVM_LOW)
endfunction
function void omosEnv::write_slvRspImp(RhAhb5RspTrans _tr);
	`uvm_info("GETTRANS",$sformatf("get slave's rsp tr:\n%s",_tr.sprint),UVM_LOW)
	if (mstRsp!=null) begin
		if (!_tr.compare(mstRsp)) begin
			`uvm_error("CHECK","rspuest trans compare failed")
			`uvm_info("CHECK",$sformatf("master rsp:\n%s\nslave rsp:\n%s",mstRsp.sprint(),_tr.sprint()),UVM_LOW)
		end else begin
			`uvm_info("CHECK","response compare success",UVM_LOW)
		end
		mstRsp=null;
	end else begin
		slvRsp=_tr;
	end
endfunction

function void omosEnv::build_phase(uvm_phase phase); // ##{{{
	super.build_phase(phase);
	`rhudbg("local build_phase starting ...")
	mst  = RhAhb5Vip::type_id::create("mst",this);
	slv  = RhAhb5Vip::type_id::create("slv",this);
	__setupDebugComp__();

	$cast(mstc,mst.createConfig(RHAHB5_MASTER,"top.ifCtrl"));
	$cast(slvc,slv.createConfig(RHAHB5_SLAVE,"top.ifCtrl"));

	// basic configs
	mstc.setActivePassive(UVM_ACTIVE);
	slvc.setActivePassive(UVM_ACTIVE);
	slvc.response(RHAHB5_RANDOM);

	// TODO, reqI=new("ahb.reqI",this);
	// TODO, reqDataI=new("ahb.reqDataI",this);
	// TODO, rspI=new("ahb.rspI",this);
	`rhudbg($sformatf("build master with basic config:\n%s",mstc.sprint()))
	`rhudbg($sformatf("build slave with basic config:\n%s",slvc.sprint()))

	mreqI     = new("mreqI",this);
	mreqDataI = new("mreqDataI",this);
	mrspI     = new("mrspI",this);
	sreqI     = new("sreqI",this);
	sreqDataI = new("sreqDataI",this);
	srspI     = new("srspI",this);
	`rhudbg("local build_phase leaving ...")
endfunction // ##}}}
function void omosEnv::connect_phase(uvm_phase phase); // ##{{{
	super.connect_phase(phase);
	`uvm_info("connect","running in connect_phase ...",UVM_LOW)
	mst.reqCtrlP.connect(mreqI);
	mst.reqDataP.connect(mreqDataI);
	mst.rspP.connect    (mrspI);
	slv.reqCtrlP.connect(sreqI);
	slv.reqDataP.connect(sreqDataI);
	slv.rspP.connect    (srspI);
endfunction // ##}}}
task omosEnv::run_phase(uvm_phase phase); // ##{{{
	super.run_phase(phase);
endtask // ##}}}

`endif
