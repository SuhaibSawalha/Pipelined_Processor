module Register_File(  
    input  [2:0]  Rs1, Rs2, Rd,   // 3-bit registers Rs1, Rs2, and Rd for source and destination registers
    input clk,                      // Clock signal
    input RegWr,                    // Register write enable signal
    input  [15:0] WBus,             // 16-bit data to be written to the register file
    output reg [15:0] Bus1, Bus2    // 16-bit outputs for Bus1 and Bus2 (read data from registers)
);

    // Declare a register file of 8 registers, each 16-bits wide
    reg [15:0] rf[7:0]; 
    
    // Initial block to set all registers to zero
    initial begin   
        // Initialize all registers in the file to zero
        for (int i = 0; i < 8; i = i + 1)
            rf[i] = 0;
    end

    // Always block triggered by the rising edge of the clock
    always @(posedge clk) begin
        // If the RegWr signal is active, write the value from WBus to the register at Rd
        if (RegWr)
            rf[Rd] <= WBus;  // Write to the register at index Rd
    end

    // Assign Bus1 and Bus2 with the contents of registers Rs1 and Rs2 respectively
    // If the register index is non-zero, it reads the value from the register, otherwise, it defaults to zero
    assign Bus1 = rf[Rs1];  // Read data from register Rs1
    assign Bus2 = rf[Rs2];  // Read data from register Rs2

    // Initial block for monitoring the contents of the register file
    initial begin
        // Display the contents of all registers
        $monitor("%b %b %b %b %b %b %b %b", rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
    end

endmodule
