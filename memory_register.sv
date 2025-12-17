module memory_register (
    input clk , rst_n ,
    // control signals inputs
    input RegWriteE ,
    input [1:0] ResultSrcE ,
    input MemWriteE ,
    // data inputs 
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [4:0] RdE,
    input [31:0] PCPlus4E,
    // control signals ouputs
    output reg RegWriteM ,
    output reg [1:0] ResultSrcM ,
    output reg MemWriteM ,
    // data outputs
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCPlus4M
);
always @(posedge clk  , negedge rst_n ) begin
    if(~rst_n) begin // reset the whole register
        // reset control signals
        RegWriteM <= 0;
        ResultSrcM <= 0;
        MemWriteM <= 0;
        // reset data
        ALUResultM <= 0;
        WriteDataM <= 0;
        RdM <= 0;
        PCPlus4M <= 0;
    end
    else begin
        // update control signals
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        // update data
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
    end
end
    
endmodule
