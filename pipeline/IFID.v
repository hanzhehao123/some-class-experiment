module IFID (clk,rst,IFID_Write,
			IF_pcSel,IF_opcode,IF_NPC,
			ID_pcSel,ID_opcode,ID_NPC);
               
	input  clk;
	input  rst;
	input  IFID_Write;

	input  [1:0] IF_pcSel;
	input  [31:0] IF_opcode;
	input  [31:0] IF_NPC;

	output reg [1:0] ID_pcSel;
	output reg [31:0] ID_opcode;
	output reg [31:0] ID_NPC;
			   
	always@(posedge clk or posedge rst) 
	begin
		if(rst)
		begin
			ID_opcode=0;
			ID_NPC=0;
			ID_pcSel=0;
		end
		else if(IFID_Write)
		begin
			ID_opcode=IF_opcode;
			ID_NPC=IF_NPC;
			ID_pcSel=IF_pcSel;
		end
	end // end always
      
endmodule
