`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    WB_stage
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module   WB_stage(input clk,                                 
                    input rst,                  
                    input [31:0] inst_EXE,                   
                    input [31:0] PC_EXE,                     
                    input [31:0] ALUOut_EXE,                 
                    input [31:0] MemDataOut_EXE,               
                    input [31:0] VDOTOut_EXE,               
                    input [4:0]  rdAddr_EXE,                     
                    input [1:0]  dataToReg_EXE,                
                    input regWrite_EXE,                      
                    output wire[31:0] PC_WB,                 
                    output wire[31:0] inst_WB,               
                    output wire[4:0]  rdAddr_WB,                 
                    output wire       regWrite_WB,           
                    output wire[31:0] rdData_WB
                );
    wire [1:0] dataToReg_WB;
    wire [31:0] ALUOut_WB, memDataOut_WB, VDOTOut_WB;
   
    REG_EX_WB REG_EX_WB(              //EX/WB Latch
        .clk            (clk),
        .rst            (rst),
        .EN             (1'b1),

        .PC_in          (PC_EXE),
        .IR_in          (inst_EXE),
        .ALUOut_in      (ALUOut_EXE),
        .memDataOut_in  (MemDataOut_EXE),
        .VDOTOut_in     (VDOTOut_EXE),
        .rdAddr_in      (rdAddr_EXE),
        .dataToReg_in   (dataToReg_EXE),
        .regWrite_in    (regWrite_EXE),

        .PC_out         (PC_WB),
        .IR_out         (inst_WB),
        .ALUOut_out     (ALUOut_WB),
        .memDataOut_out (memDataOut_WB),
        .VDOTOut_out    (VDOTOut_WB),
        .rdAddr_out     (rdAddr_WB),
        .dataToReg_out  (dataToReg_WB),
        .regWrite_out   (regWrite_WB)
    );
    
    MUX4T1_32 mux_WB(       
        .I0             (memDataOut_WB),
        .I1             (VDOTOut_WB),   
        .I2             (ALUOut_WB), 
        .I3             (32'd0), 
        .s              (dataToReg_WB),
        .o              (rdData_WB)
    );

endmodule