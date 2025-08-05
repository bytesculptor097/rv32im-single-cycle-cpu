module tb_data_ram;
    reg clk;
    reg we;
    reg [31:0] addr;
    reg [31:0] din;
    wire [31:0] dout;

    data_ram uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Test 1: Check initial value at mem[25]
        addr = 25 << 2; // Word-aligned address
        we = 0;
        #10;
        $display("Initial mem[25] = %h", dout); // Expect DEADBEEF

        // Test 2: Write to mem[10]
        addr = 10 << 2;
        din = 32'hCAFEBABE;
        we = 1;
        #10;

        // Test 3: Read from mem[10]
        we = 0;
        #10;
        $display("Read mem[10] = %h", dout); // Expect CAFEBABE

        // Test 4: Boundary test
        addr = 255 << 2;
        din = 32'h12345678;
        we = 1;
        #10;
        we = 0;
        #10;
        $display("Read mem[255] = %h", dout); // Expect 12345678

        $finish;
    end
endmodule