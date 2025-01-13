module Hazard (
	input [2:0] Rs, Rt,
	input [2:0] Rd2, Rd3, Rd4,			 	
	input Ex_RegWr, Mem_RegWr, WB_RegWr,   
	input MemRd_Ex,
	output reg [1:0] ForwardA, ForwardB,
	output reg stall
	);									 
	
	initial
		stall = 0;
	
	always @(*) 					 	
		begin							   
			if (Rs == Rd2 && Ex_RegWr)
				ForwardA = 2'b01;
			else if (Rs == Rd3 && Mem_RegWr)
				ForwardA = 2'b10;
			else if (Rs == Rd4 && WB_RegWr)
				ForwardA = 2'b11;
			else
				ForwardA = 2'b00;	
				
			if (Rt == Rd2 && Ex_RegWr)
				ForwardB = 2'b01;
			else if (Rt == Rd3 && Mem_RegWr)
				ForwardB = 2'b10;
			else if (Rt == Rd4 && WB_RegWr)
				ForwardB = 2'b11;
			else
				ForwardB = 2'b00; 	
				
			stall = (MemRd_Ex === 1'b1) && ((ForwardA === 2'b01) || (ForwardB === 2'b01));
		end
		
endmodule