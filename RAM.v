module RAM(din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input [9:0]din;
input clk,rst_n,rx_valid;
output reg [ADDR_SIZE-1:0]dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0]mem[MEM_DEPTH-1:0];
reg [ADDR_SIZE-1:0] write_address,read_address;
always@(posedge clk)begin
if(~rst_n)begin
dout <= 0;
tx_valid <= 0;
write_address <= 0 ;
read_address <= 0 ;
end
else begin
if((din[9:8]==2'b00)&&(rx_valid==1))begin
write_address <= din[7:0];
end
else if((din[9:8]==2'b01)&&(rx_valid==1))begin
mem[write_address] <= din[7:0];
end
else if((din[9:8]==2'b10)&&(rx_valid==1)) begin
read_address <= din[7:0];
end
else if((din[9:8]==2'b11)&&(rx_valid==1))begin
dout <= mem[read_address];
tx_valid <= 1;
end
end
end
endmodule 