`ifndef rh_axi4_trans__svh
`define rh_axi4_trans__svh

class rh_axi4_trans extends uvm_sequence_item; // {

	rhaxi4_trans_enum transType;
	realtime beginTime,endTime;
	local bit[1:0] timeRecorded;
	uint32_t id,len,size;
	bit[255:0] addr;
	rhaxi4_burst_enum burst;
	bit[63:0] user;

	// region is kind of a base address of one axi request, so that a real single slave can be
	// treated as multiple logical slaves through the region signal. Address range within 4KB
	// should has the same region signal.
	bit[3:0] region;

	// different code of the 4-bit cache has different meaning of a device type, details
	// shall refer to the AXI4 protocol.
	bit[3:0] cache;
	bit lock;

	bit [2:0] prot;
	bit [3:0] qos;

	bit[7:0] data[];
	bit strobe[];
	uint32_t dsize;

	// process delay, based on cycles
	uint32_t delay;



	`uvm_object_utils_begin(rh_axi4_trans)
		`uvm_field_enum(rhaxi4_trans_enum,transType,UVM_ALL_ON)
		`uvm_field_enum(rhaxi4_burst_enum,burst,UVM_ALL_ON)
		`uvm_field_real(beginTime,UVM_ALL_ON)
		`uvm_field_real(endTime,UVM_ALL_ON)
		`uvm_field_int(timeRecorded,UVM_ALL_ON)
		`uvm_field_int(id,UVM_ALL_ON)
		`uvm_field_int(len,UVM_ALL_ON)
		`uvm_field_int(size,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(user,UVM_ALL_ON)
		`uvm_field_int(region,UVM_ALL_ON)
		`uvm_field_int(cache,UVM_ALL_ON)
		`uvm_field_int(lock,UVM_ALL_ON)
		`uvm_field_int(prot,UVM_ALL_ON)
		`uvm_field_int(qos,UVM_ALL_ON)
		`uvm_field_int(dsize,UVM_ALL_ON)
		`uvm_field_int(delay,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="rh_axi4_trans");
		super.new(name);
		timeRecorded=2'b00;
	endfunction

	// APIs

	// record beginTime/endTime, first time recorded the beginTime, then record
	// endTime.
	extern function void recordTime(realtime t);

	// send, to send this trans through input port
	extern function void send(uvm_analysis_port#(rh_axi4_trans) p);

endclass // }

function void rh_axi4_trans::send(uvm_analysis_port#(rh_axi4_trans) p); // {
	p.write(this);
endfunction // }


function void rh_axi4_trans::recordTime(realtime t);
	if (timeRecorded[0]) begin
		endTime=t;
		timeRecorded[1]=1;
	end else begin
		beginTime=t;
		timeRecorded[0]=1;
	end
endfunction

class rh_axi4_resetTrans extends uvm_sequence_item; // {

	typedef enum logic {
		unknown  = 'bx,
		active   = 'b0,
		inactive = 'b1
	} reset_enum;

	reset_enum reset;
	realtime t;

	`uvm_object_utils_begin(rh_axi4_resetTrans)
		`uvm_field_enum(reset_enum,reset,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="rh_axi4_resetTrans");
		super.new(name);
	endfunction

	function void send(reset_enum r,realtime _t,uvm_analysis_port#(resetTr_t) p);
		reset=r;t=_t;
		p.write(this);
	endfunction


endclass // }

`endif
