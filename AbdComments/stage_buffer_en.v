module stage_buffer_en (CLK, en, I, O);
	
	parameter n = 16;
	input CLK, en;	 
	input [n-1:0] I;
	output reg [n-1:0] O;
	reg [n-1:0] val;  
	
	initial
		val <= I;
	
	always @(negedge CLK)  
		if (en)
			val <= I;
		
	always @(posedge CLK)	 
		if (en)
			O <= val;
		
endmodule		  


module stage_buffer_instruction (CLK, stall, kill, I, O);
	
	parameter n = 16;
	input CLK, stall, kill;	 
	input [n-1:0] I;
	output reg [n-1:0] O;
	reg [n-1:0] val;  
	
	initial
		val <= I;
	
	always @(negedge CLK)  
		if (!stall && !kill)
			val <= I;
		
	always @(posedge CLK)	 
		if (!stall && !kill)
			O <= val;		
		else if (kill)
			O <= 16'b1111111111111111;
		
endmodule