`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
The instruction memory module, triggered at the positive edge of the IF clock 
Function:   Stores the instructions of the program in sequence and passes to the processor one-by-one
Inputs:     32-bit instruction address 
Outputs:    32-bitinstruction
*/
//////////////////////////////////////////////////////////////////////////////////


module instruction_mem(
    input clk,
    input [29:0] instruction_address,   // 30-bit wide, the 2 LSB of the 32-bit address are ignored
    output reg [31:0] instruction_out,
    output reg ins_ready       
    );
    
    parameter instruction_count = 200;         // number of instructions
    reg [31:0] instruction_rom [instruction_count:0]; // creating memory  
       
    always @(posedge clk)
        begin
         ins_ready <= 1'b0;
         instruction_out <= instruction_rom[instruction_address];  // output the instruction 
         ins_ready <= 1'b1;
        end
        
    initial 
        begin
            //inst_ram[0] = instruction  
            instruction_rom[0] = 32'b000000001001_00000_000_00101_0010011;      // addi x5,x0,9    # a = 9
            instruction_rom[1] = 32'b000000000011_00000_000_00110_0010011;      // addi x6,x0,3    # b = 3
            instruction_rom[2] = 32'b0000000_00110_00101_000_00111_0110011;     // add x7,x5,x6    # x7 = a + b
            instruction_rom[3] = 32'b0100000_00110_00101_000_00101_0110011;     // sub x5,x5,x6    # a = a - b 
            instruction_rom[4] = 32'b111111111111_00101_000_00101_0010011;      // addi x5,x5,-1   # a  = a - 1
            instruction_rom[5] = 32'b0000000_00110_00101_010_00111_0110011;     // slt x7,x5,x6    # c = a < b ? 1:0
            instruction_rom[6] = 32'b001111101000_00111_000_00111_0010011;      // addi x7,x7,1000   # add 1000 to x7
            instruction_rom[7] = 32'b0000000_00111_00000_010_00100_0100011;     // sw x7,4(x0)     # store c in memory
            instruction_rom[8] = 32'b000000000100_00110_010_00111_0010011;      // slti x7,x6,4    # c = b < 4 ? 1:0
            instruction_rom[9] = 32'b00000000000000000011_11100_0110111;        // lui x28,3       # x28 = 3 << 12
          //instruction_rom[10] = 32'b00000000000000000001_11101_0010111;     // auipc x29,0     # x29 = pc(4 x 10) + 3 << 12 (12288)
            instruction_rom[10] = 32'b011111010000_00000_000_00111_0010011;     // addi x7,x0, 2000 # x7 = 2000
            instruction_rom[11] = 32'b0000000_00000_00101_000_00100_1100011;    // beq x5,x0,8    # if x5 == x0 jump 2 steps
            instruction_rom[12] = 32'b000000000001_00101_000_00101_0010011;     // addi x5,x5,1    # x5 = x5 + 1
            instruction_rom[13] = 32'b000000000010_00101_000_00101_0010011;     // addi x5,x5,2    # x5 = x5 + 2
            instruction_rom[14] = 32'b0000000_00000_00101_001_00100_1100011;    // bne x5,x0,8     # if x5 != x0 jump 2 steps
            instruction_rom[15] = 32'b000000000110_00101_000_00101_0010011;     // addi x5,x5,6    # x5 = x5 + 6
            instruction_rom[16] = 32'b000000000001_00110_000_00110_0010011;     // addi x6,x6,1    # x6 = x6 + 1
            instruction_rom[17] = 32'b0000000_00110_00101_101_00100_1100011;    // bge x5,x6,8     # if x5 >= x6 go to line 20
            instruction_rom[18] = 32'b011110100011_00000_000_00101_0010011;     // addi x5,x0,1955  # a = 1955 (max int for immi12 - 2047)
            instruction_rom[19] = 32'b001111110011_00000_000_00110_0010011;     // addi x6,x0,1011  # b = 1011
            instruction_rom[20] = 32'b001111110011_00101_111_00111_0010011;     // andi x7,x5,1011  # x7 = a & b
            instruction_rom[21] = 32'b0000000_00110_00101_111_00111_0110011;    // and x7,x5,x6     # x7 = x5 & x6
            instruction_rom[22] = 32'b001111110011_00101_110_00111_0010011;     // ori x7,x5,1011  # x7 = a | b
            instruction_rom[23] = 32'b0000000_00110_00101_110_00111_0110011;    // or x7,x5,x6     # x7 = x5 | x6
            instruction_rom[24] = 32'b001111110011_00101_100_00111_0010011;     // xori x7,x5,1011  # x7 = a ^ b
            instruction_rom[25] = 32'b0000000_00110_00101_100_00111_0110011;    // xor x7,x5,x6     # x7 = x5 ^ x6
            instruction_rom[26] = 32'b000011100000_00000_000_00101_0010011;     // addi x5,x0,224     # x5 = 224
            instruction_rom[27] = 32'b000000000100_00000_000_00110_0010011;     // addi x6,x0,4     # x6 = 4
            instruction_rom[28] = 32'b0000000_00110_00101_001_00111_0110011;    // sll x7,x5,x6     # x7 = x5 << x6 //ignore the sign bit
            instruction_rom[29] = 32'b0000000_00110_00101_101_00111_0110011;    // srl x7,x5,x6     # x7 = x5 >> x6
            instruction_rom[30] = 32'b0000000_00101_00101_001_00111_0010011;    // slli x7,x5,5    # x7 = x5 << 5  //ignore the sign bit
            instruction_rom[31] = 32'b0000000_00011_00101_101_00111_0010011;    // srli x7,x5,3   # x7 = x5 >> 3
            
            instruction_rom[32] = 32'b0100000_00110_00101_101_00111_0110011;    // sra x7,x5,x6     # x7 = x5 << x6 //dont ignore the sign bit
            instruction_rom[33] = 32'b0100000_00101_00101_101_00111_0010011;    // srai x7,x5,5    # x7 = x5 << 5
            
            instruction_rom[34] = 32'b0100000_00110_00101_101_00111_0110011;    // sra x7,x5,x6     # x7 = x5 << x6 //dont ignore the sign bi
            instruction_rom[35] = 32'b0000000_00101_00000_010_01000_0100011;    // sw x5,8(x0)  # mem[4 + 0] = x5, word addressable(multiples of 4)
            instruction_rom[36] = 32'b0000000_00101_00000_000_00001_0100011;    // sb x5,1(x0)  # mem[1 + 0] = x5, byte addressable(any interger)
            instruction_rom[37] = 32'b0000000_00101_00000_001_00110_0100011;    // sh x5,6(x0)  # mem[2 + 0] = x5, halfword addressable(multiples of 2)
            
            instruction_rom[38] = 32'b000000000001_00000_000_00101_0010011;     // addi x5,x0,1    # x5 = 1
            instruction_rom[39] = 32'b000000000101_00101_000_00101_0010011;     // addi x5,x5,5    # x5 = 5
            instruction_rom[40] = 32'b00000001000000000000_00111_1101111;       // jal x7,8        # x7 = pc + 4, jump 2 steps (pc = pc+8)
            instruction_rom[41] = 32'b000000000001_00000_000_00100_0010011;     // addi x4,x0,1    #this will skip and will not execute
            instruction_rom[42] = 32'b000000000101_00000_000_00100_0010011;     // addi x4,x0,5    # x4 = 5
            instruction_rom[43] = 32'b00000000100000000000_00111_1101111;       // jal x7,4        # x7 = pc + 4, jump 1, this is to store pc to x7
            instruction_rom[44] = 32'b000001100_00111_000_00100_1100111;        // jalr x4,x7,12   # x4 = pc + 4, jump 3 steps (pc = pc +12)
    
            instruction_rom[45] = 32'b000000000000_00000_010_00110_0000011;     // lw x6,0(x0)    # x6 = mem[0 + 0]
            instruction_rom[46] = 32'b000000001000_00000_000_00111_0000011;     // lb x7,8(x0)    # x7 = mem[1 + 0] load the byte from bit 7:0 and sign extrended

        end
    
endmodule
