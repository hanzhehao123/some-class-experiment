module EX_Forward(EX_ForwardA,EX_ForwardB,EX_rs,EX_rt,MEM_WeSel,WB_WeSel,MEM_RegWrite,WB_RegWrite);
	input[4:0]		EX_rs;
	input[4:0]		EX_rt;
	input[4:0]		MEM_WeSel;
	input[4:0]		WB_WeSel;
	input			MEM_RegWrite;
	input			WB_RegWrite;
	output reg[1:0]	EX_ForwardA;
	output reg[1:0]	EX_ForwardB;
	
	always@(EX_rs or EX_rt or MEM_WeSel or WB_WeSel or MEM_RegWrite or WB_RegWrite)
	begin
		EX_ForwardA = 2'b00;
		EX_ForwardB = 2'b00;
		if (MEM_RegWrite && (MEM_WeSel != 0) && (MEM_WeSel == EX_rs))
			EX_ForwardA = 2'b10;
		else if (WB_RegWrite && (WB_WeSel != 0) && (WB_WeSel == EX_rs))
			EX_ForwardA = 2'b01;
		if (MEM_RegWrite && (MEM_WeSel != 0) && (MEM_WeSel == EX_rt))
			EX_ForwardB = 2'b10;
		//MEM EX
		//WB阶段要写的寄存器和当前要读的寄存器相同，产生旁路
		
		else if (WB_RegWrite && (WB_WeSel != 0) && (WB_WeSel == EX_rt))
			EX_ForwardB = 2'b01;
		
	
		//EX EX
		//MEM阶段要写的寄存器和当前要读的寄存器相同，产生旁路
		
	end
	
endmodule