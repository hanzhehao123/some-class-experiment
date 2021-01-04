module traffic(clk1hz,clk1khz,dout,scan,light,reset,zhu,zhi);

input zhu,zhi;
input reset;
input clk1hz,clk1khz;
output[7:0] dout;
output[5:0] scan;
output[7:0] light;

reg[7:0] dout;
reg[5:0] scan;
reg[7:0] light;
reg[3:0] time1,time2,data;
reg flag,temp;
reg stop;

initial temp=1'b1;
initial stop=1'b0;

always@(temp)
begin
	scan<={4'b0000,temp,(~temp)};
end
	
always@(posedge clk1khz)
begin
	temp<=~temp;
	if(temp==1'b1)
		data<=time1;
	else data<=time2;
end

always@(posedge clk1hz)
begin
	if(!stop)
	begin
		if(time1==4'b0000)
		begin
			if(time2==4'b0000)
			begin
				time1<=4'b1001;
				time2<=4'b0010;
				flag<=~flag;
			end
			else
			begin
				time2<=time2-1;
				time1<=4'b1001;
			end
		end
		else time1<=time1-1;
	end
end

always@(time1,flag,time2)
begin
	if(reset)
	begin
		stop<=1;
		light<=8'b10000100;
	end
	else
	begin
		if((!zhu)&(!zhi))
		begin
			stop<=0;
			if(light==8'b00100100) stop<=1;
		end
		if((!zhu)&(zhi))
		begin
			stop<=0;
			if(light==8'b10000001) stop<=1;
		end
		if((zhu)&(!zhi))
		begin
			stop<=0;
			if(light==8'b00100100) stop<=1;
		end
		if((zhu)&(zhi))
			stop<=0;

	if((time1<4'b0100)&(flag==1'b1)&(time2==4'b0000))
		begin light<=8'b01000100; end
	else if((time1<4'b1010)&(flag==1'b1))
		begin light<=8'b00100100; end
	else if((time1<4'b0100)&(flag==1'b0)&(time2==4'b0000))
		begin light<=8'b10000010; end
	else if((time1<4'b1010)&(flag==1'b0))
		begin light<=8'b10000001; end
	end
end

always@(data)
begin
	case(data)
		4'b0000: dout<=8'b00111111;
		4'b0001: dout<=8'b00000110;
		4'b0010: dout<=8'b01011011;
		4'b0011: dout<=8'b01001111;
		4'b0100: dout<=8'b01100110;
		4'b0101: dout<=8'b01101101;
		4'b0110: dout<=8'b01111101;
		4'b0111: dout<=8'b00000111;
		4'b1000: dout<=8'b01111111;
		4'b1001: dout<=8'b01101111;
		4'b1010: dout<=8'b01110111;
		4'b1011: dout<=8'b01111100;
		4'b1100: dout<=8'b00111001;
		4'b1101: dout<=8'b01011110;
		4'b1110: dout<=8'b01111001;
		4'b1111: dout<=8'b00000000;
		default dout<=8'b00000000;
	endcase
end
endmodule