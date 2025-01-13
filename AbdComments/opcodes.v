// Defining opcodes for different instructions

`define AND 4'b0000    // Opcode for AND operation
`define ADD 4'b0000    // Opcode for ADD operation
`define SUB 4'b0000    // Opcode for SUB operation
`define SLL 4'b0000    // Opcode for Shift Left Logical operation
`define SRL 4'b0000    // Opcode for Shift Right Logical operation
`define ANDI 4'b0010   // Opcode for AND Immediate operation
`define ADDI 4'b0011   // Opcode for ADD Immediate operation
`define LW 4'b0100     // Opcode for Load Word operation
`define SW 4'b0101     // Opcode for Store Word operation
`define BEQ 4'b0110    // Opcode for Branch if Equal operation
`define BNE 4'b0111    // Opcode for Branch if Not Equal operation
`define FOR 4'b1000    // Opcode for FOR operation (possibly loop)
`define JMP 4'b0001    // Opcode for Jump operation
`define CALL 4'b0001   // Opcode for Call operation
`define RET 4'b0001    // Opcode for Return operation
