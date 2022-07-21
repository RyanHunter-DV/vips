`ifndef rh_axi4_vip_configBase__svh
`define rh_axi4_vip_configBase__svh

virtual class rh_axi4_vip_configBase extends uvm_object;

	rh_axi4_device_enum dev;

    bit respEn = 1'b0;


    function new(string name="rh_axi4_vip_configBase");
        super.new(name);
    endfunction

	// return 1 when dev:
	// is *active*
	extern function bit isActive( );
	// return if device is a master
	extern function bit isMaster( );
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


	// configs for slave 
	pure virtual task drive(string sig,logic [1023:0] val);
	pure virtual function uint32_t getLowDuration(string sig);
	pure virtual function uint32_t getHighDuration(string sig);

	pure virtual task driveBChannel(rh_axi4_trans tr);

endclass

function bit rh_axi4_vip_configBase::isMaster( ); // {
	// PLACEHOLDER, auto generated function, add content here
	if (dev==rh_axi4_active_master || dev==rh_axi4_passive_master)
		return 1;
	else return 0;
endfunction // }

function bit rh_axi4_vip_configBase::isActive( ); // {
	// PLACEHOLDER, auto generated function, add content here
	if (dev==rh_axi4_active_master || dev==rh_axi4_active_slave)
		return 1;
	else return 0;
endfunction // }


`endif
