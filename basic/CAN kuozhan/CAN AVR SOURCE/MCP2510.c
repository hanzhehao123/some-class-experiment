/************************************************************************************\
	MCP2510 CAN总线试验演示程序2003.10
\************************************************************************************/


#include "MCP2510.h"
#include "def.h"
#include "regx51.h"

/********************** MCP2510 Pin *********************************/
//#define MCP2510_CS				0x4		//EXIO2

/********************** MCP2510 Instruction *********************************/
#define MCP2510INSTR_RESET		0xc0
#define MCP2510INSTR_READ		0x03
#define MCP2510INSTR_WRITE		0x02
#define MCP2510INSTR_RTS		0x80	//request to send
#define MCP2510INSTR_RDSTAT	0xa0	//read status
#define MCP2510INSTR_BITMDFY	0x05	//bit modify


//#define MCP2510_Enable()		do{CLREXIOBIT(MCP2510_CS);}while(0)
//#define MCP2510_Disable()		do{SETEXIOBIT(MCP2510_CS); Delay(1);}while(0)

    MCP2510_Enable()
    {P1_0=0;}

	MCP2510_Disable()
    {P1_0=1;}

void MCP2510_Reset()
{
	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_RESET);

	MCP2510_Disable();
}

void MCP2510_Write(int address, int value)
{
	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_WRITE);
	SendSIOData((unsigned char)address);
	SendSIOData((unsigned char)value);

	MCP2510_Disable();
}

unsigned char MCP2510_Read(int address)
{
	unsigned char result;

	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_READ);
	SendSIOData((unsigned char)address);

	//SendSIOData(0);
	result=ReadSIOData();

	MCP2510_Disable();

	return result;
}

unsigned char MCP2510_ReadStatus()
{
	unsigned char result;

	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_RDSTAT);

	result=ReadSIOData();

	MCP2510_Disable();

	return result;
}

void MCP2510_WriteBits(int address,int value,int mask)
{  int baddress,bvalue,bmask;
    baddress=address;
	bvalue=value;
	bmask=mask;
	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_BITMDFY);
	SendSIOData((unsigned char)baddress);
	SendSIOData((unsigned char)bmask);
	SendSIOData((unsigned char)bvalue);

	MCP2510_Disable();
}


void MCP2510_SetBandRate(CanBandRate bandrate, BOOL IsBackNormal)
{
	//
	// Bit rate calculations.
	//
	//Input clock fre=16MHz
	// In this case, we'll use a speed of 125 kbit/s, 250 kbit/s, 500 kbit/s.
	// If we set the length of the propagation segment to 7 bit time quanta,
	// and we set both the phase segments to 4 quanta each,
	// one bit will be 1+7+4+4 = 16 quanta in length.
	//
	// setting the prescaler (BRP) to 0 => 500 kbit/s.
	// setting the prescaler (BRP) to 1 => 250 kbit/s.
	// setting the prescaler (BRP) to 3 => 125 kbit/s.
	//
	// If we set the length of the propagation segment to 3 bit time quanta,
	// and we set both the phase segments to 1 quanta each,
	// one bit will be 1+3+2+2 = 8 quanta in length.
	// setting the prescaler (BRP) to 0 => 1 Mbit/s.

	// Go into configuration mode
	MCP2510_Write(MCP2510REG_CANCTRL, MODE_CONFIG);

	switch(bandrate){
	case BandRate_125kbps:
		MCP2510_Write(CNF1, SJW1|BRP4);	//Synchronization Jump Width Length =1 TQ
		MCP2510_Write(CNF2, BTLMODE_CNF3|(SEG4<<3)|SEG7); // Phase Seg 1 = 4, Prop Seg = 7
		MCP2510_Write(CNF3, SEG4);// Phase Seg 2 = 4
		break;
	case BandRate_250kbps:
		MCP2510_Write(CNF1, SJW1|BRP2);	//Synchronization Jump Width Length =1 TQ
		MCP2510_Write(CNF2, BTLMODE_CNF3|(SEG4<<3)|SEG7); // Phase Seg 1 = 4, Prop Seg = 7
		MCP2510_Write(CNF3, SEG4);// Phase Seg 2 = 4
		break;
	case BandRate_500kbps:
		MCP2510_Write(CNF1, SJW1|BRP1);	//Synchronization Jump Width Length =1 TQ
		MCP2510_Write(CNF2, BTLMODE_CNF3|(SEG4<<3)|SEG7); // Phase Seg 1 = 4, Prop Seg = 7
		MCP2510_Write(CNF3, SEG4);// Phase Seg 2 = 4
		break;
	case BandRate_1Mbps:
		MCP2510_Write(CNF1, SJW1|BRP1);	//Synchronization Jump Width Length =1 TQ
		MCP2510_Write(CNF2, BTLMODE_CNF3|(SEG3<<3)|SEG2); // Phase Seg 1 = 2, Prop Seg = 3
		MCP2510_Write(CNF3, SEG2);// Phase Seg 2 = 1
		break;
	}

	if(IsBackNormal){
		//Enable clock output
		MCP2510_Write(CLKCTRL, MODE_LOOPBACK | CLKEN | CLK1);
	}
}


