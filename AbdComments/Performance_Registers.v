`include "opcodes.v"

module Performance_Registers (
	input CLK,
	input [3:0] Op,
	input stall,   
	input kill
	);
	
	
	reg [15:0] Rex, // Total number of executed instructions 
	Rlw, // Total number of load instructions
	Rsw, // Total number of store instructions			
	Ralu, // Total number of ALU instructions
	Rctrl, // Total number of control instructions	
	Rclk, // Total number of clock cycles
	Rstall, // Total number of stall cycles	 
	Rkill; // Total number of killed instructions
	
	initial 
		begin
			Rex = 0;
			Rlw = 0;
			Rsw = 0;
			Ralu = 0;
			Rctrl = 0;
			Rclk = 0;
			Rstall = 0;		  
			Rkill = 0;
		end					 
		
	initial 
		begin
			#1499
			$display("%0d", Rex);
			$display("%0d", Rlw);
			$display("%0d", Rsw);
			$display("%0d", Ralu);
			$display("%0d", Rctrl);
			$display("%0d", Rclk);
			$display("%0d", Rstall);
			$display("%0d", Rkill);
		end				  
		
		
	always @(posedge CLK)
		begin	  
			Rclk += 1;	 
			Rex += 1;
			if (kill == 1'b1 || stall == 1'b1)
				Rstall += 1;
			if (kill == 1'b1)
				Rkill += 1;	 
			case (Op)
				4'b0000: Ralu += 1;
				`ANDI: 	 Ralu += 1;
				`ADDI:   Ralu += 1;
				`LW:     Rlw += 1;
				`SW:     Rsw += 1;
				`BEQ:    Rctrl += 1;
				`BNE:    Rctrl += 1;
				`FOR:    begin
						 Ralu += 1; 
					     Rctrl += 1;	
						 end
				4'b0001: Rctrl += 1;   
				default: Rex -= 1;
			endcase
		end
		
endmodule
		
	
