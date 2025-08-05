module control_unit_tb;
    reg [6:0] opcode;
    wire RegWrite, ALUSrc, MemRead, MemWrite, Branch, Jump, Jump_r, memtoreg, AUIPC;
    wire [1:0] ALUOp;

    control_unit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .Jump_r(Jump_r),
        .memtoreg(memtoreg),
        .AUIPC(AUIPC),
        .ALUOp(ALUOp)
    );

    initial begin
        $monitor("opcode=%b | RegWrite=%b ALUSrc=%b MemRead=%b MemWrite=%b Branch=%b Jump=%b Jump_r=%b memtoreg=%b AUIPC=%b ALUOp=%b",
                 opcode, RegWrite, ALUSrc, MemRead, MemWrite, Branch, Jump, Jump_r, memtoreg, AUIPC, ALUOp);

        opcode = 7'b0110011; #10; // R-type
        opcode = 7'b0010011; #10; // ADDI
        opcode = 7'b0000011; #10; // LW
        opcode = 7'b0100011; #10; // SW
        opcode = 7'b1100011; #10; // BEQ
        opcode = 7'b0110111; #10; // LUI
        opcode = 7'b1101111; #10; // JAL
        opcode = 7'b1100111; #10; // JALR
        opcode = 7'b0010111; #10; // AUIPC

        $finish;
    end
endmodule