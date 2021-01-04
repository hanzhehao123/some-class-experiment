module EXMEM(clk,rst,EXMEM_Write,
	EX_Branch,EX_BNE,EX_MemRead,EX_MemWrite,EX_Mem2R,EX_RegWrite,
	EX_AluRes,EX_GPR_Data_2,EX_Wesel,EX_rt,EX_zero,EX_NPC,EX_jal,
	MEM_Branch,MEM_BNE,MEM_MemRead,MEM_MemWrite,MEM_Mem2R,MEM_RegWrite,
	MEM_AluRes,MEM_GPR_Data_2,MEM_Wesel,MEM_rt,MEM_zero,MEM_NPC,MEM_jal);

	input clk;
	input rst;
	input EXMEM_Write;
	
	input EX_Branch;
	input EX_BNE;
	input EX_MemRead;
	input EX_MemWrite;
	input EX_Mem2R;
	input EX_RegWrite;
	input [31:0] EX_AluRes;
	input [31:0] EX_GPR_Data_2;
	input [4:0] EX_Wesel;
	input [4:0] EX_rt;
	input EX_zero;
	input EX_jal;
	input [31:0] EX_NPC;
	
	output reg MEM_Branch;
	output reg MEM_BNE;
	output reg MEM_MemRead;
	output reg MEM_MemWrite;
	output reg MEM_Mem2R;
	output reg MEM_RegWrite;
	output reg [31:0] MEM_AluRes;
	output reg [31:0] MEM_GPR_Data_2;
	output reg [4:0] MEM_Wesel;
	output reg [4:0] MEM_rt;
	output reg MEM_zero;
	output reg MEM_jal;
    output reg [31:0]MEM_NPC;
    always@(posedge clk or posedge rst) 
	begin
		if(rst)
			begin
				MEM_Branch=0;
				MEM_BNE=0;
				MEM_MemRead=0;
				MEM_MemWrite=0;
				MEM_Mem2R=0;
				MEM_RegWrite=0;
				MEM_AluRes=0;
				MEM_GPR_Data_2=0;
				MEM_Wesel=0;
				MEM_rt=0;
				MEM_zero=0;
				MEM_NPC=0;
				MEM_jal=0;
			end
		else if(EXMEM_Write)
			begin
				MEM_Branch=EX_Branch;
				MEM_BNE=EX_BNE;
				MEM_MemRead=EX_MemRead;
				MEM_MemWrite=EX_MemWrite;
				MEM_Mem2R=EX_Mem2R;
				MEM_RegWrite=EX_RegWrite;
				MEM_AluRes=EX_AluRes;
				MEM_GPR_Data_2=EX_GPR_Data_2;
				MEM_Wesel=EX_Wesel;
				MEM_rt=EX_rt;
				MEM_zero=EX_zero;
				MEM_NPC=EX_NPC;
				MEM_jal=EX_jal;
			end
   end // end always
      
endmodule