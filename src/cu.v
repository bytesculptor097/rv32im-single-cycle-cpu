module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg Jump_r,
    output reg memtoreg,
    output reg [1:0] ALUOp,
    output reg csr_read_en,    
    output reg csr_write_en,   
    output reg is_csr,
    output reg [2:0] branch_type  
);

 always @(*) begin
    // Default values
    RegWrite = 0;
    ALUSrc   = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    Jump     = 0;
    Jump_r   = 0;
    ALUOp    = 2'b00;
    memtoreg = 0;
    csr_read_en  = 0;
    csr_write_en = 0;
    is_csr = 0;
    branch_type = 3'b000; // Default to BEQ

    case (opcode)
        7'b0110011: begin // R-type
            RegWrite = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b10;
            memtoreg = 0;
        end

        7'b0010011: begin // I-type (e.g., addi)
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b0000011: begin // Load
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            memtoreg = 1;
            ALUOp    = 2'b00;
        end

        7'b0100011: begin // Store
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        7'b1100011: begin // Branch
            Branch   = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b01;
            case (funct3)
                3'b000: branch_type = 3'b000; // BEQ
                3'b001: branch_type = 3'b001; // BNE
                3'b100: branch_type = 3'b010; // BLT
                3'b101: branch_type = 3'b011; // BGE
                default: branch_type = 3'b000;
            endcase
        end

        7'b0110111: begin // LUI
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b11;
        end

        7'b1101111: begin // JAL
            RegWrite = 1;
            Jump     = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b1100111: begin // JALR
            RegWrite = 1;
            Jump_r   = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b0010111: begin // AUIPC
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b1110011: begin // SYSTEM (CSR)
            is_csr = 1;
            RegWrite = 1;
            case (funct3)
                3'b001, 3'b010, 3'b011, 3'b101, 3'b110, 3'b111: begin
                    csr_read_en  = 1;
                    csr_write_en = 1;
                end
                default: begin
                    csr_read_en  = 0;
                    csr_write_en = 0;
                end
            endcase
        end

        default: begin
            // No action
        end
    endcase
 end

endmodule