`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    IF_stage
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
module   IF_stage(input clk,                                 
                    input rst,
                    input stall,                          
                    input branch,                       
                    input [31:0] jump_addr,                 
                    output wire[31:0] PC_IF,                 
                    output wire[31:0] inst_IF                
                );

    wire [31:0] next_PC, PC_plus4;

    REG32 REG_PC(               //CPU instruction output
        .clk        (clk),
        .rst        (rst),
        .CE         (~stall),
        .D          (next_PC),
        .Q          (PC_IF)
    );
    
    add_32 add_IF(              //Instruction address increasing module
        .a          (PC_IF),
        .b          (32'd4),
        .c          (PC_plus4)
    );

    MUX2T1_32 mux_IF(           //Instruction address jump selection module
        .I0         (PC_plus4),
        .I1         (jump_addr),
        .s          (branch),
        .o          (next_PC)
    );

    ROM_D inst_rom(             //Instruction memory
        .a          (PC_IF[8:2]),
        .spo        (inst_IF)
    );

endmodule