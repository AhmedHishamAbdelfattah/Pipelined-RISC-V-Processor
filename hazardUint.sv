module hazardUint (
    input [4:0] Rs1E , Rs2E, Rs1D , Rs2D,
    input [4:0] RdM , RdW, RdE,
    input RegWriteM , RegWriteW,
    input ResultSrcE0,
    input PcSrcE,
    output reg[1:0] forwardAE , forwardBE,
    output StallF , StallD, FlushE , FlushD
);
// 1 - data dep. handling 

// forwardAE
always @(*) begin
    if((Rs1E == RdM ) && (RegWriteM == 1'b1) && (Rs1E != 1'b0))
        forwardAE = 2'b10;
    else if ((Rs1E == RdW ) && (RegWriteW == 1'b1) && (Rs1E != 1'b0))
        forwardAE = 2'b01;
    else
        forwardAE = 2'b00; 
end
// forwardBE
always @(*) begin
    if((Rs2E == RdM ) && (RegWriteM == 1'b1) && (Rs2E != 1'b0))
        forwardBE = 2'b10;
    else if ((Rs2E == RdW ) && (RegWriteW == 1'b1) && (Rs2E != 1'b0))
        forwardBE = 2'b01;
    else
        forwardBE = 2'b00; 
end
// stalling logic {handling the lw dep.}
wire lwStall;
assign lwStall = (((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE0 == 1'b1));
assign StallF = lwStall;
assign StallD = lwStall;
assign FlushE = lwStall | PcSrcE;

// 2- control hazards {flush the instructions in decode stage and excute stage}
assign FlushD = PcSrcE;
endmodule
