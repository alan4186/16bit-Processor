module control_fsm
(
  input	clk, reset,
  input [15:0] sram_d, regA, alu_status,
  
  output reg sram_we_n, reg_we, im_en,
  output reg [2:0] alu_op,
  output reg [3:0] reg_addr_a, reg_addr_b, reg_addr_c,
  output reg [15:0] sram_addr, sram_q, regC
  
  
 );
  
  // Define bit widths
  `define alu_op_size 3
	
	// Declare states
  parameter ADD = 5'd0, ADDI = 5'd1, SUB = 5'd2, SUBI = 5'd3, MULT = 5'd4, SW = 5'd5, LW = 5'd6, LT = 5'd7, NAND = 4'd8, DIV = 5'd9, MOD = 5'd10, LTE = 5'd11, BLT = 5'd12, BGE = 5'd13, BEQ = 5'd14, JUMP = 5'd15, FETCH = 5'd16, BLT2 = 5'd17, BGE2 = 5'd18, BEQ2 = 5'd19;	
   
  reg	[4:0] state;
  reg [15:0] instruction, pc;

  wire [3:0] op_code, op1, op2, op3, im;
  wire [11:0] jump;

  // assign the different fields of the instruction
  assign op_code = instruction[15:12];
  assign op1 = instruction[3:0];
  assign op2 = instruction[7:4];
  assign op3 = instruction[11:8];
  assign im = instruction[3:0];
  assign jump = instruction[11:0];



  // Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or negedge reset) begin
		if (reset == 1'b0)
			state <= FETCH;
		else
			case (state)
        FETCH:
          state <= {1'b0, op_code};
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
	always @ (*) begin
//   pc = 16'd0;
//	  instruction = 16'd0;
//   sram_addr = 16'd0;
//	  sram_we_n = 1'b1;
//	  reg_addr_a = 4'hf;
//	  reg_addr_b = 4'd0;
//	  reg_addr_c = 4'd0;
//	  reg_we = 1'b0;
//	  alu_op = `alu_op_size'd0;
//	  im_en = 1'b0;
//	  sram_q = 16'd0;
	  
		case (state)
      FETCH: begin
        instruction <= sram_d;
        sram_addr <= pc;
        sram_we_n <= 1'b1;
		  pc <= pc;
		  end
		ADD: begin
		  reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h0;
        im_en <= 1'b0;  
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
		ADDI: begin
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h0;
        im_en <=1'b1;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
		SUB: begin
		  reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h1;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
		SUBI: begin
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h1;
        im_en <=1'b1;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      MULT: begin
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h2;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      SW: begin
        reg_addr_a <= op3; // output the data, will not go throguh alu because of immed field
        reg_addr_b <= op2; // op2 is the pointer
        reg_addr_c <= 4'hx; // dont care
        reg_we <= 1'b0;
        alu_op <= `alu_op_size'h0;
        im_en <= 1'b1;
        // statement to choose sram addr
        sram_we_n <= 1'b0;
        sram_q <= regA;// port A
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      LW:begin
        reg_addr_a <= 4'hx; // dont care, the immed field is used
        reg_addr_b <= op2; // op2 is the pointer
        reg_addr_c <= op3; // op3 is the register addr to load into
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h0;
        im_en <= 1'b1;
        // statement to choose sram addr
        sram_we_n <= 1'b1;
        regC <= sram_d;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      LT: begin
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h6;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      NAND: begin
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h3;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      DIV: begin 
		  reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h4;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      MOD: begin
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h5;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      LTE: begin
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= `alu_op_size'h7;
        im_en <= 1'b0;
        pc <= pc + 16'd1;
		  instruction <= instruction;
		  end
      BLT: begin
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= `alu_op_size'h6;
        im_en <= 1'b0;
		  pc <= pc;
		  instruction <= instruction;
		  end
      BGE: begin
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= `alu_op_size'h7;
        im_en <= 1'b0;
		  pc <= pc;
		  instruction <= instruction;
		  end
      BEQ: begin
        reg_addr_a <= op3;
        reg_addr_b <= op2;
        reg_addr_c <= 4'hx;
        reg_we <= 1'b0;
        alu_op <= `alu_op_size'h1;
        im_en <= 1'b0;
		  pc <= pc;
		  instruction <= instruction;
		  end
      JUMP: begin
        pc <= pc + jump;
		  instruction <= instruction;
		  end
      BLT2: begin
        if(alu_status == 16'd1) begin
          pc <= pc + {12'd0, im};
        end else begin 
          pc <= pc + 16'd1;
		  end
		  instruction <= instruction;
		end
      BGE2: begin
        if(alu_status == 16'd1) begin
          pc <= pc + {12'd0, im};
        end else begin
          pc <= pc + 16'd1;
		  end
		  instruction <= instruction;
		end
      BEQ2: begin
        if(alu_status == 16'd0) begin
          pc <= pc + {12'd0, im};
        end else begin
          pc <= pc + 16'd1;
		  end
		  instruction <= instruction;
		end
      default: begin
        pc <= 16'd0; // reset program
		  instruction <= instruction;
		end
		endcase
end

endmodule
