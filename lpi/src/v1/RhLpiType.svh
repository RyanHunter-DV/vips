`ifndef RhLpiType__svh
`define RhLpiType__svh


typedef enum int {
	// bit[1] indicates the acitve/passive
	// bit[0] indicates the PowerControl/Device
	ActivePowerControl = 'b10,
	ActiveDevice       = 'b11,
	PassivePowerControl= 'b00,
	PassiveDevice      = 'b01
} RhQLpiMode;

typedef enum {
	QStopped,
	QExit,
	QRun,
	QRequest,
	QDenied,
	QContinue
} RhQLpiState;

typedef class RhQLpiStateTrans;
typedef RhQLpiStateTrans stateTrans_t;
typedef RhQLpiMode  mode_t;
typedef RhQLpiState state_t;

`endif