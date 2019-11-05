`define ADAPT_FILT_LENGTH 16
module LMS_Adapt(
    input  clk,
    input  en,
    input  [15:0]din,
    input  signed [15:0]desired,
    output signed [15:0]dout,
    output signed [15:0]err
    );

    parameter MU = 16'd32767;
    
    reg  signed [15:0]mu = MU;
    reg  signed [15:0]coeff[`ADAPT_FILT_LENGTH-1:0]; //Filter coefficients.
    reg  signed [15:0]delay_line[`ADAPT_FILT_LENGTH-1:0]; //Input delay line.
    wire signed [31:0]accum; //Accumulator for output filter calculation.
    wire signed [31:0]stepped; //Error after step sized applied.    
    integer i; //Initialization integer.
    genvar c;  //Delay line generation variable.
    
    //Calculate the error and multiply it by the step size.
    assign err = desired - dout;   
    //assign stepped = err * mu;
    assign stepped = err << 15;
    
    //Calculate value in the accumulator.
    assign accum = delay_line[0]*coeff[0] +
                   delay_line[1]*coeff[1] +
                   delay_line[2]*coeff[2] +
                   delay_line[3]*coeff[3] +
                   delay_line[4]*coeff[4] +
                   delay_line[5]*coeff[5] +
                   delay_line[6]*coeff[6] +
                   delay_line[7]*coeff[7] +
                   delay_line[8]*coeff[8] +
                   delay_line[9]*coeff[9] +
                   delay_line[10]*coeff[10] +
                   delay_line[11]*coeff[11] +
                   delay_line[12]*coeff[12] +
                   delay_line[13]*coeff[13] +
                   delay_line[14]*coeff[14] +
                   delay_line[15]*coeff[15];
                   
    //Assign upper 16-bits to output.
    assign dout = accum[31:16];
   
    initial begin   
        //Load the filter coefficients.
        coeff[0]  = 20'd0;
        coeff[1]  = 20'd0;
        coeff[2]  = 20'd0;
        coeff[3]  = 20'd0;
        coeff[4]  = 20'd0;
        coeff[5]  = 20'd0;
        coeff[6]  = 20'd0;
        coeff[7]  = 20'd0;
        coeff[8]  = 20'd0;
        coeff[9]  = 20'd0;
        coeff[10] = 20'd0;
        coeff[11] = 20'd0; 
        coeff[12] = 20'd0;
        coeff[13] = 20'd0;
        coeff[14] = 20'd0;
        coeff[15] = 20'd0;
       
        //Initialize delay line.
        for(i = 0; i < `ADAPT_FILT_LENGTH; i = i+1'b1) begin
            delay_line[i] = 16'd0;
        end
    end
    
    //Advance the data through the delay line every clock cycle.
    generate
        for (c = `ADAPT_FILT_LENGTH-1; c > 0; c = c - 1) begin: inc_delay
            always @(posedge clk) begin
                if(en) delay_line[c] <= delay_line[c-1];
            end
        end
    endgenerate
    
    //Update with input data.
    always @(posedge clk) begin
        if(en) delay_line[0] <= din;
    end
    
    wire signed [31:0]num2[`ADAPT_FILT_LENGTH-1:0];
    wire signed [15:0]n1[`ADAPT_FILT_LENGTH-1:0];
    wire signed [15:0]n2[`ADAPT_FILT_LENGTH-1:0];
    
    //Update the coefficients with the LMS algorithm.
    generate
        for (c = `ADAPT_FILT_LENGTH; c > 0; c = c - 1) begin: adapt_update
            assign n1[c-1] = stepped[31:16];
            
            assign num2[c-1] = n1[c-1]*delay_line[c-1];
            assign n2[c-1] = num2[c-1][31:16];
            
            always @(posedge clk) begin
                if(en) coeff[c-1] <= coeff[c-1] + n2[c-1];
            end
        end
    endgenerate
endmodule
