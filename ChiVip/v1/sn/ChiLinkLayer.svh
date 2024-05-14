`ifndef ChiLinkLayer__svh
`define ChiLinkLayer__svh

//  Class: ChiLinkLayer
// object to translate between the chi packet information and signal operations.
// supports packet -> signal and signal -> packet.
// **feature of link layer**:
// 1. support multiple standalone channels, such as multiple req channel or data channel etc.
// 2. power control activation, controling the linkactive status.
// 3. credit control, for a slave, shall be able to send credit availability to transmitter.
class ChiLinkLayer extends uvm_object;
	process p; // main process id

	`uvm_object_utils(ChiLinkLayer);

	//  Group: Variables


	//  Group: Constraints


	//  Group: Functions

	//  Constructor: new
	function new(string name = "ChiLinkLayer");
		super.new(name);
	endfunction: new
	
	// start, description
	extern task start;
	// detectReset, every time detect reset active, to kill the main process.
	extern local task detectReset;
	// main, once start, need first init all outputs, and wait reset into inactive state
	extern local task main;
endclass: ChiLinkLayer

task ChiLinkLayer::main; // ##{{{
	//TODO
	//1.drive to init value
	//2.wait reset inactive
	//3.do main actions: power control, credit control etc.
endtask // ##}}}

task ChiLinkLayer::detectReset; // ##{{{
	//TODO
endtask // ##}}}

task ChiLinkLayer::start; // ##{{{
	//TODO
	fork
		detectReset;
		begin
			p=process::self();
			main;
		end
	join
endtask // ##}}}

`endif