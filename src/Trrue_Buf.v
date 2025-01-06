module True_Buf(input [15:0] in, input clk, input call, output reg [15:0] out);

    always @(posedge clk) begin
        if (call)
            out = in;
    end

endmodule
