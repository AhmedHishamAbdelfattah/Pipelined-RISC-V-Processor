module RISCV_Pipelined_32i (
    input clk, rst_n,
    output [31:0] addr, data,
    output we
);

    // --- Wires ---
    // D = Decode, E = Execute, M = Memory, W = Writeback, F = Fetch, FF = flip-flop
    wire [31:0] InstrD, InstrF, RD1D, RD2D, RD1E, RD2E, SrcAE, SrcBE;
    wire [31:0] ALUResultE, ALUResultM, WriteDataE, WriteDataM, ReadDataM, ReadDataW, PcF, PcFF, PcD, PcE, ALUResultW;
    wire [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, ImmExtD, ImmExtE, PCtargetE, ResultW;
    wire [4:0] RS1E, RS2E, RDE, RDM, RDW;
    wire RegwriteD, MemwriteD, JumpD, BranchD, ALUSrcD;
    wire RegwriteE, MemwriteE, JumpE, BranchE, ALUSrcE;
    wire RegwriteM, MemwriteM, RegwriteW;
    wire [2:0] ALUControlD, ALUControlE;
    wire [1:0] ResultsrcD, ImmsrcD, ResultsrcE, ResultsrcM, ResultsrcW, ForwarAE, ForwarBE;
    wire StallF, StallD, FlushD, FlushE, PcsrcE, ZeroE;

    // --- PC Source Logic ---
    assign PcsrcE = JumpE | (BranchE & ZeroE);

    // --- Fetch Stage ---
    mux_2_1 mux_pc(
        .in0(PCPlus4F),
        .in1(PCtargetE),
        .s(PcsrcE),
        .out(PcFF)
    ); // 2-to-1 mux for PC selection

    pc_p PCFF(
        .clk(clk),
        .rst_n(rst_n),
        .en_n(StallF),
        .pc_next(PcFF),
        .pc(PcF)
    ); // PC flip-flop

    i_memory_p instruction_memory(
        .A(PcF),
        .RD(InstrF)
    ); // Instruction memory

    pcPlus4_adder_p PCPLUS4(
        .pc(PcF),
        .pcPlus4(PCPlus4F)
    ); // PC + 4 adder

    // --- Decode Stage ---
    decode_register DPIPE(
        .clk(clk),
        .rst_n(rst_n),
        .en_n(StallD),
        .CLR(FlushD),
        .instrF(InstrF),
        .PCF(PcF),
        .PCPulse4F(PCPlus4F),
        .instrD(InstrD),
        .PCD(PcD),
        .PCPulse4D(PCPlus4D)
    ); // Decode stage pipeline register

    regfile_p Regfile(
        .clk(clk),
        .rst_n(rst_n),
        .WE3(RegwriteW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RDW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    ); // Register file

    control_p control_unit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7_5(InstrD[30]),
        .MemWrite(MemwriteD),
        .AluSrc(ALUSrcD),
        .RegWrite(RegwriteD),
        .ResultSrc(ResultsrcD),
        .jump(JumpD),
        .Branch(BranchD),
        .ALUControl(ALUControlD),
        .immSrc(ImmsrcD)
    ); // Control unit

    immExt_p Extend(
        .instr(InstrD[31:7]),
        .immSrc(ImmsrcD),
        .immExt(ImmExtD)
    ); // Immediate extension

    // --- Execute Stage ---
    excute_register EPIPE(
        .clk(clk),
        .rst_n(rst_n),
        .CLR(FlushE),
        .RegWriteD(RegwriteD),
        .ResultSrcD(ResultsrcD),
        .MemWriteD(MemwriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PcD),
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdD(InstrD[11:7]),
        .ExtImmD(ImmExtD),
        .PCPulse4D(PCPlus4D),
        .RegWriteE(RegwriteE),
        .ResultSrcE(ResultsrcE),
        .MemWriteE(MemwriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PcE),
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .RdE(RDE),
        .ExtImmE(ImmExtE),
        .PCPulse4E(PCPlus4E)
    ); // Execute stage pipeline register

    mux3_1 mux_srca(
        .in0(RD1E),
        .in1(ResultW),
        .in2(ALUResultM),
        .s(ForwarAE),
        .out(SrcAE)
    ); // 3-to-1 mux for ALU source A

    mux3_1 mux_writedata(
        .in0(RD2E),
        .in1(ResultW),
        .in2(ALUResultM),
        .s(ForwarBE),
        .out(WriteDataE)
    ); // 3-to-1 mux for ALU write data

    mux_2_1 mux_srcb(
        .in0(WriteDataE),
        .in1(ImmExtE),
        .s(ALUSrcE),
        .out(SrcBE)
    ); // 2-to-1 mux for ALU source B

    pcTarget_adder_p pctarget(
        .pc(PcE),
        .immExt(ImmExtE),
        .pcTarget(PCtargetE)
    ); // Branch target adder

    alu_p alu(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .ALUResult(ALUResultE),
        .Zero(ZeroE)
    ); // ALU

    // --- Memory Stage ---
    memory_register Mpipe(
        .clk(clk),
        .rst_n(rst_n),
        .RegWriteE(RegwriteE),
        .ResultSrcE(ResultsrcE),
        .MemWriteE(MemwriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RDE),
        .PCPlus4E(PCPlus4E),
        .RegWriteM(RegwriteM),
        .ResultSrcM(ResultsrcM),
        .MemWriteM(MemwriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RDM),
        .PCPlus4M(PCPlus4M)
    ); // Memory stage pipeline register

    data_memory_p Datamemory(
        .clk(clk),
        .WE(MemwriteM),
        .A(ALUResultM),
        .WD(WriteDataM),
        .RD(ReadDataM)
    ); // Data memory

    // --- Writeback Stage ---
    WriteBack_register Wpipe(
        .clk(clk),
        .rst_n(rst_n),
        .RegWriteM(RegwriteM),
        .ResultSrcM(ResultsrcM),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .RdM(RDM),
        .PCPlus4M(PCPlus4M),
        .RegWriteW(RegwriteW),
        .ResultSrcW(ResultsrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RDW),
        .PCPlus4W(PCPlus4W)
    ); // Writeback stage pipeline register

    mux3_1 mux_result(
        .in0(ALUResultW),
        .in1(ReadDataW),
        .in2(PCPlus4W),
        .s(ResultsrcW),
        .out(ResultW)
    ); // Writeback result multiplexer

    // --- Hazard Unit ---
    hazardUint hazard(
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdM(RDM),
        .RdW(RDW),
        .RdE(RDE),
        .RegWriteM(RegwriteM),
        .RegWriteW(RegwriteW),
        .ResultSrcE0(ResultsrcE),
        .PcSrcE(PcsrcE),
        .forwardAE(ForwarAE),
        .forwardBE(ForwarBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE),
        .FlushD(FlushD)
    ); // Hazard detection and forwarding unit

    // --- Output Logic ---
    assign addr = ALUResultM;
    assign we = MemwriteM;
    assign data = WriteDataM;

endmodule
