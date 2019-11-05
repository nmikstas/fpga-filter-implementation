`timescale 1ns / 1ps

module BLMS_TB;
    reg  clk = 1'b0;
    reg  [7:0]sw = 8'd0;
    wire [7:0]JA;
    
    wire clk_50MHz;
    wire clk_25MHz;
        
    wire signed [15:0]tone_and_noise;
    wire signed [15:0]fout;
    wire signed [15:0]dout0;
    wire signed [15:0]dout1;
    wire signed [15:0]dout2;
    wire signed [15:0]dout3;
    wire signed [15:0]blms_din0;
    wire signed [15:0]blms_din1;
    wire signed [15:0]blms_din2;
    wire signed [15:0]blms_din3;
    wire en;
            
    BLMS_Top uut(.clk(clk), .sw(sw), .JA(JA));
    
    assign clk_50MHz = uut.clk_50MHz;
    assign clk_25MHz = uut.clk_25MHz;
    
    assign tone_and_noise = uut.tone_and_noise;
    assign fout = uut.fout;
    assign dout0 = uut.dout0;
    assign dout1 = uut.dout1;
    assign dout2 = uut.dout2;
    assign dout3 = uut.dout3;
    assign blms_din0 = uut.blms_din0;
    assign blms_din1 = uut.blms_din1;
    assign blms_din2 = uut.blms_din2;
    assign blms_din3 = uut.blms_din3;
    assign en = uut.en;
    
    //Generate 100MHz clock.
    always #5 clk = ~clk;
    
    initial begin
        #500000 sw = 8'd1;
    end
endmodule
