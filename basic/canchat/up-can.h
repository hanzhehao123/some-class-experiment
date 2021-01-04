#ifndef __UP_CAN_H__
#define __UP_CAN_H__


#define UPCAN_IOCTRL_SETBAND			0x1	//set can bus band rate
#define UPCAN_IOCTRL_SETID				0x2	//set can frame id data
#define UPCAN_IOCTRL_SETLPBK			0x3	//set can device in loop back mode or normal mode
#define UPCAN_IOCTRL_SETFILTER			0x4	//set a filter for can device
#define UPCAN_IOCTRL_PRINTRIGISTER	0x5	// print register information of spi and portE

#define UPCAN_EXCAN					(1<<31)	//extern can flag

typedef enum{
	BandRate_125kbps=1,
	BandRate_250kbps=2,
	BandRate_500kbps=3,
	BandRate_1Mbps=4
}CanBandRate;

typedef struct {
	unsigned int id;	//CAN����ID
	unsigned char data[8];		//CAN��������
	unsigned char dlc;		//���ݳ���
	int IsExt; 	//�Ƿ�����չ����
	int rxRTR;	//�Ƿ���Զ��֡
}CanData, *PCanData;

/*********************************************************************\
	CAN�豸���ý��չ������ṹ��
	����:	IdMask��Mask
			IdFilter��Filter
	�Ƿ�������ݰ������¹���:
	Mask	Filter	RevID	Receive
	0		x		x		yes
	1		0		0		yes
	1		0		1		no
	1		1		0		no
	1		1		1		yes
	
\*********************************************************************/
typedef struct{
	unsigned int Mask;
	unsigned int Filter;
	int IsExt;	//�Ƿ�����չID
}CanFilter,*PCanFilter;

#endif
