module EXMEM (clk, rst,/*EXMEMrst, /*IDEXWr*/ IDEX_WB, IDEX_M, EXMEM_Rd_in , ALUOut,RD2_in,
           EXMEM_M2R,EXMEM_RegWr,EXMEM_aluout,MEMData,EXMEM_Rd,MemWr,MemR,rstEXMEM);//out
               
   input         clk;
   input         rst;
   input         rstEXMEM;
   //input         EXMEMrst;
   //input         IDEXWr; 
   
   input  [1:0] IDEX_WB; // regwr 1 m2r 0
   input  [1:0] IDEX_M;  //memw1 memr 0
   //IDEX_WB,IDEX_M,ALUop,Alusrc,RegDst
   
   input  [31:0] ALUOut; //ext o
   input  [4:0] EXMEM_Rd_in;
   input  [31:0] RD2_in;
   
   output  EXMEM_M2R;
   output  EXMEM_RegWr;
   output  [31:0] EXMEM_aluout;
   output  [31:0] MEMData;
   output  [4:0]  EXMEM_Rd;
   output  MemWr;
   output  MemR;
   
   
   
  // reg[31:0]IDEX_RD1out;
  // reg[31:0]IDEX_RD2out;
  
   reg  EXMEM_M2R;
   reg  EXMEM_RegWr;
   reg  [31:0] EXMEM_aluout;
   reg  [31:0] MEMData;
   reg  [4:0]  EXMEM_Rd;
   reg  MemWr;
   reg  MemR;
   
   always @(posedge clk or posedge rst) begin
      if ( rst /*|| rstEXMEM*/) begin
     EXMEM_M2R<=0;
     EXMEM_RegWr<=0;
     EXMEM_aluout<=0;
     MEMData<=0;
     EXMEM_Rd<=0;
     MemWr<=0;
     MemR<=0;   end
     
     if(rstEXMEM) begin
            MemWr<=0;
                EXMEM_RegWr<=0; 
                    EXMEM_M2R<=IDEX_WB[0];
     //EXMEM_RegWr<=IDEX_WB[1];
     EXMEM_aluout<=ALUOut;
     MEMData<=RD2_in;
     EXMEM_Rd<=EXMEM_Rd_in;
     //MemWr<=IDEX_M[1];
     MemR<=IDEX_M[0];
                end
    else
      begin
        
     EXMEM_M2R<=IDEX_WB[0];
     EXMEM_RegWr<=IDEX_WB[1];
     EXMEM_aluout<=ALUOut;
     MEMData<=RD2_in;
     EXMEM_Rd<=EXMEM_Rd_in;
     MemWr<=IDEX_M[1];
     MemR<=IDEX_M[0];
   end
  

   end // end always
      
endmodule

