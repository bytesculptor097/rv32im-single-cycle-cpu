module csr (
    input         clk,
    input         reset,
    input         csr_read_en,
    input         csr_write_en,
    input  [11:0] csr_addr,
    input  [31:0] csr_write_data,
    input         trap_enter,
    input         trap_exit,
    input  [31:0] current_pc,
    input  [31:0] exception_code,
    output [31:0] csr_read_data,
    output [31:0] mtvec_out,
    output [31:0] mepc_out
);

    // CSR registers
    reg [31:0] misa;
    reg [31:0] mstatus;
    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mcause;
    reg [31:0] mcycle;
    reg [31:0] minstret;

    // Constants for mstatus bits
    localparam MIE_BIT  = 3;
    localparam MPIE_BIT = 7;
    localparam MPP_BITS = 11;

    // Reset and write logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            misa     <= (1 << 30) | (1 << 8) | (1 << 12); // RV32IM
            mstatus  <= 32'b0;
            mtvec    <= 32'b0;
            mepc     <= 32'b0;
            mcause   <= 32'b0;
            mcycle   <= 32'b0;
            minstret <= 32'b0;
        end else begin
            // Auto-increment counters
            mcycle   <= mcycle + 1;
            minstret <= minstret + 1;

            // CSR write
            if (csr_write_en) begin
                case (csr_addr)
                    12'h300: mstatus  <= csr_write_data;
                    12'h305: mtvec    <= csr_write_data;
                    12'h341: mepc     <= csr_write_data;
                    12'h342: mcause   <= csr_write_data;
                    12'hC00: mcycle   <= csr_write_data;
                    12'hC02: minstret <= csr_write_data;
                    // misa is read-only
                endcase
            end

            // Trap entry logic
            if (trap_enter) begin
                mepc   <= current_pc;
                mcause <= exception_code;
                mstatus[MPIE_BIT] <= mstatus[MIE_BIT]; // Save MIE to MPIE
                mstatus[MIE_BIT]  <= 1'b0;             // Disable MIE
                mstatus[MPP_BITS+:2] <= 2'b11;         // Set MPP to Machine mode
            end

            // Trap return logic (MRET)
            if (trap_exit) begin
                mstatus[MIE_BIT]  <= mstatus[MPIE_BIT]; // Restore MIE
                mstatus[MPIE_BIT] <= 1'b1;              // Set MPIE
                mstatus[MPP_BITS+:2] <= 2'b00;          // Clear MPP to User mode
            end
        end

    end

    // CSR read logic
    assign csr_read_data = (csr_read_en) ? (
        (csr_addr == 12'h301) ? misa     :
        (csr_addr == 12'h300) ? mstatus  :
        (csr_addr == 12'h305) ? mtvec    :
        (csr_addr == 12'h341) ? mepc     :
        (csr_addr == 12'h342) ? mcause   :
        (csr_addr == 12'hC00) ? mcycle   :
        (csr_addr == 12'hC02) ? minstret :
        32'b0
    ) : 32'b0;

    // Outputs for trap handler
    assign mtvec_out = mtvec;
    assign mepc_out  = mepc;


endmodule
