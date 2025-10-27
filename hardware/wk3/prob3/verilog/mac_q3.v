// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a0, a1, a2 ,a3, b0, b1, b2, b3, c);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [bw-1:0] a0, a1, a2, a3;
input signed [bw-1:0] b0, b1, b2, b3;
// c stores previous sum
input signed [psum_bw-1:0] c;

output signed [psum_bw-1:0] out;

wire signed [psum_bw-1:0] mul_out [0:1];

assign mul_out[0] = (b0 * $signed({1'b0, a0})) + (b1 * $signed({1'b0, a1}));
assign mul_out[1] = (b2 * $signed({1'b0, a2})) + (b3 * $signed({1'b0, a3}));

assign out = c + (mul_out[0] + mul_out[1]);

endmodule
