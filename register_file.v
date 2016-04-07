module register_file
(
  input clk, rst, w_en, 
  input [3:0] addr_a, addr_b, addr_c, 
  input [15:0] data_c,
  
  output reg [15:0] data_a, data_b
);

  //`define addr_size 4

  wire w_en0, w_en1, w_en2, w_en3, w_en4, w_en5, w_en6, w_en7, w_en8, w_en9, w_enA, w_enB, w_enC, w_enD, w_enE, w_enF;
  wire [15:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, dataA, dataB, dataC, dataD, dataE, dataF;
  
  register register0(clk, rst ,w_en0, data_c, data0);
  register register1(clk, rst ,w_en1, data_c, data1);
  register register2(clk, rst ,w_en2, data_c, data2);
  register register3(clk, rst ,w_en3, data_c, data3);
  register register4(clk, rst ,w_en4, data_c, data4);
  register register5(clk, rst ,w_en5, data_c, data5);
  register register6(clk, rst ,w_en6, data_c, data6);
  register register7(clk, rst ,w_en7, data_c, data7);
  register register8(clk, rst ,w_en8, data_c, data8);
  register register9(clk, rst ,w_en9, data_c, data9);
  register register10(clk, rst ,w_enA, data_c, dataA);
  register register11(clk, rst ,w_enB, data_c, dataB);
  register register12(clk, rst ,w_enC, data_c, dataC);
  register register13(clk, rst ,w_enD, data_c, dataD);
  register register14(clk, rst ,w_enE, data_c, dataE);
  register register15(clk, rst ,w_enF, data_c, dataF);


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
  assign w_enA = (addr_c == 4'ha) ? 1'b1 : 1'b0; 
  assign w_enB = (addr_c == 4'hb) ? 1'b1 : 1'b0; 
  assign w_enC = (addr_c == 4'hc) ? 1'b1 : 1'b0; 
  assign w_enD = (addr_c == 4'hd) ? 1'b1 : 1'b0; 
  assign w_enE = (addr_c == 4'he) ? 1'b1 : 1'b0; 
  assign w_enF = (addr_c == 4'hf) ? 1'b1 : 1'b0;
  
  always@(*) begin
  case(addr_a) 
    4'h0:
      data_a <= data0;
    4'h1:
      data_a <= data1;
    4'h2:
      data_a <= data2;
    4'h3:
      data_a <= data3;
    4'h4:
      data_a <= data4;
    4'h5:
      data_a <= data5;
    4'h6:
      data_a <= data6;
    4'h7:
      data_a <= data7;
    4'h8:
      data_a <= data8;
    4'h9:
      data_a <= data9;
    4'ha:
      data_a <= dataA;
    4'hb:
      data_a <= dataB;
	 4'hc:
	   data_a <= dataC;
    4'hd:
      data_a <= dataD;
    4'he:
      data_a <= dataE;
    4'hf:
      data_a <= dataF;
  endcase
  
  case(addr_b) 
    4'h0:
      data_b <= data0;
    4'h1:
      data_b <= data1;
    4'h2:
      data_b <= data2;
    4'h3:
      data_b <= data3;
    4'h4:
      data_b <= data4;
    4'h5:
      data_b <= data5;
    4'h6:
      data_b <= data6;
    4'h7:
      data_b <= data7;
    4'h8:
      data_b <= data8;
    4'h9:
      data_b <= data9;
    4'ha:
      data_b <= dataA;
    4'hb:
      data_b <= dataB;
	 4'hc:
	   data_b <= dataC;
    4'hd:
      data_b <= dataD;
    4'he:
      data_b <= dataE;
    4'hf:
      data_b <= dataF;
  endcase

end

endmodule
