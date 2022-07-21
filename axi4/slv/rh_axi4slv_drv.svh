`ifndef rh_axi4slv_drv__svh
`define rh_axi4slv_drv__svh

class rh_axi4slv_drv extends rh_axi4_driverBase; // {

	uvm_analysis_imp #(rh_axi4_trans,rh_axi4slv_drv) rspI;


	`uvm_component_utils_begin(rh_axi4slv_drv)
	`uvm_component_utils_end

	function new(string name="rh_axi4slv_drv",uvm_component parent=null);
		super.new(name,parent);
	endfunction


// public
	extern task __mainProcess( );
	extern function void write(rh_axi4_trans tr);

// private

	// stores bresp and rresp
	rh_axi4_trans __wrsps[$];
	rh_axi4_trans __rrsps[$];

	extern local task startAWChannel( );
	extern local task startWDChannel( );
	extern local task startARChannel( );
	extern local task startRDChannel( );
	extern local task startBChannel( );



endclass // }

function void rh_axi4slv_drv::write(rh_axi4_trans tr); // {
	// PLACEHOLDER, auto generated function, add content here
	case (tr.t)
		rhaxi4_write_rsp: begin
			__wrsps.push_back(tr);
		end
		rhaxi4_read_rsp: begin
			__rrsps.push_back(tr);
		end
		default:
			`uvm_error(get_type_name(),$sformatf("unsupported trans type:\n%s",tr.sprint()))
	endcase
endfunction // }

task rh_axi4slv_drv::startBChannel( ); // {
	forever begin
		rh_axi4_trans rsp;
		wait (__wrsps.size()>0);
		rsp = __wrsps.pop_front();
		cfg.sync(rsp.processDelay);
		cfg.driveBChannel(rsp);
	end
endtask // }

task rh_axi4slv_drv::startRDChannel( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		rh_axi4_trans rsp;
		wait(__rrsps.size()>0);
		rsp = __rrsps.pop_front();
		cfg.sync(rsp.processDelay);
		cfg.driveRDChannel(rsp);
	end
endtask // }

task rh_axi4slv_drv::startARChannel( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		cfg.drive("ARREADY",'h0);
		cfg.sync(cfg.getLowDuration("ARREADY");
		cfg.drive("ARREADY",'h1);
		cfg.sync(cfg.getHighDuration("ARREADY"));
	end
endtask // }

task rh_axi4slv_drv::startWDChannel( ); // {
	// PLACEHOLDER, auto generated task, add content here
	forever begin
		cfg.drive("WREADY",'h0);
		cfg.sync(cfg.getLowDuration("WREADY");
		cfg.drive("WREADY",'h1);
		cfg.sync(cfg.getHighDuration("WREADY"));
	end
endtask // }

task rh_axi4slv_drv::startAWChannel( ); // {
	forever begin
		cfg.drive("AWREADY",'h0);
		cfg.sync(cfg.getLowDuration("AWREADY"));
		cfg.drive("AWREADY",'h1);
		cfg.sync(cfg.getHighDuration("AWREADY"));
	end
endtask // }

task rh_axi4slv_drv::__mainProcess( ); // {
	// PLACEHOLDER, auto generated task, add content here
	fork
		startAWChannel();
		startWDChannel();
		startARChannel();
		startBChannel();
		startRDChannel();
	join
endtask // }

`endif
