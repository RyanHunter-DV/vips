`ifndef rhGpvIf__sv
`define rhGpvIf__sv

interface RhGpvIf();
	logic [`RHGPV_MAX_VECTOR_WIDTH-1:0] vector;
	logic [`RHGPV_MAX_CLOCK_WIDTH-1:0] clock;
	logic [`RHGPV_MAX_RESET_WIDTH-1:0] reset;


	function void driveVector(int spos,logic bits[]);
		int size = bits.size();
		for (int pos=spos;pos<spos+size;pos++) begin
			vector[pos] <= bits[pos-spos];
		end
	endfunction


endinterface