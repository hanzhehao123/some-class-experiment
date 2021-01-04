module WBIF(clk,rst,
		WB_RegWrite,WB_Wesel,WB_GPR_input,
		WBIF_RegWrite,WBIF_Wesel,WBIF_GPR_input);
	
	input clk;
	input rst;
	
	input WB_RegWrite;
	input [4:0] WB_Wesel;
	input [31:0] WB_GPR_input;
	
	output reg WBIF_RegWrite;
	output reg [4:0] WBIF_Wesel;
	output reg [31:0] WBIF_GPR_input;
	
	always@(posedge clk or posedge rst)
	begin
		if(rst)
			begin
				WBIF_RegWrite=0;
				WBIF_Wesel=0;
				WBIF_GPR_input=0;
			end
		else
			begin
				WBIF_RegWrite=WB_RegWrite;
				WBIF_Wesel=WB_Wesel;
				WBIF_GPR_input=WB_GPR_input;
			end
	end
endmodule			
