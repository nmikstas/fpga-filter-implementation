module clk_en(
    input clk,
    output reg en = 1'b0
    );

    reg [15:0]en_counter = 16'h0;
    
    always @(posedge clk) begin
        if(en_counter == 16'd449) begin
            en_counter <= 16'h0;
            en <= 1'b1;
        end
        else begin
            en_counter <= en_counter + 1'b1;
            en <= 1'b0;
        end
    end

endmodule