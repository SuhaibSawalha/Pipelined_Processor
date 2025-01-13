module DFF (
    output reg [15:0] PC,   // 16-bit output register to hold the value of PC (Program Counter)
    input CLK,              // Clock signal for triggering the flip-flop
    input first             // Control signal to initialize PC to zero on the first clock cycle
);

    // Always block triggered on the rising edge of the clock signal (posedge CLK)
    always @(posedge CLK)
        if (first) 
            // If 'first' is asserted, reset PC to 0
            PC <= 0;

endmodule
