`timescale 1ns/1ps

module ToneGen(
    input clk,
    input en,
    output [15:0]dout
    );

    //Tone generation data.  At a 44KHz sampling rate, the lookup table
    //generates a 440Hz and 4.4KHz tone mixed together.
    reg [15:0]tonetbl[99:0];
	 
    //Pointer into the tone table.
    reg [6:0]toneptr = 7'h00;
	 
    initial begin
        tonetbl[0] = 10970;
        tonetbl[1] = 18151;
        tonetbl[2] = 19197;
        tonetbl[3] = 14105;
        tonetbl[4] = 5211;
        tonetbl[5] = -3704;
        tonetbl[6] = -8858;
        tonetbl[7] = -7914;
        tonetbl[8] = -876;
        tonetbl[9] = 9912;
        tonetbl[10] = 20660;
        tonetbl[11] = 27581;
        tonetbl[12] = 28330;
        tonetbl[13] = 22905;
        tonetbl[14] = 13642;
        tonetbl[15] = 4326;
        tonetbl[16] = -1260;
        tonetbl[17] = -780;
        tonetbl[18] = 5767;
        tonetbl[19] = 16037;
        tonetbl[20] = 26244;
        tonetbl[21] = 32601;
        tonetbl[22] = 32767;
        tonetbl[23] = 26741;
        tonetbl[24] = 16863;
        tonetbl[25] = 6918;
        tonetbl[26] = 692;
        tonetbl[27] = 527;
        tonetbl[28] = 6421;
        tonetbl[29] = 16037;
        tonetbl[30] = 25590;
        tonetbl[31] = 31295;
        tonetbl[32] = 30814;
        tonetbl[33] = 24149;
        tonetbl[34] = 13642;
        tonetbl[35] = 3081;
        tonetbl[36] = -3745;
        tonetbl[37] = -4494;
        tonetbl[38] = 837;
        tonetbl[39] = 9912;
        tonetbl[40] = 18947;
        tonetbl[41] = 24161;
        tonetbl[42] = 23217;
        tonetbl[43] = 16119;
        tonetbl[44] = 5211;
        tonetbl[45] = -5718;
        tonetbl[46] = -12878;
        tonetbl[47] = -13924;
        tonetbl[48] = -8853;
        tonetbl[49] = 0;
        tonetbl[50] = 8853;
        tonetbl[51] = 13924;
        tonetbl[52] = 12878;
        tonetbl[53] = 5718;
        tonetbl[54] = -5211;
        tonetbl[55] = -16119;
        tonetbl[56] = -23217;
        tonetbl[57] = -24161;
        tonetbl[58] = -18947;
        tonetbl[59] = -9912;
        tonetbl[60] = -837;
        tonetbl[61] = 4494;
        tonetbl[62] = 3745;
        tonetbl[63] = -3081;
        tonetbl[64] = -13642;
        tonetbl[65] = -24149;
        tonetbl[66] = -30814;
        tonetbl[67] = -31295;
        tonetbl[68] = -25590;
        tonetbl[69] = -16037;
        tonetbl[70] = -6421;
        tonetbl[71] = -527;
        tonetbl[72] = -692;
        tonetbl[73] = -6918;
        tonetbl[74] = -16863;
        tonetbl[75] = -26741;
        tonetbl[76] = -32767;
        tonetbl[77] = -32601;
        tonetbl[78] = -26244;
        tonetbl[79] = -16037;
        tonetbl[80] = -5767;
        tonetbl[81] = 780;
        tonetbl[82] = 1260;
        tonetbl[83] = -4326;
        tonetbl[84] = -13642;
        tonetbl[85] = -22905;
        tonetbl[86] = -28330;
        tonetbl[87] = -27581;
        tonetbl[88] = -20660;
        tonetbl[89] = -9912;
        tonetbl[90] = 876;
        tonetbl[91] = 7914;
        tonetbl[92] = 8858;
        tonetbl[93] = 3704;
        tonetbl[94] = -5211;
        tonetbl[95] = -14105;
        tonetbl[96] = -19197;
        tonetbl[97] = -18151;
        tonetbl[98] = -10970;
        tonetbl[99] = 0;
    end

    //Assign the output to the value in the lookup table
    //pointed to by toneptr.
    assign dout = tonetbl[toneptr];

    //Increment through the tone lookup table and wrap back
    //to zero when at the end.
    always @(posedge clk) begin
        if(en) begin
            if(toneptr == 7'd99) begin
                toneptr <= 7'd0;
            end
            else begin
                toneptr <= toneptr + 1'b1;
            end
        end
    end
endmodule
