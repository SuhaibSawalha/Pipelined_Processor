module ALU (
    input [15:0] Rs, Rt,        // Inputs Rs and Rt
    input [2:0] OPcode,         // 4-bit Opcode	  
	// output reg zero,
    output reg [15:0] Rd        // 16-bit Output
);

    always @(*) begin
        case (OPcode)
            3'b000: Rd = Rs & Rt;          // AND
            3'b001: Rd = Rs + Rt;          // ADD
            3'b010: Rd = Rs - Rt;          // SUB
            3'b011: Rd = Rs << Rt;         // SLL
            3'b100: Rd = Rs >> Rt;         // SRL
            default: Rd = 16'b0;           // Default case for undefined OPcodes
        endcase		
		// zero = Rd ? 0 : 1;
    end

endmodule