module control_fsm
(
	input	clk, reset,
  input 

  output reg [3:0]  reg_addr_a, reg_addr_b, reg_addr_c, al
);
  
  // Define bit widths
  `define alu_op_size 4
	   
  reg	[3:0] state;
  reg [15:0] instruction, pc;

  wire [3:0] op_code, op1, op2, op3, im;
  wire [11:0] jump;

	// Declare states
  parameter ADD = 0, ADDI = 1, SUB = 2, SUBI = 3, MULT = 4, SW = 5, LW = 6, LT = 7, NAND = 8, DIV = 9, MOD = 10, LTE = 11, BLT = 12, BGE = 13, BEQ = 14, JUMP = 15, FETCH = 16, BLT2 = 17, BGE2 = 18, BEQ2 = 19;	

  // assign the different fields of the instruction
  assign op_code = instrucion[15:12];
  assign op1 = instruction[3:0];
  assign op2 = instruction[7:4];
  assign op3 = instruction[11:8];
  assign im = instruction[3:0];
  assign jump = instruction[11:0];



  // Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or negedge reset) begin
		if (reset)
			state <= FETCH;
		else
			case (state)
        FETCH:
          state <= op_code;
				ADD:
				  state <= FETCH;	
				ADDI:
					state <= FETCH;
				SUB:
				  state <= FETCH;	
				SUBI:
          state <= FETCH;					
        MULT:
          state <= FETCH;
        SW:
          state <= FETCH;
        LW:
          state <= FETCH;
        LT:
          state <= FETCH;
        NAND:
          state <= FETCH;
        DIV:
          state <= FETCH;
        MOD:
          state <= FETCH;
        LTE:
          state <= FETCH;
        BLT:
          state <= BLT2;
        BGE:
          state <= BGE2;
        BEQ:
          state <= BEQ2;
        JUMP:
          state <= FETCH;
        BLT2:
          state <= FETCH;
        BGE2:
          state <= FETCH;  
        BEQ2:
          state <= FETCH;
        default:
          state <= FETCH;
			endcase
    end 
    
    // Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (*)
	begin
		case (state)
      FETCH:
        instruction <= sram_dq;
        sram_addr <= pc;
        sram_we_n <= 1'b1;
			ADD:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h0;
        im_en <= 1'b0;  
        pc <= pc + 16'd1;
			ADDI:
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h0;
        im_en <=1'b1;
        pc <= pc + 16'd1;
			SUB:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h1;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
			SUBI:
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h1;
        im_en <=1'b1;
        pc <= pc + 16'd1;
      MULT:
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h2;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      SW:
        reg_addr_a <= op3; // output the data, will not go throguh alu because of immed field
        reg_addr_b <= op2; // op2 is the pointer
        reg_addr_c <= 4'hx; // dont care
        reg_we <= 1'b0;
        alu_op <= alu_op_size'h0;
        im_en <= 1'b1;
        // statement to choose sram addr
        sram_we_n <= 1'b0;
        sram_dq <= regA;// port A
        pc <= pc + 16'd1;
      LW:
        reg_addr_a <= 4'hx; // dont care, the immed field is used
        reg_addr_b <= op2; // op2 is the pointer
        reg_addr_c <= op3; // op3 is the register addr to load into
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h0;
        im_en <= 1'b1;
        // statement to choose sram addr
        sram_we_n <= 1'b1;
        sram_dq <= regA;// port A
        pc <= pc + 16'd1;
      LT:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h6;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      NAND:
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h3;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      DIV:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h4;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      MOD:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h5;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      LTE:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h7;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
      BLT:
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= alu_op_size'h6;
        in_en <= 1'b0;
      BGE:
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= alu_op_size'h7;
        im_en <= 1'b0;
      BEQ:
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= alu_op_size'h1;
        im_en <= 1'b0
      JUMP:
        pc <= pc + j;
      BLT2:
        if(status == 16'd1)
          pc <= pc + {12'd0, im};
        else 
          pc <= pc + 16'd1;
      BGE2:
        if(status == 16'd1)
          pc <= pc + {12'd0, im};
        else
          pc <= pc + 16'd1;
      BEQ2:
        if(status == 16'd0)
          pc <= pc + {12'd0, im};
        else
          pc <= pc + 16'd1;
      default:
        pc <= 16'd0; // reset program
		endcase
	end

endmodule
