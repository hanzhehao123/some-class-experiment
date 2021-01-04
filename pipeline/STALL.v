module Stall(Bubble,PcWrite,IFID_Write,IDEX_Write,EXMEM_Write,MEMWB_Write,
			IDEX_Flush,
			EX_MemRead,EX_RegWrite,EX_Wesel,EX_Branch,EX_BNE,EX_jump,
			MEM_MemRead,MEM_RegWrite,MEM_Wesel,
			ID_rs,ID_rt,ID_Branch,ID_BNE,ID_jump,ID_pcSel,ID_jr,EX_jr);
			
	//id
	input [4:0] ID_rs;
	input [4:0] ID_rt;
	input		ID_Branch;
	input		ID_BNE;
	input		ID_jump;
	input [1:0]	ID_pcSel;
	input		ID_jr;
	//ex
	input		EX_Branch;
	input		EX_BNE;
	input		EX_jump;
	input		EX_MemRead;
	input		EX_RegWrite;
	input [4:0] EX_Wesel;
	//mem
	input [4:0] MEM_Wesel;
	input		MEM_RegWrite;
	input		MEM_MemRead;
	
	output reg PcWrite;
	output reg IDEX_Write;
	output reg IDEX_Flush;
	output reg IFID_Write;
	output reg EXMEM_Write;
	output reg MEMWB_Write;
	output reg Bubble;
	output reg EX_jr;
	always@(ID_rs or ID_rt or ID_Branch or ID_BNE or ID_pcSel or ID_jump
			or EX_RegWrite or EX_Wesel or EX_BNE or EX_Branch or EX_jump
			or MEM_Wesel or MEM_RegWrite)
	begin
		PcWrite=1;
		IFID_Write=1;
		IDEX_Write=1;
		EXMEM_Write=1;
		MEMWB_Write=1;
		IDEX_Flush=0;
		Bubble=0;
		//MEM EX stall
		//第一种阻塞，现在处于EX阶段的指令要在MEM阶段读寄存器之后才能产生写寄存器的信息
		if( (EX_MemRead==1) &&(EX_RegWrite==1) && ((EX_Wesel==ID_rs)||(EX_Wesel==ID_rt)))
		begin
			IDEX_Flush=1;
			IFID_Write=0;
			PcWrite=0;
		end
		
		//EX ID stall
		//第二种阻塞，本周期内需要信息确定是否要跳转，但是这些寄存器在本周期内无法产生
		if(ID_Branch || ID_BNE ||ID_jump)
		if((EX_RegWrite==1) &&((EX_Wesel==ID_rt)||(EX_Wesel==ID_rs)))
		begin
			IDEX_Flush=1;
			IFID_Write=0;
			PcWrite=0;
		end
		
		//MEM ID stall)
		//本周期内分支指令进行判断所需的寄存器在MEM阶段指令读寄存器后才能产生
		if(ID_Branch || ID_BNE ||ID_jump)
		if( (MEM_MemRead==1) &&(MEM_RegWrite==1) && ((MEM_Wesel==ID_rs)||(MEM_Wesel==ID_rt)))
		begin
			IDEX_Flush=1;
			IFID_Write=0;
			PcWrite=0;
		end
		//branch or bne is predicted incorrectly
		//分支判断出现错误
		if(EX_Branch||EX_BNE||EX_jump||EX_jr)
		if(ID_pcSel!=0)
		begin
			IDEX_Flush=1;
			Bubble=1;
		end
		if(ID_jr)
		begin
			IDEX_Flush=1;
		end
	end
endmodule