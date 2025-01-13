`include "opcodes.v"

module Main_Control(input [3:0] Op,	  
					input [2:0] func,
					output Call, 
					output For, 
					output RegDst, 
					output RegWr, 
					output ExtOp, 
					output ALUSrc, 
					output MemRd, 
					output MemWr, 
					output WBdata);	 
					
	reg [8:0] control;
	assign {Call, For, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata} = control;	
					
	always @(*)
		case(Op)
			4'b0000: control = 9'b0011x0000;
			`ANDI:   control = 9'b000101000;
			`ADDI:   control = 9'b000111000;
			`LW:  	 control = 9'b000111101;
			`SW:     control = 9'b00x01101x;
			`BEQ:    control = 9'b00x01000x;
			`BNE:    control = 9'b00x01000x;
			`FOR:    control = 9'b0101x0000;
			4'b0001: control = func == 3'b001 ? 9'b10x0xx00x : 9'b00x0xx00x;  
			default: control = 0;
		endcase	 				
		
endmodule
	