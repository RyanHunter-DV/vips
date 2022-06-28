`ifndef rh_axi4_trans__svh
`define rh_axi4_trans__svh

class rh_axi4_trans extends uvm_sequence_item; // {

	rh_axi4_trans_e t;
	realtime beginTime,endTime;
	local bit[1:0] timeRecorded;
	// len: number of beats, equals to AxLEN+1
	rand bit[`RH_AXI4_MAX_IW-1:0] id;
	rand bit[`RH_AXI4_MAX_AW-1:0] addr;
	rand bit[`RH_AXI4_MAX_UW-1:0] user;
	rand bit[`RH_AXI4_MAX_DW-1:0] data[];
	rand bit[`RH_AXI4_MAX_SW-1:0] strobe[];
	rand bit lock;
	rand bit[7:0] len;
	rand bit[2:0] size;
	rand bit[3:0] region;
	rand bit[3:0] cache;
	rand bit[7:0] prot;
	rand bit[3:0] qos;
	rand rh_axi4_burst_e burst;
	rand uint32_t processDelay;

	constraint len_cst {
		if (burst==rhaxi4_incr) {
			len inside {[0:8'hff]};
		} else {
			len inside {[0:4'hf]};
		}
		solve burst before len;
	};
	constraint dataSize_cst {
		data.size() == len;
		solve len before data;
	};
	constraint strobeSize_cst {
		strobe.size()==len;
		solve len before strobe;
	};
	constraint processDelay_cst {
		processDelay inside {[0:100]};
	};



	`uvm_object_utils_begin(rh_axi4_trans)
		`uvm_field_enum(rh_axi4_trans_e,t,UVM_ALL_ON)
		`uvm_field_enum(rh_axi4_burst_e,burst,UVM_ALL_ON)
		`uvm_field_int(id,UVM_ALL_ON)
		`uvm_field_int(len,UVM_ALL_ON)
		`uvm_field_int(size,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(user,UVM_ALL_ON)
		`uvm_field_int(lock,UVM_ALL_ON)
		`uvm_field_int(region,UVM_ALL_ON)
		`uvm_field_int(cache,UVM_ALL_ON)
		`uvm_field_int(prot,UVM_ALL_ON)
		`uvm_field_int(qos,UVM_ALL_ON)
		`uvm_field_sarray_int(data,UVM_ALL_ON)
		`uvm_field_sarray_int(strobe,UVM_ALL_ON)
		`uvm_field_real(beginTime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(endTime,UVM_ALL_ON|UVM_NOCOMPARE)
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

	// @RyanH // genBeatDelay, to generate a beat delay, this will be called multiple times because
	// @RyanH // one trans may contain multiple beats, the generated value is simply between
	// @RyanH // the *Min and *Max value
	// @RyanH extern function uint32_t genBeatDelay( );

	// getDelay("wa2wd")/getDelay("process")
	extern function uint32_t getDelay(string t);

endclass // }


function uint32_t rh_axi4_trans::getDelay(string t); // {
	// PLACEHOLDER, auto generated function, add content here
endfunction // }

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



`endif
