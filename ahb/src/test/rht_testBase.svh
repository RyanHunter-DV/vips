`ifndef rht_testBase__svh
`define rht_testBase__svh

class rht_testBase extends uvm_test; // {

	parameter masterNum = 4;
	parameter slaveNum  = 16;

	rh_ahbVip mst[masterNum];
	rh_ahbVip slv[slaveNum];


	function new(string name="rht_testBase",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass // }

function void rht_testBase::build_phase(uvm_phase phase); // {
	super.build_phase(phase);

	foreach (mst[i]) begin // {
		mst[i] = rh_ahbVip::type_id::create($sformatf("mst[%0d]",i),this);
	end // }
	foreach (slv[i]) begin // {
		slv[i] = rh_ahbVip::type_id::create($sformatf("slv[%0d]",i),this);
	end // }

	// set common master configs
	foreach (mst[i]) begin // {
		if (mst[i].configVip(
				AHB_MST,
				$sformatf("tb.mstIf[%0d]",i),
			)
		) begin // {
			`uvm_fatal("CFGF",$sformatf("config failed of mst[%0d]",i))
		end // }
	end // }
endfunction // }

function void rht_testBase::connect_phase(uvm_phase phase); // {
	super.connect_phase(phase);

endfunction // }


`endif
