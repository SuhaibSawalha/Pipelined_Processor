module Mux4_1 (
    input [15:0] a,    // 16-bit input 'a'
    input [15:0] b,    // 16-bit input 'b'
    input [15:0] c,    // 16-bit input 'c'
    input [15:0] d,    // 16-bit input 'd'
    input [1:0] sel,   // 2-bit select signal to choose between 'a', 'b', 'c', or 'd'
    output [15:0] y    // 16-bit output 'y' which will hold the selected value
);

    // Conditional assignment to select the appropriate input based on the value of 'sel'
    // If sel == 2'b00, output 'y' is 'a'; if sel == 2'b01, output 'y' is 'b';
    // if sel == 2'b10, output 'y' is 'c'; else, output 'y' is 'd'
    assign y = (sel == 2'b00) ? a :   // When sel is 00, choose 'a'
               (sel == 2'b01) ? b :   // When sel is 01, choose 'b'
               (sel == 2'b10) ? c :   // When sel is 10, choose 'c'
               d;                      // When sel is 11, choose 'd'

endmodule
