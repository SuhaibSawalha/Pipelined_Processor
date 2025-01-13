module stage_buffer (CLK, I, O);
	
	// Parameter n defines the width of the input and output data (default is 16 bits)
	parameter n = 16;
	
	// Input and output declarations
	input CLK;            // Clock input
	input [n-1:0] I;      // Input data (n-bit wide)
	output reg [n-1:0] O; // Output data (n-bit wide)
	
	// Internal register to hold the value between clock cycles
	reg [n-1:0] val;  

	// Initial block to set the initial value of 'val' on startup
	initial
		val <= I;
	
	// On the negative edge of the clock, update 'val' with the value of 'I'
	always @(negedge CLK)
		val <= I;
		
	// On the positive edge of the clock, update 'O' with the value of 'val'
	always @(posedge CLK)
		O <= val;
		
endmodule
