module immExt_p (
    input[24:0] instr,
    input [1:0] immSrc,
    output reg [31:0] immExt
);
always @(*) begin
    case (immSrc)
        2'b00: immExt = {{20{instr[24]}} ,instr[24:13] };             // I-type
        2'b01: immExt = {{20{instr[24]}} ,instr[24:18], instr[4:0] };  // S-type
        2'b10: immExt = {{19{instr[24]}} , instr[24] , instr[0],instr[23:19] , instr[4:1] , 1'b0}; // B-type
        2'b11: immExt = {{12{instr[24]}} , instr[12:5] , instr[13] , instr[23:14] , 1'b0}; //J-type
        default: immExt = {{20{instr[24]}} , instr[24:0]}; 
    endcase
end
    
endmodule
