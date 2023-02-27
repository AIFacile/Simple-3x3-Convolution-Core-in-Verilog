`timescale 100 ns / 10 ps

module convLayerSingle(clk,reset,image,filter,outputConv);

parameter DATA_WIDTH = 8;
parameter D = 1; //��������
parameter H = 8; //ͼ��ĸ�
parameter W = 8; //ͼ��Ŀ�
parameter F = 3; //����˵Ĵ�С��Kernel_size��

input clk, reset;
input [0:D*H*W*DATA_WIDTH-1] image;
input [0:D*F*F*DATA_WIDTH-1] filter;
output reg [0:(H-F+1)*(W-F+1)*DATA_WIDTH-1] outputConv; // ����������������ͼFeature_map

wire [0:((W-F+1)/2)*DATA_WIDTH-1] outputConvUnits; // ��������˵�����Լ���ѡ����������

reg internalReset;
wire [0:(((W-F+1)/2)*D*F*F*DATA_WIDTH)-1] receptiveField; // �������˵ľ����Receptive_field��

integer counter, outputCounter;
//counter: �������ɼ�����Ҫ��ʱ��������
//outputCounter: index to map the output of the conv units to the output of the module

reg [3:0] rowNumber, column; 
//rowNumber: ��������˼����ĳһ��
//column: determines if we are calculating the first or the second 14 pixels of the output row

RFselector
#(
	.DATA_WIDTH(DATA_WIDTH),
	.D(D),
	.H(H),
	.W(W),
	.F(F)
) RF
(
	.image(image),
	.rowNumber(rowNumber),
	.column(column),
	.receptiveField(receptiveField)
);

genvar n;

generate
	for (n = 0; n < (H-F+1)/2; n = n + 1) begin 
		convUnit
		#(
			.D(D),
			.F(F)
		) CU
		(
			.clk(clk),
			.reset(internalReset),
			.image(receptiveField[n*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
			.filter(filter),
			.result(outputConvUnits[n*DATA_WIDTH+:DATA_WIDTH])
		);
	end
endgenerate

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		internalReset = 1'b1;
		rowNumber = 0;
		column = 0;
		counter = 0;
		outputCounter = 0;
	end else if (rowNumber < H-F+1) begin
		if (counter == D*F*F+2) begin //The conv unit finishes ater 1*5*5+2 clock cycles
			outputCounter = outputCounter + 1;
			counter = 0;
			internalReset = 1'b1;
			if (column == 0) begin
				column = (H-F+1)/2;
			end else begin
				rowNumber = rowNumber + 1;
				column = 0;
			end
		end else begin
			internalReset = 0;
			counter = counter + 1;
		end
	end
end

always @ (*) begin
	outputConv[outputCounter*((W-F+1)/2)*DATA_WIDTH+:((W-F+1)/2)*DATA_WIDTH] = outputConvUnits;
end

endmodule

