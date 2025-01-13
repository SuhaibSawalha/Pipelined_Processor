module Data_Memory (
    input [15:0] address,       
    input [15:0] data_in,       
    input MemRd,                
    input MemWr,               
    input CLK,                 
    output reg [15:0] data_out  
);

    reg [15:0] memory [0:65535];
	
    always @(posedge CLK) begin											 
		#1																		 
        if (MemRd) begin							   
            data_out <= memory[address];
        end 
    end

    always @(negedge CLK) begin
        if (MemWr) begin
            memory[address] <= data_in; 
        end
    end

endmodule