/*******************************************\
*	序列读取MCP2510数据				*
\*******************************************/
/*unsigned char MCP2510_SRead( int address)
{	  unsigned char value[8];
	//int i;

	MCP2510_Enable();
	SendSIOData(MCP2510INSTR_READ);
	SendSIOData((unsigned char)address);
	//for(i=0;i<nlength;i++)
    value[0]=ReadSIOData();	
	MCP2510_Disable();
	return value[0];
}*/


/*******************************************\
*	序列写入MCP2510数据				*
\*******************************************/
void MCP2510_Swrite(int address,unsigned char value,unsigned char nlength)
{   //int address;
	int i;
	unsigned char IDarry[1];
	IDarry[0]=value;
	MCP2510_Enable();

	SendSIOData(MCP2510INSTR_WRITE);
	SendSIOData((unsigned char)address);

	for (i=0; i < nlength; i++) {
		SendSIOData(IDarry[i]);
		//pdata++;
	}
	MCP2510_Disable();
}

/*******************************************\
*	读取MCP2510 CAN总线ID				*
*	参数: address为MCP2510寄存器地址*
*			can_id为返回的ID值			*
*	返回值								*
*	TRUE，表示是扩展ID(29位)			*
*	FALSE，表示非扩展ID(11位)		*
\*******************************************/
/*BOOL MCP2510_Read_Can_ID( int address, U32* can_id)
{
	U32 tbufdata;
	unsigned char* p=(unsigned char*)&tbufdata;

	MCP2510_SRead(address, p, 4);
	*can_id = (tbufdata<<3)|((tbufdata>>13)&0x7);
	*can_id &= 0x7ff;

	if ( (p[MCP2510LREG_SIDL] & TXB_EXIDE_M) ==  TXB_EXIDE_M ) {
		*can_id = (*can_id<<2) | (p[MCP2510LREG_SIDL] & 0x03);
		*can_id <<= 16;
		*can_id |= tbufdata>>16;
		return TRUE;
	}
	return FALSE;
}*/

/***********************************************************\
*	读取MCP2510 接收的数据							*
*	参数: nbuffer为第几个缓冲区可以为3或者4	*
*			can_id为返回的ID值							*
*			rxRTR表示是否是RXRTR						*
*			data表示读取的数据						*
*			dlc表示data length code							*
*	返回值												*
*		TRUE，表示是扩展总线						*
*		FALSE，表示非扩展总线						*
\***********************************************************/
/*BOOL MCP2510_Read_Can(U8 nbuffer, BOOL* rxRTR, U32* can_id, U8* data , U8* dlc)
{

	U8 mcp_addr = (nbuffer<<4) + 0x31, ctrl;
	BOOL IsExt;

	IsExt=MCP2510_Read_Can_ID( mcp_addr, can_id);

	ctrl=MCP2510_Read(mcp_addr-1);
	*dlc=MCP2510_Read( mcp_addr+4);
	if ((ctrl & 0x08)) {
		*rxRTR = TRUE;
	}
	else{
		*rxRTR = FALSE;
	}
	*dlc &= DLC_MASK;
	MCP2510_SRead(mcp_addr+5, data, *dlc);

	return IsExt;
}*/


