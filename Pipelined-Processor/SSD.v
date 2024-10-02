module SSD (HEX, SSD);
  input [3:0] HEX;
  output reg [0:6] SSD;

  always@(HEX) begin
    case(HEX)
      4'h0:SSD=7'b0000001;
      4'h1:SSD=7'b1001111;
      4'h2:SSD=7'b0010010;
      4'h3:SSD=7'b0000110;
      4'h4:SSD=7'b1001100;
      4'h5:SSD=7'b0100100;
      4'h6:SSD=7'b0100000;
      4'h7:SSD=7'b0001111;
      4'h8:SSD=7'b0000000;
      4'h9:SSD=7'b0001100;
      4'hA:SSD=7'b0001000;
      4'hb:SSD=7'b1100000;
      4'hc:SSD=7'b0110001;
      4'hd:SSD=7'b1000010;
      4'hE:SSD=7'b0110000;
      4'hF:SSD=7'b0111000;
    endcase
  end
endmodule