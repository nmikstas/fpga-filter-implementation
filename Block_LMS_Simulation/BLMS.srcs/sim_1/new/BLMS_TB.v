`timescale 1ns / 1ps

module BLMS_TB;
    reg  clk = 1'b0;
    reg  [7:0]sw = 8'd0;
    wire [7:0]JA;
    
    wire clk_50MHz;
    wire clk_25MHz;
    wire en;
            
    BLMS_Top uut(.clk(clk), .sw(sw), .JA(JA));
    
    assign clk_50MHz = uut.clk_50MHz;
    assign clk_25MHz = uut.clk_25MHz;
    assign en = uut.en;
    
    //Generate 100MHz clock.
    always #5 clk = ~clk;
    
    initial begin
        #50000 sw = 8'd1;
    end
endmodule
