module Datapath ();				
	
	reg CLK = 1;
	always #10 CLK = ~CLK;
	initial #1500 $finish;
	
	reg  [15:0] RR, PC, FinalPC;	 
	wire [15:0] NextPC, JumpTarget, BranchTarget, CurrentPC, BusA, BusB, BusW, 
	            ExtImm6, instruction, ALU_input1, ALU_input2, ALU_output, Data_out;
	wire [8:0] offset;
	wire [5:0] Imm6;
	wire [3:0] Op; 
	wire [2:0] Rs, Rt, Rd, RW, func, ALUop;	 
	wire [1:0] PCSrc;
	wire zero, Loop, For, Call, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata, RegWrFinalLoop, RegWrF;	   
	wire [1:0] ForwardA, ForwardB;											
	wire stall, kill;
	
	reg go = 0'b0;
		
	initial		   
		PC = 0;	 
		
			
	always @(posedge CLK)  begin  	  
		if (go == 0'b0) begin	  
			#1
			go = 1'b1;
		end
		if (!stall) begin
			//#1
			PC <= FinalPC; 	
		end
	end	  												 
	
	
	Performance_Registers PR(CLK, Op, stall, kill);
	
	
	
	Hazard HZ(Rs, Rt, RW_Mem, RW_WB, RW, RegWrF_Mem, RegWrF_WB, RegWrF, MemRd_Ex, ForwardA, ForwardB, stall);  
	Control_Hazard CHZ(Op, BusA_forward, BusB_forward, kill, zero);
	
	
	
		
	// Instruction Fetch Stage
									   
	PC_Control PCM (Op, func, zero, PCSrc);				 
	assign JumpTarget = {PC[15:9], offset};
	Mux4_1 M4M (NextPC, JumpTarget, BranchTarget, RR, PCSrc, CurrentPC);  
	Mux2_1 #(16) M2M1 (CurrentPC, BusA_forward, Loop, FinalPC);	  
	Add1 A1M (PC, NextPC);							  	   
	True_Buf TFM (PC, CLK, Call && kill, RR);			
	
	Instruction_Memory IMM (PC, instruction); 					  
	
	
	// IF/ID buffers				  
	wire [15:0] PC_ID;
	stage_buffer_en #(16) PC_buffer(CLK, !stall && !kill, PC, PC_ID);
	wire [15:0] instruction_ID;
	stage_buffer_instruction #(16) inst_buffer(CLK, stall, kill, instruction, instruction_ID);
		
	
	
	// Instruction Decode Stage
											
	Decode DM (instruction_ID, Op, Rd, Rs, Rt, func, Imm6, offset); 					   
	Main_Control MCM (Op, func, Call, For, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata);	 
												   			  
	assign BranchTarget = PC_ID + ExtImm6;		
	
	Mux2_1 #(3) M2M2 (Rt, Rd, RegDst, RW_Ex);		   
	or(RegWrFinalLoop, Loop, !For);
	and(RegWrF_Ex, RegWr, RegWrFinalLoop);
	Ext EM (Imm6, ExtOp, ExtImm6);
	Register_File RFM (Rs, Rt, RW, CLK, RegWrF, BusW, BusA, BusB);  
	Mux4_1 M4FA (BusA, ALU_output, BusW_WB, BusW, ForwardA, BusA_forward);   
	Mux4_1 M4FB (BusB, ALU_output, BusW_WB, BusW, ForwardB, BusB_forward);
																			
	
	
	and(Loop, For, |BusB_forward);
		
	// ID/Ex buffers		 
	wire [15:0] BusA_forward, BusB_forward;
	wire [15:0] BusA_Ex;
	stage_buffer #(16) busa_buffer(CLK, BusA_forward, BusA_Ex);	 
	wire [15:0] BusB_Ex;
	stage_buffer #(16) busb_buffer(CLK, BusB_forward, BusB_Ex);
	wire [2:0] RW_Ex;											 
	wire [2:0] func_Ex;
	stage_buffer #(3) func_buffer(CLK, func, func_Ex);
	wire [15:0] ExtImm6_Ex;				  
	stage_buffer #(16) extimm_buffer(CLK, ExtImm6, ExtImm6_Ex);
	wire RegWrF_Ex, ALUSrc_Ex, MemRd_Ex, MemWr_Ex, WBdata_Ex;
	wire [3:0] Op_Ex;										  
  	stage_buffer #(1) alu_src_buffer(CLK, ALUSrc, ALUSrc_Ex);
  	stage_buffer #(1) memrd_buffer(CLK, MemRd, MemRd_Ex);
  	stage_buffer #(1) memwr_buffer(CLK, MemWr, MemWr_Ex);
  	stage_buffer #(4) op_buffer(CLK, Op, Op_Ex);			
	stage_buffer #(1) wbdata(CLK, WBdata, WBdata_Ex);
	
															   
	wire For_Ex;
	stage_buffer #(1) for2_buffer(CLK, For, For_Ex);
																						   
	
	
	
	// Execute Stage
	
	Mux2_1 #(16) M2M3 (BusA_Ex, 16'b1111111111111111, For_Ex, ALU_input1);	
	Mux2_1 #(16) M2M4 (BusB_Ex, ExtImm6_Ex, ALUSrc_Ex, ALU_input2);
	ALU_Control ACM (Op_Ex, func_Ex, ALUop);
	ALU ALUM (ALU_input1, ALU_input2, ALUop, ALU_output);	 
	
	
	// EX/MEM buffers
	wire [15:0] ALU_output_Mem;
	stage_buffer #(16) alu_output_buffer(CLK, ALU_output, ALU_output_Mem); 
	wire [2:0] RW_Mem;
	stage_buffer #(3) rw2_buffer(CLK, RW_Ex, RW_Mem);	  
	wire [15:0] BusB_Mem;
	stage_buffer #(16) busb2_buffer(CLK, BusB_Ex, BusB_Mem);
	wire RegWrF_Mem, MemRd_Mem, MemWr_Mem, WBdata_Mem;
	stage_buffer #(1) regwrf2_buffer(CLK, RegWrF_Ex, RegWrF_Mem);
	stage_buffer #(1) memrd2_buffer(CLK, MemRd_Ex, MemRd_Mem);
	stage_buffer #(1) memwr2_buffer(CLK, MemWr_Ex, MemWr_Mem);
	stage_buffer #(1) wbdata2_buffer(CLK, WBdata_Ex, WBdata_Mem);	
	
															 
	
	
	// Memory Stage
	
	Data_Memory DMM (ALU_output_Mem, BusB_Mem, MemRd_Mem, MemWr_Mem, CLK, Data_out);
	Mux2_1 #(16) M2M5 (ALU_output_Mem, Data_out, WBdata_Mem, BusW_WB);
	
	// Mem/WB buffers																 
	wire [2:0] RW_WB;
	stage_buffer #(3) rw3_buffer(CLK, RW_Mem, RW_WB); 				 
	stage_buffer #(1) regwrf3_buffer(CLK, RegWrF_Mem, RegWrF_WB);	
	wire [15:0] BusW_WB;
	
																				  
	
	
	// Write Back Stage
																	   
	stage_buffer #(16) busw_buffer(CLK, BusW_WB, BusW);
	
	stage_buffer #(3) rw4_buffer(CLK, RW_WB, RW); 	   
	stage_buffer #(1) regwrf4_buffer(CLK, RegWrF_WB, RegWrF);  
																																									
	
																				  
	
endmodule