module register_file(clk, rst, w_en, addr_a, addr_b, add_c, data_a, data_b, data_c);
begin

  parameter addr_size = 4;

  input clk, rst, w_en;

  input [addr_size-1:0] addr_a, addr_b, addr_c;

  input [15:0] data_c;

  output [15:0] data_a, data_b;
 
  always@(posedge clk or negedge rst) begin
    



    end
  end // end always
end
