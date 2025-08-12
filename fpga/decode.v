module decode (
    input wire [31:0] instr,
    output reg [6:0] opcode, funct7,
    output reg [4:0] rd, 
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [2:0] funct3,
    output reg [31:0] imm 
);

always @(*) begin
    // Default values to avoid latch inference
    rd      = 5'b00000;
    rs1     = 5'b00000;
    rs2     = 5'b00000;
    funct3  = 3'b000;
    funct7  = 7'b0000000;
    imm     = 32'b0;

    // Extract code
    opcode = instr[6:0];

    // R-Type: add, sub, and, or, etc.
    if (opcode == 7'b0110011) begin
        rd      = instr[11:7];
        funct3  = instr[14:12];
        rs1     = instr[19:15];
        rs2     = instr[24:20];
        funct7  = instr[31:25];
        imm     = 32'b0; // no immediate
    end

    // I-Type: addi, lw, jalr, etc.
    else if (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b1100111) begin
        rd      = instr[11:7];
        funct3  = instr[14:12];
        rs1     = instr[19:15];
        imm     = {{20{instr[31]}}, instr[31:20]}; // sign-extended 12-bit immediate
    end

    // S-Type: sw, sb, sh
    else if (opcode == 7'b0100011) begin
        funct3  = instr[14:12];
        rs1     = instr[19:15];
        rs2     = instr[24:20];
        imm     = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // sign-extended 12-bit immediate
    end

    // B-Type: beq, bne, blt, bge
    else if (opcode == 7'b1100011) begin
        funct3  = instr[14:12];
        rs1     = instr[19:15];
        rs2     = instr[24:20];
        imm     = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // sign-extended branch offset
    end

    // U-Type: lui, auipc
    else if (opcode == 7'b0110111 || opcode == 7'b0010111) begin
        rd      = instr[11:7];
        imm     = {instr[31:12], 12'b0}; // upper 20 bits shifted left
    end

    // J-Type: jal
    else if (opcode == 7'b1101111) begin
        rd      = instr[11:7];
        imm     = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // sign-extended jump offset
    end

    // CSR Instructions: csrrw, csrrs, csrrc
    else if (opcode == 7'b1110011) begin
     rd      = instr[11:7];
     funct3  = instr[14:12];
     rs1     = instr[19:15];
     imm     = {20'b0, instr[31:20]}; // CSR address as zero-extended immediate
    end

    
end

endmodule


