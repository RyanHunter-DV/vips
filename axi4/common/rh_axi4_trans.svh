`ifndef rh_axi4_trans__svh
`define rh_axi4_trans__svh

class rh_axi4_trans extends uvm_sequence_item; // {

	rh_axi4_trans_e t;
	realtime beginTime,endTime;
	local bit[1:0] timeRecorded;
	uint32_t id,len,size;
	bit[63:0] addr;
	rh_axi4_burst_e burst;
	bit[63:0] user;
	rand bit lock;
	rand bit[3:0] region;
	rand bit[3:0] cache;
	rand bit[7:0] prot;
	rand bit[3:0] qos;


	bit[7:0] data[];
	bit strobe[];
	uint32_t dsize;


	rand bit[31:0] wa2wdDelay, wdBeatsDelay, processDelay; // TODO


	`uvm_object_utils_begin(rh_axi4_trans)
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



`endif
