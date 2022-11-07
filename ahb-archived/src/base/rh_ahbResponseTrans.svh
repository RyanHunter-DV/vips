`ifndef rh_ahbResponseTrans__svh
`define rh_ahbResponseTrans__svh

class rh_ahbResponseTrans extends rh_ahbBaseTrans; // {

	typedef rh_ahbResponseTrans thisType;


	// this function will copy response only information from _rsp to this
	// object
	extern function void copyResponseInfo(thisType _rsp);

endclass // }


`endif
