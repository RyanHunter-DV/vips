`ifndef rhGpvDataObj__svh
`define rhGpvDataObj__svh
class Position extends uvm_object;
	int startPosition[$];
	int endPosition[$];

	function new(string name="Position");super.new(name);endfunction
	function void spos(int val);startPosition.push_back(val);endfunction
	function void epos(int val);endPosition.push_back(val);endfunction
endclass
class RhGpvDataObj extends uvm_object;

	Position pos[$];
	int clockIndex;
	`uvm_object_utils_begin(RhGpvDataObj)
	`uvm_object_utils_end

	function new(string name="RhGpvDataObj");
		super.new(name);
	endfunction

	extern function void setDrivePosAndValue(bitVector_t mask,logicVector_t vector);
endclass


function void RhGpvDataObj::setDrivePosAndValue(bitVector_t mask,logicVector_t vector);
	Position p=new("pos");
	bit start = 0;
	for (int idx=0;idx<`RHGPV_MAX_VECTOR_WIDTH;idx++) begin
		if (!start) if (mask[idx]==1'b1) begin start=1;p.spos(idx); end
		else if (mask[idx]==1'b0) begin start=0;p.epos(idx); end
		if (idx==`RHGPV_MAX_VECTOR_WIDTH-1 && start) begin
			start=0;
			p.epos(idx);
		end
	end
	pos.push_back(p);
endfunction

`endif