module Hazard ( clk,IDEX_MemR,IDEX_Rt,IFID_Rs,IFID_Rt,Branch,jump,Zero,
                IDEXWr,IFIDwr,rstIFID,rstIDEX,PCWr,rstEXMEM);//,EXMEM_MemR,EXMEM_Rt);//StallTwo_out,StallTwo_in);
input clk;
input IDEX_MemR;
input [4:0]IDEX_Rt;
input [4:0]IFID_Rs;
input [4:0]IFID_Rt;
input      Branch;
input      jump;
input      Zero;
//input      EXMEM_MemR;
//input      EXMEM_Rt;
//input      StallTwo_in;

output IDEXWr;
output IFIDwr;
output rstIFID;
output rstIDEX;
output PCWr;
output rstEXMEM;
//output StallTwo;

//integer StallTwo=0;
//initial begin StallTwo=0;
//end

reg IDEXWr;
reg IFIDwr;
reg rstIFID;
reg rstIDEX;
reg PCWr;
reg rstEXMEM;

always@(*) begin


  if(Branch)  begin
    if(IDEX_MemR&&((IDEX_Rt==IFID_Rs)||(IDEX_Rt==IFID_Rt)))  begin   //stall twice
      assign IFIDwr=0;
      //assign IDEXWr=0;
      assign IDEXWr=0;
      assign PCWr=0;      
      assign rstIDEX=0;    //
      assign rstIFID=0;  
      assign rstEXMEM=1;
     //StallTwo=StallTwo+1;
      end
 /*   if(EXMEM_MemR&&((EXMEM_Rt==IFID_Rs)||(EXMEM_Rt==IFID_Rt))) begin
      assign IFIDwr=0;
      assign IDEXWr=0;
      assign PCWr=0;      
      assign rstIDEX=1;    
      assign rstIFID=0;*/
  //    assign #(50) PCWr= 0;
    //  assign StallTwo=1;
              //end
   if(Zero) begin
      assign rstIFID=1;
      assign PCWr=1;
      assign IFIDwr=1; //
      assign IDEXWr=1;     
      assign rstIDEX=0;
      assign rstEXMEM=0; end
  //    assign StallTwo=0;
    if((Zero!=1)&&(IDEX_MemR&&((IDEX_Rt==IFID_Rs)||(IDEX_Rt==IFID_Rt))==1))
      begin
       assign   rstIFID=0;//
      assign   PCWr=1;
      assign   IDEXWr=1;
      assign   IFIDwr=1;
      assign   rstIDEX=0; 
      assign   rstEXMEM=0;
      assign   StallTwo=0;
       end
         end //????


                              
 /*if(StallTwo==1)  begin
      assign PCWr=0;
      assign IFIDwr=0;
      assign IDEXWr=0;
      assign StallTwo=0; end*/
                      

    
 if(!Branch)
        if(!jump)
          if(IDEX_MemR&&((IDEX_Rt==IFID_Rs)||(IDEX_Rt==IFID_Rt)))  begin           //stall the pipe
            assign PCWr=0;
            assign IFIDwr=0;
            assign rstIDEX=1;   
            assign rstIFID=0;
            assign IDEXWr=0;   //********
            assign rstEXMEM=0;
  //                assign StallTwo=0;
                                  end
         else
           begin
            assign   PCWr=1;
            assign   IDEXWr=1;
            assign   IFIDwr=1;
            assign   rstIFID=0;
            assign   rstIDEX=0;
                  assign rstEXMEM=0;
//                  assign StallTwo=0;
             end
      
      else       begin              //jump
      assign   rstIFID=1;//
      assign   PCWr=1;
      assign   IDEXWr=1;
      assign   IFIDwr=1;
      assign   rstIDEX=0; 
      assign   rstEXMEM=0;
//            assign StallTwo=0;  
end


end
endmodule
      