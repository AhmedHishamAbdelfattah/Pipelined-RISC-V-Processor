module pcTarget_adder_p (
    input [31:0] pc,
    input [31:0] immExt,
    output [31:0] pcTarget
);
assign pcTarget = pc + immExt;
    
endmodule
