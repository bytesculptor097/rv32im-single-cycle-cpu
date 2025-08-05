module tb_core;
    reg clk;
    reg rst;
    wire [31:0] x5_debug;

    // Instantiate your core
    core uut (
        .clk(clk),
        .rst(rst)

    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units per cycle
    end

    // Simulation control
    initial begin
        rst = 1;
        #10 rst = 0;

        // Run for a few cycles
        #100;



        $finish;
    end
endmodule