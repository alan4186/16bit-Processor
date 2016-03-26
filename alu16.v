module alu(clk,rst,operator,op1,op2,out,status);
begin
  parameter numBits = 16;
  parameter operatorSize = 4;
  wire [0:operatorSize - 1] operator;
  wire [0:numBits - 1] op1,op2;

  reg [0:numBits - 1] out, status;

  always@(*) begin
    if(rst == 1'b0) begin
      out <= numBits'd0;
    end else begin
      case(operator)
      operatorSize'h0: // ADD
        out <= op1 + op2;
      operatorSize'h1: // SUB
        out <= op1 - op2;
      operatorSize'h2: // MULT
        out <= op1 * op2;
      operatorSize'h3: // NAND
        out <= op1 ~& op2;
      operatorSize'h4: // DIV
        out <= op1 / op2;
      operatorSize'h5: // MOD
        out <= op1 % op2;
      operatorSize'h6: // LESS THAN 
        out <= op1 < op2;
      operatorSize'h7: // LESS THAN OR EQUAL
        out <= op1 <= op2;
      default:  // NOP
        out <= numbits'd0;
     endcase
    end
  end

  always@(posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
      status = numBits'd0;
    end else begin 
      status <= out;
    end
  end

end
