`timescale 100 ns / 10 ps

module integerMult8 (A,B,product);

input [7:0] A, B;
output reg [7:0] product;

reg sign;
reg [6:0] Integer;

integer i;
always @ (A or B) begin
    Integer = 7'b000_0000;
	if (A == 0 || B == 0) begin
		product = 0;
	end else begin
		sign = A[7] | B[7];
		for (i=0; i<7; i=i+1)begin
		    if (B[i] == 1)begin
		      Integer = Integer + ({7'b0,A[6:0]} << i);
		      end
		    else
		      Integer = Integer;
		end  
	end
	product = {sign, Integer};
end

endmodule
