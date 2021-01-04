module qiangda(clr,clk1hz,clk100khz,input1,input2,input3,input4,dout,scan,LED,reset);

input clr,clk1hz,clk100khz,input1,input2,input3,input4,reset;
output[7:0]dout;
output[5:0]scan;
output[3:0]LED;

reg[7:0]dout;
reg[5:0]scan;
reg[3:0]LED;
reg input_flag,input_flag1,count_flag;
reg[3:0]LED_N;
reg[2:0]cnt;
reg[3:0]dat,data,data1;
reg[3:0] count_one,count_ten;
reg[3:0] time_one='d0,time_ten='d3;

initial count_one='d0;
initial count_ten='d5;
initial data=4'b0000;
initial LED=4'b0000;

always@(posedge clk1hz or posedge reset or negedge clr )
begin
	if(reset == 1)
	begin
		count_one<='d5;count_ten<='d0;count_flag<=1'b0;time_one<='d0;time_ten<='d3;
	end
	else
	begin
	if(!clr)
		begin
			count_one<='d5;count_ten<='d0;count_flag<=1'b0;
		end
	else if((input_flag)&(!count_flag)&(!input_flag1))
	begin
		count_one<=time_one;count_ten<=time_ten;
		if(time_one=='d0&&time_ten=='d0)
			begin count_flag<=1'b1;time_one<='d0;time_ten<='d3;
			end
		else if(time_one=='d0)
			begin time_one<=4'b1001;
				time_ten<=time_ten-1'b1;
			end
			else
			begin time_one<=time_one-1'b1;
			end
		end
	else if((!input_flag)&(!count_flag)&(!input_flag1))
		begin
		if(count_one=='d0&&count_ten=='d0)
			begin count_flag<=1'b1;
			end
		else if(count_one=='d0)
				begin count_one<=4'b1001;
					  count_ten<=count_ten-1'b1;
				end
			 else
				begin count_one<=count_one-1'b1;
				end
		end
		 else
			begin
				count_one<=count_one;
				count_ten<=count_ten;
			end
	end
end

always@(posedge clk100khz)
begin
	if(reset == 1)
	begin
		LED_N<=4'b0000;
		input_flag<=1'b0;
		input_flag1<=1'b0;
		data<=4'b0000;
		data1<=4'b0000;
	end
	else
	begin
	if(!clr)
		begin
			LED_N<=4'b0000;
			input_flag1<=1'b0;
			data<=4'b0000;
				if(input1==0)
				begin
				data1<=4'b0001;
				LED<=4'b1000;
				input_flag1<=1'b1;
				end
			else if(input2==0)
				begin
				data1<=4'b0010;
				LED<=4'b0100;
				input_flag1<=1'b1;
				end
			else if(input3==0)
				begin
				data1<=4'b0011;
				LED<=4'b0010;
				input_flag1<=1'b1;
				end
			else if(input4==0)
				begin
				data1<=4'b0100;
				LED<=4'b0001;
				input_flag1<=1'b1;
				end
			else
				begin
				data1<=data1;
				LED<=LED_N;
				input_flag1<=input_flag1;
				end
		end
	else if((!input_flag)&(!count_flag))
			begin
			if(input1==0)
				begin
				data<=4'b0001;
				LED<=4'b1000;
				input_flag<=1'b1;
				end
			else if(input2==0)
				begin
				data<=4'b0010;
				LED<=4'b0100;
				input_flag<=1'b1;
				end
			else if(input3==0)
				begin
				data<=4'b0011;
				LED<=4'b0010;
				input_flag<=1'b1;
				end
			else if(input4==0)
				begin
				data<=4'b0100;
				LED<=4'b0001;
				input_flag<=1'b1;
				end
			else
				begin
				data<=data;
				LED<=LED_N;
				input_flag<=input_flag;
				end
			end
	end
end

always@(posedge clk100khz)
begin
	if(cnt==3'b101)
		begin cnt<=0; end
	else
		begin cnt<=cnt+1'b1; end
end

always@(cnt,data,data1,count_one,count_ten)
begin 
  case(cnt)
     3'b000:begin scan<= 6'b000000;end
     3'b001:begin scan<= 6'b000100;dat<=data;end
     3'b010:begin scan<= 6'b010000;dat<=count_one;end
     3'b011:begin scan<= 6'b100000;dat<=count_ten;end
	 3'b100:begin scan<= 6'b000001;dat<=data1;end	
     default:begin scan<=6'b000000;end
endcase 
end 

always@(dat)
 begin
   case(dat)
     4'b0000:dout[7:0]<=8'b00111111;
     4'b0001:dout[7:0]<=8'b00000110;
     4'b0010:dout[7:0]<=8'b01011011;
     4'b0011:dout[7:0]<=8'b01001111;
     4'b0100:dout[7:0]<=8'b01100110;
     4'b0101:dout[7:0]<=8'b01101101;
     4'b0110:dout[7:0]<=8'b01111101;
     4'b0111:dout[7:0]<=8'b00000111;
     4'b1000:dout[7:0]<=8'b01111111;
     4'b1001:dout[7:0]<=8'b01101111;
     4'b1010:dout[7:0]<=8'b01110111;
     4'b1011:dout[7:0]<=8'b01111100;
     4'b1100:dout[7:0]<=8'b00111001;
     4'b1101:dout[7:0]<=8'b01011110;
     4'b1110:dout[7:0]<=8'b01111001;
     4'b1111:dout[7:0]<=8'b01110001;
     default:dout[7:0]<=8'b00000000;
endcase
end
endmodule