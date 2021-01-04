module jp(clk100khz, din, scan, dout);
	input	[3:0]	din;
	output	[5:0]	scan;
	output	[7:0]	dout;
	
	reg	[7:0]	dout;
	reg	[5:0]	scan;
	reg	[3:0]	cnt,s;
	reg	[7:0]	temp, led1, led2, led3, led4, led5, led6;
	reg	flag, clk1;
	reg	[25:0]	count;	
	
	always@(posedge clk100khz)
	 begin 
		if(count==5'd15000)
		 begin clk1=~clk1; count <= 0; end
		else 
		 begin count <= count+1'b1; end 
	 end
	 
	always@(posedge clk1)
	 begin 
		if(din[3:0]<4b'1111 && led6 ==8'b00000000) 
		begin 
			flag <= 0;
			case(din[3:0])
			4'b1110:begin temp[7:0] <= 8'b00000110; end
			4'b1101:begin temp[7:0] <= 8'b01011011; end
			4'b1011:begin temp[7:0] <= 8'b01001111; end
			4'b0111:begin temp[7:0] <= 8'b01100110; end
			4'b1100:begin temp[7:0] <= 8'b01101101; end
			4'b1010:begin temp[7:0] <= 8'b01111101; end
			4'b0110:begin temp[7:0] <= 8'b00000111; end
			4'b1001:begin temp[7:0] <= 8'b01111111; end
			default :begin temp[7:0] <= 8'b00000000; end
			endcase
		end
		
		if(flag == 0)
		begin 
		 flag <= 1;
		 led6 <= led5;	 led5 <= led4;	 led4 <= led3;	 led3 <= led2;	 led2 <= led1;	 led1 <= temp;
		end 
		else if (din[3:0] == 4'b1111)
		 begin flag <= 1; end
	end
	
	always@(posedge clk100khz)
	 begin 
		if(cnt == 3'b101)
		 begin cnt <= 0; end
		else 
		 begin cnt <= cnt+1; end
	 end
	 
	 always@(cnt)
	 begin 
		case(cnt)
		 3'b000:begin scan <= 6'b000001;dout[7:0] <= led1 ; end 
		 3'b001:begin scan <= 6'b000010;dout[7:0] <= led2 ; end 
		 3'b010:begin scan <= 6'b000100;dout[7:0] <= led3 ; end 
		 3'b011:begin scan <= 6'b001000;dout[7:0] <= led4 ; end 
		 3'b100:begin scan <= 6'b010000;dout[7:0] <= led5 ; end 
		 3'b101:begin scan <= 6'b100000;dout[7:0] <= led6 ; end 
		 default: begin scan <= 6'b000000;end 
		endcase
	 end
	 
endmodule 