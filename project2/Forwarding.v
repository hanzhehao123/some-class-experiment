module Forwarding(EXMEM_Rd,MEMWB_Rd,IDEX_Rs,IDEX_Rt,MEMWB_RegWr,EXMEM_RegWr,EXMEM_MemWr,Branch,clk,
                  ForwardA,ForwardB,BForwardA,BForwardB);
input   [4:0]EXMEM_Rd;
input   [4:0]MEMWB_Rd;
input   [4:0]IDEX_Rs;
input   [4:0]IDEX_Rt;
input        MEMWB_RegWr;
input        EXMEM_RegWr;
input        EXMEM_MemWr;
input        Branch;
input        clk;
                  
output  [1:0] ForwardA;
output  [1:0] ForwardB;
output  [1:0] BForwardA;
output  [1:0] BForwardB;

reg  [1:0] ForwardA;
reg  [1:0] ForwardB;
reg  [1:0] BForwardA;
reg  [1:0] BForwardB;

always@(*) begin

if(EXMEM_RegWr             //ex??  aluout=>rs  
  && (EXMEM_Rd != 0)
  && (EXMEM_Rd==IDEX_Rs))//
  assign ForwardA=2'b10;

  else if(MEMWB_RegWr                //memout->rs
  && (EXMEM_Rd != 0)
  && (MEMWB_Rd==IDEX_Rs))
   assign ForwardA=2'b01;
   
       else assign ForwardA=2'b00;

 if(EXMEM_RegWr              //aluout=>rd
  && (EXMEM_Rd != 0)
  && (EXMEM_Rd==IDEX_Rt))
assign ForwardB=2'b10;
      
        else if(MEMWB_RegWr                 //memout->rd
  && (EXMEM_Rd != 0)
  && (MEMWB_Rd==IDEX_Rt))
assign ForwardB=2'b01;
          else assign ForwardB=2'b00;

//**********BRANCH

if(Branch             //ex??  aluout=>rs  
  && (EXMEM_Rd != 0)
  && (EXMEM_Rd==IDEX_Rs))
assign BForwardA=2'b10;

  else if(Branch                 //memout->rs
  && (MEMWB_Rd==IDEX_Rs))
assign BForwardA=2'b01;
  else assign BForwardA=2'b00;
    
if(Branch               //aluout=>rd
  && (EXMEM_Rd != 0)
  && (EXMEM_Rd==IDEX_Rt))
assign BForwardB=2'b10;

  else if(Branch                  //memout->rd
  && (MEMWB_Rd==IDEX_Rt))
assign BForwardB=2'b01;
  else assign BForwardB=2'b00;

end
endmodule