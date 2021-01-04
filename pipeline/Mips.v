`include "ctrl_encode_def.v"
`include "instruction_def.v"
module Mips(Clk,Reset);
	
	input Clk;
	input Reset;
	
	//Preparation for IF
	wire [31:0] PC;
	wire [1:0] pcSel;
	wire [31:0] IF_opCode;
	wire [31:0] IF_NPC;
	wire [5:0] IF_IM_add;
	wire [31:0] PC_add;
	wire [31:0] NPC_add;
	
	//Preparation for ID
	wire[31:0]	ID_GPR_Data_1;
	wire[31:0]	ID_GPR_Data_2;
	wire[31:0]	ID_opCode;
	wire[31:0]	ID_NPC;
	wire[5:0]	ID_op;
	wire[5:0]	ID_funct;
	wire[4:0]	ID_Resel1;
	wire[4:0]	ID_Resel2;
	wire[25:0]	ID_jumpadd;
	wire[4:0]	ID_shamt;
	wire[15:0] 	ID_EXT_in;
	wire[4:0]	ID_rs;
	wire[4:0]	ID_rt;
	wire[4:0]	ID_rd;
	wire		IFID_Write;
	wire		IDEX_Write;
	wire		EXMEM_Write;
	wire 		MEMWB_Write;
	wire		PC_Write;
	wire		IDEX_Flush;
	wire[1:0]	ExtOp;
	wire[31:0]	ID_EXT;
	wire[4:0]	ID_Aluctrl;
	wire		ID_RegDst;
	wire		ID_Alusrc;
	wire		ID_Branch;
	wire		ID_BNE;
	wire		ID_MemWrite;
	wire		ID_MemRead;
	wire		ID_Mem2R;
	wire		ID_RegWrite;
	wire		ID_jump;
	wire		ID_zero;
	wire[31:0]	ID_Branchadd;
	wire[31:0]	ID_jump_add;
	wire[1:0]	ID_ForwardA;
	wire[1:0]	ID_ForwardB;
	wire[31:0]	ID_ALU_In1;
	wire[31:0]	ID_ALU_In2;
	wire[1:0]	ID_pcSel;
	wire		ID_jal;
	wire		Bubble;
	wire        ID_jr;
	wire [31:0] ID_jr_PC;
	//preparation for EX
	wire[4:0]	EX_Aluctrl;						
	wire		EX_RegDst;						
	wire	  	EX_Alusrc;						
	wire		EX_Branch;						
	wire		EX_BNE;				
	wire		EX_MemRead;					
	wire		EX_MemWrite;					
	wire		EX_Mem2R;					
	wire		EX_RegWrite;					
	wire[31:0]	EX_NPC;
	wire[31:0]	EX_GPR_Data_1;
	wire[31:0]	EX_GPR_Data_2;
	wire[31:0]	EX_EXT;
	wire[4:0]	EX_rs;
	wire[4:0]	EX_rt;
	wire[4:0]	EX_rd;
	wire[4:0] 	EX_shamt;
	wire[31:0]	EX_jump_add;
	wire		EX_jump;	
	wire[31:0]	EX_Alu_In1;
	wire[31:0]	EX_Alu_In2;
	wire[31:0]	EX_Alu_In2_alt;
	wire[31:0]	EX_Alu_Res;
	wire		EX_zero;
	wire[4:0]	EX_WeSel;
	wire[1:0]	EX_ForwardA;
	wire[1:0]	EX_ForwardB;
	wire		EX_jal;
	wire		EX_jr;
	//preparation for MEM
	wire		MEM_Branch;						
	wire		MEM_BNE;				
	wire		MEM_MemRead;				
	wire		MEM_MemWrite;				
	wire		MEM_Mem2R;				
	wire		MEM_RegWrite;				
	wire		MEM_zero;
	wire[31:0]	MEM_Alu_Res;
	wire[31:0]	MEM_GPR_Data_2;
	wire[4:0]	MEM_WeSel;
	wire[7:0]	MEM_Memadd;
	wire[31:0]	MEM_MemData,MEM_MemData1;
	wire[4:0]	MEM_rt;
	wire[1:0]	MEM_Forward,MEM_Forward1;
	wire[31:0]	MEM_DataIn;
	wire		MEM_jal;
	wire [31:0] MEM_NPC;
	//preparation for WB
	wire		WB_Mem2R;
	wire		WB_RegWrite;
	wire[31:0]	WB_MemData;
	wire[31:0]	WB_Alu_Res;
	wire[4:0]	WB_Wesel;
	wire[31:0]	WB_GPR_input;
	wire[31:0]  WB_NPC;
	wire		WB_jal;
	wire[7:0]	WB_Memadd;
	wire[31:0]  WB_DataIn;
	wire		WB_MemWrite;
	//preparation for WBIF
	wire		WBIF_RegWrite;
	wire[4:0]	WBIF_Wesel;
	wire[31:0]	WBIF_GPR_input;
	
	//work in IF
	//pcSel 0为PC+4，1为beq/bne,2为j
	assign pcSel =  (ID_Branch&&(ID_zero==1) || ID_BNE&&(ID_zero==0)==1) ? 1 : ((ID_jump == 1) ? 2:((ID_jr==1 )? 3:0));
	//根据pcSel选择新的PC值
	mux4 #(32) mux4_PC_add(.d0(IF_NPC),.d1(ID_Branchadd),.d2(ID_jump_add),.d3(ID_jr_PC),.s(pcSel),.y(PC_add));
	
	//如果插入Bubble，NPC为PC+4，否则就是新的PC值
	assign NPC_add=(Bubble == 1) ? IF_NPC : PC_add;//预测跳转始终发生，如果不发生，就阻塞，不让IF读beq/bne之后的指令
	//写PC
	PcUnit U_pcUnit(.PC(PC),.PcReSet(Reset),.PcSel(pcSel),.Clk(Clk),.Address(NPC_add),.PcWrite(PC_Write));
	//根据PC写NPC
	assign IF_NPC= PC + 4;
	
	//选择Instruction Memory中的取值地址
	assign IF_IM_add = PC[7:2];
	//根据指令地址取出对应的opCode
	IM U_IM(.OpCode(IF_opCode),.ImAdress(IF_IM_add));
	
	
	
	//work in IFID
	//写IFID寄存器(数据通路第一次传递)
	IFID U_IFID(.clk(Clk),.rst(Reset),.IFID_Write(IFID_Write),
			.IF_pcSel(pcSel),.IF_opcode(IF_opCode),.IF_NPC(IF_NPC),
			.ID_pcSel(ID_pcSel),.ID_opcode(ID_opCode),.ID_NPC(ID_NPC));
	
	//在opCode不同位置取出对应变量
	assign ID_op = ID_opCode[31:26];
	assign ID_funct = ID_opCode[5:0];
	assign ID_Resel1 = ID_opCode[25:21];
	assign ID_Resel2 = ID_opCode[20:16];
	assign ID_jumpadd = ID_opCode[25:0];
	assign ID_shamt = ID_opCode[10:6];
	assign ID_EXT_in = ID_opCode[15:0];
	assign ID_rs = ID_opCode[25:21];
	assign ID_rt = ID_opCode[20:16];
	assign ID_rd = ID_opCode[15:11];
	
	//根据当前指令的寄存器rs,rt选择读寄存器，存入中间变量
	//根据上一条指令的寄存器写控制信号和寄存器选择号写寄存器
	//写操作要等到WB阶段，故要等待
	GPR U_gpr(.DataOut1(ID_GPR_Data_1),.DataOut2(ID_GPR_Data_2),.clk(Clk),.WData(WB_GPR_input),
			  .WE(WB_RegWrite),.WeSel(WB_Wesel),.ReSel1(ID_Resel1),.ReSel2(ID_Resel2));
	
	//检测是否存在MEM->ID旁路 或者EX->ID旁路
	//根据检测结果设置控制信号
	ID_Forward U_ID_Forward(.ID_ForwardA(ID_ForwardA),.ID_ForwardB(ID_ForwardB),
							.ID_rs(ID_rs),.ID_rt(ID_rt),
							.EX_Wesel(EX_WeSel),.EX_RegWrite(EX_RegWrite),
							.MEM_Wesel(MEM_WeSel),.MEM_RegWrite(MEM_RegWrite),
							.WB_Wesel(WB_Wesel),.WB_RegWrite(WB_RegWrite));
	
	//如果当前寄存器不存在旁路，直接使用寄存器读出结果
	//如果当前寄存器存在旁路，存在MEM->ID旁路，使用将要写入寄存器的值作为变量值
	//如果当前寄存器存在旁路，存在EX->ID旁路，使用对应的ALU输出值作为内容
	mux3 #(32) U_mux4_ID_ForwardA(.d0(ID_GPR_Data_1),.d1(WB_GPR_input),.d2(MEM_Alu_Res),.s(EX_ForwardA),.y(ID_ALU_In1));
	mux3 #(32) U_mux4_ID_ForwardB(.d0(ID_GPR_Data_2),.d1(WB_GPR_input),.d2(MEM_Alu_Res),.s(EX_ForwardB),.y(ID_ALU_In2));

	//判断zero信号
	assign	ID_zero = (ID_ALU_In1 == ID_ALU_In2) ? 1 : 0;
	//计算beq和bne分支目标地址
	assign 	ID_Branchadd = ID_NPC + (ID_EXT << 2);
	//计算j跳转地址：高四位+中间26位+00
	assign	ID_jump_add = {ID_NPC[31:28], ID_jumpadd[25:0], 2'b0};
	assign ID_jr_PC = ((ID_Resel1==EX_rt)&&EX_RegWrite==1)?EX_Alu_Res:ID_GPR_Data_1;
	//符号扩展
	Extender U_extend(.ExtOut(ID_EXT),.DataIn(ID_EXT_in),.ExtOp(ExtOp));
	
	//判断是否需要阻塞
	//如果需要，修改PC写信号并阻塞当前正处在ID阶段的指令继续向下运行，不再继续取值
	Stall U_Stall(.Bubble(Bubble),.PcWrite(PC_Write),
			.IFID_Write(IFID_Write),.IDEX_Write(IDEX_Write),
			.EXMEM_Write(EXMEM_Write),.MEMWB_Write(MEMWB_Write),
			.IDEX_Flush(IDEX_Flush),
			.EX_MemRead(EX_MemRead),.EX_RegWrite(EX_RegWrite),.EX_Wesel(EX_WeSel),
			.EX_Branch(EX_Branch),.EX_BNE(EX_BNE),.EX_jump(EX_jump),
			.MEM_MemRead(MEM_MemRead),.MEM_RegWrite(MEM_RegWrite),.MEM_Wesel(MEM_WeSel),
			.ID_rs(ID_rs),.ID_rt(ID_rt),.ID_Branch(ID_Branch),
			.ID_BNE(ID_BNE),.ID_jump(ID_jump),.ID_pcSel(ID_pcSel),.ID_jr(ID_jr),.EX_jr(EX_jr));
	/*****/
	//产生控制信号
	Ctrl U_Ctrl(.jump(ID_jump),.RegDst(ID_RegDst),
				.Branch(ID_Branch),.MemR(ID_MemRead),.Mem2R(ID_Mem2R),.MemW(ID_MemWrite),
				.RegW(ID_RegWrite),.Alusrc(ID_Alusrc),.ExtOp(ExtOp),.Aluctrl(ID_Aluctrl),.BNE(ID_BNE),
				.OpCode(ID_op),.funct(ID_funct),.jal(ID_jal),.jr(ID_jr));
				
				
				
				
				
	//IDEX段间寄存器，数据通路第二次传递
	IDEX U_IDEX(.clk(Clk),.rst(Reset),.IDEX_Flush(IDEX_Flush),.IDEX_Write(IDEX_Write),
				.ID_Aluctrl(ID_Aluctrl),.ID_Alusrc(ID_Alusrc),.ID_BNE(ID_BNE),.ID_Branch(ID_Branch),
				.ID_EXT(ID_EXT),.ID_GPR_Data_1(ID_GPR_Data_1),.ID_GPR_Data_2(ID_GPR_Data_2),
				.ID_Mem2R(ID_Mem2R),.ID_MemRead(ID_MemRead),.ID_MemWrite(ID_MemWrite),
				.ID_NPC(ID_NPC),.ID_RegDst(ID_RegDst),.ID_RegWrite(ID_RegWrite),
				.ID_jump(ID_jump),.ID_jump_add(ID_jump_add),
				.ID_rd(ID_rd),.ID_rs(ID_rs),.ID_rt(ID_rt),.ID_shamt(ID_shamt),.ID_jal(ID_jal),.ID_jr(ID_jr),
				.EX_Aluctrl(EX_Aluctrl),.EX_Alusrc(EX_Alusrc),.EX_BNE(EX_BNE),.EX_Branch(EX_Branch),
				.EX_EXT(EX_EXT),.EX_GPR_Data_1(EX_GPR_Data_1),.EX_GPR_Data_2(EX_GPR_Data_2),
				.EX_Mem2R(EX_Mem2R),.EX_MemRead(EX_MemRead),.EX_MemWrite(EX_MemWrite),
				.EX_NPC(EX_NPC),.EX_RegDst(EX_RegDst),.EX_RegWrite(EX_RegWrite),
				.EX_jump(EX_jump),.EX_jump_add(EX_jump_add),
				.EX_rd(EX_rd),.EX_rs(EX_rs),.EX_rt(EX_rt),.EX_shamt(EX_shamt),.EX_jal(EX_jal),.EX_jr(EX_jr));
				
	//EX的旁路机制					
	EX_Forward U_EX_Forward(.EX_ForwardA(EX_ForwardA),.EX_ForwardB(EX_ForwardB),
							.EX_rs(EX_rs),.EX_rt(EX_rt),.MEM_WeSel(MEM_WeSel),.WB_WeSel(WB_Wesel),
							.MEM_RegWrite(MEM_RegWrite),.WB_RegWrite(WB_RegWrite));
							
	/*****/
	//不产生旁路，直接使用对应的寄存器内容
	//MEM->EX旁路，使用WB阶段要写入的信息
	//EX->EX旁路，使用MEM阶段指令上一周期的ALU结果
	mux3 #(32) U_mux3_EX_ForwardA(.d0(EX_GPR_Data_1),.d1(WB_GPR_input),.d2(MEM_Alu_Res),.s(EX_ForwardA),.y(EX_Alu_In1));
	mux3 #(32) U_mux3_EX_ForwardB(.d0(EX_GPR_Data_2),.d1(WB_GPR_input),.d2(MEM_Alu_Res),.s(EX_ForwardB),.y(EX_Alu_In2_alt));
	
	//如果Alusrc信号为1，第二个ALU操作数选择符号扩展值
	//计算存储器地址或立即数符号扩展
	assign 	EX_Alu_In2 = (EX_Alusrc==1)?EX_EXT:EX_Alu_In2_alt;
	
	
	//ALU操作
	Alu U_Alu(.AluResult(EX_Alu_Res),.Zero(EX_zero),.DataIn1(EX_Alu_In1),.DataIn2(EX_Alu_In2),.AluCtrl(EX_Aluctrl),.shamt(EX_shamt));
	
	//RegDst为0，写rt寄存器；RegDst为1，写rd寄存器
	assign 	EX_WeSel = (EX_jal==0?((EX_RegDst==0)?EX_rt:EX_rd):5'b11111);
	
	//计算跳转地址
	//已将跳转转移到ID级完成，不再需要该操作
	
	//assign Forward[1] = RegWrite_mem==0?0:(RegWriteAddr_mem==0?0:(RegWriteAddr_mem != RsAddr_ex?0:1));
	
	
	//EX_MEM流水线寄存器
	EXMEM U_EXMEM(.clk(Clk),.rst(Reset),.EXMEM_Write(EXMEM_Write),
				.EX_Branch(EX_Branch),.EX_BNE(EX_BNE),.EX_MemRead(EX_MemRead),
				.EX_MemWrite(EX_MemWrite),.EX_Mem2R(EX_Mem2R),.EX_RegWrite(EX_RegWrite),
				.EX_AluRes(EX_Alu_Res),.EX_GPR_Data_2(EX_GPR_Data_2),
				.EX_Wesel(EX_WeSel),.EX_rt(EX_rt),.EX_zero(EX_zero),.EX_NPC(EX_NPC),.EX_jal(EX_jal),
				.MEM_Branch(MEM_Branch),.MEM_BNE(MEM_BNE),.MEM_MemRead(MEM_MemRead),
				.MEM_MemWrite(MEM_MemWrite),.MEM_Mem2R(MEM_Mem2R),.MEM_RegWrite(MEM_RegWrite),
				.MEM_AluRes(MEM_Alu_Res),.MEM_GPR_Data_2(MEM_GPR_Data_2),
				.MEM_Wesel(MEM_WeSel),.MEM_rt(MEM_rt),.MEM_zero(MEM_zero),.MEM_NPC(MEM_NPC),.MEM_jal(MEM_jal));
	//MEM级
	
	//MEM级的旁路判断单元
	MEM_Forward U_MEM_Forward(.MEM_Forward(MEM_Forward),.MEM_rt(MEM_rt),.MEM_Alu_Res(MEM_Alu_Res),
									.WB_WeSel(WB_Wesel),.WB_RegWrite(WB_RegWrite),
									.WBIF_WeSel(WBIF_Wesel),.WBIF_RegWrite(WBIF_RegWrite),.WB_Memadd(WB_Memadd),.WB_Mem2R(WB_Mem2R),.WB_Alu_Res(WB_Alu_Res));
	
	//MEM级的旁路选择单元
	//0直接选择寄存器的第二个读出值
	//1与上一条指令存在旁路
	//2与上上条指令存在旁路
	mux3 #(32) U_mux3_MEM_Forward(.d0(MEM_GPR_Data_2),.d1(WBIF_GPR_input),.d2(WB_GPR_input),.s(MEM_Forward),.y(MEM_DataIn));
	
	//选择要写入的寄存器号
	assign MEM_Memadd = MEM_Alu_Res[7:0];
	//根据读写信号和数据读写存储器
	DMem U_Dmem(.DataOut(MEM_MemData1),.DataAdr(MEM_Memadd),.DataIn(MEM_DataIn),.DMemW(MEM_MemWrite),.DMemR(MEM_MemRead),.clk(Clk));
	//判断是否有sw-lw旁路
	//有则将上条sw的值旁路到MEM_MemData
	assign MEM_MemData = ((MEM_Mem2R==1)&& WB_MemWrite &&(MEM_Alu_Res==WB_Alu_Res))?WB_DataIn:MEM_MemData1;
	
	
	
	//MEM_WB流水线寄存器
	MEMWB U_MEMWB(.clk(Clk),.rst(Reset),.MEMWB_Write(MEMWB_Write),
				.MEM_AluRes(MEM_Alu_Res),.MEM_Mem2R(MEM_Mem2R),.MEM_MemData(MEM_MemData),
				.MEM_RegWrite(MEM_RegWrite),.MEM_Wesel(MEM_WeSel),.MEM_NPC(MEM_NPC),.MEM_jal(MEM_jal),.MEM_Memadd(MEM_Memadd),.MEM_MemWrite(MEM_MemWrite),.MEM_DataIn(MEM_DataIn),
				.WB_AluRes(WB_Alu_Res),.WB_Mem2R(WB_Mem2R),.WB_MemData(WB_MemData),
				.WB_RegWrite(WB_RegWrite),.WB_Wesel(WB_Wesel),.WB_NPC(WB_NPC),.WB_jal(WB_jal),.WB_Memadd(WB_Memadd),.WB_MemWrite(WB_MemWrite),.WB_DataIn(WB_DataIn));
	
	//MemtoReg为1的话就将存取指令加到GPR中
	//为0就把ALU运算结果写到GPR中
	//jal为1就把PC+4写到31位寄存器里
	assign WB_GPR_input = (WB_jal==1)? WB_NPC:((WB_Mem2R==1)?WB_MemData:WB_Alu_Res);
	
	
	
	//WB_IF流水线寄存器
	WBIF U_WBIF(.clk(Clk),.rst(Reset),
				.WB_RegWrite(WB_RegWrite),.WB_Wesel(WB_Wesel),.WB_GPR_input(WB_GPR_input),
				.WBIF_RegWrite(WBIF_RegWrite),.WBIF_Wesel(WBIF_Wesel),.WBIF_GPR_input(WBIF_GPR_input));
	
endmodule