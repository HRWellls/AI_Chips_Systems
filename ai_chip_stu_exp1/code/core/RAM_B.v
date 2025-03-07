`timescale 1ns / 1ps

module RAM_B(
    input [31:0] addra,
    input clka, 
    input[31:0] dina,
    input wea, 
    output[31:0] douta,
    input[2:0] access_type
);
  
    wire[31:0] MemDataOut;
    wire [3:0] mask;
    assign mask = (!wea) ? 4'b0000 : access_type[1] ? 4'b1111 : access_type[0] ? 4'b0011 : 4'b0001;

     xpm_memory_spram #(
      .ADDR_WIDTH_A(8),
      .BYTE_WRITE_WIDTH_A(8),
      .MEMORY_INIT_FILE("ram.mem"),
      .MEMORY_PRIMITIVE("block"),
      .MEMORY_SIZE(8192),
      .READ_DATA_WIDTH_A(32),
      .READ_LATENCY_A(1),
      .WRITE_DATA_WIDTH_A(32),
      .WRITE_MODE_A("read_first")
   )
   xpm_memory_spram_inst (
      .douta(MemDataOut),
      .addra(addra[9:2]), 
      .clka(clka), 
      .dina(dina), 
      .ena(1),
      .rsta(0), 
      .regcea(1),
      .sleep(0), 
      .wea(mask) 
   );

    wire [31:0] shiftedOut;
    assign shiftedOut = MemDataOut >> (addra[1:0] << 3);
    assign douta = (
        access_type == 0'd0 ? {{24{shiftedOut[7]}}, shiftedOut[7:0]} : 
        access_type == 0'd1 ? {{16{shiftedOut[15]}}, shiftedOut[15:0]} : 
        access_type == 0'd2 ? shiftedOut[31:0] :
        access_type == 0'd4 ? {24'd0, shiftedOut[7:0]} :
        access_type == 0'd5 ? {16'd0, shiftedOut[15:0]} : 32'd0
    );

endmodule