module Datapath ();				
	
	reg CLK = 0;
	always #10 CLK = ~CLK;
	initial #250 $finish;
	
	reg  [15:0] RR, PC, FinalPC;	 
	wire [15:0] NextPC, JumpTarget, BranchTarget, CurrentPC, BusA, BusB, BusW, 
	            ExtImm6, instruction, ALU_input1, ALU_input2, ALU_output, Data_out;
	wire [8:0] offset;
	wire [5:0] Imm6;
	wire [3:0] Op; 
	wire [2:0] Rs, Rt, Rd, RW, func, ALUop;	 
	wire [1:0] PCSrc;
	wire zero, Loop, For, Call, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata, RegWrFinalLoop, RegWrFinalLoop2;
		
	initial
		PC = 0;		  
	
	always @(posedge CLK)
		PC <= FinalPC;
	
				   
	PC_Control PCM (Op, func, zero, PCSrc);				 
	assign JumpTarget = {PC[15:9], offset};
	Mux4_1 M4M (NextPC, JumpTarget, BranchTarget, RR, PCSrc, CurrentPC);   
	and(Loop, For, |BusB);
	Mux2_1 #(16) M2M1 (CurrentPC, BusA, Loop, FinalPC);	  
	Add1 A1M (PC, NextPC);
	True_Buf TFM (NextPC, CLK, Call, RR);		
	// Add AM (FinalPC, ExtImm6, BranchTarget);			
	
	Instruction_Memory IMM (PC, instruction); 					  
	
	
	
	// buffer: PC, NextPC, instruction 
	// TODO: For -> stall cycle
	
	
											
	Decode DM (instruction, Op, Rd, Rs, Rt, func, Imm6, offset); 					   
	Main_Control MCM (Op, func, Call, For, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata);	 
												   			  
	assign BranchTarget = PC + ExtImm6;		
	
	Mux2_1 #(3) M2M2 (Rt, Rd, RegDst, RW);		  
	and(RegWrFinalLoop, RegWr, Loop); 
	or(RegWrFinalLoop2, RegWrFinalLoop, !For);	 
	Ext EM (Imm6, ExtOp, ExtImm6);
	Register_File RFM (Rs, Rt, RW, CLK, RegWrFinalLoop2, BusW, BusA, BusB);  
	
	
	
	
	// buffer: ExtImm6, Op, func, BusA, BusB, Rd, For, ALUSrc, MemRd, MemWr, WBdata
	
	
	
	
	
	Mux2_1 #(16) M2M3 (BusA, 16'b1111111111111111, For, ALU_input1);	
	Mux2_1 #(16) M2M4 (BusB, ExtImm6, ALUSrc, ALU_input2);
	ALU_Control ACM (Op, func, ALUop);
	ALU ALUM (ALU_input1, ALU_input2, ALUop, zero, ALU_output);	 
	
	
	
	
	// buffer: MemRd, MemWr, WBdata, ALU_output, BusB, Rd
	
	
	
	Data_Memory DMM (ALU_output, BusB, MemRd, MemWr, CLK, Data_out);  
	
	
	
	// buffer: ALU_output, Data_out, WBdata, Rd
	
	
	Mux2_1 #(16) M2M5 (ALU_output, Data_out, WBdata, BusW);
																				  
	
endmodule
