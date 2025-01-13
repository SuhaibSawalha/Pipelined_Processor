// Stage buffer with enable control
module stage_buffer_en (CLK, en, I, O);
	
	// Parameter n defines the width of the input and output data (default is 16 bits)
	parameter n = 16;
	
	// Input and output declarations
	input CLK, en;            // Clock and enable input
	input [n-1:0] I;          // Input data (n-bit wide)
	output reg [n-1:0] O;     // Output data (n-bit wide)
	
	// Internal register to hold the value between clock cycles
	reg [n-1:0] val;  

	// Initial block to set the initial value of 'val' on startup
	initial
		val <= I;
	
	// On the negative edge of the clock, if enable (en) is high, update 'val' with the value of 'I'
	always @(negedge CLK)  
		if (en)
			val <= I;
		
	// On the positive edge of the clock, if enable (en) is high, update 'O' with the value of 'val'
	always @(posedge CLK)	 
		if (en)
			O <= val;
		
endmodule		  


// Stage buffer with stall and kill control
module stage_buffer_instruction (CLK, stall, kill, I, O);
	
	// Parameter n defines the width of the input and output data (default is 16 bits)
	parameter n = 16;
	
	// Input and output declarations
	input CLK, stall, kill;    // Clock, stall, and kill input
	input [n-1:0] I;           // Input data (n-bit wide)
	output reg [n-1:0] O;      // Output data (n-bit wide)
	
	// Internal register to hold the value between clock cycles
	reg [n-1:0] val;  

	// Initial block to set the initial value of 'val' on startup
	initial
		val <= I;
	
	// On the negative edge of the clock, if stall and kill are both low, update 'val' with the value of 'I'
	always @(negedge CLK)  
		if (!stall && !kill)
			val <= I;
		
	// On the positive edge of the clock, if stall and kill are both low, update 'O' with the value of 'val'
	// If kill is high, set 'O' to 16'b1111111111111111
	always @(posedge CLK)	 
		if (!stall && !kill)
			O <= val;		
		else if (kill)
			O <= 16'b1111111111111111;
		
endmodule
