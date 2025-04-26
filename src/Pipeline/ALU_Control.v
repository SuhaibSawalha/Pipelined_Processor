// Include the header file containing opcode definitions
`include "opcodes.v"

module ALU_Control(
    input      [3:0] Op,       // 4-bit input signal representing the operation code (opcode)
    input      [2:0] func,     // 3-bit input signal representing function codes (used in R-type instructions)
    output reg [2:0] ALUop     // 3-bit output signal to specify the ALU operation
);		  
																						   
    always @(*)		
        case(Op)
            4'b0000: ALUop = func;       // R-type instructions: Directly assign func to ALUop
            `ANDI:   ALUop = 3'b000;     // ANDI instruction: ALU performs bitwise AND operation
            `ADDI:   ALUop = 3'b001;     // ADDI instruction: ALU performs addition
            `LW:     ALUop = 3'b001;     // Load Word instruction: ALU calculates address (addition)
            `SW:     ALUop = 3'b001;     // Store Word instruction: ALU calculates address (addition)
            `BEQ:    ALUop = 3'b010;     // Branch if Equal: ALU performs subtraction for comparison
            `BNE:    ALUop = 3'b010;     // Branch if Not Equal: ALU performs subtraction for comparison
            `FOR:    ALUop = 3'b001;     // FOR operation: ALU performs addition
            default: ALUop = 3'bxxx;     // Default case: Undefined ALU operation (invalid opcode)
        endcase	 									 
		
endmodule