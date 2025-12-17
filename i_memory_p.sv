module i_memory_p (
    input [31:0] A,
    output reg [31:0]RD
);

reg [31:0]mem[63:0]; 

    // Initialize the ROM with the full program instructions
    initial begin  
		mem[0]  = 32'h00500093; // addi x1, x0, 5
		mem[1]  = 32'h00A00113; // addi x2, x0, 10
		mem[2]  = 32'h002081B3; // add x3, x1, x2
		mem[3]  = 32'h40118233; // sub x4, x3, x1
		mem[4]  = 32'h0020e2b3; // or x5, x1, x2
		mem[5]  = 32'h0020f333; // and x6, x1, x2
		mem[6]  = 32'h00300023; // sw x3, 0(x0)
		mem[7]  = 32'h00002383; // lw x7, 0(x0)
		mem[8]  = 32'h0080006F; // j end (PC+8)
		mem[9]  = 32'h00100413; // addi x8, x0, 1 (skipped by jump)
		mem[10] = 32'h00900493; // addi x9, x0, 9 (end label)
    end

    // Read operation
    always @(*) begin
        RD = mem[A[7:2]]; // Address decoding 
    end
	
endmodule
