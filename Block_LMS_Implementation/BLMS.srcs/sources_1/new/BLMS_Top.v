`timescale 1ns / 1ps

module BLMS_Top(
    input  clk,
    input  [7:0]sw,
    output [7:0]JA
    );
    
    wire clk_50MHz;
    wire clk_25MHz;
    wire en;
          
    wire signed [15:0]tonegen_out;    //Output of the tone lookup table.
    wire signed [15:0]fout;           //Output of the FIR filter.
    wire signed [15:0]lfsr_out;       //16-bit Random noise variable.
    wire signed [9:0]rnd;             //10-bit noise.
    wire signed [15:0]tone_and_noise; //Combination of tone and noise.
    wire signed [15:0]serial_dout;    //Serialized output.
    
    //Selected desired output. 
    wire signed [15:0]mout;                               
    
    //Parallelized desired output.
    wire signed [15:0]dout0;
    wire signed [15:0]dout1;
    wire signed [15:0]dout2;
    wire signed [15:0]dout3;
    
    //Parallelized input to BLMS filter.
    wire signed [15:0]blms_din0;
    wire signed [15:0]blms_din1;
    wire signed [15:0]blms_din2;
    wire signed [15:0]blms_din3;
    
    //Stepped error.
    wire signed [15:0]r0;
    wire signed [15:0]r1; 
    wire signed [15:0]r2;
    wire signed [15:0]r3;
    
    //BLMS block1 outputs.
    wire signed [15:0]b1_x0_out;
    wire signed [15:0]b1_x1_out;
    wire signed [15:0]b1_x2_out;
    wire signed [15:0]b1_x3_out;
    wire signed [15:0]b1_u0;
    wire signed [15:0]b1_u1;
    wire signed [15:0]b1_u2;
    wire signed [15:0]b1_u3;
    
    //BLMS block2 outputs.
    wire signed [15:0]b2_x0_out;
    wire signed [15:0]b2_x1_out;
    wire signed [15:0]b2_x2_out;
    wire signed [15:0]b2_x3_out;
    wire signed [15:0]b2_u0;
    wire signed [15:0]b2_u1;
    wire signed [15:0]b2_u2;
    wire signed [15:0]b2_u3;
    
    //BLMS block3 outputs.
    wire signed [15:0]b3_x0_out;
    wire signed [15:0]b3_x1_out;
    wire signed [15:0]b3_x2_out;
    wire signed [15:0]b3_x3_out;
    wire signed [15:0]b3_u0;
    wire signed [15:0]b3_u1;
    wire signed [15:0]b3_u2;
    wire signed [15:0]b3_u3;
    
    //BLMS block4 outputs.
    wire signed [15:0]b4_x0_out;
    wire signed [15:0]b4_x1_out;
    wire signed [15:0]b4_x2_out;
    wire signed [15:0]b4_x3_out;
    wire signed [15:0]b4_u0;
    wire signed [15:0]b4_u1;
    wire signed [15:0]b4_u2;
    wire signed [15:0]b4_u3;
    
    //BLMS filter outputs.
    wire signed [15:0]y0;
    wire signed [15:0]y1;
    wire signed [15:0]y2;
    wire signed [15:0]y3;
    
    reg [1:0]en_counter = 2'b00;
    
    //Generate enable signal for BLMS filter.
    always@(posedge clk_50MHz) begin
        en_counter <= en_counter + 1'b1;
    end
    
    //Toggle enable signal.
    assign en = (en_counter == 2'b10|| en_counter == 2'b11) ? 1'b1 : 1'b0;
    
    //Instantiate clock generator.
    clk_wiz_0 clk_wiz(.clk_in1(clk), .clk_out1(clk_50MHz), .clk_out2(clk_25MHz));
    
    //Instantiate tone generator.
    ToneGen tg(.clk(clk_50MHz), .en(1'b1), .dout(tonegen_out));
           
    //Instatiate LFSR for random noise generation.
    lfsr lr(.clk(clk_50MHz), .en(1'b1), .rst(1'b0), .lfsr_out(lfsr_out));
    
    //Add the random noise to the tone.
    assign rnd = lfsr_out[15:6];
    assign tone_and_noise = tonegen_out + rnd;
    
    //Instantiate the FIR filter.
    FIR_Filter ff(.clk(clk_50MHz), .en(1'b1), .din(tone_and_noise), .dout(fout));
    
    //Choose filtered or unfiltered output based on sw0.
    assign mout = sw[0] ? fout : tone_and_noise;
    
    //Instantiate desired out div 4.
    Data_Div4 d4_fir(.clk(clk_50MHz), .en(1'b1), .din(mout), .d0_out(dout0), 
                     .d1_out(dout1), .d2_out(dout2), .d3_out(dout3));

    //Instantiate BLMS filter div 4.
    Data_Div4 d4_blms(.clk(clk_50MHz), .en(1'b1), .din(tone_and_noise), .d0_out(blms_din0), 
                      .d1_out(blms_din1), .d2_out(blms_din2), .d3_out(blms_din3));
                      
    //Build 16-tap block FIR filter.
    BLMS_Block b1(.clk(clk_25MHz), .x_en(en), .w_en(en), .mux_sel(~en), .dmux_sel(~en), .xin0(blms_din0), 
                  .xin1(blms_din1), .xin2(blms_din2), .xin3(blms_din3), .r0(r0), .r1(r1), 
                  .r2(r2), .r3(r3), .u0(b1_u0), .u1(b1_u1), .u2(b1_u2), .u3(b1_u3), 
                  .xout0(b1_x0_out), .xout1(b1_x1_out), .xout2(b1_x2_out), .xout3(b1_x3_out));
    
    BLMS_Block b2(.clk(clk_25MHz), .x_en(en), .w_en(en), .mux_sel(~en), .dmux_sel(~en), .xin0(b1_x0_out), 
                  .xin1(b1_x1_out), .xin2(b1_x2_out), .xin3(b1_x3_out), .r0(r0), .r1(r1), 
                  .r2(r2), .r3(r3), .u0(b2_u0), .u1(b2_u1), .u2(b2_u2), .u3(b2_u3), 
                  .xout0(b2_x0_out), .xout1(b2_x1_out), .xout2(b2_x2_out), .xout3(b2_x3_out));
    
    BLMS_Block b3(.clk(clk_25MHz), .x_en(en), .w_en(en), .mux_sel(~en), .dmux_sel(~en), .xin0(b2_x0_out), 
                  .xin1(b2_x1_out), .xin2(b2_x2_out), .xin3(b2_x3_out), .r0(r0), .r1(r1), 
                  .r2(r2), .r3(r3), .u0(b3_u0), .u1(b3_u1), .u2(b3_u2), .u3(b3_u3), 
                  .xout0(b3_x0_out), .xout1(b3_x1_out), .xout2(b3_x2_out), .xout3(b3_x3_out));    

    BLMS_Block b4(.clk(clk_25MHz), .x_en(en), .w_en(en), .mux_sel(~en), .dmux_sel(~en), .xin0(b3_x0_out), 
                  .xin1(b3_x1_out), .xin2(b3_x2_out), .xin3(b3_x3_out), .r0(r0), .r1(r1), 
                  .r2(r2), .r3(r3), .u0(b4_u0), .u1(b4_u1), .u2(b4_u2), .u3(b4_u3), 
                  .xout0(b4_x0_out), .xout1(b4_x1_out), .xout2(b4_x2_out), .xout3(b4_x3_out));
   
    //Add outputs together.
    assign y0 = b1_u0 + b2_u0 + b3_u0 + b4_u0;
    assign y1 = b1_u1 + b2_u1 + b3_u1 + b4_u1;
    assign y2 = b1_u2 + b2_u2 + b3_u2 + b4_u2;
    assign y3 = b1_u3 + b2_u3 + b3_u3 + b4_u3;
    
    //Instantiate ECU module.
    BLMS_ECU be(.clk(clk_25MHz), .r_en(~en), .din0(dout0), .din1(dout1), .din2(dout2), 
                .din3(dout3), .yin0(y0), .yin1(y1), .yin2(y2), .yin3(y3), .r0(r0), .r1(r1),
                .r2(r2), .r3(r3));
    
    //Serialize the BLMS output.
    Data_Mult4 dm(.clk(clk_50MHz), .en(1'b1), .d0_in(y0), .d1_in(y1), .d2_in(y2), .d3_in(y3), .dout(serial_dout));
    
    //Take only the upper 8 bits and make it unsigned.
    assign {JA[3:0], JA[7:4]} = serial_dout[15:8] + 8'd128;
    //assign JA[7:0] = serial_dout[15:8] + 8'd128;
         
    //assign {JA[3:0], JA[7:4]} = sw[7:0];   
endmodule
