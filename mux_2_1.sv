module mux_2_1 #(
    parameter WIDTH = 32
) (
    input [WIDTH - 1 : 0]in0 , in1,
    input s,
    output[WIDTH -1 : 0] out
);
    assign out = (s)?in1:in0;
endmodule
