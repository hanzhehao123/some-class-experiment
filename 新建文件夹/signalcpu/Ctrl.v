`include "ctrl_encode_def.v"
`include "instruction_def.v"

module Ctrl(jump,RegDst,Branch,MemR,Mem2R,MemW,RegW,Alusrc,ExtOp,Aluctrl,OpCode,funct);
	
	input [5:0]		OpCode;				//指令操作码字段
	input [5:0]		Funct;				//指令功能字段

	output reg jump;						//指令跳转
	output reg RegDst;						
	output reg Branch;						//分支
	output reg MemR;						//读存储器
	output reg Mem2R;						//数据存储器到寄存器堆
	output reg MemW;						//写数据存储器
	output reg RegW;						//寄存器堆写入数据
	output reg Alusrc;						//运算器操作数选择
	output reg ExtOp;						//位扩展/符号扩展选择
	output reg[1:0] Aluctrl;						//Alu运算选择
	
	always @(OpCode or Funct)
	 begin
	   case(OpCode)
	     6'b001111://LUI
	       begin
	        assign Branch=0;
	        assign jump=0;
	        assign Mem2R=0;
	        assign MemW=1'b0;
	        assign MemR=1'b0;
	        assign Alusrc=0;
	        assign RegDst=1;
	        assign RegW=1'b1;
	        assign ALUOp=4'b0110;
	       end
	     
	     
	     
	     6'000000://R
	       begin
	        assign Branch=0;
	        assign jump=0;
	        assign Mem2R=0;
	        assign MemW=1'b0;
	        assign MemR=1'b0;
	        assign Alusrc=0;
	        assign RegDst=0;
	        assign RegW=1'b1;
	        case(Funct)
	          6'b100000:begin ALUOp=4'b0000; end
	          6'b100001:begin ALUOp=4'b1111; end
	          6'b100010:begin ALUOp=4'b0010; end
	          6'b100011:begin ALUOp=4'b0011; end
	          6'b100111:begin ALUOp=4'b1000; end
	          6'b100110:begin ALUOp=4'b1001; end
	          6'b101010:begin ALUOp=4'b0110; end
	          6'b101011:begin ALUOp=4'b0111; end
	            default:begin ALUOp=4'b0000; end
	         endcase;
	       end
	     6'001000://ADDI
	       begin
	        assign Branch=0;
	        assign jump=1;
	        assign Mem2R=0;
	        assign MemW=1'b0;
	        assign MemR=1'b0;
	        assign Alusrc=0;
	        assign RegDst=0;
	        assign RegW=1'b0;
	        assign ALUOp=4'b0000;
	       end 
	     6'000010://J
	       begin
	        assign Branch=0;
	        assign jump=1;
	        assign Mem2R=0;
	        assign MemW=1'b0;
	        assign MemR=1'b0;
	        assign Alusrc=0;
	        assign RegDst=0;
	        assign RegW=1'b0;
	        assign ALUOp=4'b0000;
	       end
	     6'100011://LW
	       begin
	        assign Branch=0;
	        assign jump=0;
	        assign Mem2R=1;
	        assign MemW=1'b0;
	        assign MemR=1'b0;
	        assign Alusrc=1;
	        assign RegDst=0;
	        assign RegW=1'b1;
	        assign ALUOp=4'0001;
	       end
	             
	             
	             
	          default;
	         endcase;
	  end  
	/*assign jump = 1;
	assign RegDst = OpCode[0];
	assign Branch = !(OpCode[0]||OpCode[1])&&OpCode[2];
	assign MemR = (OpCode[0]&&OpCode[1]&&OpCode[5])&&(!OpCode[3]);
	assign Mem2R = MemR;
	assign MemW = OpCode[1]&&OpCode[0]&&OpCode[3]&&OpCode[5];
	assign RegW = (OpCode[2]&&OpCode[3])||(!OpCode[2]&&!OpCode[3]);
	assign Alusrc = OpCode[0]||OpCode[1];
	assign ExtOp = OpCode[2]&&OpCode[3];
	always@(OpCode or funct)
	begin
		Aluctrl[1] = ExtOp;
		if((OpCode[1]||OpCode[2]) == 0)
			Aluctrl[0] = funct[1];
		else
			Aluctrl[0] = !(OpCode[1]||OpCode[0]);
	end*/
endmodule