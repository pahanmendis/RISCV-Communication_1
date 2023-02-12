`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 06:45:59 AM
// Design Name: 
// Module Name: top_wrapper
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


module top_wrapper(
    input clk,
    input uart_tx,
    input uart_rx,
    input button,
    input [2:0] switch
    );
    
    wire reciever_status,processor_status,processor_complete,tx_status,ram_mode,tx_start,processor_start,ins_ram_mode;
    wire o_Rx_Data_valid,i_Tx_DV,o_Tx_Active,o_Tx_Serial,o_Tx_Done, w_en_global,sel;
    wire [7:0] o_Rx_Byte,i_Tx_Byte,write_data;
    wire [31:0] address, memory_size; 
    
    main_controller  controller_fsm(    .clk(clk),    .reciever_status(reciever_status),    .processor_status(processor_status),    .processor_complete(processor_complete),    .tx_status(tx_status),    .reset(button),
                                        .mode_select(switch),    .ram_mode(ram_mode),    .ins_ram_mode(ins_ram_mode),    .tx_start(tx_start),    .processor_start(processor_start)    );
    
    uart_rx     uart_rx_i(   .clk(clk),   .i_Rx_Serial(uart_rx),   .o_Rx_DV(o_Rx_Data_valid),   .o_Rx_Byte(o_Rx_Byte)   ); 
    
    uart_tx     uart_tx_i(   .i_Clock(clk),   .i_Tx_DV(i_Tx_DV),   .i_Tx_Byte(i_Tx_Byte),    .o_Tx_Active(o_Tx_Active),   .o_Tx_Serial(o_Tx_Serial),   .o_Tx_Done(o_Tx_Done)   );  
    
    data_writer         data_writer_i( .clk(clk),     .Rx_tick(o_Rx_Data_valid),  .Din(o_Rx_Byte) ,   . Wen(w_en_global)          ,.Addr(address)  ,.Dout(write_data)   , .fin(tx_status)   ,.memory_size(memory_size));
    
    ram_mode_select ram_mode_select_i(    .ram_mode(ram_mode),    .ins_ram_mode(ins_ram_mode),    .memory_size(memory_size),    .sel(sel)    );
    
    mux_ram(    .sel(sel),    .address(address),    .dout(write_data),    .w_en(w_en_global)
//    output reg [31:0] I_ram_addr,
//    output reg [7:0] I_data,
//    output reg I_w_en,
//    output reg [31:0] D_ram_addr,
//    output reg [7:0] D_data,
//    output reg D_w_en
    );
                                     
endmodule
