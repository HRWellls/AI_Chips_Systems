`timescale 1ps/1ps

module HazardDetectionUnit(
    input clk,
    input Branch_ID,
    input [4:0] rs1Addr_ID, rs2Addr_ID,

    input wire[5*3-1:0]  rdAddr_out_EXE,
    input wire[1*3-1:0]  regWrite_out_EXE,
    input wire[2*3-1:0]  op_type_out_EXE,
    input wire[1*3-1:0]  ltype_out_EXE,

    output stall, reg_FD_flush, reg_DE_flush,
    output [1:0] forward_ctrl_A, forward_ctrl_B
);



    wire rs1_forward_stall1 = (rdAddr_out_EXE[4:0] == rs1Addr_ID) && (rdAddr_out_EXE[4:0] != 'd0) && regWrite_out_EXE[0]
                             && ((op_type_out_EXE[1:0] == 2'b01 && ltype_out_EXE[0])||(op_type_out_EXE[1:0] == 2'b10));
    wire rs1_forward_stall2 = (rdAddr_out_EXE[9:5] == rs1Addr_ID) && (rdAddr_out_EXE[9:5] != 'd0) && regWrite_out_EXE[0]
                             && (op_type_out_EXE[3:2] == 2'b10);                         
    wire rs1_forward_1     = (rdAddr_out_EXE[4:0] == rs1Addr_ID) && (rdAddr_out_EXE[4:0] != 'd0) && regWrite_out_EXE[0] && !rs1_forward_stall1;
    wire rs1_forward_2     = (rdAddr_out_EXE[9:5] == rs1Addr_ID) && (rdAddr_out_EXE[9:5] != 'd0) && regWrite_out_EXE[1] && !rs1_forward_stall2 && !rs1_forward_1;
    wire rs1_forward_3     = (rdAddr_out_EXE[14:10] == rs1Addr_ID) && (rdAddr_out_EXE[14:10] != 'd0) && regWrite_out_EXE[2] && !rs1_forward_1 && !rs1_forward_2; 


    wire rs2_forward_stall1 = (rdAddr_out_EXE[4:0] == rs2Addr_ID) && (rdAddr_out_EXE[4:0] != 'd0) && regWrite_out_EXE[0]
                             && ((op_type_out_EXE[1:0] == 2'b01 && ltype_out_EXE[0])||(op_type_out_EXE[1:0] == 2'b10));
    wire rs2_forward_stall2 = (rdAddr_out_EXE[9:5] == rs2Addr_ID) && (rdAddr_out_EXE[9:5] != 'd0) && regWrite_out_EXE[0]
                                && (op_type_out_EXE[3:2] == 2'b10);
    wire rs2_forward_1     = (rdAddr_out_EXE[4:0] == rs2Addr_ID) && (rdAddr_out_EXE[4:0] != 'd0) && regWrite_out_EXE[0] && !rs2_forward_stall1;
    wire rs2_forward_2     = (rdAddr_out_EXE[9:5] == rs2Addr_ID) && (rdAddr_out_EXE[9:5] != 'd0) && regWrite_out_EXE[1] && !rs2_forward_stall2 && !rs2_forward_1;
    wire rs2_forward_3     = (rdAddr_out_EXE[14:10] == rs2Addr_ID) && (rdAddr_out_EXE[14:10] != 'd0) && regWrite_out_EXE[2] && !rs2_forward_1 && !rs2_forward_2;

    wire load_stall        = rs1_forward_stall1 | rs1_forward_stall2 | rs2_forward_stall1 | rs2_forward_stall2;

    assign stall           = load_stall;
    assign reg_FD_flush    = Branch_ID;
    assign reg_DE_flush    = load_stall;

    assign forward_ctrl_A  = {2{rs1_forward_1}} & 2'd1 |
                             {2{rs1_forward_2}} & 2'd2 |
                             {2{rs1_forward_3}} & 2'd3 ;

    assign forward_ctrl_B  = {2{rs2_forward_1}} & 2'd1 |
                             {2{rs2_forward_2}} & 2'd2 |
                             {2{rs2_forward_3}} & 2'd3 ;



endmodule