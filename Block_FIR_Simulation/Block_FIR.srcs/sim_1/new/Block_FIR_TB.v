`timescale 1ns / 1ps

module Block_FIR_TB;
    reg  clk = 1'b0;
    reg  [7:0]sw = 8'd0;
    wire [7:0]JA;
    
    Block_FIR_Top uut(.clk(clk), .sw(sw), .JA(JA));
    
    initial begin
        #50000 sw = 8'd1;
    end
    
    always #5 clk = ~clk;   
endmodule
