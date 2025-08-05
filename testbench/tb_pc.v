module tb_pc;
  reg clk;
  reg rst;
  reg [31:0] next_addr;
  wire [31:0] curr_addr;

  // Instantiate PC
  pc uut (
    .clk(clk),
    .rst(rst),
    .next_addr(next_addr),
    .curr_addr(curr_addr)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    $display("Testing PC module with external next_addr...");
    $monitor("Time=%0t | rst=%b | next_addr=%h | curr_addr=%h", $time, rst, next_addr, curr_addr);

    // Reset
    rst = 1; next_addr = 32'h00000000;
    #10 rst = 0;

    // Feed next addresses manually
    next_addr = 32'h00000004; #10;
    next_addr = 32'h00000008; #10;
    next_addr = 32'h00000020; #10; // Simulate jump
    next_addr = 32'h00000024; #10;

    // Reset again
    rst = 1; #10;
    rst = 0; next_addr = 32'h00000004; #10;

    $display("Test complete.");
    $finish;
  end
endmodule