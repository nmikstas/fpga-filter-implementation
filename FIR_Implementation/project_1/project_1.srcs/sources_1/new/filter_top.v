module filter_top(
    input clk,
    input [7:0]sw,
    output [7:0]JA
    );
        
    wire [15:0]tout; //The output of the tone lookup table.
    wire [15:0]fout; //The output of the FIR filter.
    wire [15:0]mout; //Selected output.
    wire en;         //Clock enble.
    wire clk_out;    //264MHz System clock.
    
    assign en = 1'b1;
    
    clk_wiz_0 cw (.clk_in1(clk), .clk_out1(clk_out));
    //clk_en ce(.clk(clk_out), .en(en));
    ToneGen tg(.clk(clk_out), .en(en), .dout(tout));
    FIR_Filter ff(.clk(clk_out), .en(en), .din(tout), .dout(fout));
    
    //Choose filtered or unfiltered output based on sw0.
    assign mout = sw[0] ? fout : tout;
    
    //Take only the upper 8 bits and make it unsigned.
    //assign JA = mout[15:8] + 8'd128;
    assign {JA[3:0], JA[7:4]} = mout[15:8] + 8'd128;
    
endmodule
