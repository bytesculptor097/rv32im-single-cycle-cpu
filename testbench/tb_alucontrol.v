module alu_control_tb;
    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [3:0] ALUControl;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    initial begin
        $monitor("ALUOp=%b funct3=%b funct7=%b => ALUControl=%b", ALUOp, funct3, funct7, ALUControl);

        // lw/sw/addi (ADD)
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // beq (SUB)
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // R-type ADD
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // R-type SUB
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;

        // R-type MUL
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000001; #10;

        // R-type AND
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;

        // R-type OR
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #10;

        // R-type XOR
        ALUOp = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000; #10;

        // R-type SLT
        ALUOp = 2'b10; funct3 = 3'b010; funct7 = 7'b0000000; #10;

        // R-type SLL
        ALUOp = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000; #10;

        // R-type SRL
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #10;

        // R-type SRA (optional)
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0100000; #10;

        // LUI/AUIPC
        ALUOp = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // Unknown case
        ALUOp = 2'b10; funct3 = 3'b011; funct7 = 7'b0000000; #10;

        $finish;
    end
endmodule