module IDEX (clk, rst,IDEXrst, IDEXWr, Ctrl_WB, Ctrl_M, EXT_in,IFID_Rs , IFID_Rt , IFID_Rd, 
           ALUOp_in,Alusrc_in,RegDst_in,RD1_in,RD2_in, //in
           IDEX_WB,IDEX_M,ALUOp_out,Alusrc_out,RegDst_out,
           IDEX_RD1out,IDEX_RD2out,EXT_out,IDEX_Rs,IDEX_Rt,IDEX_Rd);//out
               
   input         clk;
   input         rst;
   input         IDEXrst;
   input         IDEXWr; 
   
   input  [1:0] Ctrl_WB; // regwr m2r
   input  [1:0] Ctrl_M;  //memw memr
   //IDEX_WB,IDEX_M,ALUop,Alusrc,RegDst
   
   input  [31:0]EXT_in; //ext out
   input  [4:0] IFID_Rs;
   input  [4:0] IFID_Rt;
   input  [4:0] IFID_Rd;
   input  [4:0] ALUOp_in;
   input        Alusrc_in;
   input        RegDst_in;
   
   input  [31:0] RD1_in;
   input  [31:0] RD2_in;
   
   
   output  [1:0] IDEX_M;
   output [1:0] IDEX_WB;
   output [4:0] ALUOp_out;
   output       Alusrc_out;
   output       RegDst_out;
   output [31:0]IDEX_RD1out;
   output [31:0]IDEX_RD2out;
   output [4:0] IDEX_Rs;
   output [4:0] IDEX_Rt;
   output [31:0]EXT_out;
   output [4:0] IDEX_Rd;
               

   
  // reg[31:0]IDEX_RD1out;
  // reg[31:0]IDEX_RD2out;
  
  
   reg [1:0] IDEX_M;
   reg [1:0] IDEX_WB;
   reg [5:0] ALUOp_out;
   reg       Alusrc_out;
   reg       RegDst_out;
   reg [31:0]IDEX_RD1out;
   reg [31:0]IDEX_RD2out;
   reg [4:0] IDEX_Rs;
   reg [4:0] IDEX_Rt;
   reg [4:0] IDEX_Rd;
   reg [31:0] EXT_out;
               
   always @(posedge clk or posedge rst) begin
      if ( rst) begin
   IDEX_M<=2'b00;
   IDEX_WB<=2'b00;
   ALUOp_out<=6'b000000;
   Alusrc_out<=0;
   RegDst_out<=0;   
   IDEX_RD1out<=32'b00000000000000000000000000000000;
   IDEX_RD2out<=32'b00000000000000000000000000000000;
   IDEX_Rs<=5'b00000;
   IDEX_Rt<=5'b00000;
   IDEX_Rd<=5'b00000; 
   EXT_out<=0;
   end
   
   
    if (IDEXWr) 
    begin
   IDEX_M<=Ctrl_M;
   IDEX_WB<=Ctrl_WB;
   ALUOp_out<=ALUOp_in;
   Alusrc_out<=Alusrc_in;
   RegDst_out<=RegDst_in;
   IDEX_RD1out<=RD1_in;  
   IDEX_RD2out<=RD2_in;
   IDEX_Rs<=IFID_Rs; 
   IDEX_Rt<=IFID_Rt;
   IDEX_Rd<=IFID_Rd; 
   EXT_out<=EXT_in;
   end  //END ELSE
   
     if(IDEXrst) begin 
    //   IDEX_M[1]=0;
      // IDEX_WB[1]=0;
        IDEX_M<=2'b00;
        IDEX_WB<=2'b00;
        ALUOp_out<=6'b000000;
        Alusrc_out<=0;
        RegDst_out<=0;  
  end
      
  /* if (IDEXWr) 
    begin
   IDEX_M<=Ctrl_M;
   IDEX_WB<=Ctrl_WB;
   ALUOp_out<=ALUOp_in;
   Alusrc_out<=Alusrc_in;
   RegDst_out<=RegDst_in;
   IDEX_RD1out<=RD1_in;  
   IDEX_RD2out<=RD2_in;
   IDEX_Rs<=IFID_Rs; 
   IDEX_Rt<=IFID_Rt;
   IDEX_Rd<=IFID_Rd; 
   EXT_out<=EXT_in;
   end  //END ELSE
   */
        
   end // end always
      
endmodule

