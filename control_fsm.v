// 4-State Mealy state machine

// A Mealy machine has outputs that depend on both the state and 
// the inputs.  When the inputs change, the outputs are updated
// immediately, without waiting for a clock edge.  The outputs
// can be written more than once per state or per clock cycle.

module mealy_mac
(
	input	clk, data_in, reset,
	output reg [1:0] data_out
);
  // Declare bit widths
  parameter alu_op_size = 4;
	// Declare state register
	reg		[1:0]state;
	
	// Declare states
  parameter ADD = 0, ADDI = 1, SUB = 2, SUBI = 3, MULT = 4, SW = 5, LW = 6, LT = 7, NAND = 8, DIV = 9, MOD = 10, LTE = 11,     BLT = 12, BGE = 13, BEQ = 14, JUMP = 15, FETCH = 16;	
	
  // Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge reset) begin
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
        LW:
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
        default:
          state <= FETCH;
			endcase
	end
	
	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or data_in)
	begin
		case (state)
      FETCH:
			ADD:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h0;
        im_en <= 1'b0;  
			ADDI:
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h0;
        im_en <=1'b1;
			SUB:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h1;
        im_en <= 1'b0;
			SUBI:
        reg_addr_a <= 4'hx; // dont care
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h1;
        im_en <=1'b1;
      MULT:
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h2;
        im_en <= 1'b0;
      SW:
      LW:
      LT:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h6;
        im_en <= 1'b0;
      NAND:
  	    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h3;
        im_en <= 1'b0;
      DIV:
		    reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h4;
        im_en <= 1'b0;
      MOD:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h5;
        im_en <= 1'b0;
      LTE:
        reg_addr_a <= op1;
        reg_addr_b <= op2;
        reg_addr_c <= op3;
        reg_we <= 1'b1;
        alu_op <= alu_op_size'h7;
        im_en <= 1'b0;
      BLT:
      BGE:
      BEQ:
      JUMP:
      default:
		endcase
	end

endmodule
