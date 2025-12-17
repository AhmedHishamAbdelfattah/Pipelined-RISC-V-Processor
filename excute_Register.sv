module excute_register (
    input clk , rst_n , CLR,
    // control signals inputs
    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input [2:0] ALUControlD,
    input ALUSrcD,
    //input [1:0] ImmSrcD,
    // data inputs
    input [31:0] RD1D , RD2D,
    input [31:0] PCD,
    input [4:0] Rs1D , Rs2D, RdD,
    input [31:0] ExtImmD,
    input [31:0] PCPulse4D,
    // control signals outputs 
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,
    // data outputs
    output reg [31:0] RD1E , RD2E,
    output reg [31:0] PCE,
    output reg [4:0] Rs1E , Rs2E, RdE,
    output reg [31:0] ExtImmE,
    output reg [31:0] PCPulse4E
);

always @(posedge clk  ,negedge rst_n) begin
    if(~rst_n|CLR) begin // reset the whole register
        // reset control signals
        RegWriteE  <= 0;
        ResultSrcE <= 0;
        MemWriteE <= 0;
        JumpE <= 0;
        BranchE <= 0;
        ALUControlE <= 0;
        ALUSrcE <= 0;
        // reset data 
        RD1E <= 0;
        RD2E <= 0;
        PCE <= 0;
        Rs1E <= 0;
        Rs2E <= 0;
        RdE <= 0;
        ExtImmE <= 0;
        PCPulse4E <= 0;
    end
    else begin
            RegWriteE  <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ExtImmE <= ExtImmD;
            PCPulse4E <= PCPulse4D;
    end
end
    
endmodule
