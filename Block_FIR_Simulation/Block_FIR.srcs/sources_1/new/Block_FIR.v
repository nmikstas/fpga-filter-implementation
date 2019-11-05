`timescale 1ns / 1ps

module Block_FIR(
    input  clk,
    input  en,
    input  signed [15:0]x0_in,
    input  signed [15:0]x1_in,
    input  signed [15:0]x2_in,
    input  signed [15:0]x3_in,
    output reg signed [15:0]x0_out = 16'd0,
    output reg signed [15:0]x1_out = 16'd0,
    output reg signed [15:0]x2_out = 16'd0,
    output reg signed [15:0]x3_out = 16'd0,
    output signed [15:0]u0,
    output signed [15:0]u1,
    output signed [15:0]u2,
    output signed [15:0]u3
    );
    
    //Filter coefficients.
    parameter b0 = 16'd1;
    parameter b1 = 16'd1;
    parameter b2 = 16'd1;
    parameter b3 = 16'd1;
    
    //Coefficient registers.
    reg signed [15:0]_b0 = b0;
    reg signed [15:0]_b1 = b1;
    reg signed [15:0]_b2 = b2;
    reg signed [15:0]_b3 = b3;
    
    //Register unit.
    always @(posedge clk) begin
        if(en) begin
            x0_out <= x0_in;
            x1_out <= x1_in;
            x2_out <= x2_in;
            x3_out <= x3_in;
        end
    end
    
    /******************************IPC1******************************/   
    //Multiplier outputs.
    wire signed [31:0]IPC1_mult0;
    wire signed [31:0]IPC1_mult1;
    wire signed [31:0]IPC1_mult2;
    wire signed [31:0]IPC1_mult3;
    
    //Adder outputs.
    wire signed [31:0]IPC1_add0;
    wire signed [31:0]IPC1_add1;
    wire signed [31:0]IPC1_out;
    
    //Multiply inputs with coefficients.
    assign IPC1_mult0  = x3_in * _b0;
    assign IPC1_mult1  = x2_in * _b1;
    assign IPC1_mult2  = x1_in * _b2;
    assign IPC1_mult3  = x0_in * _b3;
    
    //Add multiplied values together.
    assign IPC1_add0 = IPC1_mult0 + IPC1_mult1;
    assign IPC1_add1 = IPC1_mult2 + IPC1_mult3;
    assign IPC1_out  = IPC1_add0  + IPC1_add1;
    
    //Assign output.
    assign u3 = IPC1_out[31:16];
    
    /******************************IPC2******************************/   
    //Multiplier outputs.
    wire signed [31:0]IPC2_mult0;
    wire signed [31:0]IPC2_mult1;
    wire signed [31:0]IPC2_mult2;
    wire signed [31:0]IPC2_mult3;
    
    //Adder outputs.
    wire signed [31:0]IPC2_add0;
    wire signed [31:0]IPC2_add1;
    wire signed [31:0]IPC2_out;
    
    //Multiply inputs with coefficients.
    assign IPC2_mult0  = x2_in *  _b0;
    assign IPC2_mult1  = x1_in *  _b1;
    assign IPC2_mult2  = x0_in *  _b2;
    assign IPC2_mult3  = x3_out * _b3;
    
    //Add multiplied values together.
    assign IPC2_add0 = IPC2_mult0 + IPC2_mult1;
    assign IPC2_add1 = IPC2_mult2 + IPC2_mult3;
    assign IPC2_out  = IPC2_add0  + IPC2_add1;
    
    //Assign output.
    assign u2 = IPC2_out[31:16];
    
    /******************************IPC3******************************/   
    //Multiplier outputs.
    wire signed [31:0]IPC3_mult0;
    wire signed [31:0]IPC3_mult1;
    wire signed [31:0]IPC3_mult2;
    wire signed [31:0]IPC3_mult3;
    
    //Adder outputs.
    wire signed [31:0]IPC3_add0;
    wire signed [31:0]IPC3_add1;
    wire signed [31:0]IPC3_out;
    
    //Multiply inputs with coefficients.
    assign IPC3_mult0  = x1_in *  _b0;
    assign IPC3_mult1  = x0_in *  _b1;
    assign IPC3_mult2  = x3_out * _b2;
    assign IPC3_mult3  = x2_out * _b3;
    
    //Add multiplied values together.
    assign IPC3_add0 = IPC3_mult0 + IPC3_mult1;
    assign IPC3_add1 = IPC3_mult2 + IPC3_mult3;
    assign IPC3_out  = IPC3_add0  + IPC3_add1;
    
    //Assign output.
    assign u1 = IPC3_out[31:16];
    
    /******************************IPC4******************************/   
    //Multiplier outputs.
    wire signed [31:0]IPC4_mult0;
    wire signed [31:0]IPC4_mult1;
    wire signed [31:0]IPC4_mult2;
    wire signed [31:0]IPC4_mult3;
    
    //Adder outputs.
    wire signed [31:0]IPC4_add0;
    wire signed [31:0]IPC4_add1;
    wire signed [31:0]IPC4_out;
    
    //Multiply inputs with coefficients.
    assign IPC4_mult0  = x0_in *  _b0;
    assign IPC4_mult1  = x3_out * _b1;
    assign IPC4_mult2  = x2_out * _b2;
    assign IPC4_mult3  = x1_out * _b3;
    
    //Add multiplied values together.
    assign IPC4_add0 = IPC4_mult0 + IPC4_mult1;
    assign IPC4_add1 = IPC4_mult2 + IPC4_mult3;
    assign IPC4_out  = IPC4_add0  + IPC4_add1;
    
    //Assign output.
    assign u0 = IPC4_out[31:16];
endmodule
