`ifndef Axi4MonitorBase__svh
`define Axi4MonitorBase__svh

class Axi4MonitorBase#(type REQ=VipSeqItem,RSP=REQ)
	extends VipMonitorBase; // {

	uvm_analysis_port#(REQ) reqP;
	uvm_analysis_port#(RSP) rspP;
	Axi4ConfigBase config;

	// only write requests need a queue here, because write requests has
	// two channels, the address channel and the data channel
	Axi4SeqItem writeReqs[$];

	`uvm_component_utils_begin(Axi4MonitorBase#(REQ,RSP))
	`uvm_component_utils_end

	function new(string name="Axi4MonitorBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern task waitResetStatusChanged(VipResetStatus currentSt, output VipResetStatus newSt);
	extern local function VipResetStatus translateSignalToResetStatus(logic sig);

	extern virtual function void build_phase(uvm_phase phase);

	extern virtual task mainProcess( );
	extern task startAWChannel( );
	extern task startWDChannel( );
	extern task waitMatchedWriteReq(int id, output Axi4SeqItem _r);
	extern task startARChannel( );
	extern task startBChannel( );
	extern task startRDChannel( );
endclass // }

task Axi4MonitorBase::startRDChannel( ); // {
	forever begin // {
		Axi4ChannelInfo info;
		Axi4SeqItem rsp=new("rrsp");
		rsp.recordTime($time);
		config.waitRDChannelInfo(info);
		rsp.convertInfoToItem(info);
		rsp.recordTime($time);
		rspP.send(rsp);
	end // }
endtask // }

task Axi4MonitorBase::startBChannel( ); // {
	forever begin // {
		Axi4ChannelInfo info;
		Axi4SeqItem rsp=new("wrsp");
		rsp.recordTime($time);
		config.waitBChannelInfo(info);
		rsp.convertInfoToItem(info);
		rsp.recordTime($time);
		rspP.send(rsp);
	end // }
endtask // }

task Axi4MonitorBase::startARChannel( ); // {
	forever begin // {
		Axi4ChannelInfo info;
		Axi4SeqItem req=new("rreq");
		req.recordTime($time);
		config.waitARChannelInfo(info);
		req.convertInfoToItem(info);
		req.recordTime($time);
		reqP.send(req);
	end // }
endtask // }

task Axi4MonitorBase::waitMatchedWriteReq(int id, output Axi4SeqItem _r); // {
	while (1) begin // {
		int currentSize = writeReqs.size();
		foreach (writeReqs[i]) begin
			if (id==writeReqs[i].id) begin
				_r = writeReqs[i];
				writeReqs.delete(i);
				return;
			end
		end
		// if not found
		wait (writeReqs.size() > currentSize);
	end // }
endtask // }

task Axi4MonitorBase::startWDChannel( ); // {
	forever begin // {
		Axi4ChannelInfo info;
		Axi4SeqItem req;
		config.waitWDChannelInfo(info);
		waitMatchedWriteReq(info.id,req);
		// merge wd info into req
		req.data  = info.data;
		req.strobe= info.strobe;
		req.resp  = info.resp;
		req.recordTime($time);
		reqP.send(req);
	end // }
endtask // }

task Axi4MonitorBase::startAWChannel( ); // {
	forever begin // {
		Axi4SeqItem req=new("wreq");
		Axi4ChannelInfo info;
		req.recordTime($time);
		config.waitAWChannelInfo(info);
		req.convertInfoToItem(info);
		writeReqs.push_back(req);
	end // }
endtask // }

function VipResetStatus Axi4MonitorBase::translateSignalToResetStatus(logic sig); // {
	case (sig) // {
		1'b1:    return resetInActive;
		1'b0:    return resetActive;
		default: return resetUnknown;
	endcase // }
endfunction // }

function void Axi4MonitorBase::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	reqP = new("reqP",this);
	rspP = new("rspP",this);
endfunction // }

task Axi4MonitorBase::waitResetStatusChanged(
	VipResetStatus currentSt,
	output VipResetStatus newSt
); // {
	logic sig;
	newSt = currentSt;
	while (currentSt == newSt) begin
		config.waitSignalChanged("ARESETN",sig);
		newSt = translateSignalToResetStatus(sig);
	end
	return;
endtask // }

task Axi4MonitorBase::mainProcess( ); // {
	fork
		start
	join
endtask // }

`endif
