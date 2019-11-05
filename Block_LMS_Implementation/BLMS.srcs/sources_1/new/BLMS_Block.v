`timescale 1ns / 1ps

module BLMS_Block(
    input clk,      //Filter clock.
    input x_en,     //X registers enable.
    input w_en,     //Weight registers enable.
    input mux_sel,  //MUX selection input.
    input dmux_sel, //DMUX selection input.
    
    input signed [15:0]xin0, //
    input signed [15:0]xin1, //16-bit Data input.
    input signed [15:0]xin2, //
    input signed [15:0]xin3, //
    
    input signed [15:0]r0, //
    input signed [15:0]r1, //Weight adjust input.
    input signed [15:0]r2, //
    input signed [15:0]r3, //
    
    output signed [15:0]u0, //
    output signed [15:0]u1, //u output for calculating y.
    output signed [15:0]u2, //
    output signed [15:0]u3, //
    
    output reg signed [15:0]xout0 = 16'd0, //
    output reg signed [15:0]xout1 = 16'd0, //Data to cascade
    output reg signed [15:0]xout2 = 16'd0, //to the next block.
    output reg signed [15:0]xout3 = 16'd0  //
    );
    
    //Filter weights.
    parameter b0 = 16'd0;
    parameter b1 = 16'd0;
    parameter b2 = 16'd0;
    parameter b3 = 16'd0;
    
    //Weight registers.
    reg signed [15:0]_b0 = b0;
    reg signed [15:0]_b1 = b1;
    reg signed [15:0]_b2 = b2;
    reg signed [15:0]_b3 = b3;
    
    /*************************Register Unit**************************/ 
    always @(posedge clk) begin
        if(x_en) begin
            xout0 <= xin0;
            xout1 <= xin1;
            xout2 <= xin2;
            xout3 <= xin3;
        end
    end
    
    /******************************IPC1******************************/
    //Multiplier inputs.
    wire signed [15:0]IPC1_mult0_in;
    wire signed [15:0]IPC1_mult1_in;
    wire signed [15:0]IPC1_mult2_in;
    wire signed [15:0]IPC1_mult3_in;
        
    //Multiplier outputs.
    wire signed [31:0]IPC1_mult0_out;
    wire signed [31:0]IPC1_mult1_out;
    wire signed [31:0]IPC1_mult2_out;
    wire signed [31:0]IPC1_mult3_out;
        
    //Adder outputs.
    wire signed [31:0]IPC1_add0;
    wire signed [31:0]IPC1_add1;
    wire signed [31:0]IPC1_out;
    
    //Do multiplications.
    assign IPC1_mult0_out  = xin3 * IPC1_mult0_in;
    assign IPC1_mult1_out  = xin2 * IPC1_mult1_in;
    assign IPC1_mult2_out  = xin1 * IPC1_mult2_in;
    assign IPC1_mult3_out  = xin0 * IPC1_mult3_in;
    
    //Do additions.
    assign IPC1_add0 = IPC1_mult0_out + IPC1_mult1_out;
    assign IPC1_add1 = IPC1_mult2_out + IPC1_mult3_out;
    assign IPC1_out  = IPC1_add0  + IPC1_add1;
    
    /******************************IPC2******************************/
    //Multiplier inputs.
    wire signed [15:0]IPC2_mult0_in;
    wire signed [15:0]IPC2_mult1_in;
    wire signed [15:0]IPC2_mult2_in;
    wire signed [15:0]IPC2_mult3_in;
        
    //Multiplier outputs.
    wire signed [31:0]IPC2_mult0_out;
    wire signed [31:0]IPC2_mult1_out;
    wire signed [31:0]IPC2_mult2_out;
    wire signed [31:0]IPC2_mult3_out;
        
    //Adder outputs.
    wire signed [31:0]IPC2_add0;
    wire signed [31:0]IPC2_add1;
    wire signed [31:0]IPC2_out;
        
    //Do multiplications.
    assign IPC2_mult0_out  = xin2  * IPC2_mult0_in;
    assign IPC2_mult1_out  = xin1  * IPC2_mult1_in;
    assign IPC2_mult2_out  = xin0  * IPC2_mult2_in;
    assign IPC2_mult3_out  = xout3 * IPC2_mult3_in;
        
    //Do additions.
    assign IPC2_add0 = IPC2_mult0_out + IPC2_mult1_out;
    assign IPC2_add1 = IPC2_mult2_out + IPC2_mult3_out;
    assign IPC2_out  = IPC2_add0  + IPC2_add1;
        
    /******************************IPC3******************************/
    //Multiplier inputs.
    wire signed [15:0]IPC3_mult0_in;
    wire signed [15:0]IPC3_mult1_in;
    wire signed [15:0]IPC3_mult2_in;
    wire signed [15:0]IPC3_mult3_in;
        
    //Multiplier outputs.
    wire signed [31:0]IPC3_mult0_out;
    wire signed [31:0]IPC3_mult1_out;
    wire signed [31:0]IPC3_mult2_out;
    wire signed [31:0]IPC3_mult3_out;
        
    //Adder outputs.
    wire signed [31:0]IPC3_add0;
    wire signed [31:0]IPC3_add1;
    wire signed [31:0]IPC3_out;
        
    //Do multiplications.
    assign IPC3_mult0_out  = xin1  * IPC3_mult0_in;
    assign IPC3_mult1_out  = xin0  * IPC3_mult1_in;
    assign IPC3_mult2_out  = xout3 * IPC3_mult2_in;
    assign IPC3_mult3_out  = xout2 * IPC3_mult3_in;
        
    //Do additions.
    assign IPC3_add0 = IPC3_mult0_out + IPC3_mult1_out;
    assign IPC3_add1 = IPC3_mult2_out + IPC3_mult3_out;
    assign IPC3_out  = IPC3_add0  + IPC3_add1;
    
    /******************************IPC4******************************/
    //Multiplier inputs.
    wire signed [15:0]IPC4_mult0_in;
    wire signed [15:0]IPC4_mult1_in;
    wire signed [15:0]IPC4_mult2_in;
    wire signed [15:0]IPC4_mult3_in;
        
    //Multiplier outputs.
    wire signed [31:0]IPC4_mult0_out;
    wire signed [31:0]IPC4_mult1_out;
    wire signed [31:0]IPC4_mult2_out;
    wire signed [31:0]IPC4_mult3_out;
        
    //Adder outputs.
    wire signed [31:0]IPC4_add0;
    wire signed [31:0]IPC4_add1;
    wire signed [31:0]IPC4_out;
        
    //Do multiplications.
    assign IPC4_mult0_out  = xin0  * IPC4_mult0_in;
    assign IPC4_mult1_out  = xout3 * IPC4_mult1_in;
    assign IPC4_mult2_out  = xout2 * IPC4_mult2_in;
    assign IPC4_mult3_out  = xout1 * IPC4_mult3_in;
        
    //Do additions.
    assign IPC4_add0 = IPC4_mult0_out + IPC4_mult1_out;
    assign IPC4_add1 = IPC4_mult2_out + IPC4_mult3_out;
    assign IPC4_out  = IPC4_add0  + IPC4_add1;
    
    /***************************DMUX Unit****************************/
    
    //DMUX outputs.
    wire signed [15:0]dmux1_out0;
    wire signed [15:0]dmux1_out1;   
    wire signed [15:0]dmux2_out0;
    wire signed [15:0]dmux2_out1;
    wire signed [15:0]dmux3_out0;
    wire signed [15:0]dmux3_out1;
    wire signed [15:0]dmux4_out0;
    wire signed [15:0]dmux4_out1;
    
    //Assign outputs.
    assign dmux1_out0 = dmux_sel ? 16'd0           : IPC1_out[31:16];
    assign dmux1_out1 = dmux_sel ? IPC1_out[31:16] : 16'd0;
    
    assign dmux2_out0 = dmux_sel ? 16'd0           : IPC2_out[31:16];
    assign dmux2_out1 = dmux_sel ? IPC2_out[31:16] : 16'd0;
    
    assign dmux3_out0 = dmux_sel ? 16'd0           : IPC3_out[31:16];
    assign dmux3_out1 = dmux_sel ? IPC3_out[31:16] : 16'd0;
    
    assign dmux4_out0 = dmux_sel ? 16'd0           : IPC4_out[31:16];
    assign dmux4_out1 = dmux_sel ? IPC4_out[31:16] : 16'd0;
    
    //Assign u values.
    assign u3 = dmux1_out1;
    assign u2 = dmux2_out1;
    assign u1 = dmux3_out1;
    assign u0 = dmux4_out1;
    
    /****************************WU Unit*****************************/
    always @(posedge clk) begin
        if(w_en) begin
            _b0 <= _b0 + dmux1_out0;
            _b1 <= _b1 + dmux2_out0;
            _b2 <= _b2 + dmux3_out0;
            _b3 <= _b3 + dmux4_out0;
        end
    end
        
    /****************************MUX Unit****************************/
    //MUX outputs.
    wire signed [15:0]mux0_out;
    wire signed [15:0]mux1_out;
    wire signed [15:0]mux2_out;
    wire signed [15:0]mux3_out;
        
    //Assign MUX outputs.
    assign mux0_out = mux_sel ? _b0 : r0;
    assign mux1_out = mux_sel ? _b1 : r1;
    assign mux2_out = mux_sel ? _b2 : r2;
    assign mux3_out = mux_sel ? _b3 : r3;
    
    //Assign MUX outputs to IPC inputs.
    assign IPC1_mult0_in = mux0_out;
    assign IPC2_mult0_in = mux0_out;
    assign IPC3_mult0_in = mux0_out;
    assign IPC4_mult0_in = mux0_out;
    assign IPC1_mult1_in = mux1_out;
    assign IPC2_mult1_in = mux1_out;
    assign IPC3_mult1_in = mux1_out;
    assign IPC4_mult1_in = mux1_out;
    assign IPC1_mult2_in = mux2_out;
    assign IPC2_mult2_in = mux2_out;
    assign IPC3_mult2_in = mux2_out;
    assign IPC4_mult2_in = mux2_out;
    assign IPC1_mult3_in = mux3_out;
    assign IPC2_mult3_in = mux3_out;
    assign IPC3_mult3_in = mux3_out;
    assign IPC4_mult3_in = mux3_out; 
endmodule
