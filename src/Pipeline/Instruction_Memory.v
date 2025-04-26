module Instruction_Memory (
    input [15:0] PC,              // 16-bit Program Counter input, which determines the memory address
    output reg [15:0] instruction // 16-bit instruction output, which stores the fetched instruction
);

    reg [15:0] RAM [0:65535];     // Define a 16-bit wide memory array with 65536 locations

    initial begin
        // Load the memory contents from the file "memfile.dat" into the RAM array
        $readmemb("memfile.dat", RAM);			 
    end

    always @(*) begin
        // Fetch the instruction from RAM at the address specified by PC
        instruction = RAM[PC]; 	   	 
    end

endmodule