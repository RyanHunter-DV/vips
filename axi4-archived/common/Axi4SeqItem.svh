`ifndef Axi4SeqItem__svh
`define Axi4SeqItem__svh

class Axi4SeqItem extends uvm_sequence_item; // {

	rand bit[`RH_AXI4_MAX_IW-1:0] id;
	rand bit[`RH_AXI4_MAX_UW-1:0] user;
	rand bit[`RH_AXI4_MAX_AW-1:0] address;
	rand bit[`RH_AXI4_MAX_DW-1:0] data[];
	rand bit[`RH_AXI4_MAX_SW-1:0] strobe[];
	rand bit lock;
	rand bit [7:0] len;
	rand bit [2:0] size; // TOOD, need enhance to enumerate type
	rand bit [3:0] region;
	rand bit [3:0] cache;
	rand bit [7:0] protect;
	rand bit [3:0] qos;
	rand Axi4BurstEnum burst;
	rand Axi4RespEnum  resp;
	Axi4SeqType t;
	rand bool rspEn;

	int delay;

	`uvm_object_utils_begin(Axi4SeqItem)
		// TODO
	`uvm_object_utils_end

	// record the start/end simtime of this transaction,
	// start time is the time that a valid signal raised on
	// interface while end time is the time that a complete signal
	// raised on interface. These two fields are for monitor. Which
	// is different from the transaction's begin_time/end_time in UVM.
	local time __start;
	local time __end;
	local bool started;

	constraint dataSize_cst {
		data.size() == len+1;
		solve len before data;
	};
	constraint strobeSize_cst {
		strobe.size() == len+1;
		solve len before strobe;
	};
	constraint len_cst {
		if (burst==Axi4Incr) {
			len inside {[0:8'hff]};
		} else {
			len inside {[0:4'hf]};
		};
		solve burst before len;
	};

	function new(string name="Axi4SeqItem");
		super.new(name);
		delay   = 100; // default value.
		started = false;
	endfunction


	extern function int processDelay(int max=-1);
	extern function void recordTime(time _t);
	extern function Axi4ChannelInfo convertItemToInfo();
	extern function void convertInfoToItem(Axi4ChannelInfo s);
endclass // }

function void Axi4SeqItem::convertInfoToItem(Axi4ChannelInfo s); // {
	this.id     = s.id;
	this.user   = s.user;
	this.address= s.address
	this.lock   = s.lock;
	this.cache  = s.cache;
	this.region = s.region;
	this.protect= s.protect;
	this.qos    = s.qos;
	this.burst  = s.burst;
	this.len    = s.len;
	this.size   = s.size;
	this.resp   = t.resp;
	if (s.data.size()) begin
		this.data  = s.data;
		this.strobe= s.strobe;
	end
	return;
endfunction // }

function Axi4ChannelInfo Axi4SeqItem::convertItemToInfo(); // {
	Axi4ChannelInfo t;
	t.id     = this.id;
	t.user   = this.user;
	t.address= this.address
	t.lock   = this.lock;
	t.cache  = this.cache;
	t.region = this.region;
	t.protect= this.protect;
	t.qos    = this.qos;
	t.burst  = this.burst;
	t.len    = this.len;
	t.size   = this.size;
	t.resp   = this.resp;
	if (this.data.size()) begin
		t.data  = this.data;
		t.strobe= this.strobe;
	end
	return t;
endfunction // }

function void Axi4SeqItem::recordTime(time _t); // {
	if (started) __end = _t;
	else begin
		__start = _t;
		started = true;
	end
endfunction // }

function int Axi4SeqItem::processDelay(int max=-1); // {
	int unsigned _d = 0;
	if (max >= 0) delay = max;
	std::randomize(_d) with {_d inside {[0:delay]}};
	return _d;
endfunction // }

`endif
