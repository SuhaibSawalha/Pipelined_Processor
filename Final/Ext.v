module Ext (
    input [5:0] a,        // 6-bit input a
    input control,        // 1-bit control signal to determine extension type
    output reg [15:0] ext // 16-bit output extended value
);

always @(*) begin														
    if (control == 1'b0) begin
        // If control is 0, sign-extend with zeros
        ext = {10'b0, a};  // Zero-extend the 6-bit input a to 16 bits
    end else begin
        // If control is 1, sign-extend with the sign bit (a[5])
        ext = { {10{a[5]}}, a };  // Sign-extend the 6-bit input a to 16 bits
    end
end

endmodule