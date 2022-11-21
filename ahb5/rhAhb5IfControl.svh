`ifndef rhAhb5IfControl__svh
`define rhAhb5IfControl__svh

class RhAhb5IfControl #( AW=32,DW=32) extends RhAhb5IfControlBase;
	virtual RhAhb5If#(AW,DW) vif;
	`uvm_object_utils_begin(RhAhb5IfControl#(AW,DW))
	`uvm_object_utils_end
	extern virtual task driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
	extern virtual task driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern virtual task waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
	extern local task __waitHREADYSyncd__(bit val);
	extern local task __responseError__(output bit e);
	extern virtual task getResetChanged(output logic s);
	extern local function bit[AW-1:0] __calculateCurrentAddress__(RhAhb5TransBeat b);
	extern local function int __decodeHSizeToByte__(bit[2:0] hsize);
	extern function  new(string name="RhAhb5IfControl");
endclass
task RhAhb5IfControl::driveAddressPhase(RhAhb5TransBeat b, bit waitReady);
	bit[AW-1:0] addr = __calculateCurrentAddress__(b);
	vif.HADDR  <= addr;
	
	vif.HTRANS <= b.trans;
	if (b.trans==RHAHB5_NONSEQ) begin
		vif.HBURST <= b.burst;
		vif.HWRITE <= b.write;
		vif.HSIZE  <= b.size;
		vif.HPROT  <= b.prot;
		vif.HMASTLOCK <= b.lock;
		vif.HMASTER <= b.master;
		vif.HNONSEC <= b.nonsec;
		vif.HEXCL   <= b.excl;
	end
	if (waitReady) __waitHREADYSyncd__(1);
	else @(posedge vif.HCLK);
	
endtask
task RhAhb5IfControl::driveDataPhase(ref RhAhb5TransBeat b,output bit isError);
	vif.HWDATA <= b.data[DW-1:0];
	fork
		__waitHREADYSyncd__(1);
		__responseError__(isError);
	join_any
	disable fork;
endtask
task RhAhb5IfControl::waitDataPhase(ref RhAhb5TransBeat b,output bit isError);
	fork
		__waitHREADYSyncd__(1);
		__responseError__(isError);
	join_any
	disable fork;
endtask
task RhAhb5IfControl::__waitHREADYSyncd__(bit val);
	do
		@(posedge vif.HCLK);
	while (vif.HREADY !== val);
endtask
task RhAhb5IfControl::__responseError__(output bit e);
	do begin
		@(posedge vif.HCLK);
		e = vif.HRESP[0];
	end while (e==1'b0);
endtask
task RhAhb5IfControl::getResetChanged(output logic s);
endtask
function bit[AW-1:0] RhAhb5IfControl::__calculateCurrentAddress__(RhAhb5TransBeat b);
	bit[AW-1:0] addr;
	rhahb5_hburst_enum burst = rhahb5_hburst_enum'(b.burst);
	int byteSize = __decodeHSizeToByte__(b.size);
	addr = b.addr[AW-1:0] + byteSize*b.index;
	if (
		burst==RHAHB5_WRAP4 ||
		burst==RHAHB5_WRAP8 ||
		burst==RHAHB5_WRAP16
	) begin
		case(byteSize)
			1: addr=addr;
			2: addr[0]   = 'h0;
			4: addr[1:0] = 'h0;
			8: addr[2:0] = 'h0;
			16:addr[3:0] = 'h0;
			32:addr[4:0] = 'h0;
			64:addr[5:0] = 'h0;
			128:addr[6:0]= 'h0;
		endcase
	end
	return addr;
endfunction
function int RhAhb5IfControl::__decodeHSizeToByte__(bit[2:0] hsize);
	case (hsize)
		3'h0: return 1;
		3'h1: return 2;
		3'h2: return 4;
		3'h3: return 8;
		3'h4: return 16;
		3'h5: return 32;
		3'h6: return 64;
		3'h7: return 128;
	endcase
endfunction
function  RhAhb5IfControl::new(string name="RhAhb5IfControl");
	super.new(name);
endfunction

`endif
