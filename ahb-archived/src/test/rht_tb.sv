module rht_tb; // {

	parameter masterNum = 4;
	parameter slaveNum  = 16;

	rh_ahbIf mstIf[masterNum];
	rh_ahbIf slvIf[slaveNum];



	initial begin
		run_test();
	end

	initial begin // {
		foreach mstIf[i] begin
			uvm_config_db#(virtual rh_ahbIf)::set(
				null,
				"uvm_test_top",
				$sformatf("tb.mstIf[%0d]",i),
				mstIf[i]
			);
		end
		foreach slvIf[i] begin
			uvm_config_db#(virtual rh_ahbIf)::set(
				null,
				"uvm_test_top",
				$sformatf("tb.slvIf[%0d]",i),
				slvIf[i]
			);
		end
	end // }



endmodule // }
