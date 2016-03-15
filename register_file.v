module register_file(clk, rst, w_en, addr_a, addr_b, add_c, data_a, data_b, data_c);
begin

  parameter addr_size = 4;

  input clk, rst, w_en;

  input [addr_size-1:0] addr_a, addr_b, addr_c;

  input [15:0] data_c;

  output [15:0] data_a, data_b;

  register register0(clk, rst ,w_en0, data_in, data0);
  register register1(clk, rst ,w_en1, data_in, data1);
  register register2(clk, rst ,w_en2, data_in, data2);
  register register3(clk, rst ,w_en3, data_in, data3);
  register register4(clk, rst ,w_en4, data_in, data4);
  register register5(clk, rst ,w_en5, data_in, data5);
  register register6(clk, rst ,w_en6, data_in, data6);
  register register7(clk, rst ,w_en7, data_in, data7);
  register register8(clk, rst ,w_en8, data_in, data8);
  register register9(clk, rst ,w_en9, data_in, data9);
  register register10(clk, rst ,w_en10, data_in, data10);
  register register11(clk, rst ,w_en11, data_in, data11);
  register register12(clk, rst ,w_en12, data_in, data12);
  register register13(clk, rst ,w_en13, data_in, data13);
  register register14(clk, rst ,w_en14, data_in, data14);
  register register15(clk, rst ,w_en15, data_in, data15);


  assign w_en0 = (addr_c == 4'h0) ? 1'b1 : 1'b0; 
  assign w_en1 = (addr_c == 4'h1) ? 1'b1 : 1'b0; 
  assign w_en2 = (addr_c == 4'h2) ? 1'b1 : 1'b0; 
  assign w_en3 = (addr_c == 4'h3) ? 1'b1 : 1'b0; 
  assign w_en4 = (addr_c == 4'h4) ? 1'b1 : 1'b0; 
  assign w_en5 = (addr_c == 4'h5) ? 1'b1 : 1'b0; 
  assign w_en6 = (addr_c == 4'h6) ? 1'b1 : 1'b0; 
  assign w_en7 = (addr_c == 4'h7) ? 1'b1 : 1'b0; 
  assign w_en8 = (addr_c == 4'h8) ? 1'b1 : 1'b0; 
  assign w_en9 = (addr_c == 4'h9) ? 1'b1 : 1'b0; 
  assign w_en10 = (addr_c == 4'ha) ? 1'b1 : 1'b0; 
  assign w_en11 = (addr_c == 4'hb) ? 1'b1 : 1'b0; 
  assign w_en12 = (addr_c == 4'hc) ? 1'b1 : 1'b0; 
  assign w_en13 = (addr_c == 4'hd) ? 1'b1 : 1'b0; 
  assign w_en14 = (addr_c == 4'he) ? 1'b1 : 1'b0; 
  assign w_en15 = (addr_c == 4'hf) ? 1'b1 : 1'b0;

  case(addr_a) begin
    4'h0:
      data_a = data0;
    4'h1:
      data_a = data1;
    4'h2:
      data_a = data2
    4'h3:
      data_a = data3;
    4'h4:
      data_a = data4;
    4'h5:
      data_a = data5;
    4'h6:
      data_a = data6;
    4'h7:
      data_a = data7;
    4'h8:
      data_a = data8;
    4'h9:
      data_a = data9;
    4'ha:
      data_a = dataA;
    4'hb:
      data_a = dataB;
    4'hd:
      data_a = dataC;
    4'he:
      data_a = dataD;
    4'hf:
      data_a = dataF;
  endcase
  
  case(addr_b) begin
    4'h0:
      data_b = data0;
    4'h1:
      data_b = data1;
    4'h2:
      data_b = data2;
    4'h3:
      data_b = data3;
    4'h4:
      data_b = data4;
    4'h5:
      data_b = data5;
    4'h6:
      data_b = data6;
    4'h7:
      data_b = data7;
    4'h8:
      data_b = data8;
    4'h9:
      data_b = data9;
    4'ha:
      data_b = dataA;
    4'hb:
      data_b = dataB;
    4'hd:
      data_b = dataC;
    4'he:
      data_b = dataD;
    4'hf:
      data_b = dataF;
  endcase
end
