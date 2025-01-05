module ALU_Control(
  input	[3:0] opcode,
  output reg	[2:0] ALUop
);

  always @(*)
    case(opcode)
		`JMP: ALUop = 3'b000; 
    `CALL: ALUop = 3'b001;
		`RET: ALUop = 3'b010;
    endcase
endmodule
