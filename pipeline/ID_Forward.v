module ID_Forward(ID_ForwardA,ID_ForwardB,ID_rs,ID_rt,
				EX_Wesel,EX_RegWrite,
				MEM_Wesel,MEM_RegWrite,
				WB_Wesel,WB_RegWrite);
				
	input [4:0] ID_rs;
	input [4:0] ID_rt;
	input [4:0] MEM_Wesel,EX_Wesel;
	input [4:0] WB_Wesel;
	input		MEM_RegWrite,EX_RegWrite;
	input		WB_RegWrite;
	
	output reg [1:0] ID_ForwardA;
	output reg [1:0] ID_ForwardB;
	
	always@(ID_rs or ID_rt or MEM_Wesel or MEM_RegWrite or WB_RegWrite or WB_Wesel)
	begin
		ID_ForwardA=2'b00;
		ID_ForwardB=2'b00;
		
		//MEM ID forward
		//当前MEM阶段的指令会写寄存器，所写寄存器单元是当前指令会读的单元。
		if((WB_RegWrite==1)&&(WB_Wesel!=0)&&(WB_Wesel==ID_rs))
			ID_ForwardA=2'b01;
		if((WB_RegWrite==1)&&(WB_Wesel!=0)&&(WB_Wesel==ID_rt))
			ID_ForwardA=2'b01;
			
		//EX ID forward
		//当前EX阶段的指令会写寄存器，所写寄存器单元是当前指令会读的单元。
		if((MEM_RegWrite==1)&&(MEM_Wesel!=0)&&(MEM_Wesel==ID_rs))
			ID_ForwardA=2'b10;
		if((MEM_RegWrite==1)&&(MEM_Wesel!=0)&&(MEM_Wesel==ID_rt))
			ID_ForwardB=2'b10;
			
	end
endmodule