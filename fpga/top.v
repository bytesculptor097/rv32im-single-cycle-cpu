module top (
    input wire rst,
    output wire [7:0] result,
    output wire uarttx
);

    wire [31:0] din;    
    wire high_clk;
    SB_HFOSC #(.CLKHF_DIV ("0b00")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(high_clk));
    
    reg [5:0] clk_div_counter = 0;
    reg clk = 0;

   always @(posedge high_clk) begin
    clk_div_counter <= clk_div_counter + 1;
    if (clk_div_counter == 17) begin
        clk <= ~clk;
        clk_div_counter <= 0;
    end
  end


    // Internal wires
    wire branch;
    wire [31:0] curr_addr;
    reg [31:0] next_addr;
    wire [31:0] ram_out;
    wire [6:0] opcode, funct7;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [31:0] imm;
    wire regwrite, alusrc, memread, memwrite, jump, auipc, jump_r;
    wire branch_taken = branch & zero; // branch taken if condition is true
    wire [1:0] aluop;
    wire memtoreg;
    wire [3:0] alu_control;
    wire [31:0] rs1value, rs2value;
    wire [31:0] input_b = alusrc ? imm : rs2value;
    wire [31:0] alu_result;
    wire [31:0] mem_data;
    wire [31:0] write_data = is_csr ? csr_read_data : (memtoreg ? mem_data : alu_result);
    wire [31:0] x3_debug;
    wire [31:0] x5_debug;
    wire zero;
    wire [31:0] branch_target;
    wire csr_read_en, csr_write_en, is_csr;
    wire [31:0] csr_read_data;
    wire [31:0] x10_debug;
    wire [31:0] x7_debug;
    wire [31:0] x4_debug;




    // Instantiate CSR module

  csr csr_inst (
    .clk(clk),
    .reset(rst),
    .csr_addr(ram_out[31:20]),      // CSR address field from instruction
    .csr_read_en(csr_read_en),
    .csr_write_en(csr_write_en),
    .csr_write_data(rs1value),      // CSR write data from rs1
    .csr_read_data(csr_read_data)
  );


    // Instantiate PC
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_addr(next_addr),
        .curr_addr(curr_addr)
    );

    // RAM (Instruction Memory)
    ram ram_inst (
        .clk(clk),
        .we(1'b0),
        .addr(curr_addr),
        .din(din),
        .dout(ram_out)
    );

    // Decoder
    decode decode_inst (
        .instr(ram_out),
        .opcode(opcode),
        .funct7(funct7),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .imm(imm)
    );

    // Control Unit
    control_unit control_unit_inst (
        .opcode(opcode),
        .funct3(funct3),
        .RegWrite(regwrite),
        .ALUSrc(alusrc),
        .MemRead(memread),
        .MemWrite(memwrite),
        .Branch(branch),
        .Jump(jump),
        .Jump_r(jump_r),
        .memtoreg(memtoreg),
        .AUIPC(auipc),
        .ALUOp(aluop),
        .csr_read_en(csr_read_en),
        .csr_write_en(csr_write_en),
        .is_csr(is_csr)
    );

    // ALU Control
    alu_control alu_control_inst (
        .ALUOp(aluop),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(alu_control)
    );

    // Register File
    regfile regfile_inst (
        .clk(clk),
        .reg_write(regwrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rs1_val(rs1value),
        .rs2_val(rs2value),
        .x3_debug(x3_debug),
        .x5_debug(x5_debug),
        .x10_debug(x10_debug),
        .x7_debug(x7_debug),
        .x4_debug(x4_debug) 
    );

    // ALU
    ALU ALU_inst (
        .A(rs1value),
        .B(input_b),
        .ALUControl(alu_control),
        .Result(alu_result),
        .zero(zero)
    );

    // Data RAM
    data_ram data_ram_inst (
        .clk(clk),
        .we(memwrite),
        .addr(alu_result),
        .din(rs2value),
        .dout(mem_data)
    );

    wire  uart_tx_busy;
    wire      uart_txd;

 uart_tx #(
  .CLK_FREQ(48_000_000),
  .BAUD_RATE(115_200)
 ) uart_tx_inst (
  .clk      (high_clk),
  .rst_n    (~rst),           // invert your active-high rst
  .tx_start (uart_tx_en),
  .tx_data  (uart_tx_data),
  .tx       (uart_txd),
  .tx_busy  (uart_tx_busy)
 ) ;

 assign uarttx = uart_txd;     // top-level output


    // Cycle counter and debug display
    reg [31:0] cycle = 0;
    always @(posedge clk) begin
        cycle <= cycle + 1;
    end



    // PC increment logic
    always @(*) begin
     if (jump_r)
        next_addr = rs1value + imm;
     else if (jump)
        next_addr = curr_addr + imm;
     else if (branch && zero)
        next_addr = curr_addr + imm;
     else
        next_addr = curr_addr + 4;
    end

    assign result = x3_debug[7:0]; // Output the lower 8 bits of x5 for result

    reg [2:0] init_cnt;

 always @(posedge clk) begin
  if (rst) 
    init_cnt <= 0;
  else if (init_cnt < 3) 
    init_cnt <= init_cnt + 1;
 end

 localparam [31:0] EXPECTED_MUL_RESULT = 32'h0000_00ba; // decimal 186
 localparam [31:0] EXPECTED_DIV_RESULT = 32'h0000_0005; // decimal 5
 localparam [31:0] EXPECTED_REM_RESULT = 32'h0000_0001; // decimal 1

 // FSM state
 reg        m_extension_detected;
 reg        sent;
 reg [4:0]  msg_index;
 reg [7:0]  uart_tx_data;
 reg        uart_tx_en;

 // Message to send
 reg [7:0] message [0:21];
 initial begin
  message[ 0] = "M"; message[ 1] = "-"; message[ 2] = "e"; message[ 3] = "x";
  message[ 4] = "t"; message[ 5] = "e"; message[ 6] = "n"; message[ 7] = "s";
  message[ 8] = "i"; message[ 9] = "o"; message[10] = "n"; message[11] = " ";
  message[12] = "s"; message[13] = "u"; message[14] = "p"; message[15] = "p";
  message[16] = "o"; message[17] = "r"; message[18] = "t"; message[19] = "e";
  message[20] = "d"; message[21] = "\n";
 end

 always @(posedge clk) begin
  if (rst) begin
    m_extension_detected <= 0;
    sent                 <= 0;
    msg_index            <= 0;
    uart_tx_en           <= 0;
  end else begin
    // 1) When to detect: wait a few cycles for x10_debug to settle
    if (!m_extension_detected && init_cnt == 3 &&
        x3_debug == EXPECTED_MUL_RESULT && x4_debug == EXPECTED_DIV_RESULT && x7_debug == EXPECTED_REM_RESULT) begin
      m_extension_detected <= 1;
    end

    // 2) Once detected, send the message byte-by-byte
    if (m_extension_detected && !sent) begin
      if (!uart_tx_busy) begin
        uart_tx_data <= message[msg_index];
        uart_tx_en   <= 1;
        msg_index    <= msg_index + 1;
        if (msg_index == 22) begin
          sent <= 1;
        end
      end else begin
        // hold off enabling until UART is ready
        uart_tx_en <= 0;
      end
    end else begin
      uart_tx_en <= 0;
    end
  end
 end
 


endmodule