/***********************************************************\
*	写入MCP2510 发送的数据							*
*	参数: nbuffer为第几个缓冲区可以为0、1、2	*
*			ext表示是否是扩展总线					*
*			can_id为返回的ID值							*
*			rxRTR表示是否是RXRTR						*
*			data表示读取的数据						*
*			dlc表示data length code							*
*		FALSE，表示非扩展总线						*
\***********************************************************/
/*void MCP2510_Write_Can( U8 nbuffer, BOOL ext, U32 can_id, BOOL rxRTR, U8* data,U8 dlc )
{
	U8 mcp_addr = (nbuffer<<4) + 0x31;
	MCP2510_Swrite(mcp_addr+5, data, dlc );  // write data bytes
	MCP2510_Write_Can_ID( mcp_addr, can_id,ext);  // write CAN id
	if (rxRTR)
		dlc |= RTR_MASK;  // if RTR set bit in byte
	MCP2510_Write((mcp_addr+4), dlc);            // write the RTR and DLC
}*/

/*******************************************\
*	设置MCP2510 CAN总线ID				*
*	参数: address为MCP2510寄存器地址*
*			can_id为设置的ID值			*
*			IsExt表示是否为扩展ID	*
\*******************************************/
void MCP2510_Write_Can_ID(int address, U32 can_id, BOOL IsExt)
{
	U32 tbufdata;
	unsigned char IDarry[4],i;

	if (IsExt) {
		can_id&=0x1fffffff;	//29位
		tbufdata=can_id &0xffff;
		tbufdata<<=16;
		tbufdata|=(can_id>>(18-5)&(~0x1f));
		tbufdata |= TXB_EXIDE_M;
	}
	else{
		can_id&=0x7ff;	//11位
		tbufdata= (can_id>>3)|((can_id&0x7)<<13);
	}
	IDarry[0]=tbufdata&0xff;
	IDarry[1]=(tbufdata>>8)&0xff;
	IDarry[2]=(tbufdata>>16)&0xff;
	IDarry[3]=(tbufdata>>24)&0xff;
	for(i=0;i<4;i++)
	MCP2510_Swrite(address, IDarry[i], 1);
	
	//MCP2510_Swrite(address, (unsigned char)tbufdata,4);
}  



// Setup the CAN buffers used by the application.
// We currently use only one for reception and one for transmission.
// It is possible to use several to get a simple form of queue.
//
// We setup the unit to receive all CAN messages.
// As we only have at most 4 different messages to receive, we could use the
// filters to select them for us.
//
// mcp_init() should already have been called.
void canSetup(void)
{
    // As no filters are active, all messages will be stored in RXB0 only if
    // no roll-over is active. We want to recieve all CAN messages (standard and extended)
    // (RXM<1:0> = 11).
    //SPI_mcp_write_bits(RXB0CTRL, RXB_RX_ANY, 0xFF);
    //SPI_mcp_write_bits(RXB1CTRL, RXB_RX_ANY, 0xFF);

    // But there is a bug in the chip, so we have to activate roll-over.
	MCP2510_WriteBits(RXB0CTRL, (RXB_BUKT+RXB_RX_ANY), 0xFF);
	MCP2510_WriteBits(RXB1CTRL, RXB_RX_ANY, 0xFF);
}

/***********************************************************************************\
								发送数据
	参数:
		data，发送数据

	Note: 使用三个缓冲区循环发送，没有做缓冲区有效检测
\***********************************************************************************/
/*void canWrite(U32 id, U8 *pdata, unsigned char dlc, BOOL IsExt, BOOL rxRTR)
{
	static int ntxbuffer=0;
	MCP2510_Write_Can(ntxbuffer, IsExt, id, rxRTR, pdata, dlc);

	switch(ntxbuffer){
	case 0:
		MCP2510_transmit(TXB10CTRL);
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
	}
}*/

