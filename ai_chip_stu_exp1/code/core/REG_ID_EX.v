`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS ID/EX Latch
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

module    REG_ID_EX(input clk,                                          //ID/EX Latch
                    input rst,
                    input EN,                                           
                    input flush,                                        
                    input [31:0] IR_in,                                 
                    input [31:0] PC_in,                                 
                    input [31:0] rs1Data_in,                            
                    input [31:0] rs2Data_in,                            
                    input [31:0] imm_in,                                
                    input [4:0]  rs2Addr_in,
                    input [4:0]  rdAddr_in,                             
                    input ALUSrc_A_in,                                  
                    input ALUSrc_B_in,                                  
                    input [3:0]  ALUControl_in,                         
                    input [1:0] dataToReg_in,                                 
                    input regWrite_in,                                  
                    input memWrite_in,                                  
                    input [2:0] memAccType_in,
                    input MIO_in,

                    output reg[31:0] PC_out,                            
                    output reg[31:0] IR_out,                            
                    output reg[31:0] rs1Data_out,                       
                    output reg[31:0] rs2Data_out,                       
                    output reg[31:0] imm_out,                           
                    output reg[4:0]  rs2Addr_out,
                    output reg[4:0]  rdAddr_out,                        
                    output reg       ALUSrc_A_out,                      
                    output reg       ALUSrc_B_out,                      
                    output reg[3:0]  ALUControl_out,                    
                    output reg[1:0]  dataToReg_out,                     
                    output reg       regWrite_out,                      
                    output reg       memWrite_out,                      
                    output reg[2:0]  memAccType_out,
                    output reg       MIO_out
                );

    always @(posedge clk or posedge rst) begin                           //ID/EX Latch
    if(rst) begin
        rs2Addr_out       <= 0;
        rdAddr_out        <= 0;
        regWrite_out      <= 0;
        memWrite_out      <= 0;
        IR_out            <= 32'h00000000;
        PC_out            <= 32'h00000000;
        MIO_out           <= 0;
    end
    else if(EN)begin
            if(flush)begin                                  
                IR_out          <= 32'h00000000;                
                rs2Addr_out     <= 0;
                rdAddr_out      <= 0;                           
                regWrite_out    <= 0;                          
                memWrite_out    <= 0;                           
                PC_out          <= PC_in;              
                MIO_out         <= 0;
            end
            else begin                                     
                PC_out              <= PC_in;                       
                IR_out              <= IR_in;                       
                rs1Data_out         <= rs1Data_in;                    
                rs2Data_out         <= rs2Data_in;                         
                imm_out             <= imm_in;                     
                rs2Addr_out         <= rs2Addr_in;
                rdAddr_out          <= rdAddr_in;                   
                ALUSrc_A_out        <= ALUSrc_A_in;                
                ALUSrc_B_out        <= ALUSrc_B_in;                  
                ALUControl_out      <= ALUControl_in;                
                dataToReg_out       <= dataToReg_in;                 
                regWrite_out        <= regWrite_in;                 
                memWrite_out        <= memWrite_in;                 
                memAccType_out      <= memAccType_in;
                MIO_out             <= MIO_in;
            end
        end
    end

endmodule