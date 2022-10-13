`ifndef Axi4Interface__sv
`define Axi4Interface__sv

interface Axi4Interface; // {



	task driveAWChannel(Axi4ChannelInfo _i); // {
	endtask // }

	task driveWDChannel(Axi4ChannelInfo _i); // {
	endtask // }

	task driveARChannel(Axi4ChannelInfo _i); // {
	endtask // }

endinterface // }

`endif
