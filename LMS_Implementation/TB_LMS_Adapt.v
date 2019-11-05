module TB_LMS_Adapt;

    reg  clk = 1'b0;
    reg  [7:0]sw = 1'b1;
    wire [7:0]JA;
    
    wire [15:0]d;
    wire [15:0]y;
    wire [15:0]e;
    wire [15:0]n1;
        
    filter_top uut(.clk(clk), .sw(sw), .JA(JA));
    
    assign d = uut.fout;
    assign y = uut.aout;
    assign e = uut.err;
    assign n1 = uut.af.n1[0];
  
    always #5 clk = ~clk;
    
    initial begin
        //#20000000 sw[0] = 1'b1;
        //#40000 sw[0] = 1'b1;
    end
endmodule
