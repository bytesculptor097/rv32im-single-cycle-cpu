module core (
    input wire clk,
    input wire rst,
    output wire [7:0] result
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
    wire [31:0] mtvec, mepc;
    wire trap_enter, trap_exit;
    wire [31:0] exception_code;
    wire [31:0] x2_debug;





    // Instantiate CSR module

   csr csr_inst (
    .clk(clk),
    .reset(rst),
    .csr_addr(ram_out[31:20]),
    .csr_read_en(csr_read_en),
    .csr_write_en(csr_write_en),
    .csr_write_data(rs1value),
    .csr_read_data(csr_read_data),
    .trap_enter(trap_enter),
    .trap_exit(trap_exit),
    .current_pc(curr_addr),
    .exception_code(exception_code),
    .mtvec_out(mtvec),
    .mepc_out(mepc)
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
        .clk(clk),
        .opcode(opcode),
        .funct3(funct3),
        .ram_out(ram_out),
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
        .branch_type(branch_type),
        .trap_enter(trap_enter),
        .trap_exit(trap_exit),
        .exception_code(exception_code)
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



  always @(*) begin
    if (trap_enter)
        next_addr = mtvec;
    else if (trap_exit)
        next_addr = mepc;
    else if (jump_r)
        next_addr = (rs1value + imm) & ~32'h1;
    else if (jump)
        next_addr = curr_addr + imm;
    else if (branch) begin
        case (branch_type)
            3'b000: next_addr = zero  ? curr_addr + imm : curr_addr + 4;
            3'b001: next_addr = !zero ? curr_addr + imm : curr_addr + 4;
            3'b010: next_addr = (rs1value < rs2value) ? curr_addr + imm : curr_addr + 4;
            3'b011: next_addr = (rs1value >= rs2value) ? curr_addr + imm : curr_addr + 4;
            default: next_addr = curr_addr + 4;
        endcase
    end else
        next_addr = curr_addr + 4;
 end

    assign result = x3_debug[7:0]; // Output the lower 8 bits of x5 for result, change this as per your preference


endmodule


