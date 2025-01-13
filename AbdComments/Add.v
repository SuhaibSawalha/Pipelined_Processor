module Add (
    input [15:0] a,          // 16-bit input operand 'a'
    input [15:0] b,          // 16-bit input operand 'b'
    output [15:0] sum        // 16-bit output for the result of addition
);

    // Perform addition of the two 16-bit inputs 'a' and 'b'
    assign sum = a + b;

endmodule
