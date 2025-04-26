module Data_Memory (
    input [15:0] address,        // 16-bit memory address for reading or writing
    input [15:0] data_in,        // 16-bit data input for write operations
    input MemRd,                 // Control signal to enable memory read
    input MemWr,                 // Control signal to enable memory write
    input CLK,                   // Clock signal for synchronizing read/write operations
    output reg [15:0] data_out   // 16-bit data output for read operations
);

    // Declare a 16-bit wide memory array with 65536 locations (address range: 0 to 65535)
    reg [15:0] memory [0:65535];
																				  
    always @(posedge CLK) begin											 
        #1 // 1-unit delay to simulate memory read latency										 
        if (MemRd) begin					
            data_out <= memory[address];       // Read data from the specified memory address
        end 
    end
						
    always @(negedge CLK) begin
        if (MemWr) begin                      
            memory[address] <= data_in;        // Write data_in to the specified memory address
        end
    end

endmodule