module core_top(

  input clk, rst, run_n,
  input [3:0] reg_addr_d, 
  output [15:0] reg_out

);

//wire clk;
wire reg_we, sram_we_n, ram_wren;
wire [2:0] alu_operator;
wire [3:0] reg_addr_a, reg_addr_b, reg_addr_c;
wire [15:0] ram_addr, ram_data, reg_data_a, reg_data_b, reg_data_c, reg_data_d, alu_op_a,alu_out,alu_status, ram_q,pc;

assign reg_out = reg_data_d;
assign ram_wren = ~sram_we_n;

//pll_slow mhz_5(clk_50, clk);

register_file register_file0(clk, rst, reg_we, reg_addr_a, reg_addr_b, reg_addr_c, reg_addr_d, reg_data_c, reg_data_a, reg_data_b, reg_data_d);

alu16 alu16_0( clk,rst,alu_operator, alu_op_a, reg_data_b, alu_out, alu_status);

control_fsm control_fsm0( clk, rst, run_n, ram_q, reg_data_a, reg_data_b, alu_status, alu_out,
								  sram_we_n, reg_we, alu_operator, reg_addr_a, reg_addr_b,
								  reg_addr_c, alu_op_a, reg_data_c, ram_addr, ram_data);

main_memory main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);								  
//main_memory_sxm_d main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);								  
//main_memory_sxm main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);								  
//main_memory_ram_test main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);
//main_memory_ram_test2 main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);
//main_memory_addi_test main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);
//main_memory_lw_test main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);
//main_memory_sw_test main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);
//main_memory_ble_test main_memory0(ram_addr[7:0], clk, ram_data, ram_wren, ram_q);

  
endmodule
