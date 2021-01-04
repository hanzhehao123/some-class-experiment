`include "instruction_def.v"
`include "ctrl_encode_def.v"

module Ctrl(jump,RegDst,Branch,MemR,Mem2R,MemW,RegW,Alusrc,ExtOp,Aluctrl,BNE,
			OpCode,funct,jal,jr);
	
	input [5:0]		OpCode;
	input [5:0]		funct;

	output reg BNE;//判断是否为bne信号
	output reg jump;
	output reg RegDst;//0为rt,1为rd					
	output reg Branch;
	output reg MemR;
	output reg Mem2R;
	output reg MemW;
	output reg RegW;
	output reg Alusrc;
	output reg jal;
	output reg jr;
	output reg[1:0] ExtOp;
	output reg[4:0] Aluctrl;
	
always@(OpCode or funct)
	begin
		BNE = 0;
		
		case (OpCode)
		`	INSTR_RTYPE_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				
				Alusrc = 0;
				jal = 0;
				
				ExtOp = `EXT_ZERO;
				case (funct)
					`INSTR_ADD_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_ADD;end
					`INSTR_ADDU_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_ADDU;end
					`INSTR_SUB_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_SUB;end
					`INSTR_SUBU_FUNCT : begin RegW = 1; jr = 0;Aluctrl = `ALUOp_SUBU;end
					`INSTR_AND_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_AND;end
					`INSTR_OR_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_OR;end
					`INSTR_NOR_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_NOR;end
					`INSTR_XOR_FUNCT : begin RegW = 1;jr = 0;Aluctrl = `ALUOp_XOR;end
					`INSTR_SLT_FUNCT :begin RegW = 1;jr = 0; Aluctrl = `ALUOp_SLT;end
					`INSTR_SLTU_FUNCT :begin RegW = 1; jr = 0; Aluctrl = `ALUOp_SLTU;end
					`INSTR_SLL_FUNCT :begin RegW = 1;jr = 0; Aluctrl = `ALUOp_SLL;end
					`INSTR_SRL_FUNCT :begin RegW = 1;jr = 0; Aluctrl = `ALUOp_SRL;end
					`INSTR_JR_FUNCT: begin RegW = 0;jr = 1;Aluctrl = `ALUOp_ADD;end
					default: ;
				endcase
			end
			`INSTR_J_OP:
			begin
				jal = 0;
				jr = 0;
				jump = 1;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 0;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_JAL_OP:
			begin
				jal = 1;
				jr = 0;
				jump = 1;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			
			`INSTR_LUI_OP :
			begin
				jal = 0;
				jr = 0;
				jump = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_HIGHPOS;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_BNE_OP:
			begin
				jump = 0;
				jr = 0;
				jal = 0;
				RegDst = 0;
				Branch = 0;
				BNE = 1;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 0;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_BEQ_OP:
			begin
				jump = 0;
				jr = 0;
				jal = 0;
				RegDst = 0;
				Branch = 1;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 0;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_SW_OP:
			begin
				jump = 0;
				jal = 0;
				jr = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 1;
				RegW = 0;
				Alusrc = 1;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_LW_OP:
			begin
				jump = 0;
				jr = 0;
				jal = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 1;
				Mem2R = 1;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_ADDI_OP:
			begin
				jump = 0;
				jr = 0;
				jal = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_ORI_OP:
			begin
				jump = 0;
				jr = 0;
				jal = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_OR;
			end
			default: ;
		endcase
	end
endmodule