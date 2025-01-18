module Hazard (
    input [2:0] Rs, Rt,      // 3-bit inputs for source registers Rs and Rt
    input [2:0] Rd2, Rd3, Rd4, // 3-bit inputs for destination registers Rd2, Rd3, and Rd4
    input Ex_RegWr, Mem_RegWr, WB_RegWr, // Control signals indicating if registers are written to in the Execute, Memory, or Write-back stages
    input MemRd_Ex,           // Signal indicating if a memory read is happening in the Execute stage
    output reg [1:0] ForwardA, ForwardB,  // Forwarding signals for registers Rs and Rt
    output reg stall          // Stall signal to prevent hazards
);

	initial
	    stall = 0;  // Initialize stall to 0
	
	always @(*) begin
	    // Determine forwarding logic for register Rs
	    if (Rs == Rd2 && Ex_RegWr)  // Check if Rs matches Rd2 and if there's a write-back in the Execute stage
	        ForwardA = 2'b01;        // Forward from Execute stage
	    else if (Rs == Rd3 && Mem_RegWr)  // Check if Rs matches Rd3 and if there's a write-back in the Memory stage
	        ForwardA = 2'b10;        // Forward from Memory stage
	    else if (Rs == Rd4 && WB_RegWr)  // Check if Rs matches Rd4 and if there's a write-back in the Write-back stage
	        ForwardA = 2'b11;        // Forward from Write-back stage
	    else
	        ForwardA = 2'b00;        // No forwarding for Rs
	
	    // Determine forwarding logic for register Rt
	    if (Rt == Rd2 && Ex_RegWr)  // Check if Rt matches Rd2 and if there's a write-back in the Execute stage
	        ForwardB = 2'b01;        // Forward from Execute stage
	    else if (Rt == Rd3 && Mem_RegWr)  // Check if Rt matches Rd3 and if there's a write-back in the Memory stage
	        ForwardB = 2'b10;        // Forward from Memory stage
	    else if (Rt == Rd4 && WB_RegWr)  // Check if Rt matches Rd4 and if there's a write-back in the Write-back stage
	        ForwardB = 2'b11;        // Forward from Write-back stage
	    else
	        ForwardB = 2'b00;        // No forwarding for Rt
	
	    // Stall if there is a memory read in the Execute stage and forwarding is required
	    stall = (MemRd_Ex === 1'b1) && ((ForwardA === 2'b01) || (ForwardB === 2'b01));
	end

endmodule