`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 03:52:38 AM
// Design Name: 
// Module Name: main_controller
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


module main_controller(
    input clk,
    input reciever_status,
    input processor_status,
    input processor_complete,
    input tx_status,
    input reset,
    input [2:0] mode_select,
    output reg ram_mode,
    output reg ins_ram_mode,
    output reg tx_start,
    output reg processor_start
    );
    
    reg [2:0] state;
    parameter idle = 3'b000;
    parameter instruction_load = 3'b001;
    parameter data_load = 3'b010;
    parameter data_transfer = 3'b011;
    parameter processor_execute = 3'b100;
    
    always @(posedge clk)
    begin
        if (reset==1'b1)
            begin
            state<=idle;
            ram_mode<=1'b0;
            ins_ram_mode<=1'b0;
            tx_start<=1'b0;
            processor_start<=1'b0; 
            end 
        else         
            case (state)
            idle:
                  
                    if (mode_select==3'b001)
                        state<=instruction_load;
                    else if (mode_select==3'b010)
                        state<=data_load;
                    else if (mode_select==3'b011)
                        state<=data_transfer;
                    else if (mode_select==3'b100)
                        state<=processor_execute;
                    else
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0;  
                        state<=idle;
                        end
             instruction_load:
                  
                    if (reciever_status==1'b1)
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0; 
                        state<=idle;
                        end
                    else
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b1;
                        tx_start<=1'b0;
                        processor_start<=1'b0;  
                        state<=instruction_load;
                        end       
             data_load:
                  
                    if (reciever_status==1'b1)
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0; 
                        state<=idle;
                        end
                    else
                        begin
                        ram_mode<=1'b1;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0;  
                        state<=data_load;
                        end
                        
              data_transfer:
                  
                    if (tx_status==1'b1)
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0; 
                        state<=idle;
                        end
                    else
                        begin
                        ram_mode<=1'b1;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b1;
                        processor_start<=1'b0;  
                        state<=data_transfer;
                        end
                        
                processor_execute:
                  
                    if ((processor_complete==1'b1) && (processor_status==1'b0))    //processor complete
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0; 
                        state<=idle;
                        end
                       
                    else if((processor_complete==1'b0) && (processor_status==1'b0))    //processor ready to execute
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b1;  
                        state<=processor_execute;
                        end 
                    else     //processor busy
                        begin
                        ram_mode<=1'b0;
                        ins_ram_mode<=1'b0;
                        tx_start<=1'b0;
                        processor_start<=1'b0;  
                        state<=processor_execute;
                        end                         
                                
             endcase
    end 
                         
    
    
endmodule
