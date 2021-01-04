module MEMWB (clk,rst, EXMEM_M2R, EXMEM_RegWr, MEMData_in,ALUOut_in,EXMEM_Rd,
              M2R, RegWr,MEMData_out,ALUOut_out,MEMWB_Rd);
               
   input         clk;
   input         rst;
   
   input         EXMEM_M2R;
   input         EXMEM_RegWr; 
   input  [31:0] MEMData_in;
   input  [31:0] ALUOut_in;
   input  [4:0]  EXMEM_Rd;
   
   output        M2R;
   output        RegWr;
   output [31:0] MEMData_out;
   output [31:0] ALUOut_out;
   output [4:0]  MEMWB_Rd;
      
   reg       M2R;
   reg [31:0] MEMData_out;
   reg [31:0] ALUOut_out;
   reg [4:0]  MEMWB_Rd;
   reg       RegWr;
 

               
   always @(posedge clk or posedge rst) begin
      if ( rst ) begin
           M2R<=0;
           MEMData_out<=0;
           ALUOut_out<=0;
           MEMWB_Rd<=0;
           RegWr<=0;     end
      else    begin
           M2R<=EXMEM_M2R;
           RegWr<=EXMEM_RegWr;
           MEMData_out<=MEMData_in;
           ALUOut_out<=ALUOut_in;
           MEMWB_Rd<=EXMEM_Rd;             end
   end // end always
      
endmodule

