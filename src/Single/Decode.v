module Decode (
    input [15:0] instruction,
    output reg [3:0] opcode,
    output reg [2:0] rd,
    output reg [2:0] rs,
    output reg [2:0] rt,
    output reg [2:0] func,
    output reg [5:0] imm,
    output reg [8:0] offset
);

always @(*) begin	
        case(instruction[15:12])
            4'b0000: begin					  
				{opcode, rd, rs, rt, func} = instruction;	 
            end
            4'b0001: begin				 
				{opcode, offset, func} = instruction;  
            end
            default: begin				   
				{opcode, rs, rt, imm} = instruction;  
            end
        endcase
    end

endmodule