`include "opcodes.v"  // Include the file that defines opcodes like ANDI, ADDI, etc.

module Performance_Registers (
    input CLK,           // Clock signal
    input [3:0] Op,     // 4-bit opcode
    input stall,         // Stall signal (indicating pipeline stall)
    input kill           // Kill signal (indicating instruction to be killed)
);

    // Register declarations to track various performance metrics
    reg [15:0] Rex,      // Total number of executed instructions 
        Rlw,              // Total number of load instructions
        Rsw,              // Total number of store instructions			
        Ralu,             // Total number of ALU instructions
        Rctrl,            // Total number of control instructions	
        Rclk,             // Total number of clock cycles
        Rstall,           // Total number of stall cycles	 
        Rkill;            // Total number of killed instructions

    // Initial values for all the registers
    initial begin
        Rex = 0;
        Rlw = 0;
        Rsw = 0;
        Ralu = 0;
        Rctrl = 0;
        Rclk = 0;
        Rstall = 0;		  
        Rkill = 0;
    end					 

    // Display performance statistics after 1499 clock cycles
    initial begin
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

    // Always block triggered on the rising edge of the clock
    always @(posedge CLK) begin
        Rclk += 1;  // Increment the clock cycle count
        Rex += 1;   // Increment the total number of executed instructions

        // Check if the instruction is stalled or killed, and update stall and kill counters
        if (kill == 1'b1 || stall == 1'b1)
            Rstall += 1;
        if (kill == 1'b1)
            Rkill += 1;

        // Based on the opcode, increment the appropriate instruction counters
        case (Op)
            4'b0000: Ralu += 1;    // ALU operation
            `ANDI:   Ralu += 1;    // ANDI operation
            `ADDI:   Ralu += 1;    // ADDI operation
            `LW:     Rlw += 1;     // Load Word operation
            `SW:     Rsw += 1;     // Store Word operation
            `BEQ:    Rctrl += 1;   // Branch Equal operation
            `BNE:    Rctrl += 1;   // Branch Not Equal operation
            `FOR:    begin         // FOR loop
                        Ralu += 1; 
                        Rctrl += 1;
                    end
            4'b0001: Rctrl += 1;   // Control operation
            default: Rex -= 1;    // If opcode is not recognized, decrement the executed instruction counter
        endcase
    end

endmodule
