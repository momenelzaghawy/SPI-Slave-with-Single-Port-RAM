module RAM_tb();
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
reg [9:0]din;
reg clk,rst_n,rx_valid;
wire [7:0]dout;
wire tx_valid;

RAM dut(.*);
initial begin
clk = 0;
forever 
#1 clk = ~clk;
end 

initial begin
rst_n = 0;
rx_valid = 1;
@(negedge clk);
rst_n = 1;
din = 10'b0011110011;
@(negedge clk);
din = 10'b0100110011;
@(negedge clk);
din = 10'b1011110011;
@(negedge clk);
din = 10'b1111110011;
@(negedge clk);
$stop;
end
endmodule 