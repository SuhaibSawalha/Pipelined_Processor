`include "opcodes.v"  // Include the opcodes.v file which defines opcode constants

module Main_Control(
    input [3:0] Op,        // 4-bit opcode input
    input [2:0] func,      // 3-bit function code input
    output Call,           // Control signal for Call instruction
    output For,            // Control signal for For loop instruction
    output RegDst,         // Control signal for Register destination
    output RegWr,          // Control signal for Register write
    output ExtOp,          // Control signal for extension operation
    output ALUSrc,         // Control signal for ALU source
    output MemRd,          // Control signal for memory read
    output MemWr,          // Control signal for memory write
    output WBdata          // Control signal for Write-back data
);

    reg [8:0] control;    // 9-bit control signal to manage various control lines
    // Assign the individual control lines from the 9-bit control signal
    assign {Call, For, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata} = control;

    always @(*)  // Always block to generate control signals based on the opcode and function code
        case(Op)
            4'b0000: control = 9'b0011x0000;  // Control signals for opcode 0000 (e.g., NOP or similar)
            `ANDI:   control = 9'b000101000;  // Control signals for ANDI instruction (Immediate AND)
            `ADDI:   control = 9'b000111000;  // Control signals for ADDI instruction (Immediate ADD)
            `LW:     control = 9'b000111101;  // Control signals for LW (Load Word) instruction
            `SW:     control = 9'b00x01101x;  // Control signals for SW (Store Word) instruction
            `BEQ:    control = 9'b00x01000x;  // Control signals for BEQ (Branch if Equal) instruction
            `BNE:    control = 9'b00x01000x;  // Control signals for BNE (Branch if Not Equal) instruction
            `FOR:    control = 9'b0101x0000;  // Control signals for FOR instruction (Loop related)
            4'b0001: control = func == 3'b001 ? 9'b10x0xx00x : 9'b00x0xx00x;  // Control for a specific function code under opcode 0001
            default: control = 0;  // Default case to ensure control is cleared in case of undefined opcode
        endcase

endmodule
