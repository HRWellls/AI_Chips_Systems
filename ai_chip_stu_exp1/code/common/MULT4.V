` timescale 1ns / 1ps

module Mult4(
    input clk,                                        
    input rst,
    input EN,                                           
    input[3:0] A, B,
    output[7:0] res
);
    
    wire [7:0] A0,A1,A2,A3;
    assign A0[3:0] = A;
    assign A0[7:4] = 4'b0;
    assign A1 = A0 << 1;
    assign A2 = A0 << 2;
    assign A3 = A0 << 3;

    assign res = ({8{B[0]}} & A0) + ({8{B[1]}} & A1) + ({8{B[2]}} & A2) + ({8{B[3]}} & A3);


endmodule