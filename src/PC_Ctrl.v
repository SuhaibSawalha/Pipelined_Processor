module PC_Ctrl(
    input [3:0] op,        
    input zero,            
    output reg [1:0] PCSrc
);
    always @(*) begin
        case (op)
            4'b0000: PCSrc = 2'b00; 
            4'b0001: PCSrc = 2'b01;
            4'b0110: PCSrc = (zero) ? 2'b10 : 2'b00; 
            4'b0111: PCSrc = (zero) ? 2'b10 : 2'b00;
		   4'b1000: PCSrc = 2'b11;
            default: PCSrc = 2'b00; 
        endcase
    
endmodule
