`ifndef RhQLpiIf__sv
`define RhQLpiIf__sv

interface RhQLpiIf(input logic clock, input logic resetn);

	logic QREQn;
	logic QACCEPTn;
	logic QDENY;
	logic QACTIVE;

endinterface

`endif