module control_fsm
(
  input	clk, reset,  run_n,
  input [15:0] sram_d, regA, regB, alu_status, alu_out,
  
  output reg sram_we_n, reg_we,
  output reg [2:0] alu_op,
  output reg [3:0] reg_addr_a, reg_addr_b, reg_addr_c,
  output [15:0] alu_op_a, reg_data_c,
  output reg [15:0] sram_addr, sram_q
  
 );
  
  // Define bit widths
  `define alu_op_size 3

//===========================================================================
// Parameter Declarations
//===========================================================================
// Declare states
parameter ADD = 5'd0;
parameter ADDI = 5'd1; 
parameter SUB = 5'd2; 
parameter SUBI = 5'd3; 
parameter MULT = 5'd4; 
parameter SW = 5'd5; 
parameter LW = 5'd6; 
parameter LT = 5'd7; 
parameter NAND = 4'd8; 
parameter DIV = 5'd9; 
parameter MOD = 5'd10; 
parameter LTE = 5'd11; 
parameter BLT = 5'd12; 
parameter BLE = 5'd13; 
parameter BEQ = 5'd14; 
parameter JUMP = 5'd15; 
parameter FETCH = 5'd16; 
parameter BLT2 = 5'd17;
parameter BLE2 = 5'd18; 
parameter BEQ2 = 5'd19; 
parameter SW2 = 5'd20;
parameter DECODE = 5'd21; 
parameter LW2 = 5'd22; 
parameter LW3 = 5'd23; 
parameter SW3 = 5'd24; 
parameter SW4 = 5'd25; 
parameter JUMP2 = 5'd26;
parameter BLE3 = 5'd27;	
parameter BLT3 = 5'd28;
parameter BEQ3 = 5'd29; 



  reg im_en;
  reg	[4:0] state;
  reg [15:0] instruction,pc, regC;

  wire ram_to_reg;
  wire [3:0] op_code, op1, op2, op3, im;
  wire [11:0] jump;
  //wire [15:0] alu_op_a;
  
  // assign the different fields of the instruction
  assign op_code = instruction[15:12];
  assign op1 = instruction[3:0];
  assign op2 = instruction[7:4];
  assign op3 = instruction[11:8];
  assign im = instruction[3:0];
  assign jump = instruction[11:0];

  assign alu_op_a = im_en ? {12'd0, im} : regA;
  assign ram_to_reg = (state == LW) | (state == LW2) | (state == LW3);
  assign reg_data_c = ram_to_reg ? sram_d : alu_out;
  
  // Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or negedge reset) begin
		if (reset == 1'b0) begin
			state <= FETCH;
		end else if(!run_n)
			case (state)
        FETCH:
		      state <= DECODE;
  		  DECODE:
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
          state <= SW2;
        SW2:
		      state <= SW3;
  		  SW3:
		      state <= SW4;
		    SW4:
		      state <= FETCH;
        LW:
		      state <= LW2;
		    LW2:
		      state <= LW3;
		    LW3:
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
        BLE:
          state <= BLE2;
        BEQ:
          state <= BEQ2;
        JUMP:
          state <= JUMP2;
		    JUMP2:
		      state <= FETCH;
        BLT2:
          state <= BLT3;
        BLT3:
          state <= FETCH;
        BLE2:
		      state <= BLE3;
		    BLE3:
          state <= FETCH;  
        BEQ2:
          state <= BEQ3;
        BEQ3:
          state <= FETCH;
        default:
          state <= FETCH;
			endcase
    end 
    
  // Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (posedge clk or negedge reset) begin
		if(reset == 1'b0) begin
			pc <= 16'h0000;
			instruction <= 16'hf000; // jump to 0
			sram_addr <= 16'h0000;
			sram_we_n <= 1'b1;
			sram_q <= 16'h0000;
	  end else begin
		case (state)
      FETCH: begin
        instruction <= sram_d;
        sram_addr <= pc;
        sram_we_n <= 1'b1;
		    pc <= pc;
		    sram_q <= 16'hffff;
		  end
		DECODE: begin
		  pc <= pc;
		  instruction <= instruction;
		  sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
		ADD: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
		ADDI: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
       sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
		SUB: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
		SUBI: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    MULT: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		  end
    SW: begin
      sram_we_n <= 1'b1;// should work
      sram_q <= regA;// port A
		  sram_addr <= alu_out;
      pc <= pc;
		  instruction <= instruction;
		end
		SW2: begin
      sram_we_n <= 1'b0;
      sram_q <= regA;// port A
		  sram_addr <= alu_out;
      pc <= pc;
		  instruction <= instruction;
		end
		SW3: begin
      sram_we_n <= 1'b1;
      sram_q <= regA;// port A
		  sram_addr <= pc;// for fetch cycle
      pc <= pc;
		  instruction <= instruction;
		  end
		SW4: begin
      sram_we_n <= 1'b1;
      sram_q <= regA;// port A
		  sram_addr <= pc;// for fetch cycle
      pc <= pc + 16'd1;
		  instruction <= instruction;
		end
    LW:begin
      sram_we_n <= 1'b1;
		  sram_addr <= alu_out;
      pc <= pc;
		  instruction <= instruction;
		  sram_q <= 16'hffff;
		end
		LW2:begin
      sram_we_n <= 1'b1;
		  sram_addr <= pc;
      pc <= pc;
		  instruction <= instruction;
		  sram_q <= 16'hffff;
		end
		LW3:begin
      sram_we_n <= 1'b1;
		  sram_addr <= pc;
      pc <= pc + 16'd1;
		  instruction <= instruction;
		  sram_q <= 16'hffff;
		end
    LT: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    NAND: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		  end
    DIV: begin 
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    MOD: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    LTE: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    BLT: begin
		  pc <= pc;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    BLE: begin
		  pc <= pc;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    BEQ: begin
		  pc <= pc;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
    JUMP: begin
		  // move back 1 because previous instruction adds 1 to pc
		  // extend MSB beacuse jump is signed
      pc <= pc + {jump[11],jump[11],jump[11],jump[11],jump} - 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  // shortcut to save a clock cycle, no need to wait for pc to update
		  sram_addr <= pc + {jump[11],jump[11],jump[11],jump[11],jump}  - 16'd1;// extend MSB beacuse jump is signed
		end
    JUMP2: begin
      pc <= pc + 16'd1; 
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  // pc should be updated now
		  sram_addr <= pc;
		end
    BLT2: begin
      if(alu_status == 16'd1) begin
        pc <= pc + {12'd0, im};
        sram_addr <= pc + {12'd0, im};
      end else begin 
        pc <= pc;
        sram_addr <= sram_addr;
		  end
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		end
    BLT3: begin
      // made to look like BLE3
      pc <= pc + 16'd1;
      instruction <= instruction;
      sram_we_n <= 1'b1;
      sram_q <= 16'hffff;
      sram_addr <= sram_addr;
    end
    BLE2: begin
      if(alu_status == 16'd1) begin
        pc <= pc + {12'd0, im};
		    sram_addr <= pc + {12'd0, im};
      end else begin
        pc <= pc; // + 16'd1;
        sram_addr <= sram_addr;
		  end
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		end
    BLE3: begin
      pc <= pc + 16'd1;
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;
		end
    BEQ2: begin
      if(alu_status == 16'd0) begin
        pc <= pc + {12'd0, im};
        sram_addr <= pc + {12'd0, im};
      end else begin
        pc <= pc; // + 16'd1;
        sram_addr <= sram_addr; //pc + 16'd1;
   		end
		  instruction <= instruction;
      sram_we_n <= 1'b1;
	  	sram_q <= 16'hffff;
	  end
    BEQ3: begin
      // made to look like BLE3
      pc <= pc + 16'd1;
      instruction <= instruction;
      sram_we_n <= 1'b1;
      sram_q <= 16'hffff;
      sram_addr <= sram_addr;
    end
    default: begin
      pc <= 16'd0; // reset program
		  instruction <= instruction;
      sram_we_n <= 1'b1;
		  sram_q <= 16'hffff;
		  sram_addr <= sram_addr;// infered latch
		end
		endcase
  end
end

always@(*) begin
	case (state)
    FETCH: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
      im_en = 1'b0;
    end
		DECODE: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
      im_en = 1'b0;
		end
		ADD: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
		  alu_op = `alu_op_size'h0;
      im_en = 1'b0;
		end
		ADDI: begin
      reg_addr_a = 4'hx; // dont care
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
		  alu_op = `alu_op_size'h0;
      im_en = 1'b1;
		end
		SUB: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
		  alu_op = `alu_op_size'h1;
      im_en = 1'b0;
		end
		SUBI: begin
		  reg_addr_a = 4'hx; // dont care
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
		  alu_op = `alu_op_size'h1;
      im_en = 1'b1;
		end
    MULT: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
		  alu_op = `alu_op_size'h2;
      im_en = 1'b0;
		end
    SW: begin
		  reg_addr_a = op3; // output the data, will not go throguh alu because of immed field
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = 4'hx; // dont care
      reg_we = 1'b0;
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
		end
		SW2: begin
		  reg_addr_a = op3; // output the data, will not go throguh alu because of immed field
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = 4'hx; // dont care
      reg_we = 1'b0;
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
      reg_we = 1'b0;
		end
		SW3: begin
		  reg_addr_a = op3; // output the data, will not go throguh alu because of immed field
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = 4'hx; // dont care
      reg_we = 1'b0;
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
      reg_we = 1'b0;
		end
		SW4: begin
		  reg_addr_a = op3; // output the data, will not go throguh alu because of immed field
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = 4'hx; // dont care
      reg_we = 1'b0;
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
      reg_we = 1'b0;
		end
    LW:begin
		  reg_addr_a = 4'hx; // dont care, the immed field is used
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = op3; // op3 is the register addr to load into
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
		  reg_we = 1'b0;
		end
		LW2:begin
		  reg_addr_a = 4'hx; // dont care, the immed field is used
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = op3; // op3 is the register addr to load into
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
      reg_we = 1'b0;
		end
		LW3:begin
		  reg_addr_a = 4'hx; // dont care, the immed field is used
      reg_addr_b = op2; // op2 is the pointer
      reg_addr_c = op3; // op3 is the register addr to load into
      reg_we = 1'b1;
      alu_op = `alu_op_size'h0;
      im_en = 1'b1;
		end
    LT: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
      alu_op = `alu_op_size'h6;
      im_en = 1'b0;
		end
    NAND: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
      alu_op = `alu_op_size'h3;
      im_en = 1'b0;
	  end
    DIV: begin 
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
      alu_op = `alu_op_size'h4;
      im_en = 1'b0;
	  end
    MOD: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
      alu_op = `alu_op_size'h5;
      im_en = 1'b0;
		end
    LTE: begin
		  reg_addr_a = op1;
      reg_addr_b = op2;
      reg_addr_c = op3;
      reg_we = 1'b1;
      alu_op = `alu_op_size'h7;
      im_en = 1'b0;
		end
    BLT: begin
		  reg_addr_a = op3;
      reg_addr_b = op2;
      reg_addr_c = 4'hx;
      reg_we = 1'b0;
      alu_op = `alu_op_size'h6;
      im_en = 1'b0;
		end
    BLE: begin
		  reg_addr_a = op3;
      reg_addr_b = op2;
      reg_addr_c = 4'hx;
      reg_we = 1'b0;
      alu_op = `alu_op_size'h7;
      im_en = 1'b0;
    end
    BEQ: begin
		  reg_addr_a = op3;
      reg_addr_b = op2;
      reg_addr_c = 4'hx;
      reg_we = 1'b0;
      alu_op = `alu_op_size'h1;
      im_en = 1'b0;
		end
    JUMP: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
      reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    JUMP2: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
      reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		  end
    BLT2: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
      reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    BLE2: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
      reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    BEQ2: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
      reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    BLT3: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    BLE3: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
    BEQ3: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end

    default: begin
		  reg_addr_a = 4'hf;
      reg_addr_b = 4'hf;
      reg_addr_c = 4'hf;
		  reg_we = 1'b0;
		  alu_op = `alu_op_size'h0;
		  im_en = 1'b0;
		end
		endcase
end


endmodule
