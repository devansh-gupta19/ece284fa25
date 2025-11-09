// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;


// Your code goes here
// res_temp stores multiplication result for signed and magnitude format
wire [bw-1:0] res_temp;
assign res_temp[bw-2:0] = a_q[bw-2:0] * b_q[bw-2:0];
assign res_temp[bw-1] = a_q[bw-1] ^ b_q[bw-1];

always @(posedge clk) begin
	if (reset) begin
		psum_q <= 0;
	end
	else begin
		a_q <= A;
		b_q <= B;
		if (format == 0) begin
			if (acc) begin
				psum_q <= psum_q + (a_q * b_q);
			end
		end
		else begin
			if (acc) begin
				if (psum_q[psum_bw-1] == res_temp[bw-1]) begin
					psum_q[psum_bw-2:0] <= psum_q[psum_bw-2:0] + res_temp[bw-2:0];
				end
				else begin
					if (psum_q[psum_bw-2:0] > res_temp[bw-2:0]) begin
						psum_q[psum_bw-2:0] <= psum_q[psum_bw-2:0] - res_temp[bw-2:0];
					end
					else begin
						psum_q[psum_bw-2:0] = res_temp[bw-2:0] - psum_q[psum_bw-2:0];
						psum_q[psum_bw-1] = res_temp[bw-1];
					end
				end
			end
		end
	end
end

endmodule
