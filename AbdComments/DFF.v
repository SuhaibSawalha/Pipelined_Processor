module DFF (PC, input CLK, input first);
	
	output reg [15:0] PC;
	
	always @(posedge CLK)
		if (first) 
			PC <= 0;
			
endmodule