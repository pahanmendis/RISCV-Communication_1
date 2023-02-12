`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 02:25:20 AM
// Design Name: 
// Module Name: RISCV_processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RISCV_processor(
    input clk,
//    input IF_clk,
//    input ID_clk,
//    input EX_clk,
//    input MEM_clk,
//    input WB_clk,
    output [29:0] program_counter_external,
    input [31:0] instruction,
    output [1:0] mem_write,    
    output [1:0] mem_read,    
    output [31:0] C_bus_external,        //check if possible    
    output [31:0] rs2_data_external,    //check if possible
    input [31:0] read_data
    
    );

//reg IF_clk;
reg ID_clk;
reg EX_clk;
reg MEM_clk;
reg WB_clk;    
    
//wire declarations  
wire [31:0] program_counter,  write_data, pc_update_out;

wire [31:0] rs1_data,rs2_data,immediate_data,B_bus,C_bus, pc_add4;

wire [4:0] ALU_op;

//program_counter <= 32'b0;

//flags
wire z_flag,p_flag,n_flag;
//control signals 
wire [1:0] extend;
wire [2:0] im_slice;
wire alu_source;
wire [1:0] branch;
wire [2:0] to_reg;
//wire [1:0] mem_read;
//wire [1:0] mem_write;
wire reg_write;  

assign rs2_data_external=rs2_data;
assign program_counter_external=program_counter[31:2];
assign C_bus_external=C_bus;




//instruction_mem intruction_memory   (    .IF_clk(IF_clk),    .instruction_address(program_counter[31:2]),    .instruction(instruction)    );

//data_mem            data_memory     (   .MEM_clk(MEM_clk),  .mem_write(mem_write),    .mem_read(mem_read),    .data_address(C_bus),    .write_data(rs2_data),    .read_data(read_data)  );  

program_counter     pc              (    .WB_clk(WB_clk),    .pc_input(pc_update_out),    .pc_output(program_counter)    );

register_memory     reg_memory      (.ID_clk(ID_clk), .WB_clk(WB_clk), .reg_write(reg_write), .rs1_addr(instruction[19:15]), .rs2_addr(instruction[24:20]), .rd_addr(instruction[11:7]),  .write_data(write_data),  .rs1_data(rs1_data),    .rs2_data(rs2_data)    );

immediate_data_gen  immediate_data_generator( .ID_clk(ID_clk),   .extend(extend),    .im_slice(im_slice),    .instruction_in(instruction),    .imm_data(immediate_data)    );

ALU_control_gen     ALU_controls    (    .instruction(instruction),    .ALU_op(ALU_op)    );

control_unit        CU              (   .ID_clk(ID_clk),   .opcode(instruction[6:0]),   .func3(instruction[14:12]),  .im_slice(im_slice),  .extend(extend),
                                    .alu_source(alu_source),   .branch(branch),    .to_reg(to_reg),  .mem_read(mem_read),    .mem_write(mem_write),  .reg_write(reg_write)    );

mux_2               mux2            (    .A(rs2_data), .B(immediate_data),     .sel(alu_source),    .out(B_bus)    );                

ALU                 ALU1            (   .EX_clk(EX_clk),    .A(rs1_data),    .B(B_bus),    .ALU_op(ALU_op),    .z_flag(z_flag),    .p_flag(p_flag),    .n_flag(n_flag),    .out(C_bus)    );



mux_4               mux4            (    .A(immediate_data),     .B(C_bus),     .C(read_data),     .D(pc_add4),     .sel(to_reg),   .out(write_data)    );         

pc_update           pc_update1      (    .MEM_clk(MEM_clk), .program_counter(program_counter),    .immediate_data(immediate_data),    .c_bus(C_bus),    .pc_update_out(pc_update_out),    .branch(branch),    .z_flag(z_flag),    .p_flag(p_flag),    .n_flag(n_flag)    );

Adder_4             add4            (    .MEM_clk(MEM_clk),    .pc_in(pc_update_out),      .branch(branch),    .pc_add_4(pc_add4)    );

endmodule
