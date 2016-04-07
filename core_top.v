module core_top(
  inout [15:0] sram_dq,
  
  input clk, rst,
  
  output [15:0] reg_out,
  output [18:0] sram_addr_full

);

wire reg_we, sram_we_n;
wire [2:0] alu_operator;
wire [3:0] reg_addr_a, reg_addr_b, reg_addr_c;
wire [15:0] sram_addr, reg_data_a, reg_data_b, reg_data_c, alu_op_a,alu_out,alu_status, sram_q;

assign reg_out = reg_data_a;

assign sram_dq = sram_we_n ? sram_q : 16'hzzzz;
assign sram_addr_full = {3'd0, sram_addr};


register_file register_file0(clk, rst, reg_we, reg_addr_a, reg_addr_b, reg_addr_c, reg_data_c, reg_data_a, reg_data_b);

alu16 alu16_0( clk,rst,alu_operator, alu_op_a, reg_data_b, alu_out, alu_status);

control_fsm control_fsm0( clk, rst, sram_dq, reg_data_a, reg_data_b, alu_status, alu_out,
								  sram_we_n, reg_we, alu_operator, reg_addr_a, reg_addr_b,
								  reg_addr_c, alu_op_a, reg_data_c, sram_addr, sram_q);


  
endmodule
