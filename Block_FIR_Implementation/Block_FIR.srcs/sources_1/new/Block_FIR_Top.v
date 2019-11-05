`timescale 1ns / 1ps

module Block_FIR_Top(
    input  clk,
    input  [7:0]sw,
    output [7:0]JA
    );
    
    wire clk_100MHz;
    wire clk_25MHz;
    wire en;
      
    wire signed [15:0]tonegen_out;
    
    //Data divider outputs.
    wire en_out;
    wire signed [15:0]d0_out;
    wire signed [15:0]d1_out;
    wire signed [15:0]d2_out;
    wire signed [15:0]d3_out;
    
    //FIR f1 outputs
    wire signed [15:0]f1_x0_out;
    wire signed [15:0]f1_x1_out;
    wire signed [15:0]f1_x2_out;
    wire signed [15:0]f1_x3_out;
    wire signed [15:0]f1_u0;
    wire signed [15:0]f1_u1;
    wire signed [15:0]f1_u2;
    wire signed [15:0]f1_u3;
    
    //FIR f2 outputs
    wire signed [15:0]f2_x0_out;
    wire signed [15:0]f2_x1_out;
    wire signed [15:0]f2_x2_out;
    wire signed [15:0]f2_x3_out;
    wire signed [15:0]f2_u0;
    wire signed [15:0]f2_u1;
    wire signed [15:0]f2_u2;
    wire signed [15:0]f2_u3;
    
    //FIR f3 outputs
    wire signed [15:0]f3_x0_out;
    wire signed [15:0]f3_x1_out;
    wire signed [15:0]f3_x2_out;
    wire signed [15:0]f3_x3_out;
    wire signed [15:0]f3_u0;
    wire signed [15:0]f3_u1;
    wire signed [15:0]f3_u2;
    wire signed [15:0]f3_u3;
    
    //FIR f4 outputs
    wire signed [15:0]f4_x0_out;
    wire signed [15:0]f4_x1_out;
    wire signed [15:0]f4_x2_out;
    wire signed [15:0]f4_x3_out;
    wire signed [15:0]f4_u0;
    wire signed [15:0]f4_u1;
    wire signed [15:0]f4_u2;
    wire signed [15:0]f4_u3;
    
    //Block filter outputs.
    wire signed [15:0]y0;
    wire signed [15:0]y1;
    wire signed [15:0]y2;
    wire signed [15:0]y3;
    
    wire [15:0]serial_dout; //Serialized output.
    wire [15:0]mout;        //Selected output.
    
    assign en = 1'b1;
    
    clk_wiz_0 cw(.clk_in1(clk), .clk_out1(clk_100MHz), .clk_out2(clk_25MHz));   
    ToneGen tg(.clk(clk_100MHz), .en(en), .dout(tonegen_out));
    Data_Div4 dd(.clk(clk_100MHz), .en(en), .din(tonegen_out), .en_out(en_out),
                 .d0_out(d0_out), .d1_out(d1_out), .d2_out(d2_out), .d3_out(d3_out));

    //Build 16-tap block FIR filter.
    Block_FIR #(.b0(16'd2320), .b1(16'd4143), .b2(16'd4592), .b3(16'd7278))f1(.clk(clk_25MHz), .en(en),
                 .x0_in(d0_out), .x1_in(d1_out), .x2_in(d2_out), .x3_in(d3_out), 
                 .x0_out(f1_x0_out), .x1_out(f1_x1_out), .x2_out(f1_x2_out), .x3_out(f1_x3_out), 
                 .u0(f1_u0), .u1(f1_u1), .u2(f1_u2), .u3(f1_u3));
    
    Block_FIR #(.b0(16'd8423), .b1(16'd10389), .b2(16'd11269), .b3(16'd12000))f2(.clk(clk_25MHz), .en(en),
                 .x0_in(f1_x0_out), .x1_in(f1_x1_out), .x2_in(f1_x2_out), .x3_in(f1_x3_out), 
                 .x0_out(f2_x0_out), .x1_out(f2_x1_out), .x2_out(f2_x2_out), .x3_out(f2_x3_out), 
                 .u0(f2_u0), .u1(f2_u1), .u2(f2_u2), .u3(f2_u3));
                 
    Block_FIR #(.b0(16'd12000), .b1(16'd11269), .b2(16'd10389), .b3(16'd8423))f3(.clk(clk_25MHz), .en(en),
                 .x0_in(f2_x0_out), .x1_in(f2_x1_out), .x2_in(f2_x2_out), .x3_in(f2_x3_out), 
                 .x0_out(f3_x0_out), .x1_out(f3_x1_out), .x2_out(f3_x2_out), .x3_out(f3_x3_out), 
                 .u0(f3_u0), .u1(f3_u1), .u2(f3_u2), .u3(f3_u3));
                 
    Block_FIR #(.b0(16'd7278), .b1(16'd4592), .b2(16'd4143), .b3(16'd2320))f4(.clk(clk_25MHz), .en(en),
                 .x0_in(f3_x0_out), .x1_in(f3_x1_out), .x2_in(f3_x2_out), .x3_in(f3_x3_out), 
                 .x0_out(f4_x0_out), .x1_out(f4_x1_out), .x2_out(f4_x2_out), .x3_out(f4_x3_out), 
                 .u0(f4_u0), .u1(f4_u1), .u2(f4_u2), .u3(f4_u3));
    
    //Add outputs together.
    assign y0 = f1_u0 + f2_u0 + f3_u0 + f4_u0;
    assign y1 = f1_u1 + f2_u1 + f3_u1 + f4_u1;
    assign y2 = f1_u2 + f2_u2 + f3_u2 + f4_u2;
    assign y3 = f1_u3 + f2_u3 + f3_u3 + f4_u3;
    
    //Serialize the output data.
    Data_Mult4 dm(.clk(clk_100MHz), .en(en), .d0_in(y0), .d1_in(y1), .d2_in(y2), .d3_in(y3), .dout(serial_dout));
    
    //Choose filtered or unfiltered output based on sw0.
    assign mout = sw[0] ? serial_dout : tonegen_out;
        
    //Take only the upper 8 bits and make it unsigned.
    //assign JA = mout[15:8] + 8'd128;
    assign {JA[3:0], JA[7:4]} = mout[15:8] + 8'd128;
endmodule
