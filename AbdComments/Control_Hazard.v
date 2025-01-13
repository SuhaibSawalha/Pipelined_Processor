// Include the header file containing opcode definitions
`include "opcodes.v"

module Control_Hazard (
    input [3:0] Op,                // 4-bit opcode indicating the instruction type
    input [15:0] BusA_forward,     // 16-bit forwarded value of register A
    input [15:0] BusB_forward,     // 16-bit forwarded value of register B
    output reg kill,               // Signal to indicate whether to kill (invalidate) the pipeline
    output reg zero                // Signal to indicate a zero condition for branch operations
);

    // Internal signal to handle initialization (unused in logic)
    reg go = 0;

    // Initialize output signals to zero
    initial begin
        kill = 0;
        zero = 0;
    end

    // Always block triggered by changes in any input signals
    always @(*) begin
        // Kill the pipeline if certain control hazards are detected:
        // - BEQ (Branch if Equal) and BusA_forward equals BusB_forward
        // - BNE (Branch if Not Equal) and BusA_forward does not equal BusB_forward
        // - Unconditional jumps or calls: JMP, CALL, RET, FOR
        kill = ((Op == `BEQ) && (BusA_forward == BusB_forward)) || 
               ((Op == `BNE) && (BusA_forward != BusB_forward)) || 
               (Op == `JMP) || (Op == `CALL) || (Op == `RET) || (Op == `FOR);

        // Set zero signal for branch conditions:
        // - BEQ or BNE where BusA_forward equals BusB_forward
        zero = (Op == `BEQ || Op == `BNE) && (BusA_forward == BusB_forward); 
    end

endmodule
