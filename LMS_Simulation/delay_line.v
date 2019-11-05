`timescale 1ns / 1ps

module delay_line#(LENGTH = 101)(
    input  clk,
    input  en,
    input  [15:0]din,
    output [15:0]dout
    );
    
    reg [15:0]delay[LENGTH-1:0];
    integer i; //Initialization integer.
    genvar c;  //Delay line generation variable.
    
    //Initialize delay line.
    initial begin
        for(i = 0; i < LENGTH; i = i+1) begin
            delay[i] = 16'd0;
        end
    end
    
    assign dout = delay[LENGTH-1];
    
    //Advance the data through the delay line every clock cycle.
    generate
        for (c = LENGTH-1; c > 0; c = c - 1) begin: inc_delay
            always @(posedge clk) begin
                if(en) delay[c] <= delay[c-1];
            end
        end
    endgenerate
    
    //Update with input data.
    always @(posedge clk) begin
        if(en) delay[0] <= din;
    end
    
endmodule
