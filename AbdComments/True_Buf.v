module True_Buf(input [15:0] in,   // 16-bit input signal
                input clk,           // Clock signal
                input call,          // Control signal to trigger the output assignment
                output reg [15:0] out // 16-bit output signal
);

    // Always block triggered by the negative edge of the clock (negedge)
    always @(negedge clk) begin
        // If the 'call' signal is active, assign the input 'in' to the output 'out'
        if (call)
            out = in;  // Transfer input to output when 'call' is high
    end

endmodule
