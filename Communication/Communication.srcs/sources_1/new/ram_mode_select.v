`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 06:22:00 AM
// Design Name: 
// Module Name: ram_mode_select
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


module ram_mode_select(
    input ram_mode,
    input ins_ram_mode,
    output reg [31:0] memory_size,
    output reg sel
    );
    
    always@(*)
        if ((ram_mode==1'b1) & (ins_ram_mode==1'b0))
            begin
            memory_size=32'd0;   //set max address to data
            sel = 1'b0;
            end
        else if ((ram_mode==1'b0) & (ins_ram_mode==1'b1))
            begin
            memory_size=32'd0;   //set max address to data
            sel = 1'b1;
            end
        else 
            begin
            memory_size=32'd0;   //set max address to data
            sel = 1'b0;
            end
endmodule
