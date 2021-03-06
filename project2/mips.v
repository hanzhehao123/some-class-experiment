module mips( clk, rst );
   input   clk;
   input   rst;
   
   //pc
   wire [31:0] PC_out;  
   wire        PCBra;
   
   
   //im
   wire [4:0]  imAdr;
   wire [31:0] opCode;
   wire [25:0] IMM;
   
   //ifid
   wire[63:0] IFID_in;
   wire[63:0] IFID_out;
   wire       rstIFID;
   wire       IFIDwr;
  ///////////////////////
   
   //RF
   wire [4:0] RegAddr1,RegAddr2,RegWAddr;
	 wire [31:0] RD1,RD2;
	 wire 		Zero;
	 //Extender

	wire [15:0] Imm16;
	wire [31:0] extDataOut;
	
	//IDEX
  wire        IDEXrst;
  wire  [1:0] Ctrl_WB; // regwr m2r
  wire  [1:0] Ctrl_M;  //memw memr  
   wire [1:0] IDEX_M;
   wire [1:0] IDEX_WB;
   wire [5:0] IDEX_ALUOp;
   wire       IDEX_Alusrc;
   wire       IDEX_RegDst_out;
   wire [31:0]IDEX_RD1out;
   wire [31:0]IDEX_RD2out;
   wire [4:0] IDEX_Rs;
   wire [4:0] IDEX_Rt;
   wire [4:0] IDEX_Rd;
   wire       IDEXWr;
   wire [31:0] IDEX_extout;
   
  //ALU
   wire [31:0] aluIn1;
  	wire [31:0] aluIn2;
	 wire [31:0]	aluOut;
	 
	
	//EXMEM
	 wire  EXMEM_M2R;
   wire  EXMEM_RegWr;
   wire  [31:0] EXMEM_aluout;
   wire  [31:0] MEMData;
   wire  [4:0]  EXMEM_Rd;
   wire  EXMEM_MemWr;
   wire  EXMEM_MemR;
   wire  [4:0] EXMEM_Rd_in;
   
	//DM
	 	wire [4:0]  dmDataAdr;
	  wire [31:0] dmDataOut;
	  
	//MEMWB
	 wire           MEMWB_M2R; 
	 wire           MEMWB_RegWr;
	 wire    [31:0] MEMData_out;
	 wire    [31:0] MEMWB_ALUOut_out;
	 wire    [4:0]  MEMWB_Rd;
	 wire    [31:0] MEMWBdataout;
  	
  	//ctrl
 	wire [5:0]		Op;
	wire [5:0]		Funct;
  wire  jump;						
	wire  RegDst;				
	wire  Branch;						
	wire  MemR;						
	wire  Mem2R;						
	wire  MemWr;			
	wire  DMWr;			
	wire  RFWr;						
	wire  Alusrc;				
	wire  [1:0] EXTOp;						
	wire  [4:0] ALUOp;	
	
	//forwarding
	wire  [1:0]ForwardA;
	wire  [1:0]ForwardB;
	wire  [1:0]BForwardA;
	wire  [1:0]BForwardB;
   


   
   //assign PC_in=((PCWr||jump)==1))?extDataOut:PC;
   
  // PC U_PC (
   //   .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(extDataOut), .PC(PCOut),.jump(jump),.IMM(IMM)
  // );
  
 PC U_PC( 
 .clk(clk), .rst(rst), .PCBra(PCBra), .PC(PC_out) ,.jump(jump),.IMM(IMM),.PCnew(extDataOut),.PCWr(PCWr)  ); 
   
//   wire   PC;  //in ifid
 //  assign PC4=PCout+4;
  assign PCBra = ((Branch&&Zero)==1)?1:0;
 //always @(posedge clk or posedge rst) begin
 // assign PCBra = ((Branch&&Zero)==1)?1:0;

 /* if(PCBra==1) assign PCSrc=01;
  else if(jump==1) assign PCSrc=10;
   else  assign PCSrc=00; */
 // assign PCSrc=(PCBra==1)?2'b01:((jump==1)?2'b10:2'b00);
  
//integer i;
//reg [31:0] temp;

//assign PC4=PCout+4;

                 //branch
/*always @(posedge clk or posedge rst) begin

          temp={extDataOut[31:2],2'b00};
          
          PCBranch=PCout+temp;
 //      end
       
          PCjump={PCout[31:28],IMM,2'b00};
 end
 */
