`include "ctrl_encode_def.v"
`include "instruction_def.v"

module Ctrl(jump,RegDst,Branch,MemR,Mem2R,MemW,RegW,Alusrc,EXtOp,ALUOp,OpCode,Funct);
	
	input [5:0]		OpCode;				
	input [5:0]		Funct;				

	output  jump;						//
	output  RegDst;				//		
	output  Branch;						
	output  MemR;						
	output  Mem2R;						
	output  MemW;						
	output  RegW;						
	output  Alusrc;				
	output  [1:0]EXtOp;						
	output  [4:0] ALUOp;			
	
	//rstIFID

	
	reg  jump;						
	reg  RegDst;				
	reg  Branch;						
	reg  MemR;						
	reg  Mem2R;						
	reg  MemW;						
	reg  RegW;						
	reg  Alusrc;				
	reg  [1:0] EXtOp;						
	reg  [4:0] ALUOp;		

	

	
	always @(OpCode or Funct)
	 begin
	case(OpCode)
	  `INSTR_RTYPE_OP : //R type 000000
	  begin
	    assign Branch=0;
	    assign Mem2R=0;
	    assign MemW=1'b0;
	    assign MemR=1'b0;
	    assign Alusrc=0;
	    assign EXtOp=`EXT_ZERO;
	    assign RegDst=1;
	    //assign RegDstb=1;
		  assign jump=0;

	   case(Funct)
	     6'b100001: //ADDU
	       begin
	         assign    RegW=1'b1;
	         assign    ALUOp=`ALUOp_ADDU;
	       end
	     6'b100011: //SUBU
	       begin
	         assign    RegW=1'b1;
	         assign    ALUOp=`ALUOp_SUBU;
	        end
	      default: ;
	      endcase
		end
	   
	     `INSTR_ORI_OP :
	      begin
			assign     Branch=0;
			assign	   Mem2R=0;
			assign	   MemW=1'b0;
			assign	   MemR=1'b0;
			assign	   Alusrc=1;
			assign	   EXtOp=`EXT_ZERO;
			assign	   RegDst=0;
			//assign    RegDstb=1;
			assign	   RegW=1'b1;
			assign     ALUOp=`ALUOp_OR;
			assign 	   jump=0;

		   
	      end

		`INSTR_LW_OP :
		begin
			assign     Branch=0;
			assign	   Mem2R=1;
			assign	   MemW=1'b0;
			assign	   MemR=1'b1;
			assign	   Alusrc=1;
			assign	   EXtOp=`EXT_SIGNED;
			assign	   RegDst=0;
			//assign    RegDstb=1;
			assign	   RegW=1'b1;
			assign     ALUOp=`ALUOp_ADD;
			assign     jump=0;

		   
	      end
		  
		 `INSTR_SW_OP :
		 begin
			assign    Branch=0;
			assign	   MemW=1'b1;
			assign	   MemR=1'b0;
			assign	   Alusrc=1;
			assign	   EXtOp=`EXT_SIGNED;
			assign	   RegDst=0;
			//assign    RegDstb=1;
			assign	   RegW=1'b0;
			assign     ALUOp=`ALUOp_ADD;
			assign     jump=0;

		   
	      end
		  
		 `INSTR_BEQ_OP :
		 begin
			assign Branch=1;
			assign Mem2R=0;
			assign MemW=1'b0;
			assign MemR=1'b0;
			assign Alusrc=0;
			assign EXtOp=`EXT_ZERO;
			assign RegDst=0;
			assign	RegW=1'b0;
			//assign RegDstb=1;
			assign jump=0;
			assign ALUOp=`ALUOp_SUBU;
	
		end
		
		`INSTR_J_OP:
		begin
			assign Branch=0;
			assign Mem2R=0;
			assign MemW=1'b0;
			assign MemR=1'b0;
			assign jump=1;
			end
			
	  `INSTR_LUI_OP :
	  	      begin
			assign    Branch=0;
			assign	   Mem2R=0;
			assign	   MemW=1'b0;
			assign	   MemR=1'b0;
			assign	   Alusrc=1;
			assign	   EXtOp=`EXT_HIGHPOS;
			assign    RegDst=0;
			assign	   RegW=1'b1;
			assign    ALUOp=`ALUOp_OR; 
			assign 	   jump=0;

		   
	      end

	
		
		 default: ;
	endcase
	end
endmodule