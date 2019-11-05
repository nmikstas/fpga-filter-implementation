`timescale 1ns / 1ps

module BLMS_ECU(
    input clk,     //Filter clock.
    input r_en,    //Weight adjust registers enable.
    
    input signed [15:0]din0, //
    input signed [15:0]din1, //Desired inputs.
    input signed [15:0]din2, //
    input signed [15:0]din3, //
    
    input signed [15:0]yin0, //
    input signed [15:0]yin1, //From filter output.
    input signed [15:0]yin2, //
    input signed [15:0]yin3, //
    
    output reg signed [15:0]r0 = 16'd0, //
    output reg signed [15:0]r1 = 16'd0, //Stepped error output.
    output reg signed [15:0]r2 = 16'd0, //
    output reg signed [15:0]r3 = 16'd0  //
    );
    
    //Adder outputs.
    wire signed [15:0]add_out0;
    wire signed [15:0]add_out1;
    wire signed [15:0]add_out2;
    wire signed [15:0]add_out3;
    
    //Mu outputs.
    wire signed [31:0]mu0;
    wire signed [31:0]mu1;
    wire signed [31:0]mu2;
    wire signed [31:0]mu3;
    
    //Assign outputs.
    assign add_out0 = din0 - yin0;
    assign add_out1 = din1 - yin1;
    assign add_out2 = din2 - yin2;
    assign add_out3 = din3 - yin3;
        
    //Multiply error by mu (hard coded).
    assign mu0 = add_out0 << 15;
    assign mu1 = add_out1 << 15;
    assign mu2 = add_out2 << 15;
    assign mu3 = add_out3 << 15;
    
    //Update delay registers.
    always @(posedge clk) begin
        if(r_en) begin
            r0 <= mu0[31:16];
            r1 <= mu1[31:16];
            r2 <= mu2[31:16];
            r3 <= mu3[31:16];
        end
    end
endmodule
