module mux3_1 #(
    parameter WIDTH = 32
) (
    input [WIDTH - 1 : 0] in0 ,  in1 , in2,
    input [1:0]s,
    output reg [WIDTH - 1 : 0] out
);

always @(*) begin
    case (s)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2; 
        default: out = in0;
    endcase
end
    
endmodule
