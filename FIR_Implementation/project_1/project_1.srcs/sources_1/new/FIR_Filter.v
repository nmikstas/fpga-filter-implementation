`define FILT_LENGTH 16

module FIR_Filter(
    input  clk,
    input  en,
    input  [15:0]din,
    output [15:0]dout
    );
  
    reg signed [15:0]coeff[`FILT_LENGTH/2-1:0]; //Filter coefficients.
    reg signed [15:0]delay_line[`FILT_LENGTH-1:0]; //Input delay line.
    wire [31:0]accum; //Accumulator for output filter calculation.    
    integer i; //Initialization integer.
    genvar c;  //Delay line generation variable.
   
    reg signed [16:0]preadd_regs[7:0]; //Save calc after preadd.
    reg signed [31:0]mult_regs[7:0];   //Save calc after multiplication.
    reg signed [31:0]tree1_regs[3:0];  //Save calc after first layer of adder tree.
    reg signed [31:0]tree2_regs[1:0];  //Save calc after first layer of adder tree.
    reg signed [31:0]treeout_reg;      //Save calc after complete.
   
    //assign dout = treeout_reg[31:16];
    
    //Calculate value in the accumulator.
    assign accum = (delay_line[0] + delay_line[15]) * coeff[0] +
                   (delay_line[1] + delay_line[14]) * coeff[1] +
                   (delay_line[2] + delay_line[13]) * coeff[2] +
                   (delay_line[3] + delay_line[12]) * coeff[3] +
                   (delay_line[4] + delay_line[11]) * coeff[4] +
                   (delay_line[5] + delay_line[10]) * coeff[5] +
                   (delay_line[6] + delay_line[9])  * coeff[6] +
                   (delay_line[7] + delay_line[8])  * coeff[7];

    //Assign upper 16-bits to output.
    assign dout = accum[31:16];
      
    initial begin   
        //Load the filter coefficients.
        coeff[0] = 16'd2320;
        coeff[1] = 16'd4143;
        coeff[2] = 16'd4592;
        coeff[3] = 16'd7278;
        coeff[4] = 16'd8423;
        coeff[5] = 16'd10389;
        coeff[6] = 16'd11269;
        coeff[7] = 16'd12000;
                 
        //Initialize delay line.
        for(i = 0; i < `FILT_LENGTH; i = i+1'b1) begin
            delay_line[i] = 16'd0;
        end
        
        //Initialize the preadder regs.
        for(i = 0; i < 8; i = i+1'b1) begin
            preadd_regs[i] = 17'd0;
        end
                
        //Initialize the multiplier regs.
        for(i = 0; i < 8; i = i+1'b1) begin
            mult_regs[i] = 32'd0;
        end
        
        //Initialize the first layer of the adder tree regs.
        for(i = 0; i < 4; i = i+1'b1) begin
            tree1_regs[i] = 32'd0;
        end
        
        //Initialize the second layer of the adder tree regs.
        for(i = 0; i < 2; i = i+1'b1) begin
            tree2_regs[i] = 32'd0;
        end        
        
        //Initialize the adder tree output reg.
        treeout_reg = 32'd0;
    end
    
    //Advance the data through the delay line every clock cycle.
    generate
        for (c = `FILT_LENGTH-1; c > 0; c = c - 1) begin: inc_delay
            always @(posedge clk) begin
                if(en) delay_line[c] <= delay_line[c-1];
            end
        end
    endgenerate
    
    //Update with input data.
    always @(posedge clk) begin
        if(en) delay_line[0] <= din;
    end
endmodule
