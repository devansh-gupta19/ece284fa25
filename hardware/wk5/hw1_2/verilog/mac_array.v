// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  reg [3:0] cnt;
  wire [(row+1)*psum_bw*col-1:0]psum_temp;
  reg [(row*2)-1:0] inst_temp;

  assign psum_temp[psum_bw*col-1:0] = in_n;

  genvar i;
  for (i=1; i < row+1 ; i=i+1) begin : row_iterate
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
      .clk(clk),
      .out_s(psum_temp[psum_bw*col*(i+1)-1 : psum_bw*col*i]),
      .in_w(in_w[(i*bw)-1:(i-1)*bw]),
      .in_n(psum_temp[psum_bw*col*i-1 : psum_bw*col*(i-1)]),
      .valid(valid),
      .inst_w(inst_temp[2*i-1:2*(i-1)]),
      .reset(reset)
      );
  end

  integer r;
  always @ (posedge clk) begin
	// inst_w flows to row0 to row7
	if (reset) begin
		cnt <= 1;
		inst_temp <= 0;
	end
	else begin
		// Add new instruction in the lower 2 bits and pass
		// instructions from previous row to the next one
		inst_temp <= {inst_temp[2*row-3:0], inst_w};
	end
  end
endmodule
