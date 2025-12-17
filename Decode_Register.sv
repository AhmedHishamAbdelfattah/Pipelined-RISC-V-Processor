module decode_register (
    input clk , rst_n, en_n ,CLR,
    input [31:0] instrF,
    input [31:0] PCF,
    input [31:0]PCPulse4F,
    output reg [31:0]instrD,
    output reg [31:0]PCD,
    output reg [31:0]PCPulse4D
);

always @(posedge clk , negedge rst_n ) begin
    if(~rst_n | CLR) begin
        instrD    <= 0;
        PCD       <= 0;
        PCPulse4D <=0;
    end
    else begin
        if(~en_n) begin
            instrD    <= instrF;
            PCD       <= PCF;
            PCPulse4D <= PCPulse4F;
        end
    end
end
endmodule
