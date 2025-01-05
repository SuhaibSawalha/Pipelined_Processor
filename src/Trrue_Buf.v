module True_Buf(input clk, input ret, output reg out);

    always @(posedge clk) begin
        if (ret)
            out = clk;
    end

endmodule
