`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    ID_stage
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
module   ID_stage(input clk,                                 
                    input rst,
                    input regWrite_WB,                       
                    input [31:0] PC_IF,                      
                    input [31:0] inst_IF,                    
                    input [31:0] rdData_WB,                          
                    input [4:0]  rdAddr_WB,                      
                    input wire[32*3-1:0] PC_out,
                    input wire[32*3-1:0] inst_out,
                    input wire[5*3-1:0]  rdAddr_out,
                    input wire[1*3-1:0]  regWrite_out,
                    input wire[32*3-1:0] DATA_out,
                    input wire[2*3-1:0]  op_type_out,
                    input wire[1*3-1:0]  ltype_out,
                    output wire[31:0] inst_ID,               
                    output wire[31:0] PC_ID,        
                    output wire[4:0]  rs2Addr_ID,         
                    output wire[31:0] rs1Data_ID,           
                    output wire[31:0] rs2Data_ID,           
                    output wire[4:0]  rdAddr_ID,
                    output wire[31:0] jump_addr,           
                    output wire       branch_ctrl,           
                    output wire       ALUSrc_A_ctrl,         
                    output wire       ALUSrc_B_ctrl,         
                    output wire[1:0]  dataToReg_ctrl,        
                    output wire       regWrite_ctrl,        
                    output wire       memWrite_ctrl,            
                    output wire       MIO_ctrl,
                    output wire[3:0]  ALUControl_ctrl,
                    output wire[2:0]  memAccType_ctrl,
                    output wire       stall,          
                    output wire       reg_DE_flush,  
                    output wire       forward_ctrl_ls,
                    output wire[31:0] imm_ID
                );

    wire reg_FD_flush, cmp_res_ID, JALR;
    wire[1:0] forward_ctrl_A, forward_ctrl_B;
    wire[2:0] ImmSel_ctrl, cmp_ctrl;
    wire [31:0] rs1_data_reg, rs2_data_reg, addA_ID;
    wire [4:0] rs1Addr_ID;

    // IF/ID Register
    REG_IF_ID reg_IF_ID(
        .clk            (clk),
        .rst            (rst),
        .EN             (1'b1),
        // When data hazard appears, the reg must stall for 1 cycle 
        // and wait for data to be ready.
        .Data_stall     (stall),
        // When control hazard appears, i.e. a jump inst will be executed, 
        // the reg must be flush and wait for new jump_addr.
        .flush          (reg_FD_flush),
        // Data inputs and outputs. 
        .PC_in          (PC_IF),
        .IR_in          (inst_IF),
        .PC_out         (PC_ID),
        .IR_out         (inst_ID)
    );

    // Extract RS1/RS2/RD fields from instruction.
    // Please set each field to 0(x0) if the field is not available.
    // This will simplify the hazard unit logic.

    assign rdAddr_ID  = (inst_ID[6:0] == 7'h23 || inst_ID[6:0] == 7'h63) 
                        ? 5'd0 : inst_ID[11:7];
    assign rs1Addr_ID = (inst_ID[6:0] == 7'h17 || inst_ID[6:0] == 7'h37 || inst_ID[6:0] == 7'h6f) 
                        ? 5'd0 : inst_ID[19:15];
    assign rs2Addr_ID = (inst_ID[6:0] == 7'h13 || inst_ID[6:0] == 7'h17 || inst_ID[6:0] == 7'h37 
                        || inst_ID[6:0] == 7'h67 || inst_ID[6:0] == 7'h6f) 
                        ? 5'd0 : inst_ID[24:20];

    // Extrace memory access type (func3 of load/store instructions)
    assign memAccType_ID = inst_ID[14:12];
    
    // The instruction decoder
    CtrlUnit ctrl(
        // Inputs
        .inst           (inst_ID),              // Input instruction.
        .cmp_res        (cmp_res_ID),           // result for B type compare.
        // Outputs
        .Branch         (branch_ctrl),          // whether to move PC.
        .ALUSrc_A       (ALUSrc_A_ctrl),        // 0 for rs1 data, 1 for using PC (JAL/JALR/AUIPC).
        .ALUSrc_B       (ALUSrc_B_ctrl),        // 0 for using rs2 data, 1 for using immediate number.
        .dataToReg      (dataToReg_ctrl),       // Which data as reg file input. 0 for ALU result, 1 for dataMem output.
        .regWrite       (regWrite_ctrl),        // Whether to write data back to reg file.
        .memWrite       (memWrite_ctrl),        // Whether to write data memory.
        .MIO            (MIO_ctrl),             // Debug signal, not drwan in figure.
        .ImmSel         (ImmSel_ctrl),          // To tell immediate generator how to extrace immediate from instruction. Not drawn in figure.
        .cmp_ctrl       (cmp_ctrl),             // Compare type of B-type instructions, as the input of compare unit. Not drawn in figure.
        .ALUControl     (ALUControl_ctrl),      // ALU calculation type. 
        .memAccType     (memAccType_ctrl),      // Memory access size and signedness.
        .JALR           (JALR)                  // Used by JALR instruction. Whether move PC to rs1+imm.
    );
    
    // Reg File, including x0~x31
    Regs register(
        .clk            (clk),
        .rst            (rst),
        .L_S            (regWrite_WB),
        .R_addr_A       (rs1Addr_ID),
        .R_addr_B       (rs2Addr_ID),
        .rdata_A        (rs1_data_reg),
        .rdata_B        (rs2_data_reg),
        .Wt_addr        (rdAddr_WB),
        .Wt_data        (rdData_WB)
    );

    // Immediate generator
    ImmGen imm_gen(
        .ImmSel         (ImmSel_ctrl),
        .inst_field     (inst_ID),
        .Imm_out        (imm_ID)
    );
    
    // RS1 data forwarding multiplexer
    MUX4T1_32 mux_forward_A(
        .I0             (rs1_data_reg),
        .I1             (DATA_out[31:0]),
        .I2             (DATA_out[63:32]),
        .I3             (DATA_out[95:64]),
        .s              (forward_ctrl_A),
        .o              (rs1Data_ID)
    );
    
    // RS2 data forwarding multiplexer
    MUX4T1_32 mux_forward_B(
        .I0             (rs2_data_reg),
        .I1             (DATA_out[31:0]),
        .I2             (DATA_out[63:32]),
        .I3             (DATA_out[95:64]),
        .s              (forward_ctrl_B),
        .o              (rs2Data_ID)
    );
    
    // PC jump multiplexer
    MUX2T1_32 mux_branch_ID(
        .I0             (PC_ID),
        .I1             (rs1Data_ID),
        .s              (JALR),
        .o              (addA_ID)
    );

    // PC plus immediate
    add_32 add_branch_ID(
        .a              (addA_ID),
        .b              (imm_ID),
        .c              (jump_addr)
    );

    // Compare rs1 and rs2, which is for branch instructions
    cmp_32 cmp_ID(
        .a              (rs1Data_ID),
        .b              (rs2Data_ID),
        .ctrl           (cmp_ctrl),
        .c              (cmp_res_ID)
    );




    /*

    MUX2T1_32 mux_A_EXE(           // ALUA selection module
        .I0             (rs1Data_EXE),
        .I1             (PC_EXE),
        .s              (ALUSrc_A_EXE),
        .o              (ALUA_EXE)
    );

    MUX2T1_32 mux_B_EXE(            // ALUB selection module
        .I0             (rs2Data_EXE),
        .I1             (imm_exe),
        .s              (ALUSrc_B_EXE),
        .o              (ALUB_EXE)
    );

    */

    // Pipeline CPU forwarding and hazard control unit
    // In the figure, forwarding and hazard detection are done in respective modules,
    // in this inplementation we combine the 2 functions in one module.

    HazardDetectionUnit hazard_unit(
        .clk                (clk),
        .Branch_ID          (branch_ctrl),
        .rs1Addr_ID         (rs1Addr_ID),
        .rs2Addr_ID         (rs2Addr_ID),
        .rdAddr_out_EXE     (rdAddr_out),
        .regWrite_out_EXE   (regWrite_out),
        .op_type_out_EXE    (op_type_out),
        .ltype_out_EXE      (ltype_out),       
        // Output signals
        .stall              (stall),            // When forwarding cannot solve the data hazard, 
        .reg_DE_flush       (reg_DE_flush),     // stall PC and IF/ID reg for 1 cycle and flush ID/EXE reg.
        .reg_FD_flush       (reg_FD_flush),     // When control hazard appears, i.e. branch condition met, flush IF/ID reg.
        .forward_ctrl_A     (forward_ctrl_A),   // Control the source of rs1Data.
        .forward_ctrl_B     (forward_ctrl_B)    // Control the source of rs2Data.
    );

endmodule