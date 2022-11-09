`ifndef rh_ahbMstSeqItem__svh
`define rh_ahbMstSeqItem__svh

class rh_ahbMstSeqItem extends uvm_sequence_item; // {

	rand int busyTransRateMin[];
	rand int busyTransRateMax[];
	constraint busyTransRateLimit_cst {
		solve incrSize before busyTransRateMin;
		solve incrSize before busyTransRateMax;
		if (burst==AHB_INCR) {
			busyTransRateMin.size() == incrSize;
			busyTransRateMax.size() == incrSize;
		} else if (burst==AHB_SINGLE) {
			busyTransRateMin.size()==0;
			busyTransRateMax.size()==0;
		} else if (burst==AHB_INCR4||burst==AHB_WRAP4) {
			busyTransRateMin.size()==4;
			busyTransRateMax.size()==4;
		} else if (burst==AHB_INCR8||burst==AHB_WRAP8) {
			busyTransRateMin.size()==8;
			busyTransRateMax.size()==8;
		} else if (burst==AHB_INCR16||burst==AHB_WRAP16) {
			busyTransRateMin.size()==16;
			busyTransRateMax.size()==16;
		} else {
			busyTransRateMin.size()==0;
			busyTransRateMax.size()==0;
		};
	};
	rand int busyTransRate[];
	constraint busyTransRate_cst {
		solve incrSize before busyTransRate;
		solve busyTransRateMin before busyTransRate;
		solve busyTransRateMax before busyTransRate;

		if (burst==AHB_INCR) {busyTransRate.size() == incrSize;}
		else if (burst==AHB_SINGLE) {busyTransRate.size()==0;}
		else if (burst==AHB_INCR4||burst==AHB_WRAP4) {busyTransRate.size()==4;}
		else if (burst==AHB_INCR8||burst==AHB_WRAP8) {busyTransRate.size()==8;}
		else if (burst==AHB_INCR16||burst==AHB_WRAP16) {busyTransRate.size()==16;}
		else {busyTransRate.size()==0;}

		foreach (busyTransRate[i]) {
			busyTransRate[i] inside {[busyTransRateMin[i]:busyTransRateMax]i]]};
		}
	};

	rand rh_ahbBurstType_t burst;
	rand int incrSize; // the htrans number when burst is INCR
	// constraints
	constraint incrSize_cst {
		solve burst before incrSize;
		if (burst==AHB_INCR) {incrSize inside {[1:32]};} else {incrSize==0;}
	};


	rand rh_ahbSizeType_t size; // indicates to hsize
	// constraints
	// TODO


	rand bit[127:0] startAddr;
	// constraints


	rand bit[7:0] dataBytes[$];
	// constraints
	constraint dataValue_cst {
		dataBytes.size() == dataSize;
		solve dataSize before dataBytes;
	};

	// dataSize depends on burst size and burst type
	//
	rand int dataSize;
	// constraints
	constraint dataSize_cst {

		solve burst before dataSize;
		solve size before dataSize;
	};



	// set this sequence item not to insert any busy trans
	// an API for users
	// this API should be set before randomization
	extern function void noBusyTrans();






	// this API should be set after randomization
	// set the busyTransRate min/max value manually of all positions
	extern function void setBusyTransRate(int min, int max, int i=-1);


endclass // }


`endif
