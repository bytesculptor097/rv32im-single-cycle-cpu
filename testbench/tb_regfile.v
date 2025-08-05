module tb_regfile;
    reg clk;
    reg reg_write;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rs1_val, rs2_val;
    wire [31:0] x3_debug, x5_debug;

    regfile uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .x3_debug(x3_debug),
        .x5_debug(x5_debug)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Test 1: Read initial values
        rs1 = 5'd0; // x1
        rs2 = 5'd1; // x2
        #10;
        $display("Initial rs1_val (x1) = %h", rs1_val); // Expect 5
        $display("Initial rs2_val (x2) = %h", rs2_val); // Expect 5

        // Test 2: Write to x3
        rd = 5'd3;
        wd = 32'hCAFEBABE;
        reg_write = 1;
        #10;

        // Test 3: Write to x5
        rd = 5'd5;
        wd = 32'hDEADBEEF;
        #10;

        // Test 4: Attempt to write to x0 (should be ignored)
        rd = 5'd0;
        wd = 32'hFFFFFFFF;
        #10;

        // Test 5: Read back x3 and x5
        rs1 = 5'd3;
        rs2 = 5'd5;
        reg_write = 0;
        #10;
        $display("Read x3 = %h", rs1_val); // Expect CAFEBABE
        $display("Read x5 = %h", rs2_val); // Expect DEADBEEF

        // Debug outputs
        $display("x3_debug = %h", x3_debug);
        $display("x5_debug = %h", x5_debug);

        $finish;
    end
endmodule