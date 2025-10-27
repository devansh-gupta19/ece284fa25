// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [bw-1:0] a;
input signed [bw-1:0] b;
// c stores previous sum
input signed [psum_bw-1:0] c;

output signed [psum_bw-1:0] out;

assign out = c + (b * $signed({1'b0, a}));

endmodule
