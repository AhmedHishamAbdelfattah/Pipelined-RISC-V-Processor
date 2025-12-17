module data_memory_p (
    input clk , WE,
    input [31:0]A,
    input [31:0]WD,
    output[31:0]RD 
);
reg [31:0]data_mem[1023:0];

always @(posedge clk) begin
    if(WE)
        data_mem[A] <= WD;
end
assign RD = (WE == 1'b0) ? data_mem[A] : 0;
endmodule
