module Datapath (); // Main Datapath module

	// Clock generation
	reg CLK = 1, done = 0;
	always #5 CLK = ~CLK;  // Toggle clock
	initial  // Stop the simulation	 
		begin
			#1000
            done = 1;
            #1
            $finish;
		end
	
	// Register definitions
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
	
	// Control signal to mark the first cycle
	reg first_cycle = 0'b0;
		
	initial		   
		PC = 0;  // Initialize PC to 0
		
		
	// Main clocked process for handling program counter
	always @(posedge CLK)  begin  	  
		if (first_cycle == 0'b0) begin	  
			#1
			first_cycle = 1'b1;  // Set the first cycle as done
		end
		if (!stall) begin	   
			PC <= FinalPC;  // Update PC if no stall
		end
	end	  
												 
	// Instantiate performance registers
	Performance_Registers PR(CLK, Op, stall, kill, done);
	
	// Instantiate hazard detection unit
	Hazard HZ(Rs, Rt, RW_Mem, RW_WB, RW, RegWrF_Mem, RegWrF_WB, RegWrF, MemRd_Ex, ForwardA, ForwardB, stall);  

	// Control hazard unit instantiation
	Control_Hazard CHZ(Op, BusA_forward, BusB_forward, Loop, kill, zero);
	
	// Instruction Fetch Stage
	PC_Control PCM (Op, func, zero, PCSrc);  // Control logic for PC
	assign JumpTarget = {PC[15:9], offset};  // Calculate JumpTarget address
	Mux4_1 M4M (NextPC, JumpTarget, BranchTarget, RR, PCSrc, CurrentPC);  // Mux for selecting next PC
	Mux2_1 #(16) M2M1 (CurrentPC, BusA_forward, Loop, FinalPC);  // Mux to choose final PC value
	Add1 A1M (PC, NextPC);  // Add current PC to NextPC for address calculation
	True_Buf TFM (PC, CLK, Call && kill, RR);  // Buffer for storing the PC

	// Instruction Memory instantiation
	Instruction_Memory IMM (PC, instruction); 					  
	
	
	// IF/ID buffers (stage buffers for storing intermediate values)
	wire [15:0] PC_ID;
	stage_buffer_en #(16) PC_buffer(CLK, !stall && !kill, PC, PC_ID);  // Store PC in ID stage buffer
	wire [15:0] instruction_ID;
	stage_buffer_instruction #(16) inst_buffer(CLK, stall, kill, instruction, instruction_ID);  // Store instruction in ID stage buffer
		
	
	// Instruction Decode Stage
	Decode DM (instruction_ID, Op, Rd, Rs, Rt, func, Imm6, offset);  // Decode instruction
	Main_Control MCM (Op, func, Call, For, RegDst, RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata);  // Main control logic
												   			  
	// Branch target calculation
	assign BranchTarget = PC_ID + ExtImm6;		
	
	// Mux to choose between Rt and Rd for Register Write address
	Mux2_1 #(3) M2M2 (Rt, Rd, RegDst, RW_Ex);		   
	or(RegWrFinalLoop, Loop, !For);  // Logic for RegWrFinalLoop
	and(RegWrF_Ex, RegWr, RegWrFinalLoop);  // Logic for RegWrF_Ex
	Ext EM (Imm6, ExtOp, ExtImm6);  // Sign extension for Imm6
	Register_File RFM (Rs, Rt, RW, CLK, RegWrF, BusW, BusA, BusB);  // Register File
	// Forwarding logic for ALU inputs
	Mux4_1 M4FA (BusA, ALU_output, BusW_WB, BusW, ForwardA, BusA_forward);   
	Mux4_1 M4FB (BusB, ALU_output, BusW_WB, BusW, ForwardB, BusB_forward);
																			
	// Loop detection for forwarding
	and(Loop, For, |BusB_forward);
		
	// ID/Ex buffers
	wire [15:0] BusA_forward, BusB_forward;
	wire [15:0] BusA_Ex;
	stage_buffer #(16) busa_buffer(CLK, BusA_forward, BusA_Ex);  // Buffer for BusA
	wire [15:0] BusB_Ex;
	stage_buffer #(16) busb_buffer(CLK, BusB_forward, BusB_Ex);  // Buffer for BusB
	wire [2:0] RW_Ex;											 
	wire [2:0] func_Ex;
	stage_buffer #(3) func_buffer(CLK, func, func_Ex);  // Buffer for func
	wire [15:0] ExtImm6_Ex;				  
	stage_buffer #(16) extimm_buffer(CLK, ExtImm6, ExtImm6_Ex);  // Buffer for extended Imm6
	wire RegWrF_Ex, ALUSrc_Ex, MemRd_Ex, MemWr_Ex, WBdata_Ex;
	wire [3:0] Op_Ex;										  
  	stage_buffer #(1) alu_src_buffer(CLK, ALUSrc, ALUSrc_Ex);  // Buffer for ALUSrc
  	stage_buffer #(1) memrd_buffer(CLK, MemRd, MemRd_Ex);  // Buffer for MemRd
  	stage_buffer #(1) memwr_buffer(CLK, MemWr, MemWr_Ex);  // Buffer for MemWr
  	stage_buffer #(4) op_buffer(CLK, Op, Op_Ex);  // Buffer for Op code
	stage_buffer #(1) wbdata(CLK, WBdata, WBdata_Ex);  // Buffer for WB data
	
	// For loop flag buffer
	wire For_Ex;
	stage_buffer #(1) for2_buffer(CLK, For, For_Ex);
																						   
	// Execute Stage
	
	// ALU input selection
	Mux2_1 #(16) M2M3 (BusA_Ex, 16'b1111111111111111, For_Ex, ALU_input1);	
	Mux2_1 #(16) M2M4 (BusB_Ex, ExtImm6_Ex, ALUSrc_Ex, ALU_input2);  // Mux to select ALU input
	ALU_Control ACM (Op_Ex, func_Ex, ALUop);  // ALU control logic
	ALU ALUM (ALU_input1, ALU_input2, ALUop, ALU_output);  // ALU operation
	
	// EX/MEM buffers
	wire [15:0] ALU_output_Mem;
	stage_buffer #(16) alu_output_buffer(CLK, ALU_output, ALU_output_Mem);  // Store ALU output in MEM stage buffer
	wire [2:0] RW_Mem;
	stage_buffer #(3) rw2_buffer(CLK, RW_Ex, RW_Mem);  // Buffer for RW in MEM stage
	wire [15:0] BusB_Mem;
	stage_buffer #(16) busb2_buffer(CLK, BusB_Ex, BusB_Mem);  // Buffer for BusB in MEM stage
	wire RegWrF_Mem, MemRd_Mem, MemWr_Mem, WBdata_Mem;
	stage_buffer #(1) regwrf2_buffer(CLK, RegWrF_Ex, RegWrF_Mem);  // Buffer for RegWrF in MEM stage
	stage_buffer #(1) memrd2_buffer(CLK, MemRd_Ex, MemRd_Mem);  // Buffer for MemRd in MEM stage
	stage_buffer #(1) memwr2_buffer(CLK, MemWr_Ex, MemWr_Mem);  // Buffer for MemWr in MEM stage
	stage_buffer #(1) wbdata2_buffer(CLK, WBdata_Ex, WBdata_Mem);  // Buffer for WB data in MEM stage
	
	// Memory Stage
	
	// Data memory access
	Data_Memory DMM (ALU_output_Mem, BusB_Mem, MemRd_Mem, MemWr_Mem, CLK, Data_out);
	// Mux for selecting data for WriteBack
	Mux2_1 #(16) M2M5 (ALU_output_Mem, Data_out, WBdata_Mem, BusW_WB);
	
	// Mem/WB buffers
	wire [2:0] RW_WB;
	stage_buffer #(3) rw3_buffer(CLK, RW_Mem, RW_WB);  // Buffer for RW in WB stage
	stage_buffer #(1) regwrf3_buffer(CLK, RegWrF_Mem, RegWrF_WB);  // Buffer for RegWrF in WB stage
	wire [15:0] BusW_WB;
	
	// Write Back Stage
	stage_buffer #(16) busw_buffer(CLK, BusW_WB, BusW);  // Buffer for BusW in WB stage
	stage_buffer #(3) rw4_buffer(CLK, RW_WB, RW);  // Buffer for RW in WB stage
	stage_buffer #(1) regwrf4_buffer(CLK, RegWrF_WB, RegWrF);  // Buffer for RegWrF in WB stage
	
endmodule		