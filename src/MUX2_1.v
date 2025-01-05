module MUX2_1 (
    input [15:0] a,
    input [15:0] b,
    input sel,
    output [15:0] y
);

    assign y = (sel) ? b : a;

endmodule
