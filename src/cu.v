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
    output reg AUIPC,
    output reg [1:0] ALUOp,
    output reg csr_read_en,    
    output reg csr_write_en,   
    output reg is_csr           

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
    AUIPC    = 0;
    memtoreg = 0;
    csr_read_en  = 0;
    csr_write_en = 0;
    is_csr = 0;

    case (opcode)
        7'b0110011: begin // R-type (e.g., add, sub)
            RegWrite = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b10;
            memtoreg = 0; // Write ALU result to register
        end

        7'b0010011: begin // I-type (e.g., addi)
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
            MemRead  = 0;
            MemWrite = 0;
            memtoreg = 0; // Write ALU result to register
        end

        7'b0000011: begin // I-type (e.g., lw)
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemWrite = 0;
            memtoreg = 1; // Read data from memory
            ALUOp    = 2'b00;
        end

        7'b0100011: begin // S-type (e.g., sw)
            RegWrite = 0;
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        7'b1100011: begin // B-type (e.g., beq)
            RegWrite = 0;
            ALUSrc   = 0;
            Branch   = 1;
            ALUOp    = 2'b01;
        end

        7'b0110111: begin // U-type (e.g., lui)
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b11; // Custom code for LUI
        end

        7'b1101111: begin // J-type (e.g., jal)
            RegWrite = 1;
            Jump   = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b1100111: begin // I-type (e.g., jalr)
            RegWrite = 1;
            Jump_r   = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        7'b0010111: begin // U-type (auipc) 
            RegWrite = 1;
            AUIPC    = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00; // Use ALU to add PC + imm
        end

        7'b1110011: begin // SYSTEM (CSR)
            is_csr = 1;
            RegWrite = 1; // CSR instructions write to rd

            case (funct3)
                3'b001: begin // CSRRW
                    csr_read_en  = 1;
                    csr_write_en = 1;
                end
                3'b010: begin // CSRRS
                    csr_read_en  = 1;
                    csr_write_en = 1; // only if rs1 ≠ x0 (handled elsewhere)
                end
                3'b011: begin // CSRRC
                    csr_read_en  = 1;
                    csr_write_en = 1; // only if rs1 ≠ x0
                end
                3'b101: begin // CSRRWI
                    csr_read_en  = 1;
                    csr_write_en = 1;
                end
                3'b110: begin // CSRRSI
                    csr_read_en  = 1;
                    csr_write_en = 1;
                end
                3'b111: begin // CSRRCI
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
            
        end

        
    endcase



 end


endmodule