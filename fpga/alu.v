module ALU(
    input [31:0] A, B,
    input [3:0] ALUControl,
    output reg [31:0] Result,
    output reg zero
);

    // Signed and Unsigned numbers logic
    wire signed [31:0] A_signed = $signed(A);
    wire signed [31:0] B_signed = $signed(B);

    wire [31:0] abs_A = A_signed[31] ? (~A_signed + 1) : A_signed;
    wire [31:0] abs_B = B_signed[31] ? (~B_signed + 1) : B_signed;

    wire [31:0] unsigned_mul = abs_A * abs_B;
    wire [31:0] unsigned_div = (abs_B != 0) ? abs_A / abs_B : 32'hFFFFFFFF;
    wire [31:0] unsigned_rem = (abs_B != 0) ? abs_A % abs_B : abs_A;

    wire mul_sign = A_signed[31] ^ B_signed[31];
    wire div_sign = A_signed[31] ^ B_signed[31];

    wire [31:0] signed_mul = mul_sign ? (~unsigned_mul + 1) : unsigned_mul;
    wire [31:0] signed_div = div_sign ? (~unsigned_div + 1) : unsigned_div;
    wire [31:0] signed_rem = A_signed[31] ? (~unsigned_rem + 1) : unsigned_rem;

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;                           // AND
            4'b0001: Result = A | B;                           // OR
            4'b0010: Result = A + B;                           // ADD
            4'b0110: Result = A - B;                           // SUB
            4'b0011: Result = A ^ B;                           // XOR
            4'b1000: Result = A << B[4:0];                     // SLL
            4'b1001: Result = A >> B[4:0];                     // SRL
            4'b0101: Result = A >>> B[4:0];                    // SRA
            4'b0111: Result = (A_signed < B_signed) ? 32'b1 : 32'b0; // SLT
            4'b0100: Result = (A < B) ? 32'b1 : 32'b0;         // SLTU

            // Signed MUL/DIV/REM
            4'b1010: Result = signed_mul;                      // MUL
            4'b1011: Result = (B == 0) ? 32'hFFFFFFFF : signed_div; // DIV
            4'b1101: Result = (B == 0) ? A : signed_rem;       // REM

            // Unsigned DIV/REM
            4'b1100: Result = (B == 0) ? 32'hFFFFFFFF : A / B; // DIVU
            4'b1110: Result = (B == 0) ? A : A % B;            // REMU

            default: Result = 32'b0;                           // Invalid
        endcase

        zero = (Result == 32'b0);

        $display("ALUControl=%b, A=%d, B=%d, Result=%d", ALUControl, A, B, Result);
    end

endmodule