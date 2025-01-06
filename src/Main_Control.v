`define R    4'b0000
`define ANDI 4'b0010  
`define ADDI 4'b0011  
`define LW   4'b0100
`define SW   4'b0101
`define BEQ  4'b0110
`define BNQ  4'b0111 
`define FOR  4'b1000
`define J    4'b0001

module Main_Control(
    input       		[3:0] op,
    output reg        ALUSrc, For, Call,
    output reg        RegDest, WBdata, RegWr,
    output reg        ExtOp,
    output reg        MemRd, MemWr
);

	always @(*) begin
	    ALUSrc   = 0;
	    For      = 0;
	    Call     = 0;
	    RegDest  = 0;
	    WBdata   = 0;
	    RegWr    = 0;
	    ExtOp    = 0;
	    MemRd    = 0;
	    MemWr    = 0;
	
	    case (op)
	        `R: begin 
	            ALUSrc   = 0;
	            RegDest  = 1;
	            WBdata   = 0;
	            RegWr    = 1;
	        end
	
	        `ANDI: begin
	            ALUSrc   = 1;
	            RegDest  = 0;
	            WBdata   = 0;
	            RegWr    = 1;
	            ExtOp    = 0;
	        end	   
			
			`ADDI: begin
	            ALUSrc   = 1;
	            RegDest  = 0;
	            WBdata   = 0;
	            RegWr    = 1;
	            ExtOp    = 1;
	        end
	
	        `LW: begin
	            ALUSrc   = 1;
	            RegDest  = 0;
	            RegWr    = 1;
	            ExtOp    = 1;
	            MemRd    = 1;
	        end
	
	        `SW: begin
	            ALUSrc   = 1;
	            ExtOp    = 1;
	            MemWr    = 1;
	        end
	
	        `BEQ: begin
	            ExtOp    = 1;
	        end
	
	        `BNQ: begin
	            ExtOp    = 1;
	        end
	
	        `FOR: begin
	            For      = 1;
	            Call     = 1;
	            RegDest  = 0;
	            WBdata   = 0;
	            RegWr    = 1;
	        end
	
	        `J: begin
	        end
	
	        default: begin
	        end
	    endcase
	end
	
	endmodule
