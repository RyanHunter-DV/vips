`ifndef rhGpvIfCtrl__svh
`define rhGpvIfCtrl__svh

class RhGpvIfCtrl;

	virtual RhGpvIf vif;
	string name;

	function new(string n="RhGpvIfCtrl");
		name = n;
	endfunction


endclass


`endif
