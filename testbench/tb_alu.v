module tb_ALU;
  reg [31:0] A, B;
  reg [3:0] ALUControl;
  wire [31:0] Result;
  wire Zero;

  // Instantiate the ALU
  ALU uut (
    .A(A),
    .B(B),
    .ALUControl(ALUControl),
    .Result(Result),
    .Zero(Zero)
  );

  initial begin
    $display("Starting ALU test...");
    $monitor("ALUControl=%b | A=%h B=%h => Result=%h | Zero=%b", ALUControl, A, B, Result, Zero);

    // AND
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 4'b0000; #10;

    // OR
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 4'b0001; #10;

    // ADD
    A = 32'h00000005; B = 32'h0000000A; ALUControl = 4'b0010; #10;

    // SUB
    A = 32'h0000000A; B = 32'h00000005; ALUControl = 4'b0110; #10;

    // XOR
    A = 32'hAAAAAAAA; B = 32'h55555555; ALUControl = 4'b0011; #10;

    // SLL
    A = 32'h00000001; B = 32'h00000004; ALUControl = 4'b0100; #10;

    // SLT (signed comparison)
    A = -5; B = 3; ALUControl = 4'b0101; #10;
    A = 5; B = -3; ALUControl = 4'b0101; #10;

    // MUL
    A = 32'h00000003; B = 32'h00000004; ALUControl = 4'b1010; #10;

    // Zero flag test
    A = 32'h00000005; B = 32'h00000005; ALUControl = 4'b0110; #10; // SUB → Zero

    // Invalid operation
    A = 32'h12345678; B = 32'h87654321; ALUControl = 4'b1111; #10;

    $display("ALU test complete.");
    $finish;
  end
endmodule