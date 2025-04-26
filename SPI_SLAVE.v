module SPI_SLAVE (
    input MOSI ,
    input SS_n ,
    input clk , rst_n ,
    input tx_valid ,
    input [7:0] tx_data ,
    output reg MISO ,
    output reg [9:0] rx_data ,
    output reg rx_valid 
);
parameter IDLE      = 3'b000 ;
parameter WRITE     = 3'b001 ;
parameter CHK_CMD   = 3'b010 ;
parameter READ_ADD  = 3'b011 ;
parameter READ_DATA = 3'b100 ;

reg rd_add ;
reg [3:0] counter_1 ;
reg [2:0] counter_2 ;
reg [9:0] out_reg ;

reg [2:0] cs , ns ;

(* fsm_encoding = "gray" *)


always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE ;

    end    
    else begin
        cs <= ns ;
    end
end

always @(*) begin
    case (cs)
    IDLE : begin
         if (SS_n) ns = IDLE ;
         else ns = CHK_CMD ;
    end
    CHK_CMD : begin
        if (SS_n) ns = IDLE ;
        else if ((~SS_n)&&(MOSI)&&(~rd_add)) begin
            ns = READ_ADD ;
        end
        else if ((~SS_n)&&(MOSI)&&(rd_add)) begin
            ns = READ_DATA ;
        end
        else if ((~SS_n)&&(~MOSI)) begin
            ns = WRITE ;
        end
    end
    READ_ADD : begin
        if (SS_n) begin
            ns = IDLE ;
        end
        else ns = READ_ADD ;
    end
    READ_DATA : begin
        if (SS_n) begin 
            ns = IDLE ;
    end
        else ns = READ_DATA ;
    end

    WRITE :begin
        if (SS_n) ns = IDLE ;
        else ns = WRITE ;
    end
    default : ns = IDLE ;

    endcase  
    end

always @(posedge clk) begin
    if (~rst_n) begin
        rx_data <= 0 ;
        rd_add <= 0 ;
        rx_valid <= 0 ;
        counter_1 <= 9 ;
        counter_2 <= 7 ;
        out_reg <= 0 ;

    end
    else begin
    if (cs == IDLE) begin
        rx_valid <= 0 ;
        out_reg <= 0 ;
    end
    if ((cs == WRITE)) begin
      if ( (counter_1 >= 0)&&(~rx_valid)&&(counter_1!=4'b1111) ) begin
            out_reg[counter_1] <= MOSI ;
            counter_1 <= counter_1 - 1 ; 
        end
        else begin
            counter_1 <= 9 ;
            rx_valid  <= 1 ;
            rx_data   <= out_reg ;
        end  
    end
    if ((cs == READ_ADD)) begin
        rd_add = 1 ;
      if ( (counter_1 >= 0)&&(~rx_valid)&&(counter_1!=4'b1111) ) begin
            out_reg[counter_1] <= MOSI ;
            counter_1 <= counter_1 - 1 ; 
        end
        else begin
            counter_1 <= 9 ;
            rx_valid  <= 1 ;
            rx_data   <= out_reg ;
        end  
    end
    if (cs == READ_DATA) begin
        rd_add <= 0 ;
              if ( (counter_1 > 0)&&(~rx_valid)&&(counter_1!=4'b1111)  ) begin
            out_reg[counter_1] <= MOSI ;
            counter_1 <= counter_1 - 1 ; 
        end
        else begin
            counter_1 <= 9 ;
            rx_valid  <= 1 ;
            rx_data   <= out_reg ;
        end 
        if (tx_valid) begin
        if (counter_2 >=0 ) begin
        MISO  <= tx_data [counter_2] ;
        counter_2 <= counter_2 - 1 ;
        end
        else counter_2 <= 7 ;
    end 
    end

    
end
end
        
endmodule