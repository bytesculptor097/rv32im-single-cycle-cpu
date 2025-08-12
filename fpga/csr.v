module csr (
    input         clk,
    input         reset,
    input  [11:0] csr_addr,
    input         csr_read_en,
    input         csr_write_en,
    input  [31:0] csr_write_data,
    output [31:0] csr_read_data
);

    // Define CSR registers
    reg [31:0] misa;
    reg [31:0] mstatus;
    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mcause;

    // Initialize CSRs on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            misa    <= (1 << 30) | (1 << 8) | (1 << 12); // RV32IM
            mstatus <= 32'b0;
            mtvec   <= 32'b0;
            mepc    <= 32'b0;
            mcause  <= 32'b0;
        end else if (csr_write_en) begin
            case (csr_addr)
                12'h300: mstatus <= csr_write_data;
                12'h305: mtvec   <= csr_write_data;
                12'h341: mepc    <= csr_write_data;
                12'h342: mcause  <= csr_write_data;
                // misa is read-only — no write
            endcase
        end
    end

    // CSR read logic
    assign csr_read_data = (csr_read_en) ? (
        (csr_addr == 12'h301) ? misa    :
        (csr_addr == 12'h300) ? mstatus :
        (csr_addr == 12'h305) ? mtvec   :
        (csr_addr == 12'h341) ? mepc    :
        (csr_addr == 12'h342) ? mcause  :
        32'b0
    ) : 32'b0;

endmodule