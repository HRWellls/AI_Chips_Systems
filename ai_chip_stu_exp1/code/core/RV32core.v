`timescale 1ns / 1ps


module  RV32core(
        input clk,  // main clock
        input rst  // synchronous reset
    );

    wire branch, regWrite_ID, memWrite_ID, MIO_ID,
        ALUSrc_A_ID, ALUSrc_B_ID;
    wire [1:0] dataToReg_ID;
    wire [3:0] ALUControl_ID;

    wire forward_ctrl_ls;

    wire stall;
    wire [31:0] PC_IF, inst_IF;

    wire [31:0] jump_addr, PC_ID, inst_ID, imm_ID, rs1Data_ID, rs2Data_ID;
    
    wire reg_DE_flush, regWrite_EXE, memWrite_EXE, MIO_EXE;
    wire [1:0] dataToReg_EXE;
    wire [2:0] memAccType_ID, memAccType_EXE;
    wire [4:0] rs2Addr_ID, rs2Addr_EXE, rdAddr_ID, rdAddr_EXE;
    wire [31:0] ALUOut_EXE, PC_EXE, inst_EXE, memDataIn_EXE, MemDataOut_EXE, VDOTOut_EXE;

    wire regWrite_WB;
    wire [4:0] rdAddr_WB;
    wire [31:0] rdData_WB, PC_WB, inst_WB;


    wire[32*3-1:0] PC_out;
    wire[32*3-1:0] inst_out;
    wire[5*3-1:0]  rdAddr_out;
    wire[1*3-1:0]  regWrite_out;
    wire[32*3-1:0] DATA_out;
    wire[2*3-1:0]  op_type_out;
    wire[1*3-1:0]  ltype_out;

    assign PC_EXE = PC_out[31:0];
    assign inst_EXE = inst_out[31:0];

    wire [31:0] PC_EXE_Hazard;                    
    wire [31:0] inst_EXE_Hazard;                  
    wire [31:0] ALUOut_EXE_Hazard;                      
    wire [31:0] MemDataOut_EXE_Hazard;                      
    wire [31:0] VDOTOut_EXE_Hazard;                      
    wire [4:0]  rdAddr_EXE_Hazard;                   
    wire regWrite_EXE_Hazard;                      
    wire [2:0]  op_EXE_Hazard;                      
    wire [1:0]  dataToReg_tmp_EXE_Hazard;


    // IF stage
    IF_stage IF_stage(
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .jump_addr      (jump_addr),
        .branch         (branch),
        .PC_IF          (PC_IF),
        .inst_IF        (inst_IF)
    );

    // ID stage
    ID_stage ID_stage(
        .clk            (clk),              
        .rst            (rst),
        .regWrite_WB    (regWrite_WB),            
        .PC_IF          (PC_IF),                  
        .inst_IF        (inst_IF),                
        .rdData_WB      (rdData_WB),           
        .rdAddr_WB      (rdAddr_WB),                  
        .PC_out         (PC_out),
        .inst_out       (inst_out),
        .rdAddr_out     (rdAddr_out),
        .regWrite_out   (regWrite_out),
        .DATA_out       (DATA_out),
        .op_type_out    (op_type_out),
        .ltype_out  (ltype_out),

        .inst_ID        (inst_ID),                
        .PC_ID          (PC_ID),                  
        .rs1Data_ID     (rs1Data_ID),            
        .rs2Data_ID     (rs2Data_ID),            
        .rs2Addr_ID     (rs2Addr_ID),
        .rdAddr_ID      (rdAddr_ID),
        .jump_addr      (jump_addr),             
        .branch_ctrl    (branch),            
        .ALUSrc_A_ctrl  (ALUSrc_A_ID),          
        .ALUSrc_B_ctrl  (ALUSrc_B_ID),          
        .dataToReg_ctrl (dataToReg_ID),         
        .regWrite_ctrl  (regWrite_ID),          
        .memWrite_ctrl  (memWrite_ID),             
        .MIO_ctrl       (MIO_ID),               
        .ALUControl_ctrl(ALUControl_ID),
        .memAccType_ctrl(memAccType_ID),
        .stall          (stall),
        .reg_DE_flush   (reg_DE_flush), 
        .forward_ctrl_ls(forward_ctrl_ls),
        .imm_ID         (imm_ID)
    );


    // EX stage
    EXE_stage EXE_stage(
        .clk            (clk),                  
        .rst            (rst),               
        .reg_DE_flush   (reg_DE_flush),               
        .inst_ID        (inst_ID),                    
        .PC_ID          (PC_ID),                      
        .rs2Addr_ID     (rs2Addr_ID),
        .rs1Data_ID     (rs1Data_ID),                
        .rs2Data_ID     (rs2Data_ID),  
        .rdAddr_ID      (rdAddr_ID),              
        .imm_ID         (imm_ID),
        .ALUSrc_A_ID    (ALUSrc_A_ID),              
        .ALUSrc_B_ID    (ALUSrc_B_ID),              
        .ALUControl_ID  (ALUControl_ID),            
        .dataToReg_ID   (dataToReg_ID),             
        .regWrite_ID    (regWrite_ID),              
        .memWrite_ID    (memWrite_ID),                 
        .memAccType_ID  (memAccType_ID),
        .MIO_ID         (MIO_ID),

        // For hazard dection. You can simply ignore them. 
        .PC_EXE_Hazard       (PC_EXE_Hazard),                      
        .inst_EXE_Hazard     (inst_EXE_Hazard),                    
        .ALUOut_EXE_Hazard   (ALUOut_EXE_Hazard),                      
        .MemDataOut_EXE_Hazard   (MemDataOut_EXE_Hazard),                      
        .VDOTOut_EXE_Hazard  (VDOTOut_EXE_Hazard),                      
        .rdAddr_EXE_Hazard   (rdAddr_EXE_Hazard),                   
        .regWrite_EXE_Hazard (regWrite_EXE_Hazard),                       
        .op_EXE_Hazard       (op_EXE_Hazard),                      
        .dataToReg_tmp_EXE_Hazard (dataToReg_tmp_EXE_Hazard),

        .ALUOut_EXE     (ALUOut_EXE),
        .MemDataOut_EXE (MemDataOut_EXE),
        .VDOTOut_EXE    (VDOTOut_EXE),
        .dataToReg_EXE  (dataToReg_EXE)

    );

    // For hazard dection. We already implemented it so you don't need to modify it.
    EXE_Hazard EXE_Hazard(
        .clk            (clk),             
        .rst            (rst),
        .PC_EXE         (PC_EXE_Hazard),    
        .inst_EXE       (inst_EXE_Hazard),
        .ALUOut         (ALUOut_EXE_Hazard),
        .MemDataOut         (MemDataOut_EXE_Hazard),
        .VDOTOut        (VDOTOut_EXE_Hazard),
        .rdAddr_EXE     (rdAddr_EXE_Hazard),
        .regWrite_EXE   (regWrite_EXE_Hazard),
        .op_type        (op_EXE_Hazard),
        .dataToReg_tmp  (dataToReg_tmp_EXE_Hazard),

        .PC_out         (PC_out),
        .inst_out       (inst_out),
        .rdAddr_out     (rdAddr_out),
        .regWrite_out   (regWrite_out),
        .DATA_out       (DATA_out),
        .op_type_out    (op_type_out),
        .ltype_out      (ltype_out)
    );

    // WB stage
    WB_stage WB_stage(
        .clk            (clk),             
        .rst            (rst),
        .inst_EXE       (inst_out[95:64]),              
        .PC_EXE         (PC_out[95:64]),                
        .ALUOut_EXE     (ALUOut_EXE),
        .MemDataOut_EXE (MemDataOut_EXE), 
        .VDOTOut_EXE    (VDOTOut_EXE),       
        .rdAddr_EXE     (rdAddr_out[14:10]),                
        .dataToReg_EXE  (dataToReg_EXE),         
        .regWrite_EXE   (regWrite_out[2]),
        .PC_WB          (PC_WB),                 
        .inst_WB        (inst_WB),               
        .rdAddr_WB      (rdAddr_WB),                 
        .regWrite_WB    (regWrite_WB),
        .rdData_WB      (rdData_WB)
    );

endmodule