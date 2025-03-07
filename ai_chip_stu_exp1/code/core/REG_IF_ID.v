`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS IF/ID Latch
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

module    REG_IF_ID(input clk,                                      //IF/ID Latch
                    input rst,
                    input EN,                                      
                    input Data_stall,                               
                    input flush,                                   
                    input [31:0] PC_in,                             
                    input [31:0] IR_in,                             

                    output reg[31:0] PC_out,                       
                    output reg[31:0] IR_out                        
                );

//reg[31:0]PC_out,IR_out;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IR_out <= 32'h00000000;                            
            PC_out <= 32'h00000000;                     
        end
        else if(EN)begin
            if(Data_stall)begin
                IR_out <= IR_out;                 //IR_in waiting for Data Hazards 
                PC_out <= PC_out;  end            
            else if(flush)begin
                IR_out <= 32'h00000013;       //IR_in waiting for Control Hazards 
                PC_out <= PC_out;  end        
            else begin
                IR_out <= IR_in;             
                PC_out <= PC_in;  end         
            end
        else begin
            IR_out <= IR_out;
            PC_out <= PC_out;
        end
    end

endmodule