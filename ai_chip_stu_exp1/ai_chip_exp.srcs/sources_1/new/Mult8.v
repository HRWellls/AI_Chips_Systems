`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/07 14:24:31
// Design Name: 
// Module Name: Mult8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mult8(
    input clk,
    input rst,
    input EN,
    input[7:0] A, B,
    output[15:0] res
);

wire [7:0] multiA0B0, multiA0B1, multiA1B0, multiA1B1;
reg  [7:0] res00, res01, res10, res11;

Mult4 mult4_0(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[3:0]),
    .B(B[3:0]),
    .res(multiA0B0)
);

Mult4 mult4_1(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[3:0]),
    .B(B[7:4]),
    .res(multiA0B1)
);

Mult4 mult4_2(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[7:4]),
    .B(B[3:0]),
    .res(multiA1B0)
);

Mult4 mult4_3(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[7:4]),
    .B(B[7:4]),
    .res(multiA1B1)
);

always @(posedge clk or posedge rst) begin
    if(rst)begin
        res00 <= 8'b0;
        res01 <= 8'b0;
        res10 <= 8'b0;
        res11 <= 8'b0;
    end
    else if(EN)begin
        res00 <= multiA0B0;
        res01 <= multiA0B1;
        res10 <= multiA1B0;
        res11 <= multiA1B1;
    end
end

wire [15:0] res00_15, res01_15, res10_15, res11_15;

assign res00_15 = res00 << 0;
assign res01_15 = res01 << 4;
assign res10_15 = res10 << 4;
assign res11_15 = res11 << 8;

assign res = res00_15 + res01_15 + res10_15 + res11_15;
endmodule
