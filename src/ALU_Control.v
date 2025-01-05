module ALU_Control(
  input	[3:0] opcode,
  output reg	[2:0] ALUop
);

  always @(*)
    case(opcode)
		`AND: ALUop = 3'b000; 
    `ADD: ALUop = 3'b001;
		`SUB: ALUop = 3'b010;
    `SLL: ALUop = 3'b011;
    `SRL: ALUop = 3'b100;
    endcase
endmodule
