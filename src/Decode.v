module Decode (
    input [15:0] instruction,
    input [3:0] opcode,
    input [2:0] rd,
    input [2:0] rs,
    input [2:0] rt,
    input [2:0] func,
    input [5:0] imm,
    input [8:0] offset,
    output reg [15:0] reordered_instruction
);

    always @(*) begin
        case(opcode)
            4'b0000: begin
                reordered_instruction = {opcode, rd, rs, rt, func};
            end
            4'b0001: begin
                reordered_instruction = {opcode, offset, func};
            end
            default: begin
                reordered_instruction = {opcode, rs, rt, imm};
            end
        endcase
    end

endmodule
