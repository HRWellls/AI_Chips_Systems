`timescale 1ns / 1ps

module   EXE_Hazard(
                    input clk,                                 
                    input rst,
                    input [31:0] PC_EXE,                      
                    input [31:0] inst_EXE,                    
                    input [31:0] ALUOut,                      
                    input [31:0] MemDataOut,                      
                    input [31:0] VDOTOut,                      
                    input [4:0]  rdAddr_EXE,                   
                    input regWrite_EXE,                       
                    input [2:0]  op_type,                      
                    input [1:0]  dataToReg_tmp,                
                    output wire[32*3-1:0] PC_out,
                    output wire[32*3-1:0] inst_out,
                    output wire[5*3-1:0]  rdAddr_out,
                    output wire[1*3-1:0]  regWrite_out,
                    output wire[32*3-1:0] DATA_out,
                    output wire[2*3-1:0]  op_type_out,
                    output wire[1*3-1:0]  ltype_out
                );


    reg[31:0] PC_out_reg [0:1];
    reg[31:0] IR_out_reg [0:1];
    reg[31:0] DATA_out_reg [0:1];
    reg[4:0]  rdAddr_out_reg [0:1];
    reg       regWrite_out_reg [0:1];
    reg[1:0]  op_type_reg [0:1];
    reg       ltype_out_reg [0:1];
    integer i;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for (i = 0;i<2;i=i+1 ) begin
                PC_out_reg[i]         <= 0;
                IR_out_reg[i]         <= 0;
                DATA_out_reg[i]       <= 0;
                rdAddr_out_reg[i]     <= 0;
                regWrite_out_reg[i]   <= 0;
                op_type_reg[i]        <= 0;
                ltype_out_reg[i]  <= 0;
            end
        end
        else begin
            PC_out_reg[1]         <= PC_out_reg[0];
            IR_out_reg[1]         <= IR_out_reg[0];
            
            rdAddr_out_reg[1]     <= rdAddr_out_reg[0];
            regWrite_out_reg[1]   <= regWrite_out_reg[0];
            op_type_reg[1]        <= op_type_reg[0];
            ltype_out_reg[1]  <= ltype_out_reg[0];
            
            PC_out_reg[0]         <= PC_EXE;
            IR_out_reg[0]         <= inst_EXE;
            rdAddr_out_reg[0]     <= rdAddr_EXE;
            regWrite_out_reg[0]   <= regWrite_EXE;
            op_type_reg[0]        <= op_type;
            ltype_out_reg[0]  <= dataToReg_tmp;
            if(op_type_reg[0] == 2'b01) begin
                DATA_out_reg[1]   <= MemDataOut;
            end
            else begin
                DATA_out_reg[1]       <= DATA_out_reg[0];
            end
            if(op_type == 2'b00) begin
                DATA_out_reg[0]   <= ALUOut;
            end
            else begin
                DATA_out_reg[0]       <= 0;
            end
        end
    end
    

    assign PC_out[31:0] = PC_EXE;
    assign inst_out[31:0] = inst_EXE;
    assign rdAddr_out[4:0] = rdAddr_EXE;
    assign regWrite_out[0] = regWrite_EXE;
    assign DATA_out[31:0] = ALUOut;
    assign op_type_out[1:0] = op_type;
    assign ltype_out[0] = (dataToReg_tmp == 2'd0);

    assign PC_out[32*2-1:32] = PC_out_reg[0];
    assign inst_out[32*2-1:32] = IR_out_reg[0];
    assign rdAddr_out[5*2-1:5] = rdAddr_out_reg[0];
    assign regWrite_out[1] = regWrite_out_reg[0];
    assign DATA_out[32*2-1:32] = (op_type_reg[0] == 2'b01) ? MemDataOut : DATA_out_reg[0];
    assign op_type_out[3:2] = op_type_reg[0];
    assign ltype_out[1] = ltype_out_reg[0];

    assign PC_out[32*3-1:32*2] = PC_out_reg[1];
    assign inst_out[32*3-1:32*2] = IR_out_reg[1];
    assign rdAddr_out[5*3-1:5*2] = rdAddr_out_reg[1];
    assign regWrite_out[2] = regWrite_out_reg[1];
    assign DATA_out[32*3-1:32*2] = (op_type_reg[1] == 2'b10) ? VDOTOut : DATA_out_reg[1];
    assign op_type_out[5:4] = op_type_reg[1];
    assign ltype_out[2] = ltype_out_reg[1];



endmodule