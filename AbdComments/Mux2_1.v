module Mux2_1 (
    a,        // Input 'a' of width n
    b,        // Input 'b' of width n
    sel,      // Select signal (1-bit) to choose between 'a' and 'b'
    y         // Output 'y' of width n, the selected value
);			   

    parameter n = 16;  // Parameter 'n' defines the width of the inputs and output (default is 16 bits)
    
    input  [n-1:0] a, b;  // 'a' and 'b' are n-bit inputs
    input sel;             // 'sel' is the selection signal (1-bit)
    output [n-1:0] y;     // 'y' is the n-bit output

    // The value of 'y' is determined based on 'sel': if 'sel' is 1, 'y' is 'b'; if 'sel' is 0, 'y' is 'a'
    assign y = (sel) ? b : a;  // Conditional assignment for the multiplexer's output

endmodule
