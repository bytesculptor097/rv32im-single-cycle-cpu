module tb_decode;
  reg [31:0] instr;
  wire [6:0] opcode, funct7;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [31:0] imm;

  // Instantiate decode module
  decode uut (
    .instr(instr),
    .opcode(opcode),
    .funct7(funct7),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .funct3(funct3),
    .imm(imm)
  );

  initial begin
    $display("Starting decode test...");

    // R-Type: ADD x3, x1, x2 → 32'h002081b3
    instr = 32'h002081b3; #10;
    $display("R-Type ADD: opcode=%b, rd=%d, rs1=%d, rs2=%d, funct3=%b, funct7=%b", opcode, rd, rs1, rs2, funct3, funct7);

    // I-Type: ADDI x2, x0, 10 → 32'h00a00113
    instr = 32'h00a00113; #10;
    $display("I-Type ADDI: opcode=%b, rd=%d, rs1=%d, imm=%h, funct3=%b", opcode, rd, rs1, imm, funct3);

    // S-Type: SW x5, 8(x1) → 32'h00512023
    instr = 32'h00512023; #10;
    $display("S-Type SW: opcode=%b, rs1=%d, rs2=%d, imm=%h, funct3=%b", opcode, rs1, rs2, imm, funct3);

    // B-Type: BEQ x1, x2, offset → 32'h00208663
    instr = 32'h00208663; #10;
    $display("B-Type BEQ: opcode=%b, rs1=%d, rs2=%d, imm=%h, funct3=%b", opcode, rs1, rs2, imm, funct3);

    // U-Type: LUI x5, 0x12345 → 32'h123450b7
    instr = 32'h123450b7; #10;
    $display("U-Type LUI: opcode=%b, rd=%d, imm=%h", opcode, rd, imm);

    // J-Type: JAL x1, offset → 32'h004000ef
    instr = 32'h004000ef; #10;
    $display("J-Type JAL: opcode=%b, rd=%d, imm=%h", opcode, rd, imm);

    $display("Decode test complete.");
    $finish;
  end
endmodule