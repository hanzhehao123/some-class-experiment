module PC( clk, rst, PCBra, PC ,jump,IMM,PCnew,PCWr);
           
   input         clk;
   input         rst;
   input         PCBra;
   input         PCWr;
 //  input  [31:0] NPC;
   input  [25:0] IMM;
   input         jump;
   input  [31:0] PCnew;
 //  input         StallTwo;
   output [31:0] PC;
   
   reg [31:0] PC;

   
   integer i;
   reg [31:0] temp;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         PC <= 32'h0000_3000;   
  if(PCWr) begin       
    
      PC=PC+4;
      
      if ( PCBra ) 
        //branch
        begin
          for(i=0;i<30;i=i+1)
            temp[31-i]=PCnew[29-i];
          temp[0]=0;
          temp[1]=0;
          
          PC=PC+temp;
       end
       
      if(jump)    //jump
         begin
           PC={PCnew[31:28],IMM,2'b00};
        end
    end
    
//  if(StallTwo==1) begin
//    PC=PC-4;
 //   StallTwo=0;
  // end // end always
 end
           
endmodule

/*
module PC( clk, rst, PCout ,NPC,PCWr);
           
   input         clk;
   input         rst;

   input         PCWr;
  // input    [1:0]PCSrc;
   input  [31:0] NPC;
   //input  [25:0] IMM;
   //input         jump;
   output reg  [31:0] PCout;
 //  output [31:0] PC;

always @(posedge clk or posedge rst) begin
      if ( rst ) 
         PCout <= 32'h0000_3000;   
      if(PCWr)     
        PCout<=NPC;
      end
    endmodule*/