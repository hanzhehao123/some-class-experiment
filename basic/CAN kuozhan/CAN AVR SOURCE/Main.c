
#include"MCP2510.h"
#include"def.h"
#include"regx51.h"

#define MCP2510INSTR_WRITE		0x02
#define MCP2510INSTR_READ		0x03

int main(void)
{
	int n,i,k,j;
	char step[8]={0x10,0x30,0x20,0x60,0x40,0xc0,0x80,0x90};
	//static unsigned char ntxbuffer=0;
	unsigned char dlc;
	//unsigned char value[8]={9,},trans[8]={1,0,3,4,5,6,7,8};
	char value[8]={9,};
	 // trans[8]={'1','2','3','4','5','6','7','8'};
	U8 byte;			
	unsigned char mcp_addr;

	Targetinit();	//目标版初始化

	init_MCP2510(BandRate_250kbps);//可在该函数内设置成回环模式
                                  //从而只用一台设备完成实验
	canSetup();
		
	for(;;)
	{	
  /*  mcp_addr = (ntxbuffer<<4)+0x31;
	 P1_0=0;

	SendSIOData(MCP2510INSTR_WRITE);
	SendSIOData((unsigned char)(mcp_addr+5));

	for (i=0; i < 8; i++) {
		SendSIOData(trans[i]);
	}
	P1_0=1;	
	MCP2510_Write_Can_ID( mcp_addr, 0x123,FALSE);  // write CAN id
	
	MCP2510_Write((mcp_addr+4), 8);            // write the RTR and DLC

    switch(ntxbuffer){
	case 0:
		MCP2510_transmit(TXB0CTRL);
		ntxbuffer=1;
		break;
	case 1:
		MCP2510_transmit(TXB1CTRL);
		ntxbuffer=2;
		break;
	case 2:
		MCP2510_transmit(TXB2CTRL);
		ntxbuffer=0;
		break;
	}	*/		   

       //while((n=canPoll())==-1);
		if((n=canPoll())!=-1){//CAN总线收数据
			byte=MCP2510_Read(CANINTF);

		  	if(n==0){
		     	if(byte & RX0INT){
			    //*isExt=MCP2510_Read_Can(n+3, rxRTR, id, pdata, dlc);
		    	mcp_addr = ((n+3)<<4) + 0x31;
			    //MCP2510_Read_Can_ID( mcp_addr, can_id);
                dlc=MCP2510_Read( mcp_addr+4);
			    dlc &= DLC_MASK;
				//value[0]=MCP2510_SRead((int)(mcp_addr+5));
				P1_0=0;//MCP2510_Enable();P1_0=0;
				SendSIOData(MCP2510INSTR_READ);
				SendSIOData((unsigned char)(mcp_addr+5));
				for(i=0;i<dlc;i++)
    			value[i]=ReadSIOData();	
				P1_0=1;//MCP2510_Disable();				  
			    //MCP2510_SRead((int)(mcp_addr+5),dlc);
				//MCP2510_SRead((int)(mcp_addr+5),1);
		     	MCP2510_WriteBits(CANINTF, ~RX0INT, RX0INT); // Clear interrupt
		        }
		
	        }
	        else if(n ==1 ){
		      if(byte & RX1INT){
		      mcp_addr = ((n+4)<<4) + 0x31;
			  //*isExt=MCP2510_Read_Can(n+4, rxRTR, id, pdata, dlc);
              dlc=MCP2510_Read( mcp_addr+4);
		  	  dlc &= DLC_MASK;
			  //value[0]=MCP2510_SRead((int)(mcp_addr+5));
			  	P1_0=0;//MCP2510_Enable();
				SendSIOData(MCP2510INSTR_READ);
				SendSIOData((unsigned char)(mcp_addr+5));
				for(i=0;i<dlc;i++)
    			value[i]=ReadSIOData();	
				P1_0=1;//MCP2510_Disable();				  
			  //MCP2510_SRead((int)(mcp_addr+5),dlc);
			  //MCP2510_SRead((int)(mcp_addr+5),1);
			  MCP2510_WriteBits(CANINTF, ~RX1INT, RX1INT); // Clear interrupt
		      }
		
	        }		 		 
          }
		 	
		 	
         
        switch(value[0])
          { case 0x81:
             {
			 P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
            if(value[1]==1)
             {P1_5=0;
			 P1_4=0;
			 for(i=0;i<30000;i++);
			 P1_4=1;}
             else if(value[1]==0)
             {P1_5=1;
			 P1_4=0;
			 for(i=0;i<30000;i++);
			 P1_4=1;}

             value[0]=0;
			 value[1]=3;
             }break;
            case 0x82:
            {P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
			if(value[1]==1)
             P1_6=0;
             else if(value[1]==0)
             P1_6=1;
             value[0]=0;
			 value[1]=3;
             }break;
            case 0x83:
            {P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
			if(value[1]==1)
             P1_7=0;
             else if(value[1]==0)
             P1_7=1;
             value[0]=0;
			 value[1]=3;
             }break;
            case 0x84:
            {P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
			if(value[1]==1)
             P1_4=0;
             else if(value[1]==0)
             P1_4=1;
             value[0]=0;
			 value[1]=3;
             }break;
            case 0x85:

            {//if((0<=value[1])&&(value[1]<10))
			P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
             P2=value[1];
             //else
             //P2=0xaa; 
             value[0]=0;
			 value[1]=0xaa;
             }break;
            case 0x86:
 			{P1_4=0;
			 for(i=0;i<10000;i++);
			 P1_4=1;
			if(value[1]>=0)
			 
			   for(k=0;k<(int)(value[1]*4);k++){
			     for(i=0;i<8;i++){
 				   P0=(P0&0x0f)+step[i];
   				   for(j=0;j<170;j++);
 			     }
				 }
             else
               for(k=(int)(value[1]*4);k<0;k++){
			     for(i=7;i>=0;i--){
 				   P0=(P0&0x0f)+step[i];
   				   for(j=0;j<170;j++);
 			     }
				 }
			value[0]=0;
			value[1]=0;
		    }break;
		  /* case '1':
		   	{P1_6=0;
			 for(k=0;k<256;k++)
			  for(i=0;i<8;i++){
 				P0=(P0&0x0f)+step[i];
   				 for(j=0;j<170;j++);
 			   }			 
			 P1_6=1;
			 P1_4=0;
			 for(l=0;l<10000;l++);
			 P1_4=1;
			 value[0]=9;
		   	}break;
           case '2':
		    {P2=0x88;
			 for(k=0;k<30000;k++);
			 P2=0xaa;		
			 value[0]=9;
			 
			}break;
			//default:
			//P1_4=0;	*/						
	    }//end switch
      }
}
