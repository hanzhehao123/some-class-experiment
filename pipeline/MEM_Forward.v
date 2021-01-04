module MEM_Forward(MEM_rt,WB_WeSel,WB_RegWrite,WBIF_WeSel,WBIF_RegWrite,MEM_Forward,MEM_Memadd,WB_Memadd,WB_Mem2R,MEM_Alu_Res,WB_Alu_Res);

	input[4:0]		MEM_rt;
	input[4:0]		WB_WeSel;
	input			WB_RegWrite;
	input[4:0]		WBIF_WeSel;
	input			WBIF_RegWrite;
	input[4:0]		MEM_Memadd;
	input[4:0]		WB_Memadd;
	input			WB_Mem2R;
	input[32:0]		MEM_Alu_Res,WB_Alu_Res;
	output reg[1:0]	MEM_Forward;
	
	always@(MEM_rt or WB_WeSel or WB_RegWrite or WBIF_RegWrite or WBIF_WeSel or WB_Mem2R or MEM_Alu_Res or WB_Alu_Res)
	begin
		MEM_Forward = 2'b00;
		
		//MEM MEM
		//下一条指令要写的寄存器是当前指令写存储器的来源寄存器
		if (WB_RegWrite && (WB_WeSel != 0) && (WB_WeSel == MEM_rt))
			MEM_Forward = 2'b10;
		
		//下下条指令要写的寄存器是当前指令写存储器的来源寄存器
		else if (WBIF_RegWrite && (WBIF_WeSel != 0) && (WBIF_WeSel == MEM_rt))
			MEM_Forward = 2'b01;
		/*if(!WB_Mem2R&&(MEM_Alu_Res==WB_Alu_Res))
			MEM_Forward = 2'b11;*/
	end
	
endmodule