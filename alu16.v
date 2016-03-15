module alu(clk,rst,operator,op1,op2,op3);
begin
  parameter numBits = 16;
  parameter operatorSize = 3;
  wire [0:operatorSize - 1] operator;
  wire [0:numBits - 1] op1,op2;

  reg [0:numBits - 1] op3;

  always@(*) begin
    if(rst == 1'b0) begin
      op3 <= numBits'd0;
    end else begin
      case(operator)
      operatorSize'h0: // ADD
        op3 <= op1 + op2;
      operatorSize'h1: // SUB
        op3 <= op1 - op2;
      operatorSize'h2: // MULT
        op3 <= op1 * op2;
      operatorSize'h3: // NAND
        op3 <= op1 ~& op2;
      operatorSize'h4: // DIV
        op3 <= op1 / op2;
      operatorSize'h5: // MOD
        op3 <= op1 % op2;
      operatorSize'h6: // ROTL
        op3 <= {op1[numBits-2:1], op1[numBits -1] };
      operatorSize'h7: // NOP
        op3 <= numBits'd0;
     endcase
    end
end
