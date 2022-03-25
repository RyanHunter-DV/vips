`ifndef rh_axi4mst_drv__svh
`define rh_axi4mst_drv__svh

class rh_axi4mst_drv extends rh_axi4_drvBase; // {

	uvm_analysis_imp_rhaxi4_resp#(respTr_t,rh_axi4mst_drv) respI;

	uvm_event waDone;
	reqTr_t reqQue[$];

	`uvm_component_utils_begin(rh_axi4mst_drv)
	`uvm_component_utils_end

	function new(string name="rh_axi4mst_drv",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	// phases
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

	// main task
	extern task mainProcess();

	// tlm
	extern function void write_resp(respTr_t _t);


	// internal actions
	// this is a task to raise the channels which should be used for sending
	// the corresponding request.
	extern task raiseChannels(bit[4:0] chnl);

	// the task to process and drive write address information to signal layer, input information comes
	// from the class member: req. When write address processed, need to trigger an event for write
	// data operations.
	extern task processWriteAddress;

	// to process the write data channel, this task will be raised the same time as processWriteAddress, but
	// it can only been processed after the waDone event's triggered. Besides, this channel will have
	// a delay before real operating on the data channel, this delay is a random value according to config table
	// we call it wa2wdDelay, it has two thredshold values, the wa2wdDelay_min/wa2wdDelay_max in config, and
	// wa2wdDelay will randomly generated between this two values.
	extern task processWriteData;

	// this task will process and send read request to signal layer
	extern task processReadAddress;

	// record req into a queue that will be used when comes a response, create a new object to store
	// req information incase 
	extern function void reqRecord(reqTr_t req);

endclass // }

function void rh_axi4mst_drv::write_resp(respTr_t _t);
	reqTr_t _tmp;
	foreach (reqQue[i])
		if (reqQue[i].id==_t.id) begin
			_tmp=reqQue[i];
			reqQue.delete(i);
			break;
		end
	_t.set_id_info(_tmp);
	_t.copy(_tmp);
	_tmp=null; // clear req
	seq_item_port.put_response(_t);
endfunction

function void rh_axi4mst_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	waDone=new("waDone");
endfunction

task rh_axi4mst_drv::mainProcess(); // {
	bit legal = 1'b1;
	seq_item_port.get_next_item(req);
	legal = legalityCheck(req);
	if (legal) begin // {
		if (req.delay) cfg.sync(req.delay);
		case (req.type)
			rhaxi4_write_req:
				raiseChannels(WAChannel|WDChannel);
			rhaxi4_read_req:
				raiseChannels(RAChannel);
			default:
				`uvm_error(get_type_name(),$sformatf("unsupported req type(%s)",req.type.name()))
		endcase
	end // }
	seq_item_port.item_done();

endtask // }

task rh_axi4mst_drv::raiseChannels(bit[4:0] chnl); // {
	fork
		if (chnl&rhaxi4_channel_bit'(WAChannel)) processWriteAddress;
		if (chnl&rhaxi4_channel_bit'(WDChannel)) processWriteData;
		if (chnl&rhaxi4_channel_bit'(RAChannel)) processReadAddress;
	join
endtask // }

task rh_axi4mst_drv::processWriteAddress; // {
	req.recordTime($time);
	cfg.driveWA(req);
	waDone.trigger();
endtask // }

task rh_axi4mst_drv::processWriteData; // {
	waDone.reset();waDone.wait_trigger();
	// process wa2wd delay in driveWD()
	cfg.driveWD(req);
	req.recordTime($time);
	reqRecord(req);
endtask // }

function void rh_axi4mst_drv::reqRecord(reqTr_t req);
	reqQue.push_back(req);
endfunction

task rh_axi4mst_drv::processReadAddress; // {
	req.recordTime($time);
	cfg.driveRA(req);
	req.recordTime($time);
endtask // }

`endif
