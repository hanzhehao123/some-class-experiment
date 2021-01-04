module IDEX(clk,rst,IDEX_Flush,IDEX_Write,
			ID_Aluctrl,ID_Alusrc,ID_BNE,ID_Branch,ID_EXT,ID_GPR_Data_1,ID_GPR_Data_2,
			ID_Mem2R,ID_MemRead,ID_MemWrite,ID_NPC,ID_RegDst,ID_RegWrite,
			ID_jump,ID_jump_add,ID_rd,ID_rs,ID_rt,ID_shamt,ID_jal,ID_jr,
			EX_Aluctrl,EX_Alusrc,EX_BNE,EX_Branch,EX_EXT,EX_GPR_Data_1,EX_GPR_Data_2,
			EX_Mem2R,EX_MemRead,EX_MemWrite,EX_NPC,EX_RegDst,EX_RegWrite,
			EX_jump,EX_jump_add,EX_rd,EX_rs,EX_rt,EX_shamt,EX_jal,EX_jr);
               
	input clk;
	input rst;
	input IDEX_Flush;
	input IDEX_Write;
	
	input [4:0] ID_Aluctrl;
	input ID_RegDst;
	input ID_Alusrc;
	input ID_Branch;
	input ID_BNE;
	input ID_MemRead;
	input ID_MemWrite;
	input ID_Mem2R;
	input ID_RegWrite;
	input [31:0] ID_NPC;
	input [31:0] ID_GPR_Data_1;
	input [31:0] ID_GPR_Data_2;
	input [31:0] ID_EXT;
	input [4:0]  ID_rs;
	input [4:0]  ID_rt;
	input [4:0]  ID_rd;
	input [4:0]  ID_shamt;
	input [31:0] ID_jump_add;
	input ID_jump;
	input ID_jal;
	input ID_jr;
	output reg [4:0] EX_Aluctrl;
	output reg EX_RegDst;
	output reg EX_Alusrc;
	output reg EX_Branch;
	output reg EX_BNE;
	output reg EX_MemRead;
	output reg EX_MemWrite;
	output reg EX_Mem2R;
	output reg EX_RegWrite;
	output reg [31:0] EX_NPC;
	output reg [31:0] EX_GPR_Data_1;
	output reg [31:0] EX_GPR_Data_2;
	output reg [31:0] EX_EXT;
	output reg [4:0]  EX_rs;
	output reg [4:0]  EX_rt;
	output reg [4:0]  EX_rd;
	output reg [4:0]  EX_shamt;
	output reg [31:0] EX_jump_add;
	output reg EX_jal;
	output reg EX_jump;
    output reg EX_jr;
    always@(posedge clk or posedge rst) 
	begin
		if(rst)
			begin
				EX_Aluctrl=0;
				EX_RegDst=0;
				EX_Alusrc=0;
				EX_Branch=0;
				EX_BNE=0;
				EX_MemRead=0;
				EX_MemWrite=0;
				EX_Mem2R=0;
				EX_RegWrite=0;
				EX_NPC=0;
				EX_GPR_Data_1=0;
				EX_GPR_Data_2=0;
				EX_EXT=0;
				EX_rs=0;
				EX_rt=0;
				EX_rd=0;
				EX_shamt=0;
				EX_jump_add=0;
				EX_jump=0;
				EX_jal=0;
				EX_jr=0;
			end
		else if(IDEX_Write)
			begin
				EX_Aluctrl=ID_Aluctrl;
				EX_RegDst=ID_RegDst;
				EX_Alusrc=ID_Alusrc;
				EX_Branch=ID_Branch;
				EX_BNE=ID_BNE;
				EX_MemRead=ID_MemRead;
				EX_MemWrite=ID_MemWrite;
				EX_Mem2R=ID_Mem2R;
				EX_RegWrite=ID_RegWrite;
				EX_NPC=ID_NPC;
				EX_GPR_Data_1=ID_GPR_Data_1;
				EX_GPR_Data_2=ID_GPR_Data_2;
				EX_EXT=ID_EXT;
				EX_rs=ID_rs;
				EX_rt=ID_rt;
				EX_rd=ID_rd;
				EX_shamt=ID_shamt;
				EX_jump_add=ID_jump_add;
				EX_jump=ID_jump;
				EX_jal=ID_jal;
				EX_jr=ID_jr;
			end
		if(IDEX_Flush)
			begin
				EX_Aluctrl=0;
				EX_RegDst=0;
				EX_Alusrc=0;
				EX_Branch=0;
				EX_BNE=0;
				EX_MemRead=0;
				EX_MemWrite=0;
				EX_Mem2R=0;
				EX_RegWrite=0;
				EX_jump=0;
				EX_jal=0;
				EX_jr=0;
			end
    end // end always
      
endmodule


