module tb_ram;
  reg clk;
  reg we;
  reg [31:0] addr;
  reg [31:0] din;
  wire [31:0] dout;

  // Instantiate RAM
  ram uut (
    .clk(clk),
    .we(we),
    .addr(addr),
    .din(din),
    .dout(dout)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    $display("Starting RAM test...");
    we = 0; addr = 32'h00000008; din = 32'h00000000; // addr[11:2] = 2

    #10; // Wait for clock edge
    $display("Read from addr 0x08: dout = %h (should be 002081b3)", dout);

    // Write new value
    we = 1; din = 32'hDEADBEEF; addr = 32'h0000000C; // addr[11:2] = 3
    #10;

    // Read back
    we = 0; addr = 32'h0000000C;
    #10;
    $display("Read from addr 0x0C: dout = %h (should be DEADBEEF)", dout);

    $display("RAM test complete.");
    $finish;
  end
endmodule