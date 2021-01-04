module light(clk100khz,light);
	input clk100khz;
	output [7:0] light;
	parameter len=7;
	
	reg [7:0] light;
	reg [25:0] count, count1;
	reg clk,clk1,clk2,b;
	reg [1:0] flag;
	
	initial b=1'b1;
	
	always@(posedge clk100khz) //·ÖÆµ1hz
		begin
		 if(count=='d49999)
			begin clk1=~clk1; count <= 0; end
		else 
			begin count <= count+1'b1; end
		end
		
	always@(posedge clk100khz) //·ÖÆµ10hz
		begin
		 if(count1=='d4999)
			begin clk2=~clk2; count1 <= 0; end
		else 
			begin count1 <= count1+1'b1; end
		end		
		
	always@(posedge clk100khz) //
		begin
		 if(b)
			clk<=clk1;
		 else 
			clk<=clk2;
		end		
		
	always@(posedge clk)
	begin
		if(flag==2'b00)
			begin
				light<=8'b11111111;
				if(light==8'b11111111)
					begin
					light<=8'b00000000;
					flag<=2'b01;
					end
			end
			
	else if(flag==2'b01)
			begin
			if(light==8'b00000000)
				begin light<=8'b10000000; end
			else light<={1'b0,light[len:1]};
			if(light[1]==1)
			    flag<=2'b10;
			end
		
	else if(flag==2'b10)
			begin
			 light<=8'b10101010;
			 if(light[1]==1)
				begin
					light<=8'b01010101;
					flag<=2'b11;
				end
			end
			
	else if(flag==2'b11)
			begin
			 flag<=2'b00;
			 b=~b;
			end
			
	end
endmodule
	
	
/*else if(flag==3'b100)
			begin
			 light[len:4]<={1'b1,light[len:5]};
			 light[len-4:0]<={1'b1,light[len-4:1]};
			 if(light[1]==1)
				flag<=3'b101;
			end
			
	else if(flag==3'b101)
			begin
			 light<=8'b00000000;
			 flag<=3'b110;
			end
			
	else if(flag==3'b110)
			begin
			flag<=3'b000;
			b=~b;
			end*/		