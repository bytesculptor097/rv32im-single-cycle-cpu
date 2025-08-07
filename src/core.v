module core (
    input wire clk,
    input wire rst,
    output wire [7:0] result,
    output wire uarttx
);

    wire [31:0] din;    


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
    wire regwrite, alusrc, memread, memwrite, jump, jump_r;
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
    wire [2:0] branch_type;




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
        .ALUOp(aluop),
        .csr_read_en(csr_read_en),
        .csr_write_en(csr_write_en),
        .is_csr(is_csr),
        .branch_type(branch_type)
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
        .x4_debug(x4_debug),
        .x2_debug(x2_debug) 
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





    // Cycle counter and debug display
    reg [31:0] cycle = 0;
    always @(posedge clk) begin
        cycle <= cycle + 1;
    end



  // PC increment logic
  always @(*) begin
    if (jump_r)
        next_addr = (rs1value + imm) & ~32'h1;  // JALR, aligned
    else if (jump)
        next_addr = curr_addr + imm;            // JAL
    else if (branch) begin
        case (branch_type)
            3'b000: next_addr = zero  ? curr_addr + imm : curr_addr + 4; // BEQ
            3'b001: next_addr = !zero ? curr_addr + imm : curr_addr + 4; // BNE
            3'b010: next_addr = (rs1value < rs2value) ? curr_addr + imm : curr_addr + 4; // BLT
            3'b011: next_addr = (rs1value >= rs2value) ? curr_addr + imm : curr_addr + 4; // BGE
            default: next_addr = curr_addr + 4;                          // fallback
        endcase
    end else
        next_addr = curr_addr + 4;  // default sequential execution
  end

    assign result = x5_debug[7:0]; // Output the lower 8 bits of x5 for result

    reg [2:0] init_cnt;

 always @(posedge clk) begin
  if (rst) 
    init_cnt <= 0;
  else if (init_cnt < 3) 
    init_cnt <= init_cnt + 1;
 end

// Expected values
localparam [31:0] EXPECTED_X3_RESULT  = 32'h000000BA;
localparam [31:0] EXPECTED_X4_RESULT  = 32'h00000005;
localparam [31:0] EXPECTED_X7_RESULT  = 32'h00000001;
localparam [31:0] EXPECTED_X10_RESULT = 32'h40001100;

// UART wires
wire uart_tx_busy;
wire uart_txd;
assign uarttx = uart_txd;

// UART transmitter instantiation
uart_tx #(
  .CLK_FREQ(50_000_000),
  .BAUD_RATE(115_200)
) uart_tx_inst (
  .clk      (clk),
  .rst_n    (~rst),
  .tx_start (uart_tx_en),
  .tx_data  (uart_tx_data),
  .tx       (uart_txd),
  .tx_busy  (uart_tx_busy)
);

// UART message buffer (4 messages × 18 bytes = 72)
reg [7:0] messages [0:71];
initial begin
  // Message 0: MUL supported
  messages[ 0] = "M"; messages[ 1] = "U"; messages[ 2] = "L"; messages[ 3] = " ";
  messages[ 4] = "s"; messages[ 5] = "u"; messages[ 6] = "p"; messages[ 7] = "p";
  messages[ 8] = "o"; messages[ 9] = "r"; messages[10] = "t"; messages[11] = "e";
  messages[12] = "d"; messages[13] = "\n"; messages[14] = 8'h00; messages[15] = 8'h00;
  messages[16] = 8'h00; messages[17] = 8'h00;

  // Message 1: DIV supported
  messages[18] = "D"; messages[19] = "I"; messages[20] = "V"; messages[21] = " ";
  messages[22] = "s"; messages[23] = "u"; messages[24] = "p"; messages[25] = "p";
  messages[26] = "o"; messages[27] = "r"; messages[28] = "t"; messages[29] = "e";
  messages[30] = "d"; messages[31] = "\n"; messages[32] = 8'h00; messages[33] = 8'h00;
  messages[34] = 8'h00; messages[35] = 8'h00;

  // Message 2: REM supported
  messages[36] = "R"; messages[37] = "E"; messages[38] = "M"; messages[39] = " ";
  messages[40] = "s"; messages[41] = "u"; messages[42] = "p"; messages[43] = "p";
  messages[44] = "o"; messages[45] = "r"; messages[46] = "t"; messages[47] = "e";
  messages[48] = "d"; messages[49] = "\n"; messages[50] = 8'h00; messages[51] = 8'h00;
  messages[52] = 8'h00; messages[53] = 8'h00;

  // Message 3: M extension supported
  messages[54] = "M"; messages[55] = " "; messages[56] = "e"; messages[57] = "x";
  messages[58] = "t"; messages[59] = "e"; messages[60] = "n"; messages[61] = "s";
  messages[62] = "i"; messages[63] = "o"; messages[64] = "n"; messages[65] = " ";
  messages[66] = "s"; messages[67] = "u"; messages[68] = "p"; messages[69] = "p";
  messages[70] = "o"; messages[71] = "r"; messages[72] = "t"; messages[73] = "e";
  messages[74] = "d"; messages[75] = "\n";
end

// FSM registers
reg [3:0] validated;         // Bit flags for x3, x4, x7, x10
reg       sent;
reg [6:0] uart_index;
reg [6:0] byte_index;
reg [7:0] uart_tx_data;
reg       uart_tx_en;

// UART FSM
always @(posedge clk) begin
  if (rst) begin
    validated   <= 0;
    sent        <= 0;
    uart_tx_en  <= 0;
    uart_index  <= 0;
    byte_index  <= 0;
  end else begin
    // Detect register values after init delay
    if (init_cnt == 3) begin
      if (x3_debug  == EXPECTED_X3_RESULT)  validated[0] <= 1;
      if (x4_debug  == EXPECTED_X4_RESULT)  validated[1] <= 1;
      if (x7_debug  == EXPECTED_X7_RESULT)  validated[2] <= 1;
      if (x10_debug == EXPECTED_X10_RESULT) validated[3] <= 1;
    end

    // Send messages sequentially
    if (validated != 0 && !sent) begin
      if (!uart_tx_busy) begin
        uart_tx_data <= messages[uart_index];
        uart_tx_en   <= 1;
        uart_index   <= uart_index + 1;
        byte_index   <= byte_index + 1;

        if (byte_index == 14) begin
          byte_index <= 0;
          if (validated[0]) begin
            validated[0] <= 0;
            uart_index   <= 18;
          end else if (validated[1]) begin
            validated[1] <= 0;
            uart_index   <= 36;
          end else if (validated[2]) begin
            validated[2] <= 0;
            uart_index   <= 54;
          end else if (validated[3]) begin
            validated[3] <= 0;
            sent         <= 1;
          end
        end
      end else begin
        uart_tx_en <= 0;
      end
    end else begin
      uart_tx_en <= 0;
    end
  end
end

endmodule