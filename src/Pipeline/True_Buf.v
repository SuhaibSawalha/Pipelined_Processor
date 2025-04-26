module True_Buf(input [15:0] in,   // 16-bit input signal
                input clk,           // Clock signal
                input call,          // Control signal to trigger the output assignment
                output reg [15:0] out // 16-bit output signal
);
																			 
    always @(negedge clk) begin
        // If the 'call' signal is active, assign the input 'in' to the output 'out'
        if (call)
            out = in;
    end

endmodule