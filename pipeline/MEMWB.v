module MEMWB(clk,rst,MEMWB_Write,
MEM_AluRes,MEM_Mem2R,MEM_MemData,MEM_RegWrite,MEM_Wesel,MEM_jal,MEM_NPC,MEM_Memadd,MEM_MemWrite,MEM_DataIn,
WB_AluRes,WB_Mem2R,WB_MemData,WB_RegWrite,WB_Wesel,WB_jal,WB_NPC,WB_Memadd,WB_MemWrite,WB_DataIn);
               
	input clk;
	input rst;
	input MEMWB_Write;
	
	input MEM_Mem2R;
	input MEM_RegWrite;
	input [31:0] MEM_MemData;
	input [31:0] MEM_AluRes;
	input [4:0] MEM_Wesel;
    input [31:0] MEM_NPC;
	input [31:0] MEM_DataIn;
	input MEM_jal;
	input [7:0] MEM_Memadd;
	output reg WB_Mem2R;
	output reg WB_RegWrite;
	output reg [31:0] WB_MemData;
	output reg [31:0] WB_AluRes;
	output reg [4:0] WB_Wesel;
	output reg [31:0] WB_NPC;
	output reg [7:0]WB_Memadd;
	output reg WB_jal;
	output reg [31:0]WB_DataIn;
	input MEM_MemWrite;
	output reg WB_MemWrite;
    always@(posedge clk or posedge rst) 
    begin
		if(rst)
			begin
				WB_Mem2R=0;
				WB_RegWrite=0;
				WB_MemData=0;
				WB_AluRes=0;
				WB_Wesel=0;
				WB_NPC=0;
				WB_jal=0;
				WB_Memadd=0;
				WB_MemWrite=0;
				WB_DataIn=0;
			end
		else if(MEMWB_Write)
			begin
				WB_Mem2R=MEM_Mem2R;
				WB_RegWrite=MEM_RegWrite;
				WB_MemData=MEM_MemData;
				WB_AluRes=MEM_AluRes;
				WB_Wesel=MEM_Wesel;
				WB_NPC=MEM_NPC;
				WB_jal=MEM_jal;
				WB_Memadd=MEM_Memadd;
				WB_MemWrite=MEM_MemWrite;
				WB_DataIn=MEM_DataIn;
			end
	end // end always
      
endmodule
