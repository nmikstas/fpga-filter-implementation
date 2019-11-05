`timescale 1ns / 1ps

module lfsr(
    input clk,
    input en,
    input rst,
    output [15:0]lfsr_out
    );
    
    //Create a 16-bit linear feedback shift register with
    //maximal polynomial x^16 + x^14 + x^13 + x^11 + 1.
    reg [15:0]lfsr = 16'd1;
    wire feedback;
    
    assign feedback = ((lfsr[15] ^ lfsr[13]) ^ lfsr[12]) ^ lfsr[10];
    assign lfsr_out = lfsr;
        
    //Update the linear feedback shift register.
    always @(posedge clk) begin
        if(rst) lfsr <= 16'd1;
        else if(en) lfsr <= {lfsr[14:0], feedback};
    end
endmodule
