// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb_q3;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a [0:3];
reg  [bw-1:0] b [0:3];
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec;
integer w_dec;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
	input integer activation;
	begin
		x_bin = activation;
	end

endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input unsigned [bw-1:0] a0, a1,a2, a3;
  input signed [bw-1:0] b0, b1, b2, b3;
  input signed [psum_bw-1:0] prev_sum;
  begin
	  mac_predicted = prev_sum + (b0 * $signed({1'b0, a0})) + (b1 * $signed({1'b0, a1})) + (b2 * $signed({1'b0, a2})) + (b3 * $signed({1'b0, a3}));

end
endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a0(a[0]), 
        .a1(a[1]), 
        .a2(a[2]), 
        .a3(a[3]), 
        .b0(b[0]),
        .b1(b[1]),
        .b2(b[2]),
        .b3(b[3]),
        .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb_q3.vcd");
  $dumpvars(0,mac_tb_q3);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  // Data length is 20 in the data files, send in batch of 4

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     for (u = 0; u < 4; u++) begin	
     	w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     	x_scan_file = $fscanf(x_file, "%d\n", x_dec);
	a[u] = x_bin(x_dec); // unsigned number
     	b[u] = w_bin(w_dec); // signed number
     end

     c = expected_out;
     expected_out = mac_predicted(a[0], a[1], a[2], a[3], b[0], b[1], b[2], b[3], c);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




