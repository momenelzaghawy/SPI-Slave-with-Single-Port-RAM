module SPI (
    input MOSI ,
    input clk ,
    input rst_n , 
    input SS_n ,
    output MISO 
);
wire tx_valid , rx_valid ;
wire [7:0] tx_data ;
wire [9:0] rx_data ;
SPI_SLAVE M1 (.MOSI(MOSI),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.MISO(MISO),.tx_valid(tx_valid),.tx_data(tx_data),.rx_valid(rx_valid),.rx_data(rx_data));
RAM M2 (.clk(clk),.rst_n(rst_n),.din(rx_data),.rx_valid(rx_valid),.tx_valid(tx_valid),.dout(tx_data));

endmodule