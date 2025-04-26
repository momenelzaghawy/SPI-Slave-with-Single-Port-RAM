module SPI_tb ();
    reg MOSI ;
    reg clk ;
    reg rst_n ; 
    reg SS_n ;
    wire MISO;
    SPI DUT (.*);

    initial begin
        $readmemh("mem.dat",DUT.M2.mem);
        clk=0;
        forever #1 clk=~clk;
    end 
    initial begin
    rst_n = 0 ;
    @ (negedge clk) ;
    rst_n = 1 ;
    // SEND WRITE ADDRESS (FF)
    SS_n = 0 ;
    @(negedge clk);
    MOSI = 0 ;
    @ (negedge clk) ;
    MOSI = 0 ;
    //
    @ (negedge clk) ;
    @ (negedge clk) ;
    repeat (8) begin
    MOSI = 1 ;
    @ (negedge clk) ;
    end
    //
    @ (negedge clk) ;

     SS_n = 1 ;
    repeat(2) @(negedge clk) ;
    // SEND WRITE DATA (RANDOMIZED)
    SS_n = 0 ;
    @(negedge clk);
    @(negedge clk);
    MOSI = 0 ;
    @ (negedge clk) ;
    MOSI = 1 ;
    @ (negedge clk) ;
    repeat (8) begin
        MOSI = $random ;
        @ (negedge clk) ;
    end
     SS_n = 1 ;
    @(negedge clk) ;
    // SEND READ ADDRESS (FF)
    SS_n = 0 ;
        @ (negedge clk) ;
    @ (negedge clk) ;
    MOSI = 1 ;
    @ (negedge clk) ;
    MOSI = 0 ;
    @ (negedge clk) ;
    //
    repeat (8) begin
    MOSI = 1 ;
    @ (negedge clk) ;
    end
    //
    repeat(2) @(negedge clk) ;
     SS_n = 1 ;
    repeat(2) @(negedge clk) ;
    //SEND READ DATA COMMAND 
    SS_n = 0 ;
    @ (negedge clk) ;
    MOSI = 1 ;
    @ (negedge clk) ;
    MOSI = 1 ;
    @ (negedge clk) ;
    repeat (8) begin
        MOSI = $random ;
        @ (negedge clk) ;
    end
    // WAIT to display on
     repeat(10)@(negedge clk) ;

     
$stop ;
end
    
endmodule