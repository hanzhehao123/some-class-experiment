`include "instruction_def.v"
`include "ctrl_encode_def.v"

module PcUnit(PC,PcReSet,PcSel,Clk,Address,PcWrite);

	input   PcReSet;
	input   [1:0]PcSel;
	input   Clk;
	input   [31:0] Address;
	input 	PcWrite;
	
	output reg[31:0] PC;
	
	always@(posedge Clk or posedge PcReSet)
	begin
		if(PcReSet==1)
			PC<=32'h0000_3000;
		if(PcWrite)
			PC=Address;
	end
endmodule
	
	