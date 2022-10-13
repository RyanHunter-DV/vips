`ifndef Axi4SlaveDriver__svh
`define Axi4SlaveDriver__svh

class Axi4SlaveDriver extends Axi4DriverBase; // {

	local logic defaultValues[string];

	Axi4SeqItem bresps[$];
	Axi4SeqItem rresps[$];

	`uvm_component_utils(Axi4SlaveDriver)

	function new(string name="Axi4SlaveDriver",uvm_component parent=null);
		super.new(name,parent);
		defaultValues["AWREADY"]= 1'bx;
		defaultValues["WREADY"] = 1'bx;
		defaultValues["ARREADY"]= 1'bx;
	endfunction


	extern virtual task mainProcess( );
	extern local task startAWChannel( );
	extern local task startARChannel( );
	extern local task startWDChannel( );
	extern local task getSeqItem( );
	extern local task startBChannel( );
	extern local task startRDChannel( );
endclass // }

task Axi4SlaveDriver::startRDChannel( ); // {
	forever begin
		Axi4SeqItem _rsp;
		Axi4ChannelInfo info;
		wait (rresps.size() > 0);
		_rsp = rresps.pop_front();
		cfg.sync(_rsp.processDelay());
		info = _rsp.convertItemToInfo();
		cfg.drive("RDCHANNEL",info);
	end
endtask // }

task Axi4SlaveDriver::startBChannel( ); // {
	forever begin
		Axi4SeqItem _rsp;
		Axi4ChannelInfo info;
		wait (bresps.size() > 0);
		_rsp = bresps.pop_front();
		cfg.sync(_rsp.processDelay());
		info = _rsp.convertItemToInfo();
		cfg.drive("BCHANNEL",info);
	end
endtask // }

task Axi4SlaveDriver::getSeqItem( ); // {
	forever begin
		seq_item_port.get_next_item(req);
		case (req.t)
			RHAxi4WriteRsp: bresps.push_back(req);
			RHAxi4ReadRsp : rresps.push_back(req);
		endcase
		seq_item_port.item_done();
	end
endtask // }

task Axi4SlaveDriver::startWDChannel( ); // {
	Axi4ChannelInfo wchnl;
	forever begin
		wchnl.weady = defaultValues["WREADY"];
		cfg.drive("WREADY",wchnl);
		cfg.sync(cfg.lowDuration("WREADY"));
		wchnl.wready = 1'b1;
		cfg.drive("WREADY",wchnl);
		cfg.sync(cfg.highDuration("WREADY"));
	end
endtask // }

task Axi4SlaveDriver::startARChannel( ); // {
	Axi4ChannelInfo archnl;
	forever begin
		archnl.arready = defaultValues["ARREADY"];
		cfg.drive("ARREADY",archnl);
		cfg.sync(cfg.lowDuration("ARREADY"));
		archnl.arready = 1'b1;
		cfg.drive("ARREADY",archnl);
		cfg.sync(cfg.highDuration("ARREADY"));
	end
endtask // }

task Axi4SlaveDriver::startAWChannel( ); // {
	Axi4ChannelInfo awchnl;
	forever begin
		awchnl.awready = defaultValues["AWREADY"];
		cfg.drive("AWREADY",awchnl);
		cfg.sync(cfg.lowDuration("AWREADY"));
		awchnl.awready = 1'b1;
		cfg.drive("AWREADY",awchnl);
		cfg.sync(cfg.highDuration("AWREADY"));
	end
endtask // }

task Axi4SlaveDriver::mainProcess( ); // {
	fork
		getSeqItem();
		startAWChannel();
		startWDChannel();
		startARChannel();
		startRDChannel();
		startBChannel();
	join
endtask // }

`endif
