`include "opcodes.v"

module ALU_Control(
	input      [3:0] Op,
	input      [2:0] func,	
	output reg [2:0] ALUop);		  
	
	always @(*)
		case(Op)
			4'b0000: ALUop = func;
			`ANDI:   ALUop = 3'b000;
			`ADDI:   ALUop = 3'b001;
			`LW:  	 ALUop = 3'b001;
			`SW:     ALUop = 3'b001;	 
			`BEQ:    ALUop = 3'b010;
			`BNE:    ALUop = 3'b010;
			`FOR:    ALUop = 3'b001;
			default: ALUop = 3'bxxx;
		endcase	 
		
endmodule
