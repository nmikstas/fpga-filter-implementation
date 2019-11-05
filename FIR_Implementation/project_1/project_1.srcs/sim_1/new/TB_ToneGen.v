module TB_ToneGen;

    reg clk = 1'b0;
    reg sw0 = 1'b1;
    wire [7:0]JA;
    
    wire en;    
    //wire [15:0]cout;
    
    filter_top uut(.clk(clk), .sw({15'h00,sw0}), .JA({JA[3:0], JA[7:4]}));
    
    assign en = uut.en;
    //assign cout = uut.ce.en_counter;
    
    //initial begin
    //     #600000 sw0 = 1'b1;
    //end
    
    //100MHz clock
    always #5 clk = ~clk;
endmodule
