module Instruction_Memory (
    input [15:0] PC,             
    output reg [15:0] instruction 
);

    reg [15:0] RAM [0:65535];

    initial begin
        $readmemb("memfile.dat", RAM);			 
    end

    always @(*) begin
        instruction = RAM[PC]; 	   	 
    end

endmodule