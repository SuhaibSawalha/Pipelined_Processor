module stage_buffer (CLK, I, O);
	
	parameter n = 16;
	input CLK;		 
	input [n-1:0] I;
	output reg [n-1:0] O;
	reg [n-1:0] val;  
	
	initial
		val <= I;
	
	always @(negedge CLK)
		val <= I;
		
	always @(posedge CLK)
		O <= val;
		
endmodule