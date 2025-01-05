module Ext (
    input [5:0] a,
    input control,
    output reg [15:0] ext
);

    always @(*) begin
        if (control == 1'b0) begin
            ext = {10'b0, a};
        end else begin
            ext = { {10{a[5]}}, a };
        end
    end

endmodule
