`include "opcodes.v"

module Performance_Registers (
	input CLK,
	input [3:0] Op,
	input stall,   
	input kill,
	input done
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
		
		
	always @(posedge CLK)
		begin	  
			Rclk += 1;	 
			Rex += 1;
			if (kill == 1'b1 || stall == 1'b1)
				Rstall += 1;
			if (kill == 1'b1)
				Rkill += 1;	   	 
			if (stall == 1'b1)
				Rex -= 1;
			else case (Op)
				4'b0000: Ralu += 1;
				`ANDI: 	 Ralu += 1;
				`ADDI:   Ralu += 1;
				`LW:     begin
						 Rlw += 1; 
					     Ralu += 1;
						 end
				`SW:     begin
						 Rsw += 1;	 
						 Ralu += 1;	
						 end
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
		
		
	always @(posedge done) begin
        $display("Executed Instructions:    %0d", Rex);
        $display("Load Instructions:        %0d", Rlw);
        $display("Store Instructions:       %0d", Rsw);
        $display("ALU Instructions:         %0d", Ralu);
        $display("Control Instructions:     %0d", Rctrl);
        $display("Number of Clocks:         %0d", Rclk);
        $display("Stall Cycles:             %0d", Rstall);
        $display("Killed Instructions:      %0d", Rkill);	   
		$finish;
    end
		
endmodule
		
	
