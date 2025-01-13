`include "opcodes.v"

module Control_Hazard (		
	input [3:0] Op,
	input [15:0] BusA_forward, BusB_forward,  
	output reg kill,		  
	output reg zero							 
	);								 
	
	reg go = 0;
	initial		
		begin
			kill = 0;
			zero = 0;
		end		   
		
	always @(*) 
		begin
			kill = ((Op == `BEQ) && (BusA_forward == BusB_forward)) || ((Op == `BNE) && (BusA_forward != BusB_forward))
						   || (Op == `JMP) || (Op == `CALL) || (Op == `RET) || (Op == `FOR);  
			zero = (Op == `BEQ || Op == `BNE) && (BusA_forward == BusB_forward); 
		end
		
	/*
	always @(posedge CLK) 		
		begin		
			#1					 
			//$display("%0d %b %b %b %b %b", $time, Op, kill, zero, BusA_forward, BusB_forward);
			//if (go) begin									  
			/*
			if (((Op == `BEQ) && (BusA_forward == BusB_forward)) || ((Op == `BNE) && (BusA_forward != BusB_forward))
				|| (Op == `JMP) || (Op == `CALL) || (Op == `RET))
				begin
					kill = 1;
					instruction = 16'b1111111111111111;	
					zero = (Op == `BEQ || Op == `BNE) && (BusA_forward == BusB_forward);
				end						
				/
			
			if (kill == 1'b1 || $isunknown(Op))	  
				begin
					kill = 0; 
					zero = 0;
				end
			else	  
				begin
					kill = ((Op == `BEQ) && (BusA_forward == BusB_forward)) || ((Op == `BNE) && (BusA_forward != BusB_forward))
						   || (Op == `JMP) || (Op == `CALL) || (Op == `RET);  
					zero = (Op == `BEQ || Op == `BNE) && (BusA_forward == BusB_forward); 
				end			
				
			//end
			//go = 1;	 
			//$display("%0d %b", $time, kill);
		end	   
		*/
		
endmodule