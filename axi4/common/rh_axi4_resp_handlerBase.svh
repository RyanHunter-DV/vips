`ifndef rh_axi4_resp_handlerBase__svh
`define rh_axi4_resp_handlerBase__svh

class rh_axi4_resp_handlerBase extends uvm_component;

	typedef rh_axi4_resp_handlerBase thisType;

	uvm_analysis_port #(rh_axi4_trans) rspP;
	uvm_analysis_imp #(rh_axi4_trans,thisType) reqI;


	`uvm_component_utils(rh_axi4_resp_handlerBase)

	function new(string name="rh_axi4_resp_handlerBase", uvm_component parent=null);
		super.new(name,parent);
	endfunction

// public

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void write(rh_axi4_trans _t);

	// task to process request and generate response
	// it's an empty virtual task in vip, should overrides
	// this component
	virtual task processResponse(input rh_axi4_trans req,output rh_axi4_trans rsp ); endtask

	extern task getNextReq(output rh_axi4_trans req );

// protected
	extern protected function void send(rh_axi4_trans tr);

// private

	local rh_axi4_trans __reqs[$];

	// main processor, forever loop this task, call
	// processResponse task
	extern local task __mainProcess( );

endclass

function void rh_axi4_resp_handlerBase::send(rh_axi4_trans tr); // {
	// PLACEHOLDER, auto generated function, add content here
	rspP.write(tr);
endfunction // }

task rh_axi4_resp_handlerBase::getNextReq(output rh_axi4_trans req ); // {
	// PLACEHOLDER, auto generated task, add content here
	if (__reqs.size() == 0) wait(__reqs.size()>0);
	req = __reqs.pop_front();
endtask // }

function void rh_axi4_resp_handlerBase::write(rh_axi4_trans _t); // {
	// PLACEHOLDER, auto generated function, add content here
	__reqs.push_back(_t);
endfunction // }

task rh_axi4_resp_handlerBase::__mainProcess( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		rh_axi4_trans rsp,req;
		getNextReq(req);
		rsp=new("rsp");
		processResponse(req,rsp);
		send(rsp);
		req=null;
	end
endtask // }

task rh_axi4_resp_handlerBase::run_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated task, add content here
	__mainProcess;
endtask // }

function void rh_axi4_resp_handlerBase::build_phase(uvm_phase phase); // {
	// PLACEHOLDER, auto generated function, add content here
	reqI = new("reqI",this);
	rspP = new("rspP",this);
endfunction // }

`endif
