`include "instruction_def.v"
`include "ctrl_encode_def.v"

module Alu(shamt,AluResult,Zero,DataIn1,DataIn2,AluCtrl);

	input  [31:0] 		DataIn1;
	input  [31:0]		DataIn2;
	input  [4:0]		AluCtrl;
	input  [4:0]  		shamt;
	
	output reg[31:0]		AluResult;
	output reg				Zero;
	
	integer i;
	
	initial
	begin
		Zero = 0;
		AluResult = 0;
	end	
	
	always@(DataIn1 or DataIn2 or AluCtrl or shamt)
	begin
	
		case ( AluCtrl )
			`ALUOp_ADD  : AluResult = $signed(DataIn1) + $signed(DataIn2);
			`ALUOp_ADDU : AluResult = DataIn1 + DataIn2;
			`ALUOp_SUB  : AluResult = $signed(DataIn1) - $signed(DataIn2);
			`ALUOp_SUBU : AluResult = DataIn1 - DataIn2;
			`ALUOp_AND : AluResult = DataIn1 & DataIn2;
			`ALUOp_OR   : AluResult = DataIn1 | DataIn2;
			`ALUOp_NOR	: AluResult = ~(DataIn1 | DataIn2);
			`ALUOp_XOR  : AluResult = DataIn1 ^ DataIn2;
			`ALUOp_SLT  : AluResult = ($signed(DataIn1) < $signed(DataIn2)) ? 1 : 0;
			`ALUOp_SLTU : AluResult = (DataIn1 < DataIn2) ? 1 : 0;
			`ALUOp_BEQ : AluResult = (DataIn1 == DataIn2);
			`ALUOp_BNE : AluResult = (DataIn1 != DataIn2);
			`ALUOp_SLL : AluResult = DataIn2 << shamt;
			`ALUOp_SRL : AluResult = DataIn2 >>	shamt;
			default: ;
		endcase
	
	
		Zero=(DataIn1==DataIn2)? 1:0;
	end

endmodule