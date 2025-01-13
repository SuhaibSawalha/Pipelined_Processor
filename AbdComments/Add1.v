module Add1 (
    input [15:0] a,          // 16-bit input operand 'a'
    output [15:0] sum        // 16-bit output for the result of incrementing 'a' by 1
);

    // Perform addition: Increment the 16-bit input 'a' by 1
    assign sum = a + 1;

endmodule
