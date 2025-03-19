` timescale 1ns / 1ps

module Vdot(
    input clk,                                        
    input rst,
    input EN,                                           
    input[31:0] A, B,
    output[31:0] res
);

// [Topic 1] Please finish the code of vector dot product that requires 3 cycles for execution.

// You may add some code here...
wire [15:0] multi0, multi1, multi2, multi3;
reg  [15:0] res0, res1, res2, res3;

Mult8 mult8_0(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[7:0]),
    .B(B[7:0]),
    .res(multi0)
);

Mult8 mult8_1(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[15:8]),
    .B(B[15:8]),
    .res(multi1)
);

Mult8 mult8_2(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[23:16]),
    .B(B[23:16]),
    .res(multi2)
);

Mult8 mult8_3(
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .A(A[31:24]),
    .B(B[31:24]),
    .res(multi3)
);

always@(posedge clk or posedge rst) begin
    if(rst)begin
        res0 <= 32'b0;
        res1 <= 32'b0;
        res2 <= 32'b0;
        res3 <= 32'b0;
    end
    else if(EN)begin
        res0 <= multi0;
        res1 <= multi1;
        res2 <= multi2;
        res3 <= multi3;
    end
end


assign res = res0 + res1 + res2 + res3;

endmodule