`timescale 100 ns / 10 ps

module integerAdd8 (A,B,sum);
	
input [7:0] A, B;
output reg [7:0] sum;

reg sign, signA, signB;
reg [6:0] integerA;
reg [6:0] integerB;

always @ (A or B) begin 
    begin
    integerA = A[6:0];
    integerB = B[6:0];
    signA = A[7];
    signB = B[7];
    sum = 8'b0000_0000;
    end
	if (integerA == 0) begin						
		sum = integerB;
	end else if (integerB == 0) begin					
		sum = integerA;
	end else if (integerA == integerB && A[7] ^ B[7]==1'b1) begin
		sum=0;
	end else begin
		if (A[7] ^ B[7] == 1'b1 && integerA != integerB) begin
			if (A[7] == 1'b0)begin
			    if (integerA > integerB)begin
			        sign = 1'b0;
			        sum = {sign, (integerA - integerB)};
			        end
			    else begin
			        sign = 1'b1;
			        sum = {sign, (integerB - integerA)};
			        end
			end else if (B[7] == 1'b0)begin
			    if (integerB > integerA)begin
			        sign = 1'b0;
			        sum = {sign, (integerB - integerA)};
			        end
			    else begin
			        sign = 1'b0;
			        sum = {sign, (integerA - integerB)};
			        end
			 end
	    end else if (A[7] ^ B[7] == 1'b0)begin
	           if (A[7] == 1'b1 && B[7] == 1'b1)begin
	               sign = 1'b1;
	               sum = {sign, (integerA + integerB)};
	               end
	           else if(A[7] == 1'b0 && B[7] == 1'b0)begin
	               sign = 1'b0;
	               sum = {sign, (integerA + integerB)};
	               end
	           end 
		end
end

endmodule
