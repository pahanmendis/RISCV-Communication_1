`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2023 06:38:01 AM
// Design Name: 
// Module Name: mux_ram
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


module mux_ram(
    input sel,
    input [31:0] address,
    input [7:0] dout,
    input w_en,
    output reg [31:0] I_ram_addr,
    output reg [7:0] I_data,
    output reg I_w_en,
    output reg [31:0] D_ram_addr,
    output reg [7:0] D_data,
    output reg D_w_en
    );
    
    always @(*)
    if (sel==1'b0)    //set data ram
        begin
        I_ram_addr<=32'd0;
        I_data<=8'd0;
        I_w_en<=1'b0;
        D_ram_addr<=address;
        D_data<=dout;
        D_w_en<=w_en;
        end
    else if (sel==1'b1)   //set instruction ram
        begin
        I_ram_addr<=address;
        I_data<=dout;
        I_w_en<=w_en;
        D_ram_addr<=32'd0;
        D_data<=8'd0;
        D_w_en<=1'b0;
        end
    else
        begin
        I_ram_addr<=32'd0;
        I_data<=8'd0;
        I_w_en<=1'b0;
        D_ram_addr<=32'd0;
        D_data<=8'd0;
        D_w_en<=1'b0;
        end            
        
endmodule
