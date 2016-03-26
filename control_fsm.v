module control_fsm(clk,rst, alu_operator, reg_file_addr_a, reg_file_addr_b, reg_file_addr_c, sram_dq);
begin

parameter alu_operator_size = 3;
parameter reg_file_addr_size = 4;

input clk;
input rst;

output [alu_operator_size-1:0] alu_operator;
output [reg_file_addr_size-1:0] reg_file_addr_a, reg_file_addr_b, reg_file_addr_c;

reg [reg_file_addr_size-1:0] reg_file_addr_a, reg_file_addr_b, reg_file_addr_c;
reg [alu_operator_size-1:0]  alu_operator;
reg s, ns;


  always@(posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
      s <= 2'b00;
      ns <= 2'b01;
    end else begin
      case(s) begin
        2'd0: // fetch
          ns <= 2'd1;
        2'd1: // decode
          ns <= 2'd2;
        2'd2: // execute
          ns <= 2'd3;
        2'd3: // update
          ns <= 2'd0;
      endcase

    end

  always@(posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
      alu_operator <= alu_operator_size'h7;
      reg_file_addr_a <= reg_file_addr_size'd0;
      reg_file_addr_b <= reg_file_addr_size'd0;
      reg_file_addr_c <= reg_file_addr_size'd0;

    end else begin
      case(s) begin
      2'd0: // fetch
        sram_addr <= pc;
        intr_reg <= sram_dq;
      2'd1: // decode 
        case({ count, op_code}) begin
          4'h0: // ADD

          4'h1: // ADDI

          4'h2: // SUB

          4'h3: // SUBI

          4'h4: // MULT

          4'h5: // SW

          4'h6: // LW

          4'h7: // LESS THAN

          4'h8: // NAND

          4'h9: // DIV

          4'ha: // MOD

          4'hb: // LESS THAN EQUAL

          4'hc: // BLT

          4'hd: // BGE

          4'he: // BEQ

          4'hf: // J

        endcase

        2'd2: // execute
          case(op_code) begin
            4'h0: // ADD
              alu_operator <= alu_operator_size'h0;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'h1: // ADDI
              alu_operator <= alu_operator_size'h0;
              reg_file_addr_a <= op1;
            4'h2: // SUB
              alu_operator <= alu_operator_size'h1;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'h3: // SUBI
              alu_operator <= alu_operator_size'h1;
              reg_file_addr_a <= op1;
            4'h4: // MULT
              alu_operator <= alu_operator_size'h2;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'h5: // SW
              alu_operator <= alu_operator_size'h0;
              we_n <= 1'b0; // SRAM we_n
              im_en <= 1'b1; // use the immed field for the ALU
              reg_file_addr_a <= op1; // get the address
              reg_file_addr_b <= op2; // get the data
            4'h6: // LW
              alu_operator <= alu_operator_size'h0;
              we_n <= 1'b1;
              im_en <= 1'b1;
              reg_file_addr_a <= op1;
              reg_file_addr_c <= op2;
              reg_we <= 1'b1;
            4'h7: //
              alu_operator <= alu_operator_size'h7;
              reg_file_addr_c <= op1;
            4'h8: // NAND
              alu_operator <= alu_operator_size'h3;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'h9: // DIV
              alu_operator <= alu_operator_size'h4;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'ha: // MOD
              alu_operator <= alu_operator_size'h5;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'hb: // ROTL
              alu_operator <= alu_operator_size'h6;
              reg_file_addr_a <= op1;
              reg_file_addr_b <= op2;
              reg_file_addr_c <= op3;
            4'hc: // BLT
              alu_operator <= alu_operator_size'h7;
              
            4'hd: // BGE
              alu_operator <= alu_operator_size'h7;
            4'he: // BEQ
              alu_operator <= alu_operator_size'h7;

            4'hf: // J
              alu_operator <= alu_operator_size'h7;
              npc <= pc + j;
          endcase

      2'd3: // update
        case(op_code) begin
          4'h5: // SW

          4'h6: // LW

          4'h7: //


          4'hc: // BLT

          4'hd: // BGE

          4'he: // BEQ

          4'hf: // J
          
          default:
            pc <= npc;
        endcase

    endcase
    endcase

    end // end if else rst
  end // end always

end
