`include "ctrl_encode_def.v"
module Extender(ExtOut,DataIn,ExtOp);

	input [15:0] DataIn;
	input ExtOp;
	output reg[31:0] ExtOut;
	
	integer i;					//逻辑计数
	
	always@(DataIn or ExtOp)
	begin
	  
	  case (ExtOp)
         2'b00: ExtOut = {16'd0, DataIn};
         2'b01: ExtOut = {{16{DataIn[15]}}, DataIn};
         2'b10: ExtOut = {DataIn, 16'd0};
         default: ;
      endcase
		/*if(ExtOp == 1)
			begin
				for(i=0;i<32;i=i+1)
				begin
					if(i<16)
						ExtOut[i] = DataIn[i];
					else
						ExtOut[i] = 0;
				end	
			end
		else
			begin
				for(i=0;i<32;i=i+1)
				begin
					if(i<16)
						ExtOut[i] = DataIn[i];
					else
						ExtOut[i] = DataIn[15];
				end
			end*/
	end
endmodule