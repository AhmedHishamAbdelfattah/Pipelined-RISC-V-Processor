module control_p (
    input [6:0] op,
    input [2:0] funct3,
    input funct7_5, 
    output reg MemWrite,AluSrc,RegWrite,
    output reg [1:0]ResultSrc,
    output reg jump , Branch,
    output reg [2:0]ALUControl,
    output reg [1:0] immSrc
);
reg [1:0] ALUOp;
//main decoder
always @(*) begin
    jump = 1'b0;
    casex (op)
        3:begin //lw
            RegWrite = 1'b1;
            immSrc = 2'b00;
            AluSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 2'b01;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end
        35:begin //sw
            RegWrite = 1'b0;
            immSrc = 2'b01;
            AluSrc = 1'b1;
            MemWrite = 1'b1;
            ResultSrc = 2'bxx;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end 
        51:begin //R-type
            RegWrite = 1'b1;
            immSrc = 2'bxx;
            AluSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            ALUOp = 2'b10;
        end 
        99:begin //beq
            RegWrite = 1'b0;
            immSrc = 2'b10;
            AluSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 2'bxx;
            Branch = 1'b1;
            ALUOp = 2'b01;
        end
        19:begin //I-type
            RegWrite = 1'b1;
            immSrc = 2'b00;
            AluSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            ALUOp = 2'b10;
        end
        111:begin
            RegWrite = 1'b1;
            immSrc = 2'b11;
            AluSrc = 1'bx;
            MemWrite = 1'b0;
            ResultSrc = 2'b10;
            Branch = 1'b0;
            ALUOp = 2'bxx;
            jump = 1'b1;
        end
        default:begin
            RegWrite = 1'b0;
            immSrc = 2'b00;
            AluSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 2'b00;
            Branch = 1'b0;
            ALUOp = 2'b00;
            jump = 1'b0;
        end 
    endcase
end

 // ALU Decoder 

    always @(*) begin
        case (ALUOp)

            // ----------------------------------------
            // ALUop = 00 → always ADD (for load/store)
            // ----------------------------------------
            2'b00: ALUControl = 3'b000; // ADD
            // ----------------------------------------
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 01 → always SUB (for branch) beq
            // ----------------------------------------
            2'b01: ALUControl = 3'b001; // SUB
            // ----------------------------------------
            // ----------------------------------------

            // ----------------------------------------
            // ALUop = 10 → Use funct7, funct3, op5
            // ----------------------------------------
            2'b10: begin
                casex({funct7_5, op[5], funct3})
                    // ADD
                    5'b00_000: ALUControl = 3'b000;
                    5'b01_000: ALUControl = 3'b000;
                    5'b10_000: ALUControl = 3'b000;

                    // SUB
                    5'b11_000: ALUControl = 3'b001;

                    // SLT
                    5'bxx_010: ALUControl = 3'b101;

                    // OR
                    5'bxx_110: ALUControl = 3'b011;

                    // AND
                    5'bxx_111: ALUControl = 3'b010;

                    default: ALUControl = 3'bxxx;
                endcase
            end

            default: ALUControl = 3'bxxx;
        endcase
    end
    
endmodule
