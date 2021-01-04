
module IFID (clk, rst, rstIFID, IFIDWr, IFID_out, IFID_in);
               
   input         clk;
   input         rst;
   input         rstIFID;
   input         IFIDWr; 
   input  [63:0] IFID_in;

   output [63:0] IFID_out;
   
   reg [63:0] IFID_out;
               
   always @(posedge clk or posedge rst) begin
      if ( rst || rstIFID) 
         IFID_out <= 0;
    else if (IFIDWr)
         IFID_out <= IFID_in;
   end // end always
      
endmodule
