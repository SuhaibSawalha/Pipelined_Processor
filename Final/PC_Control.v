`include "opcodes.v"  // Include the file that defines opcodes

module PC_Control(
    input  [3:0] Op,     // 4-bit input opcode
    input  [2:0] func,   // 3-bit function code
    input        zero,    // 1-bit zero signal (result of comparison)
    output reg [1:0] PCSrc  // 2-bit output that determines the source of the next PC value
);

    always @(*) 
    begin
        PCSrc = 0;  // Default assignment to PCSrc

        case(Op)  // Check the opcode value to determine the control signal for PCSrc
            4'b0000: PCSrc = 2'b00;  // For opcode 0000, set PCSrc to 00
            `ANDI:   PCSrc = 2'b00;  // For ANDI opcode, set PCSrc to 00
            `ADDI:   PCSrc = 2'b00;  // For ADDI opcode, set PCSrc to 00
            `LW:     PCSrc = 2'b00;  // For LW (Load Word), set PCSrc to 00
            `SW:     PCSrc = 2'b00;  // For SW (Store Word), set PCSrc to 00
            `BEQ:    PCSrc = zero ? 2'b10 : 2'b00;  // For BEQ (Branch Equal), if zero is 1, PCSrc is 10 (branch); else 00
            `BNE:    PCSrc = zero ? 2'b00 : 2'b10;  // For BNE (Branch Not Equal), if zero is 0, PCSrc is 10 (branch); else 00
            `FOR:    PCSrc = 2'b00;  // For FOR, set PCSrc to 00
            4'b0001: PCSrc = func == 3'b010 ? 2'b11 : 2'b01;  // For jump instruction, check func value: if func is RET, set PCSrc to 11; else 01
            default: PCSrc = 0;  // Default case: set PCSrc to 0
        endcase
    end

endmodule