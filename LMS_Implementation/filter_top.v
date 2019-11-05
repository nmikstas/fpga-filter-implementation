module filter_top(
    input clk,
    input [7:0]sw,
    output [7:0]JA
    );
        
    wire signed [15:0]tout;           //Output of the tone lookup table.
    wire [15:0]fout;                  //Output of the FIR filter.
    wire [15:0]aout;                  //Output of the adaptive filter.
    wire [15:0]err;                   //Adaptive filter error.
    wire [15:0]lfsr_out;              //16-bit Random noise variable.
    wire en;                          //Clock enble.
    wire [9:0]rnd;                    //10-bit noise.
    wire signed [15:0]tone_and_noise; //Combination of tone and noise.
    wire signed [15:0]delay_out;      //Output of the delay line.    
    wire [15:0]mout;                  //Selected desired output.
    wire clk19_8MHz;                  //19.8MHz system clock.
       
    assign rnd = lfsr_out[15:6];
    assign tone_and_noise = tout + rnd;
    //assign en = 1'b1;
    
    clk_wiz_0 cw(.clk_in1(clk), .clk_out1(clk19_8MHz), .reset(1'b0));
    ToneGen tg(.clk(clk19_8MHz), .en(en), .dout(tout));
    FIR_Filter ff(.clk(clk19_8MHz), .en(en), .din(tone_and_noise), .dout(fout));
    LMS_Adapt af(.clk(clk19_8MHz), .en(en), .din(tone_and_noise), .desired(mout), .dout(aout), .err(err));
    lfsr sr(.clk(clk19_8MHz), .en(en), .lfsr_out(lfsr_out));
    clk_en ce(.clk(clk19_8MHz), .en(en));
    
    //Choose filtered or unfiltered output based on sw0.
    assign mout = sw[0] ? fout : tone_and_noise;//delay_out;
      
    //Take only the upper 8 bits and make it unsigned.
    assign {JA[3:0], JA[7:4]} = aout[15:8] + 8'd128;
    //assign JA[7:0] = aout[15:8] + 8'd128;
	 
	//assign {JA[3:0], JA[7:4]} = sw[7:0];   
endmodule
