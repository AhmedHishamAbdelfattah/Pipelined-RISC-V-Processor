
`timescale 1ns/1ps

module TB_RISCV_Pipelined();

    reg clk;
    reg rst_n;
	wire [31:0] addr, data ;
	wire we ;

    integer k;
    integer m;

    // DUT
    RISCV_Pipelined_32i dut (
        .clk(clk),
        .rst_n(rst_n),
		.addr(addr),
		.data(data),
		.we(we)
    );


// ================================================================================================================
// CLOCK & RESET
// ================================================================================================================

    // Clock generation (10 ns period)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Active-low reset
    initial begin
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
    end


// ================================================================================================================
// PIPELINE DEBUG MONITOR (Every Cycle)
// ================================================================================================================
always @(posedge clk) begin
    #1; // allow signals to settle

    $display("\n================================================================================");
    $display(" Cycle @ time = %0t", $time);
    $display("================================================================================");

    // --------------------------------------------------------------------------------
    // FETCH STAGE
    // --------------------------------------------------------------------------------
    $display(" FETCH STAGE:");
    $display("  PC_F        = %h", dut.PcF);
    $display("  Instr_F     = %h", dut.InstrF);
    $display("  PCPlus4_F   = %h", dut.PCPlus4F);

    // --------------------------------------------------------------------------------
    // DECODE STAGE
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" DECODE STAGE:");
    $display("  PC_D        = %h", dut.PcD);
    $display("  Instr_D     = %h", dut.InstrD);
    $display("  RD1_D       = %h", dut.RD1D);
    $display("  RD2_D       = %h", dut.RD2D);
    $display("  ImmExt_D    = %h", dut.ImmExtD);

    $display("  CONTROL D:");
    $display("   RegWriteD  = %b", dut.RegwriteD);
    $display("   MemWriteD  = %b", dut.MemwriteD);
    $display("   ALUSrcD    = %b", dut.ALUSrcD);
    $display("   BranchD    = %b", dut.BranchD);
    $display("   JumpD      = %b", dut.JumpD);
    $display("   ResultSrcD = %b", dut.ResultsrcD);
    $display("   ALUCtrlD   = %b", dut.ALUControlD);

    // --------------------------------------------------------------------------------
    // EXECUTE STAGE
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" EXECUTE STAGE:");
    $display("  PC_E        = %h", dut.PcE);
    $display("  SrcA_E      = %h", dut.SrcAE);
    $display("  SrcB_E      = %h", dut.SrcBE);
    $display("  ALUResultE  = %h", dut.ALUResultE);
    $display("  ZeroE      = %b", dut.ZeroE);
    $display("  PCtargetE  = %h", dut.PCtargetE);

    $display("  CONTROL E:");
    $display("   RegWriteE  = %b", dut.RegwriteE);
    $display("   MemWriteE  = %b", dut.MemwriteE);
    $display("   BranchE    = %b", dut.BranchE);
    $display("   JumpE      = %b", dut.JumpE);
    $display("   PcSrcE     = %b", dut.PcsrcE);

    // --------------------------------------------------------------------------------
    // MEMORY STAGE
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" MEMORY STAGE:");
    $display("  ALUResultM  = %h", dut.ALUResultM);
    $display("  WriteDataM  = %h", dut.WriteDataM);
    $display("  ReadDataM   = %h", dut.ReadDataM);
    $display("  MemWriteM  = %b", dut.MemwriteM);

    // --------------------------------------------------------------------------------
    // WRITEBACK STAGE
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" WRITEBACK STAGE:");
    $display("  ALUResultW  = %h", dut.ALUResultW);
    $display("  ReadDataW   = %h", dut.ReadDataW);
    $display("  ResultW     = %h", dut.ResultW);
    $display("  RdW         = %0d", dut.RDW);
    $display("  RegWriteW  = %b", dut.RegwriteW);

    // --------------------------------------------------------------------------------
    // HAZARD & FORWARDING
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" HAZARD UNIT:");
    $display("  ForwardAE = %b", dut.ForwarAE);
    $display("  ForwardBE = %b", dut.ForwarBE);
    $display("  StallF   = %b", dut.StallF);
    $display("  StallD   = %b", dut.StallD);
    $display("  FlushD   = %b", dut.FlushD);
    $display("  FlushE   = %b", dut.FlushE);

    // --------------------------------------------------------------------------------
    // REGISTER FILE (x0–x9)
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" REGISTER FILE:");
    for (k = 0; k < 10; k = k + 1)
        $display("  x%0d = %h", k, dut.Regfile.reg_file[k]);

    // --------------------------------------------------------------------------------
    // DATA MEMORY (0–7)
    // --------------------------------------------------------------------------------
    $display("--------------------------------------------------------------------------------");
    $display(" DATA MEMORY:");
    for (m = 0; m < 8; m = m + 1)
        $display("  mem[%0d] = %h", m, dut.Datamemory.data_mem[m]);

    $display("================================================================================\n");
end


// ================================================================================================================
// FINAL CHECK & STOP
// ================================================================================================================
initial begin
    #300;

    // Expected:
    // x1 = 5
    // x2 = 10
    // x3 = 15
    // MEM[0] = 15
    // x7 = 15
    // x9 = 9

    if (dut.Regfile.reg_file[3] == 15 &&
        dut.Regfile.reg_file[7] == 15 &&
        dut.Regfile.reg_file[9] == 9)
    begin
        $display("====================================================");
        $display("          PIPELINED SIMULATION SUCCESSFUL");
        $display("====================================================");
    end
    else begin
        $display("====================================================");
        $display("          PIPELINED SIMULATION FAILED");
        $display(" x3 = %d, x7 = %d, x9 = %d",
                  dut.Regfile.reg_file[3],
                  dut.Regfile.reg_file[7],
                  dut.Regfile.reg_file[9]);
        $display("====================================================");
    end

    $stop;
end

endmodule
