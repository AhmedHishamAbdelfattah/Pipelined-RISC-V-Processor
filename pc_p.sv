module pc_p (
    input clk, rst_n, en_n,
    input [31:0]pc_next,
    output reg[31 : 0] pc
);
always @(posedge clk , negedge rst_n) begin
    if(~rst_n)
        pc <= 0;
    else
        if(~en_n)
            pc <= pc_next;
end
endmodule
