`timescale 100 ns / 10 ps

module processingElement8(clk,reset,A,B,result);

parameter DATA_WIDTH = 8;

input clk, reset;
input [DATA_WIDTH-1:0] A, B;
output reg [DATA_WIDTH-1:0] result;

wire [DATA_WIDTH-1:0] multResult;
wire [DATA_WIDTH-1:0] addResult;

integerMult8 IM (A,B,multResult);
integerAdd8 IADD (multResult,result,addResult);

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		result = 0;
	end else begin
		result = addResult;
	end
end

endmodule
