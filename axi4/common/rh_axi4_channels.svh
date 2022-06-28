`ifndef rh_axi4_channels__svh
`define rh_axi4_channels__svh

class rh_axi4_wchannel#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_object; // {

    rh_axi4_vip_configBase cfg;
	rh_axi4_dbeat_t beats[$];
	bit outstanding[uint32_t];

    `uvm_object_utils(rh_axi4_wchannel#(REQ,RSP))

    function new(string name="rh_axi4_wchannel");
        super.new(name);
    endfunction

	// drive transaction of wchannel
	// 1.send wa request and wait for ready
	// 2.start wd driver with join_none, channel will add an arbitor every time the multiple
	// processes starting to drive data on interface
    extern task drive (ref REQ tr);
	extern task init();
	extern task WDArbitor();

	extern function void _copyWAFromReq(ref REQ tr,ref rh_axi4_ainfo_t wa);
	extern function void _copyWDFromReq(ref REQ tr,ref rh_axi4_dinfo_t wd);
endclass // }

function void rh_axi4_wchannel::_copyWDFromReq(ref REQ tr,ref rh_axi4_dinfo_t wd); // {
	wd.size   = tr.dsize;
	wd.data   = tr.data;
	wd.strobe = tr.strobe;
	return;
endfunction // }

function void rh_axi4_wchannel::_copyWAFromReq(ref REQ tr,ref rh_axi4_ainfo_t wa); // {
	// PLACEHOLDER, auto generated function, add content here
	int burst_i = int'(tr.burst);
	wa.addr   = tr.addr;
	wa.id     = tr.id;
	wa.size   = tr.size;
	wa.len    = tr.len;
	wa.burst  = burst_i[1:0];
	wa.lock   = tr.lock;
	wa.qos    = tr.qos;
	wa.prot   = tr.prot;
	wa.cache  = tr.cache;
	wa.user   = tr.user;
	wa.region = tr.region;
endfunction // }

class rh_axi4_rchannel#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_object; // {

    rh_axi4_vip_configBase cfg;

    `uvm_object_utils(rh_axi4_rchannel#(REQ,RSP))
    function new(string name="rh_axi4_rchannel");
        super.new(name);
    endfunction

    // channel drive api, to drive a read request according to coming REQ trans.
    extern task drive (ref REQ tr);
	extern task init();
endclass // }

task rh_axi4_wchannel::init();
	cfg.initWA();
	cfg.initWD();
endtask


task rh_axi4_wchannel::drive(ref REQ tr); // {
    // TODO
	rh_axi4_ainfo_t wa;
    `placeholder("calling drive, will drive interface signals")
	`uvm_info(get_type_name(),$sformatf("drive write seq: \n%s",tr.sprint()),UVM_HIGH)
	_copyWAFromReq(tr,wa);
	cfg.driveWA(wa);
	// TODO, cfg.waitWAReady();
	fork _startWDChannel(tr); join_none
endtask // }
task rh_axi4_wchannel::_startWDChannel(ref REQ tr);
	// TODO
	rh_axi4_dbeat_t beat[$];
	_waitWDChannel(tr.id);

	tr.size
	// MARKER

	foreach (beat[i]) begin
		cfg.vif.sync(tr.genBeatDelay());
		_pushBeatToQueue(beat[i]);
	end
endtask

task rh_axi4_rchannel::drive(ref REQ tr); // {
    // TODO
    `placeholder("calling drive, will drive interface signals")
	`uvm_info(get_type_name(),$sformatf("drive read seq: \n%s",tr.sprint()),UVM_HIGH)
endtask // }
task rh_axi4_rchannel::init(); // {
	cfg.initRA();
endtask // }


`endif
