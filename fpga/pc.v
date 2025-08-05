module pc (
    input clk,
    input rst,
    input [31:0] next_addr,
    output reg [31:0] curr_addr
    
);


always @(posedge clk or posedge rst) begin
    if (rst)
        curr_addr <= 32'b0;  // Initialize to 0 on reset
    else
        curr_addr <= next_addr;
end

endmodule