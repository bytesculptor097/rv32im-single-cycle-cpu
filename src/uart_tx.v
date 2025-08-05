module uart_tx #(
    parameter CLK_FREQ   = 48_000_000,   // 48 MHz
    parameter BAUD_RATE  = 115_200       // 115.2 kbaud
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    // Calculate clock cycles per UART bit
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    // Internal registers
    reg [15:0] clk_cnt;          // Bit‐clock divider counter
    reg [3:0]  bit_idx;          // Shift‐register index (0–9)
    reg [9:0]  shift_reg;        // {stop, data[7:0], start}

    // FSM and data shifting
    always @(posedge clk) begin
        if (!rst_n) begin
            tx        <= 1'b1;     // Idle state
            tx_busy   <= 1'b0;
            clk_cnt   <= 0;
            bit_idx   <= 0;
            shift_reg <= 10'b11_1111_1111;  
        end else begin
            if (tx_busy) begin
                // Timing for each bit
                if (clk_cnt == CLKS_PER_BIT-1) begin
                    clk_cnt <= 0;
                    tx      <= shift_reg[0];
                    shift_reg <= {1'b1, shift_reg[9:1]}; 
                    bit_idx <= bit_idx + 1;
                    
                    // Completed all bits?
                    if (bit_idx == 9) begin
                        tx_busy <= 1'b0;
                        bit_idx <= 0;
                    end
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end else if (tx_start) begin
                // Load frame: {stop=1, data[7:0], start=0}
                shift_reg <= {1'b1, tx_data, 1'b0};
                tx_busy   <= 1'b1;
                clk_cnt   <= 0;
                bit_idx   <= 0;
            end
        end

        
    if (tx_start)
     $display("TX start: %c", tx_data);
 end


endmodule