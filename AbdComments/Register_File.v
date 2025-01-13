module Register_File(  
    input  [2:0]  Rs1, Rs2, Rd, 
	input clk,
	input RegWr,	
    input  [15:0] WBus,    
    output reg [15:0] Bus1, Bus2
);

	reg [15:0] rf[7:0];
	
	initial	  
		begin	  														   
			for (int i = 0; i < 8; i = i + 1)
				rf[i] = 0;
		end

	always @(posedge clk)
		//if (RegWr && Rd != 0)
		if (RegWr)
			rf[Rd] <= WBus ;
 
			
  	// assign Bus1 = (Rs1 != 0) ? rf[Rs1] : 0 ;
  	// assign Bus2 = (Rs2 != 0) ? rf[Rs2] : 0 ;	
	  
	  assign Bus1 = rf[Rs1];
	  assign Bus2 = rf[Rs2];
	  
	  
	 initial
		 begin				 
			 $monitor("%b %b %b %b %b %b %b %b", rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
		 end
			  

  
endmodule