`timescale 1ns / 1ps

module Data_Div4(
    input clk,
    input en,
    input [15:0]din,
    output reg en_out = 1'b0,
    output reg [15:0]d0_out = 16'd0,
    output reg [15:0]d1_out = 16'd0,
    output reg [15:0]d2_out = 16'd0,
    output reg [15:0]d3_out = 16'd0
    );
    
    reg [1:0]count = 2'd0;
    
    //Internal registers for holding data.
    reg [15:0]d0 = 16'd0;
    reg [15:0]d1 = 16'd0;
    reg [15:0]d2 = 16'd0;
    
    always @(posedge clk) begin
        if(en) begin
            count <= count + 1'b1;
        
            if(count == 2'b00) begin
                d0 <= din;
                en_out <= 1'b0;
            end
            else if(count == 2'b01) begin
                d1 <= din;
                en_out <= 1'b0;
            end
            else if(count == 2'b10) begin
                d2 <= din;
                en_out <= 1'b0;
            end
            else begin
                d0_out <= d0;
                d1_out <= d1;
                d2_out <= d2;
                d3_out <= din;
                en_out <= 1'b1;
            end
        end
    end
endmodule
