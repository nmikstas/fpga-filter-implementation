module TB_ToneGen;

    reg clk = 1'b0;
    reg sw0 = 1'b0;
    wire [7:0]JA;
    
    filter_top uut(.clk(clk), .sw({15'h00,sw0}), .JA(JA));
    
    initial begin
        #50000 sw0 = 1'b1;
    end
    
    //100MHz clock
    always #5 clk = ~clk;
endmodule
