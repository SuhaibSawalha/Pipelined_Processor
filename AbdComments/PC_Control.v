`include "opcodes.v"

module PC_Control(input  [3:0] Op,	  
				  input  [2:0] func,
				  input        zero, 
				  output reg [1:0] PCSrc);	 
				  	 
				  
	always @(*)		
		begin										 
			PCSrc = 0;
		case(Op)
			4'b0000: PCSrc = 2'b00;
			`ANDI:   PCSrc = 2'b00;
			`ADDI:   PCSrc = 2'b00;
			`LW:  	 PCSrc = 2'b00;
			`SW:     PCSrc = 2'b00;
			`BEQ:    PCSrc = zero ? 2'b10 : 2'b00;
			`BNE:    PCSrc = zero ? 2'b00 : 2'b10;
			`FOR:    PCSrc = 2'b00;
			4'b0001: PCSrc = func == 3'b010 ? 2'b11 : 2'b01; 
			default: PCSrc = 0;
		endcase	 
		end
		
endmodule
	