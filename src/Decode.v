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
        case(opcode)
            4'b0000: begin
                opcode = instruction[15:12];
                rd = instruction[11:9];
                rs = instruction[8:6];
                rt = instruction[5:3];
                func = instruction[2:0];
            end
            4'b0001: begin
                opcode = instruction[15:12];
                offset = instruction[8:0];
                func = instruction[2:0];
            end
            default: begin
                opcode = instruction[15:12];
                rs = instruction[8:6];
                rt = instruction[5:3];
                imm = instruction[5:0];
            end
        endcase
    end

endmodule
