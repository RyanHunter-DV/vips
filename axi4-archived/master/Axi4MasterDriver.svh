`ifndef Axi4MasterDriver__svh
`define Axi4MasterDriver__svh

class Axi4MasterDriver extends Axi4DriverBase; // {

	local logic defaultValues[string];

	local Axi4SeqItem awReqs[$];
	local Axi4SeqItem wdReqs[$];
	local Axi4SeqItem arReqs[$];

	local Axi4SeqItem bresp[$];
	local Axi4SeqItem rresp[$];

	uvm_analysis_imp #(Axi4SeqItem,Axi4MasterDriver) rspI;

	`uvm_component_utils_begin(Axi4MasterDriver)
	`uvm_component_utils_end

	function new(string name="Axi4MasterDriver",uvm_component parent=null);
		super.new(name,parent);
		// default values can be configured to 0, later TODO
		defaultValues["BREADY"] = 1'bx;
		defaultValues["RREADY"] = 1'bx;
	endfunction

	extern function void build_phase(uvm_phase phase);
	extern virtual task mainProcess( );

	// channel to drive bready signal, randomly drive the bready
	extern local task startBChannel( );
	// channel to drive rready signal randomly
	extern local task startRDChannel( );
	extern local task startAWChannel( );
	extern local task startWDChannel( );
	extern local task startARChannel( );

	// get sequence from seqr, and stored into local queues
	extern local task getSeqItem( );
	extern local task waitResponseInfo(input Axi4SeqItem req, output Axi4SeqItem rsp);
	extern function void write(Axi4SeqItem tr);
	extern local function Axi4SeqItem getMatchedResp(string chnl, Axi4SeqItem _r);
endclass // }

task Axi4MasterDriver::startARChannel( ); // {
	forever begin // {
		Axi4SeqItem _req;
		Axi4ChannelInfo info;
		wait(arReqs.size()>0);
		_req = arReqs.pop_front();
		cfg.sync(_req.processDelay());
		info = _req.convertItemToInfo();
		cfg.drive("ARCHANNEL",info);
	end // }
endtask // }


task Axi4MasterDriver::startWDChannel( ); // {
	forever begin // {
		Axi4SeqItem _req;
		Axi4ChannelInfo info;
		wait(wdReqs.size()>0);
		_req = wdReqs.pop_front();
		cfg.sync(_req.processDelay());
		info = _req.convertItemToInfo();
		cfg.drive("WDCHANNEL",info);
	end // }
endtask // }

function Axi4SeqItem Axi4MasterDriver::getMatchedResp(string chnl, Axi4SeqItem _r); // {
	Axi4SeqItem resp;
	case (chnl) // {
		"BRESP": begin // {
			foreach (bresp[i]) begin // {
				if (_r.id == bresp[i].id) begin // {
					resp = bresp[i];
					bresp.delete(i);
					break;
				end // }
			end // }
		end // }
		"RRESP": begin // {
			foreach (rresp[i]) begin // {
				if (_r.id == rresp[i].id) begin // {
					resp = rresp[i];
					rresp.delete(i);
					break;
				end // }
			end // }
		end // }
	endcase // }
	return resp;
endfunction // }

function void Axi4MasterDriver::write(Axi4SeqItem tr); // {
	// PLACEHOLDER, auto generated function, add content here
	foreach (drops[i]) begin
		if (drops[i] == tr.id) begin
			drops.delete(i);
			return;
		end
	end
	case (tr.t)
		RHAxi4WriteRsp:bresp.push_back(tr);
		RHAxi4ReadRsp: rresp.push_back(tr);
	endcase
	return;
endfunction // }

task Axi4MasterDriver::waitResponseInfo(
	input Axi4SeqItem req,
	output Axi4SeqItem rsp
); // {
	// PLACEHOLDER, auto generated task, add content here
	case (req.t) // {
		RHAxi4WriteReq: begin
			rsp = getMatchedResp("BRESP",req);
			while (rsp==null)) begin
				int currentSize = bresp.size();
				wait (bresp.size() > currentSize);
				rsp = getMatchedResp("BRESP",req);
			end
			rsp.set_id_info(req);
		end
		RHAxi4ReadReq: begin
			rsp = getMatchedResp("RRESP",req);
			while (rsp==null)) begin
				int currentSize = rresp.size();
				wait (rresp.size() > currentSize);
				rsp = getMatchedResp("RRESP",req);
			end
			rsp.set_id_info(req);
		end
	endcase // }
	return;
endtask // }

function void Axi4MasterDriver::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
	rspI = new("rspI",this);
endfunction // }

task Axi4MasterDriver::getSeqItem( ); // {
	forever begin
		seq_item_port.get_next_item(req);
		case (req.t)
			RHAxi4WriteReq: awReqs.push_back(req);
			RHAxi4ReadReq:  arReqs.push_back(req);
			default: begin
				`uvm_error(get_type_name(),$sformatf("unsupported seq type(%s)",req.t.name()))
			end
		endcase
		if (req.rspEn) begin // {
			waitResponseInfo(req,rsp);
			seq_item_port.item_done(rsp);
		// }
		end else begin // {
			drops.push_back(req.id);
			seq_item_port.item_done();
		end // }
	end
endtask // }

task Axi4MasterDriver::startAWChannel( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin // {
		Axi4SeqItem _req;
		Axi4ChannelInfo info;
		wait(awReqs.size()>0);
		_req = awReqs.pop_front();
		cfg.sync(_req.processDelay());
		info = _req.convertItemToInfo();
		cfg.drive("AWCHANNEL",info);
	end // }
endtask // }

task Axi4MasterDriver::startRDChannel( ); // {
	Axi4ChannelInfo rchnl;
	forever begin
		rchnl.rready = defaultValues["RREADY"];
		cfg.drive("RREADY",rchnl);
		cfg.sync(cfg.lowDuration("RREADY"));
		rchnl.rready = 1'b1;
		cfg.drive("RREADY",rchnl);
		cfg.sync(cfg.highDuration("RREADY"));
	end
endtask // }

task Axi4MasterDriver::startBChannel( ); // {
	Axi4ChannelInfo bchnl;
	forever begin
		bchnl.bready = defaultValues["BREADY"];
		cfg.drive("BREADY",bchnl);
		cfg.sync(cfg.lowDuration("BREADY"));
		bchnl.bready = 1'b1;
		cfg.drive("BREADY",bchnl);
		cfg.sync(cfg.highDuration("BREADY"));
	end
endtask // }

task Axi4MasterDriver::mainProcess( ); // {
	// PLACEHOLDER, auto generated task, add content here
	fork // {
		getSeqItem();
		startAWChannel();
		startWDChannel();
		startBChannel();
		startARChannel();
		startRDChannel();
	join // }
endtask // }

`endif
