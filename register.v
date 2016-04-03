module register(clk, rst, w_en, data_in,data);


  input clk, rst, w_en;
  input [15:0] data_in;

  output [15:0] data;
  reg [15:0] data;
  
  always@(posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
      data <= 16'd0;
    end else begin 
      if(w_en == 1'b1) begin
        data <= data_in;
      end
    end
  end // end always
endmodule
