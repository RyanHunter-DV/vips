`ifndef rh_axi4_vip_configBase__svh
`define rh_axi4_vip_configBase__svh

virtual class rh_axi4_vip_configBase extends uvm_object;

    uvm_active_passive_enum is_active;
    // string interface_path;
    rh_axi4_master_slave_enum is_master;
    bit respEn = 1'b0;


    function new(string name="rh_axi4_vip_configBase");
        super.new(name);
    endfunction

    pure virtual function void getInterface(string p);
	pure virtual task waitResetSignalChange(output logic v);

	pure virtual task initWA();
	pure virtual task initWD();
	pure virtual task initRA();

	pure virtual task driveWA(ref rh_axi4_achnl_t wa);
	pure virtual task driveRA(ref rh_axi4_achnl_t ra);
	pure virtual task driveWDBeat(ref rh_axi4_dchnl_t wd);


	// function to generate beate delay by <min> <max> value, according to 
	// device type, can drive master's wd beat delay or slave's rd beat delay
	pure virtual function uint32_t genBeatDelay(rh_axi4_device_t dev);
	pure virtual task sync(input uint32_t c);
endclass


`endif
