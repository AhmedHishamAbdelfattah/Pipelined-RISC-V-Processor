module WriteBack_register (
    input clk , rst_n,
    // control signals inputs
    input RegWriteM,
    input [1:0] ResultSrcM,
    // data inputs 
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [4:0] RdM,
    input [31:0]PCPlus4M,
    // control signals outputs 
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    // data outputs
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0] RdW,
    output reg [31:0] PCPlus4W
);
always @(posedge clk  , negedge rst_n) begin
    if(~rst_n) begin // reset the whole register
        // reset control signals
        RegWriteW <= 0;
        ResultSrcW <= 0;
        // reset data
        ALUResultW <= 0;
        ReadDataW <= 0;
        RdW <= 0;
        PCPlus4W <= 0;
    end
    else begin
        // update control signals 
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        // update data
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
    end
end
    
endmodule
