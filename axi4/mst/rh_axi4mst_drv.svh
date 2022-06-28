`ifndef rh_axi4mst_drv__svh
`define rh_axi4mst_drv__svh

class rh_axi4mst_drv extends rh_axi4_driverBase; // {

    typedef rh_axi4mst_drv thisClass;

    RSP respQue[$];

	REQ waQue[$];
	REQ wdQue[$];
	REQ raQue[$];

	rh_axi4_dchnl_t wdbeatQue[$];

    // uvm header
    `uvm_component_utils_begin(rh_axi4mst_drv)
    `uvm_component_utils_end


    function new(string name="rh_axi4mst_drv",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // uvm phase
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    // write response imp, if configured as respEn=TRUE, then response will be sent to
    // response queue. trans comes from monitor.
    // read response imp, from monitor, if conigured respEn=TRUE, then response will be sent to
    // response queue.
    uvm_analysis_imp_resp#(RSP,thisClass) respI;

    extern task __mainProcess();

    // TLM apis
    extern function void write_resp(RSP tr);

	// wait seqitem from seqr, according to write/read seq, push to
	// corresponding queue. if current seqitem's respEn==1, then wait
	// for response
	extern task __getSeqitems();

	// drive seqitem by starting wa/wd/ra channel
	extern task __driveSeqitems( );

	extern task __initMasterChannels( );
	extern task __raiseWAChnl( );
	extern task __raiseWDChnl( );

	// read address channel processing, when raQue has item, then pop that
	// from the raQue
	extern task __raiseRAChnl( );

	// a parallel thread to drive WD beat since it's on the wdbeatQue
	// so that different id's wd beats can be sent disordered.
	extern task __raiseDriveWDBeats( );
	// extract wd channel information from REQ, and split it into wd channel
	// beats
	extern function void __splitToWDBeats(REQ item, ref rh_axi4_dchnl_t beats[]);

	// search for the respQue, if matches current req item, then get current resp and delete
	// it in the queue, else wait next item been pushed into respQue
	extern task __getResponse( );
endclass // }

task rh_axi4mst_drv::__getResponse( ); // {
	int curSize;
	wait (respQue.size()); // wait size not 0
	curSize = respQue.size(); // record current respQue size

	while (1) begin
		foreach (respQue[i]) begin
			if (respQue[i].id == req.id) begin
				rsp = new("rsp");
				rsp.set_id_info(req);
				rsp.copy(respQue[i]);
				respQue.delete(i);
				return;
			end
		end
		wait(respQue.size() > curSize);
		curSize = respQue.size();
	end
endtask // }

task rh_axi4mst_drv::__raiseDriveWDBeats( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		rh_axi4_dchnl_t beat;
		wait (wdbeatQue.size());
		beat = wdbeatQue.pop_front();
		cfg.driveWDBeat(beat);
	end
endtask // }

task rh_axi4mst_drv::__initMasterChannels( ); // {
	// PLACEHOLDER, auto generated task, add content here
	fork
		cfg.initWA();
		cfg.initWD();
		cfg.initRA();
	join
	// wait all channels initialized
endtask // }

function void rh_axi4mst_drv::__splitToWDBeats(REQ item, ref rh_axi4_dchnl_t beats[]); // {
	int lastIdx = item.data.size()-1;
	beats = new[item.data.size()];
	beats[lastIdx].is_last = 1;
	foreach (item.data[i]) begin
		beats[i].data  =item.data[i];
		beats[i].strobe=item.strobe[i];
		beats[i].id    =item.id;
		beats[i].user  =item.user;
	end
	return;
endfunction // }

task rh_axi4mst_drv::__raiseRAChnl( ); // {
	forever begin
		REQ item;
		rh_axi4_achnl_t rabeat;
		`uvm_info(get_type_name(),"wait for raQue",UVM_HIGH)
		wait(raQue.size());
		item = raQue.pop_front();
		// extract trans to wachnl info
		rabeat.addr  = item.addr;
		rabeat.id    = item.id;
		rabeat.user  = item.user;
		rabeat.len   = item.len;
		rabeat.burst = item.burst;
		rabeat.qos   = item.qos;
		rabeat.prot  = item.prot;
		rabeat.lock  = item.lock;
		rabeat.cache = item.cache;
		rabeat.region= item.region;
		cfg.driveRA(rabeat);
	end
endtask // }

task rh_axi4mst_drv::__raiseWDChnl( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		rh_axi4_dchnl_t wdbeats[];
		REQ item;
		`uvm_info(get_type_name(),"wait for wdQue",UVM_HIGH)
		wait(wdQue.size()>0);
		item = wdQue.pop_front();
		// throw out this thread of one wdQue item, continue pushing
		// wdbeats into wdbeatQue after specific delay
		fork begin
			__splitToWDBeats(item,wdbeats);
			foreach (wdbeats[i]) begin
				// cfg.driveWDBeat(wdbeats[i]);
				wdbeatQue.push_back(wdbeats[i]);
				cfg.sync(cfg.genBeatDelay(axi4_master));
			end
		end join_none
	end
endtask // }

task rh_axi4mst_drv::__raiseWAChnl( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		REQ item;
		rh_axi4_achnl_t wabeat;
		`uvm_info(get_type_name(),"wait for waQue",UVM_HIGH)
		wait(waQue.size());
		item = waQue.pop_front();

		// extract trans to wachnl info
		wabeat.addr  = item.addr;
		wabeat.id    = item.id;
		wabeat.user  = item.user;
		wabeat.len   = item.len;
		wabeat.burst = item.burst;
		wabeat.qos   = item.qos;
		wabeat.prot  = item.prot;
		wabeat.lock  = item.lock;
		wabeat.cache = item.cache;
		wabeat.region= item.region;
		cfg.driveWA(wabeat);
	end
endtask // }

task rh_axi4mst_drv::__driveSeqitems( ); // {
	`uvm_info(get_type_name(),"__drvieSeqitems start ...",UVM_HIGH)
	fork
		__raiseWAChnl();
		__raiseWDChnl();
		__raiseRAChnl();
		__raiseDriveWDBeats();
	join
endtask // }

task rh_axi4mst_drv::__getSeqitems(); // {
	`uvm_info(get_type_name(),"__getSeqitems start ...",UVM_HIGH)
	forever begin
		seq_item_port.get_next_item(req);
		`uvm_info(get_type_name(),$sformatf("driver get trans:\n%s",req.sprint()),UVM_HIGH)
		case (req.t)
			rhaxi4_write_req: begin
				waQue.push_back(req);
				wdQue.push_back(req);
			end
			rhaxi4_read_req: begin
				raQue.push_back(req);
			end
			default: begin
				`uvm_error("TRE",$sformatf("unsupported trans type: %s",req.t))
			end
		endcase
		if (cfg.respEn) begin
			__getResponse(); // TODO
			seq_item_port.item_done(rsp);
		end else begin
			seq_item_port.item_done();
		end
	end
endtask // }

// driver component built up.
//
function void rh_axi4mst_drv::build_phase(uvm_phase phase); // {
	super.build_phase(phase);
    respI  = new("respI",this);
endfunction // }

function void rh_axi4mst_drv::connect_phase(uvm_phase phase); // {
	super.connect_phase(phase);
endfunction // }



function void rh_axi4mst_drv::write_resp(RSP tr); // {
    // bresp or rresp
    if (cfg.respEn) respQue.push_back(tr);
endfunction // }


task rh_axi4mst_drv::__mainProcess(); // {
	`uvm_info(get_type_name(),"__mainProcess start ...",UVM_HIGH)
	__initMasterChannels();
	fork
		__getSeqitems();
		__driveSeqitems();
	join
endtask // }


`endif
