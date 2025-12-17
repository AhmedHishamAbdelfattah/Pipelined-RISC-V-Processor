module pcPlus4_adder_p (
    input [31:0] pc,
    output[31:0] pcPlus4 
);
assign pcPlus4 = pc + 32'd4;
endmodule
