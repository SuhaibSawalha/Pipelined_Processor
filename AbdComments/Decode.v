module Decode (
    input [15:0] instruction,  // 16-bit input instruction
    output reg [3:0] opcode,  // 4-bit output opcode
    output reg [2:0] rd,      // 3-bit output register destination (rd)
    output reg [2:0] rs,      // 3-bit output register source (rs)
    output reg [2:0] rt,      // 3-bit output register target (rt)
    output reg [2:0] func,    // 3-bit output function code
    output reg [5:0] imm,     // 6-bit immediate value
    output reg [8:0] offset   // 9-bit output offset value
);

always @(*) begin	
    // Decode instruction based on the 4 most significant bits
    case(instruction[15:12])  // Check the opcode part of the instruction
        4'b0000: begin					
            // For opcode 0000, unpack instruction into opcode, rd, rs, rt, and func
            {opcode, rd, rs, rt, func} = instruction;	 
        end
        4'b0001: begin				 
            // For opcode 0001, unpack instruction into opcode, offset, and func
            {opcode, offset, func} = instruction;  
        end
        default: begin					
            // For all other opcodes, unpack instruction into opcode, rs, rt, and imm
            {opcode, rs, rt, imm} = instruction;  
        end
    endcase
end

endmodule
