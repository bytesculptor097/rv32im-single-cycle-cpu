module alu_control (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
    
        2'b00: ALUControl = 4'b0010; // ADD for lw/sw/addi
        2'b01: ALUControl = 4'b0110; // SUB for branches (e.g., beq)

        2'b10: begin // R-type
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALUControl = 4'b0110; // SUB
                    else if (funct7 == 7'b0000001)
                        ALUControl = 4'b1010; // MUL
                    else
                        ALUControl = 4'b0010; // ADD
                end
                3'b100: begin
                    if (funct7 == 7'b0000001)
                        ALUControl = 4'b1011; // DIV
                    else
                        ALUControl = 4'b0011; // XOR
                end
                3'b101: begin
                    if (funct7 == 7'b0000001)
                        ALUControl = 4'b1100; // DIVU
                    else
                        ALUControl = 4'b1001; // SRL
                end
                3'b110: begin
                    if (funct7 == 7'b0000001)
                        ALUControl = 4'b1101; // REM
                    else
                        ALUControl = 4'b0001; // OR
                end
                3'b111: begin
                    if (funct7 == 7'b0000001)
                        ALUControl = 4'b1110; // REMU
                    else
                        ALUControl = 4'b0000; // AND
                end
                3'b010: ALUControl = 4'b0111; // SLT
                3'b001: ALUControl = 4'b1000; // SLL
                default: ALUControl = 4'b1111; // Invalid
            endcase
        end

        2'b11: ALUControl = 4'b1110; // LUI or AUIPC

        default: ALUControl = 4'b1111; // Unknown
    endcase

    
end

endmodule