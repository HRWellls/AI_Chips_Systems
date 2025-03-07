`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS EX/WB Latch
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
module   REG_EX_WB(input clk,                                      //EX/WB Latch
                    input rst,
                    input EN,                                       
                    input [31:0] IR_in,                             
                    input [31:0] PC_in,                             
                    input [31:0] ALUOut_in,                         
                    input [31:0] memDataOut_in,  
                    input [31:0] VDOTOut_in,                   
                    input [1:0]  dataToReg_in,
                    input [4:0]  rdAddr_in,                                                     
                    input regWrite_in,                              
                    output reg[31:0] PC_out,                        
                    output reg[31:0] IR_out,                       
                    output reg[31:0] ALUOut_out,                    
                    output reg[31:0] memDataOut_out,  
                    output reg[31:0] VDOTOut_out,              
                    output reg[4:0]  rdAddr_out,                    
                    output reg[1:0]  dataToReg_out,                 
                    output reg       regWrite_out                   
                );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rdAddr_out     <= 0;
            regWrite_out   <= 0;
            VDOTOut_out    <= 0;
            IR_out         <= 0;
            PC_out         <= 0;
        end
        else if(EN)begin                                            
            IR_out         <= IR_in;
            PC_out         <= PC_in;                            
            ALUOut_out     <= ALUOut_in;                        
            memDataOut_out <= memDataOut_in;                   
            rdAddr_out     <= rdAddr_in;                       
            regWrite_out   <= regWrite_in;                      
            dataToReg_out  <= dataToReg_in;            
            VDOTOut_out    <=  VDOTOut_in;      
        end
    end

endmodule