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
        tonetbl[0] = 2743;
        tonetbl[1] = 4538;
        tonetbl[2] = 4799;
        tonetbl[3] = 3526;
        tonetbl[4] = 1303;
        tonetbl[5] = -926;
        tonetbl[6] = -2214;
        tonetbl[7] = -1978;
        tonetbl[8] = -219;
        tonetbl[9] = 2478;
        tonetbl[10] = 5165;
        tonetbl[11] = 6895;
        tonetbl[12] = 7083;
        tonetbl[13] = 5726;
        tonetbl[14] = 3411;
        tonetbl[15] = 1082;
        tonetbl[16] = -315;
        tonetbl[17] = -195;
        tonetbl[18] = 1442;
        tonetbl[19] = 4009;
        tonetbl[20] = 6561;
        tonetbl[21] = 8151;
        tonetbl[22] = 8192;
        tonetbl[23] = 6685;
        tonetbl[24] = 4216;
        tonetbl[25] = 1729;
        tonetbl[26] = 173;
        tonetbl[27] = 132;
        tonetbl[28] = 1605;
        tonetbl[29] = 4009;
        tonetbl[30] = 6398;
        tonetbl[31] = 7824;
        tonetbl[32] = 7704;
        tonetbl[33] = 6037;
        tonetbl[34] = 3411;
        tonetbl[35] = 770;
        tonetbl[36] = -936;
        tonetbl[37] = -1124;
        tonetbl[38] = 209;
        tonetbl[39] = 2478;
        tonetbl[40] = 4737;
        tonetbl[41] = 6040;
        tonetbl[42] = 5804;
        tonetbl[43] = 4030;
        tonetbl[44] = 1303;
        tonetbl[45] = -1430;
        tonetbl[46] = -3219;
        tonetbl[47] = -3481;
        tonetbl[48] = -2213;
        tonetbl[49] = 0;
        tonetbl[50] = 2213;
        tonetbl[51] = 3481;
        tonetbl[52] = 3219;
        tonetbl[53] = 1430;
        tonetbl[54] = -1303;
        tonetbl[55] = -4030;
        tonetbl[56] = -5804;
        tonetbl[57] = -6040;
        tonetbl[58] = -4737;
        tonetbl[59] = -2478;
        tonetbl[60] = -209;
        tonetbl[61] = 1124;
        tonetbl[62] = 936;
        tonetbl[63] = -770;
        tonetbl[64] = -3411;
        tonetbl[65] = -6037;
        tonetbl[66] = -7704;
        tonetbl[67] = -7824;
        tonetbl[68] = -6398;
        tonetbl[69] = -4009;
        tonetbl[70] = -1605;
        tonetbl[71] = -132;
        tonetbl[72] = -173;
        tonetbl[73] = -1729;
        tonetbl[74] = -4216;
        tonetbl[75] = -6685;
        tonetbl[76] = -8192;
        tonetbl[77] = -8151;
        tonetbl[78] = -6561;
        tonetbl[79] = -4009;
        tonetbl[80] = -1442;
        tonetbl[81] = 195;
        tonetbl[82] = 315;
        tonetbl[83] = -1082;
        tonetbl[84] = -3411;
        tonetbl[85] = -5726;
        tonetbl[86] = -7083;
        tonetbl[87] = -6895;
        tonetbl[88] = -5165;
        tonetbl[89] = -2478;
        tonetbl[90] = 219;
        tonetbl[91] = 1978;
        tonetbl[92] = 2214;
        tonetbl[93] = 926;
        tonetbl[94] = -1303;
        tonetbl[95] = -3526;
        tonetbl[96] = -4799;
        tonetbl[97] = -4538;
        tonetbl[98] = -2743;
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
