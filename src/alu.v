module ALU(
    input [31:0] A, B,
    input [3:0] ALUControl,
    output reg [31:0] Result,
    output reg zero   // zero output of the ALU
);

 // ALUControl encoding 

 always @(*) begin
   

    case (ALUControl)
        4'b0000: Result = A & B;           // AND
        4'b0001: Result = A | B;           // OR
        4'b0010: Result = A + B;           // ADD
        4'b0110: Result = A - B;           // SUB
        4'b0011: Result = A ^ B;           // XOR
        4'b0100: Result = A << B[4:0];     // SLL
        4'b0101: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT
        4'b1010: Result = A * B;           // MUL

        4'b1011: Result = (B == 0) ? 32'hFFFFFFFF : $signed(A) / $signed(B); // DIV
        4'b1100: Result = (B == 0) ? 32'hFFFFFFFF : A / B;                   // DIVU
        4'b1101: Result = (B == 0) ? A : $signed(A) % $signed(B);            // REM
        4'b1110: Result = (B == 0) ? A : A % B;                              // REMU

        default: Result = 32'b0;          // Invalid operation
    endcase

    zero = (Result == 32'b0);     // Set zero output if result is zero


 end

endmodule
