module Register_File(
	input  clk, 
    input  RegWr, 
    input  [2:0]  Rs1, Rs2, Rd, 
    input  [15:0] WBus, 
    output reg [15:0] Bus1, Bus2
);

	reg [15:0] rf[7:0];
	
	initial
		rf[0] = 0;

	always @(posedge clk)
		if (RegWr && Rd != 0)
			rf[Rd] <= WBus ;
 
			
  	assign Bus1 = (Rs1 != 0) ? rf[Rs1] : 0 ;
  	assign Bus2 = (Rs2 != 0) ? rf[Rs2] : 0 ;
			  

  
endmodule