/*mux4 #(32)  U_MUX4_PCSrc(                                             
        .d0(PC4), .d1(PCBranch), .d2(PCjump), .d3(0),
        .s(PCSrc[1:0]), .y(NPC));*/
        
        
//PC  U_PC( .clk(clk), .rst(rst), /*.PCSrc(PCSrc),*/ .PCout(PC_out) ,.NPC(NPC),.PCWr(PCWr));
   
   assign imAdr = PC_out[6:2];
   
   IM U_IM ( 
      .OpCode(opCode), .ImAdress(imAdr)
   );
   
   assign IFID_in[63:0]={PC_out[31:0],opCode[31:0]};
   
   //assign rstIFID=(PCWr||jump)?1:0;     //jump or branch? rstIFID 
   
   //********************************

   IFID U_IFID (
      .clk(clk), .rst(rst), .rstIFID(rstIFID), .IFIDWr(IFIDwr), .IFID_out(IFID_out), .IFID_in(IFID_in)
    );
   
   
   
   assign Op= IFID_out[31:26];
   assign Funct = IFID_out[5:0]; //for ctrl
   
   assign RegAddr1 = IFID_out[25:21];  //rs
   assign RegAddr2 = IFID_out[20:16];  //reg write data addr     beneth

   
   assign Imm16 = IFID_out[15:0];
   assign IMM = IFID_out[25:0];    //for jump
   

   wire rstEXMEM;
   
   Hazard U_Hazard ( .clk(clk),.IDEX_MemR(IDEX_M[0]),.IDEX_Rt(IDEX_Rt),.IFID_Rs(IFID_out[25:21]),
                     .IFID_Rt(IFID_out[20:16]),.Branch(Branch),.jump(jump),.Zero(Zero),
                     .IDEXWr(IDEXWr),.IFIDwr(IFIDwr),.rstIFID(rstIFID),.rstIDEX(IDEXrst),.PCWr(PCWr),.rstEXMEM(rstEXMEM));//,.EXMEM_MemR(EXMEM_MemR),.EXMEM_Rt(EXMEM_Rd)//allTwo_out),.StallTwo_in(StallTwo_in));
   
   
   
  Ctrl U_Ctrl(
        .jump(jump), .RegDst(RegDst), .Branch(Branch) , .MemR(MemR), .Mem2R(Mem2R), .MemW(DMWr),
        .RegW(RFWr), .Alusrc(Alusrc), .EXtOp(EXTOp), .ALUOp(ALUOp), .OpCode(Op), .Funct(Funct));
        
  
   assign Ctrl_WB={RFWr,Mem2R};
   assign Ctrl_M={DMWr,MemR};
	 
	 
   EXT U_EXT(
        .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(extDataOut)
   );
   
   
    RF U_RF (
      .A1(RegAddr1), .A2(RegAddr2), .A3(RegWAddr), .WD(MEMWBdataout), .clk(clk), 
      .RFWr(MEMWB_RegWr), .RD1(RD1), .RD2(RD2)
   );
   
   wire [31:0] RD1forB;
   wire [31:0] RD2forB;
   
   mux4 #(32)  U_MUX4_RFA(                                             //forwardA branch
        .d0(RD1), .d1(aluOut), .d2(MEMWBdataout), .d3(0),
        .s(BForwardA[1:0]), .y(RD1forB));
        
   mux4 #(32)  U_MUX4_RFB(                                             //forwardB branch
        .d0(RD2), .d1(aluOut), .d2(MEMWBdataout), .d3(0),
 //.d0(RD2), .d1(aluOut), .d2(aluOut), .d3(0),
        .s(BForwardB[1:0]), .y(RD2forB));
      
   assign Zero=(RD1forB==RD2forB)?1:0;    // for branch
   
			
	
   IDEX U_IDEX (
          .clk(clk), .rst(rst), .IDEXrst(IDEXrst), .IDEXWr(IDEXWr), .Ctrl_WB(Ctrl_WB), .Ctrl_M(Ctrl_M), 
          .EXT_in(extDataOut),.IFID_Rs(IFID_out[25:21]) , .IFID_Rt(IFID_out[20:16]) , .IFID_Rd(IFID_out[15:11]), 
           .ALUOp_in(ALUOp),.Alusrc_in(Alusrc),.RegDst_in(RegDst),.RD1_in(RD1),.RD2_in(RD2), //in
           .IDEX_WB(IDEX_WB),.IDEX_M(IDEX_M),.ALUOp_out(IDEX_ALUOp),.Alusrc_out(IDEX_Alusrc),.RegDst_out(IDEX_RegDst_out),
           .IDEX_RD1out(IDEX_RD1out),.IDEX_RD2out(IDEX_RD2out),.EXT_out(IDEX_extout),.IDEX_Rs(IDEX_Rs),.IDEX_Rt(IDEX_Rt),.IDEX_Rd(IDEX_Rd)
           ) ;
               
 
  //  assign aluIn2 = (IDEX_Alusrc==1)?IDEX_extout:IDEX_RD2out;             //  r/branch alusrc=0
    //***********WITHOUT FORWARD!!! ******************
    //assign aluIn1 = IDEX_RD1 ???;
    
    mux4 #(32)  U_MUX4_ALUA(                                             //forwardA
        .d0(IDEX_RD1out), .d1(MEMWBdataout), .d2(EXMEM_aluout), .d3(0),
        .s(ForwardA[1:0]), .y(aluIn1));
        
    wire [31:0]TempAluin2;                                               //temp for alusrc in   ?????rd2 
    
    mux4 #(32)  U_MUX4_ALUB(                                             //forwardB
        .d0(IDEX_RD2out), .d1(MEMWBdataout), .d2(EXMEM_aluout), .d3(0),
        .s(ForwardB[1:0]), .y(TempAluin2));
        
    assign aluIn2 = (IDEX_Alusrc==1)?IDEX_extout:TempAluin2;            //
        
   alu U_alu(
        .A(aluIn1), .B(aluIn2), .ALUOp(IDEX_ALUOp), .C(aluOut)
   );
   
  assign EXMEM_Rd_in = (IDEX_RegDst_out==1)?IDEX_Rd:IDEX_Rt;    //r 1 or i 0?
  
  
  
  
     
   
   
   
   EXMEM U_EXMEM (
                .clk(clk), /*EXMEMrst, /*IDEXWr*/ .IDEX_WB(IDEX_WB), .IDEX_M(IDEX_M), .EXMEM_Rd_in(EXMEM_Rd_in) , 
                .ALUOut(aluOut), .RD2_in(TempAluin2),.rstEXMEM(rstEXMEM),
                .EXMEM_M2R(EXMEM_M2R),.EXMEM_RegWr(EXMEM_RegWr),.EXMEM_aluout(EXMEM_aluout), .MEMData(MEMData),
                .EXMEM_Rd(EXMEM_Rd),.MemWr(EXMEM_MemWr),.MemR(EXMEM_MemR)
                );
           
  assign dmDataAdr = EXMEM_aluout[6:2];

   
   dm_4k  U_DM( 
        .addr(dmDataAdr), .din(MEMData), .DMWr(EXMEM_MemWr), .clk(clk), .dout(dmDataOut) ,.MemR(EXMEM_MemR)
   );
   

   MEMWB U_MEMWB(
        .clk(clk),.rst(rst), .EXMEM_M2R(EXMEM_M2R), .EXMEM_RegWr(EXMEM_RegWr), .MEMData_in(dmDataOut),
        .ALUOut_in(EXMEM_aluout), .EXMEM_Rd(EXMEM_Rd),
        .M2R(MEMWB_M2R), .RegWr(MEMWB_RegWr),.MEMData_out(MEMData_out),.ALUOut_out(MEMWB_ALUOut_out),.MEMWB_Rd(MEMWB_Rd));
   
   assign MEMWBdataout=(MEMWB_M2R==1)?MEMData_out:MEMWB_ALUOut_out;
  // assign wd = (MEMWB_M2R==1)?MEMData_out:MEMWB_ALUOut_out;                //lw m2r=1
   assign RegWAddr=MEMWB_Rd;
   
   Forwarding U_Forwarding(
        .EXMEM_Rd(EXMEM_Rd),.MEMWB_Rd(MEMWB_Rd),.IDEX_Rs(IDEX_Rs),.IDEX_Rt(IDEX_Rt),
        .MEMWB_RegWr(MEMWB_RegWr),.EXMEM_RegWr(EXMEM_RegWr),.EXMEM_MemWr(EXMEM_MemWr),.Branch(Branch),.clk(clk),
        .ForwardA(ForwardA),.ForwardB(ForwardB),.BForwardA(BForwardA),.BForwardB(BForwardB)
                           );
                           
  
  

endmodule