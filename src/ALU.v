module ALU (
    input [15:0] Rs, Rt,        // Inputs Rs and Rt
    input [3:0] OPcode,         // 4-bit Opcode
    output reg [15:0] Rd        // 16-bit Output
);

    always @(*) begin
        case (OPcode)
            4'b0000: Rd = Rs & Rt;          // AND
            4'b0001: Rd = Rs + Rt;          // ADD
            4'b0010: Rd = Rs - Rt;          // SUB
            4'b0011: Rd = Rs << Rt;         // SLL
            4'b0100: Rd = Rs >> Rt;         // SRL
            default: Rd = 16'b0;            // Default case for undefined OPcodes
        endcase
    end

endmodule
