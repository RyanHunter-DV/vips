module DUT(
	input clk_i,rstn_i,
	input valid_i,
	input[31:0] data_i,
	output ack_o
);

	reg ack_r;
	reg [3:0] counter_r;
	reg [3:0] counter2_r;

	assign ack_o = ack_r;

	always @(posedge clk_i or negedge rstn_i) begin
		if (~rstn_i) begin
			ack_r <= 1'b0;
			counter_r <= 4'h0;
			counter2_r<= 4'h0;
		end else begin
			if (valid_i) begin
				if (counter_r==counter2_r) begin
					counter2_r <= counter2_r + 1'b1;
					ack_r <= 1'b1;
				end else begin
					counter_r <= counter_r + 1'b1;
				end
			end
			if (ack_r == 1'b1) begin
				counter_r <= 4'h0;
				ack_r <= 1'b0;
			end
		end
	end


endmodule
