module Mux2_1 (
    a,
    b,
    sel,
    y
);			   

	parameter n = 16;
	input  [n-1:0] a, b; 
	input sel; 
	output [n-1:0] y;

    assign y = (sel) ? b : a;

endmodule
