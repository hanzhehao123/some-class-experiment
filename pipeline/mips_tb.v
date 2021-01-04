 module Mips_tb();
    
   reg clk, rst;
    
   Mips U_mips(.Clk(clk),.Reset(rst)); 
    
   initial begin
      $readmemh( "code.txt" , U_mips.U_IM.IMem ) ;  
      $monitor("PC = 0x%8X, ID_opCode = 0x%8X, Bubble = %X", U_mips.U_pcUnit.PC, U_mips.ID_opCode, U_mips.Bubble );      
      clk = 1 ;
      rst = 0 ;
      #5 rst = 1 ;
      #20 rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule
