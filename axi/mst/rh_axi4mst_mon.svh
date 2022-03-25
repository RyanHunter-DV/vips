`ifndef rh_axi4mst_mon__svh
`define rh_axi4mst_mon__svh

class rh_axi4mst_mon extends rh_axi4_monBase; // {

	uvm_analysis_port #(reqTr_t)  reqP;
	uvm_analysis_port #(respTr_t) respP;

	`uvm_component_utils_begin(rh_axi4mst_mon)
	`uvm_component_utils_end

	function new(string name="rh_axi4mst_mon",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// phase
	extern function void build_phase(uvm_phase phase);

	// main entry
	extern virtual task runStage;

	// monitorReqs
	extern task monitorReqs;
	// listenWriteReq, to raise the write channel probe, wait write address information
	// and convert it to reqTr_t, then start waiting for write data channel, until all
	// the write data received.
	extern task listenWriteReq;
	// similar as listenReadReq, wait for read address channel done, and then sendout this
	// req
	extern task listenReadReq;

	// monitorRsps
	extern task monitorRsps;
	extern task listenWriteRsp;
	extern task listenReadRsp;


endclass // }

function void rh_axi4mst_mon::build_phase(uvm_phase phase);
	super.build_phase(phase);
	reqP=new("reqP",this);
	respP=new("respP",this);
endfunction

task rh_axi4mst_mon::runStage;
	fork
		monitorReqs;
		monitorRsps;
	join
endtask

task rh_axi4mst_mon::monitorReqs;
	fork
		listenWriteReq;
		listenReadReq;
	join
endtask

task rh_axi4mst_mon::monitorRsps; // ##{{{
	fork
		listenWriteRsp;
		listenReadRsp;
	end
endtask // ##}}}

task rh_axi4mst_mon::listenWriteRsp; // ##{{{
	forever begin
		respTr_t r=new("monWrRsp");
		r.recordTime($time);
		cfg.waitBrespValid(r);
		r.recordTime($time);
		r.send(respP);
	end
endtask // ##}}}

task rh_axi4mst_mon::listenReadRsp; // ##{{{
	forever begin
		respTr_t r=new("monRdRsp");
		r.recordTime($time);
		cfg.waitReadDataValid(r);
		r.recordTime($time);
		r.send(respP);
	end
endtask // ##}}}

task rh_axi4mst_mon::listenWriteReq; // ##{{{
	forever begin
		reqTr_t r=new("monWrReq");
		r.recordTime($time);
		cfg.waitWriteAddressValid(r);
		cfg.waitWriteDataValid(r);
		r.recordTime($time);
		r.send(reqP);
	end
endtask // ##}}}

task rh_axi4mst_mon::listenReadReq; // ##{{{
	forever begin
		reqTr_t r=new("monRdReq");
		r.recordTime($time);
		cfg.waitReadAddressValid(r);
		r.recordTime($time);
		r.send(reqP);
	end
endtask // ##}}}



`endif
