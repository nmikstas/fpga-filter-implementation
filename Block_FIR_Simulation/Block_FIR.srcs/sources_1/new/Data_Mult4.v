`timescale 1ns / 1ps

module Data_Mult4(
    input clk,
    input en,
    input [15:0]d0_in,
    input [15:0]d1_in,
    input [15:0]d2_in,
    input [15:0]d3_in,
    output reg [15:0]dout = 16'd0
    );
    
    reg [1:0]count = 2'd0;
        
    //Internal registers for holding data.
    reg [15:0]d0 = 16'd0;
    reg [15:0]d1 = 16'd0;
    reg [15:0]d2 = 16'd0;
    reg [15:0]d3 = 16'd0;
    
    always @(posedge clk) begin
        if(en) begin
            count <= count + 1'b1;
                
            if(count == 2'b00) begin
                dout <= d0;
            end
            else if(count == 2'b01) begin
                dout <= d1;  
            end
            else if(count == 2'b10) begin
                dout <= d2;
            end
            else begin
                d0 <= d0_in;
                d1 <= d1_in;
                d2 <= d2_in;
                d3 <= d3_in; 
                dout <= d3;      
            end
        end
    end
             
endmodule
