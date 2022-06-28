`ifndef rh_axi4_vip_config__svh
`define rh_axi4_vip_config__svh

class rh_axi4_vip_config#(`RH_AXI4_IF_PARAM_DECL) extends rh_axi4_vip_configBase; // {

    virtual rh_axi4_if#(`RH_AXI4_IF_PARAM_MAP) vif;

	local uint32_t __wdbeatDelayMin,__wdbeatDelayMax;
	local uint32_t __rdbeatDelayMin,__rdbeatDelayMax;

    `uvm_object_utils_begin(rh_axi4_vip_config#(AW,DW,IW,UW))
    `uvm_object_utils_end

    function new(string name="rh_axi4_vip_config");
        super.new(name);
    endfunction

    virtual function void getInterface(string p);
        if (!uvm_config_db#(virtual rh_axi4_if#(`RH_AXI4_IF_PARAM_MAP))::get(null,p,"rh_axi4_if",vif))
			`uvm_fatal("NOIF",$sformatf("cannot get interface: %s",p))

    endfunction

	extern task waitResetSignalChange(output logic v);
	extern task initWA( );
	extern task initWD( );
	extern task initRA( );
	extern task driveWA(ref rh_axi4_achnl_t wa);
	extern task driveRA(ref rh_axi4_achnl_t ra);
	extern task driveWDBeat(ref rh_axi4_dchnl_t wd);
	extern virtual task sync(input uint32_t c);
	extern virtual function uint32_t genBeatDelay(rh_axi4_device_t dev);
    // TODO
endclass // }

function uint32_t rh_axi4_vip_config::genBeatDelay(rh_axi4_device_t dev);
	case (dev)
		axi4_master:
			return $urandom_range(__wdbeatDelayMin,__wdbeatDelayMax);
		axi4_slave:
			return $urandom_range(__rdbeatDelayMin,__rdbeatDelayMax);
	endcase
endfunction

task rh_axi4_vip_config::sync(input uint32_t c); // {
	vif.sync(c);
endtask // }

task rh_axi4_vip_config::driveWDBeat(ref rh_axi4_dchnl_t wd); // {
	// PLACEHOLDER, auto generated task, add content here
	vif.driveMasterWDBeat(wd);
endtask // }

task rh_axi4_vip_config::driveWA(ref rh_axi4_achnl_t wa); // {
	`uvm_info(get_type_name(),"driving wa channel:",UVM_HIGH)
	vif.driveMasterWA(wa);
endtask // }

task rh_axi4_vip_config::driveRA(ref rh_axi4_achnl_t ra); // {
	vif.driveMasterRA(ra);
endtask // }

task rh_axi4_vip_config::initRA( ); // {
	// PLACEHOLDER, auto generated task, add content here
	if (is_master==axi4_master)
		vif.initRA("axi4_master");
	else
		vif.initRA("axi4_slave");
endtask // }

task rh_axi4_vip_config::initWD( ); // {
	// PLACEHOLDER, auto generated task, add content here
	if (is_master==axi4_master)
		vif.initWD("axi4_master");
	else
		vif.initWD("axi4_slave");
endtask // }

task rh_axi4_vip_config::initWA( ); // {
	// PLACEHOLDER, auto generated task, add content here
	if (is_master==axi4_master)
		vif.initWA("axi4_master");
	else
		vif.initWA("axi4_slave");
endtask // }

task rh_axi4_vip_config::waitResetSignalChange(output logic v); // {
	// PLACEHOLDER, auto generated task, add content here
	@(vif.ARESETN);
	v = vif.ARESETN;
endtask // }



`endif