void init_MCP2510(CanBandRate bandrate)
{
	unsigned char i,j,a;

	MCP2510_Reset();

//	for(i=0;i<255;i++)
//		Uart_Printf("%x\n",MCP2510_Read(i));

	MCP2510_SetBandRate(bandrate,FALSE);

	// Disable interrups.
	MCP2510_Write(CANINTE, NO_IE);

	// Mark all filter bits as don't care:
	MCP2510_Write_Can_ID(RXM0SIDH, 0,1);
	MCP2510_Write_Can_ID(RXM1SIDH, 0,1);
	// Anyway, set all filters to 0:
	MCP2510_Write_Can_ID(RXF0SIDH, 0, 0);
	MCP2510_Write_Can_ID(RXF1SIDH, 0, 0);
	MCP2510_Write_Can_ID(RXF2SIDH, 0, 0);
	MCP2510_Write_Can_ID(RXF3SIDH, 0, 0);
	MCP2510_Write_Can_ID(RXF4SIDH, 0, 0);
	MCP2510_Write_Can_ID(RXF5SIDH, 0, 0);

																		
	//Enable clock output  MODE_NORMAL
	//MCP2510_Write(CLKCTRL, MODE_LOOPBACK| CLKEN | CLK1);//回环模式
	MCP2510_Write(CLKCTRL, MODE_NORMAL| CLKEN | CLK1);//标准模式
    //如果不能用两台设备联机实验的话，可以选择回环模式
    //这样在超级终端中可以显示键盘的输入  





  
	// Clear, deactivate the three transmit buffers
	a = TXB0CTRL;
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 14; j++) {
			MCP2510_Write(a, 0);
			a++;
	        }
       	a += 2; // We did not clear CANSTAT or CANCTRL
	}
	// and the two receive buffers.
	MCP2510_Write(RXB0CTRL, 0);
	MCP2510_Write(RXB1CTRL, 0);

	// The two pins RX0BF and RX1BF are used to control two LEDs; set them as outputs and set them as 00.
	//MCP2510_Write(BFPCTRL, 0x3C);
	
	//Open Interrupt
	MCP2510_Write(CANINTE, RX0IE|RX1IE);
}


/***********************************************************************************\
								查询是否收到数据
	返回值:如果没有数据，则返回-1，
			否则，返回收到数据的缓冲区号
	Note: 如果两个缓冲区都收到数据，则返回第一个缓冲区
\***********************************************************************************/
int canPoll()
{
	if(MCP2510_ReadStatus()&RX0INT)
		return 0;
	
	if(MCP2510_ReadStatus()&RX1INT)
		return 1;

	return -1;
}

void SendSIOData(unsigned char value)
{  
   char i;
   
   for(i=0;i<8;i++)
     {P1_3=0;
      
	  P1_1=value&0x80;
	  P1_3=1;
	  value=value<<1;
	 }
	 P1_3=0;
}

unsigned char ReadSIOData(void)
{ char i,j;
  unsigned char d,v=0;
  
  for(i=0;i<8;i++)
  {P1_3=0;
   P1_3=1;
   for(j=0;j<10;j++);
   v=v+(((P1&0x04)<<5)>>i);
  
   d=v;
  }
  
  P1_3=0;
  return (d);
}

/*BOOL canRead(int n, U32* id, U8 *pdata,  U8*dlc, BOOL* rxRTR, BOOL *isExt)
{
	U8 byte;
	byte=MCP2510_Read(CANINTF);

	if(n==0){
		if(byte & RX0INT){
			*isExt=MCP2510_Read_Can(n+3, rxRTR, id, pdata, dlc);
			MCP2510_WriteBits(CANINTF, ~RX0INT, RX0INT); // Clear interrupt
		}
		return FALSE;
	}
	else if(n ==1 ){
		if(byte & RX1INT){
			*isExt=MCP2510_Read_Can(n+4, rxRTR, id, pdata, dlc);
			MCP2510_WriteBits(CANINTF, ~RX1INT, RX1INT); // Clear interrupt
		}
		return FALSE;
	}


}*/

/*void CAN_Test()
{
	int i;
	U32 id;
	unsigned char dlc;
	BOOL rxRTR, isExt;
	BOOL temp;
	
	U8 data[8]={1,2,3,4,5,6,7,8};
	init_MCP2510(BandRate_125kbps);

	canSetup();
	canWrite(0x123, data, 8, FALSE, FALSE);

	memset(data,0,8);

	Delay(100);

	while((i=canPoll())==-1);

	temp=canRead(i, &id, data, &dlc, &rxRTR, &isExt);

	Uart_Printf("\nid=%x",id);
	Uart_Printf("\ndata=%x,%x,%x,%x",data[0],data[1],data[2],data[3]);
	
//	temp=canRead(1, &id, data, &dlc, &rxRTR, &isExt);
    
	
}*/
   

