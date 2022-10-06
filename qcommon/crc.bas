 'FINISHED FOR NOW''''''''''''''''''''''''''''''''''''''''''''''''''
 
 
 
 #Include "qcommon\qcommon.bi"


'// this is a 16 bit, non-reflected CRC using the polynomial &H1021
'// and the initial and final xor values shown below...  in other words, the
'// CCITT standard CRC used by XMODEM

#define CRC_INIT_VALUE	&Hffff
#define CRC_XOR_VALUE	&H0000

static  shared crctable(256) as  ushort  => _
 { _
	&H0000,	&H1021,	&H2042,	&H3063,	&H4084,	&H50a5,	&H60c6,	&H70e7, _
	&H8108,	&H9129,	&Ha14a,	&Hb16b,	&Hc18c,	&Hd1ad,	&He1ce,	&Hf1ef, _
	&H1231,	&H0210,	&H3273,	&H2252,	&H52b5,	&H4294,	&H72f7,	&H62d6, _
	&H9339,	&H8318,	&Hb37b,	&Ha35a,	&Hd3bd,	&Hc39c,	&Hf3ff,	&He3de, _
	&H2462,	&H3443,	&H0420,	&H1401,	&H64e6,	&H74c7,	&H44a4,	&H5485, _
	&Ha56a,	&Hb54b,	&H8528,	&H9509,	&He5ee,	&Hf5cf,	&Hc5ac,	&Hd58d, _
	&H3653,	&H2672,	&H1611,	&H0630,	&H76d7,	&H66f6,	&H5695,	&H46b4, _
	&Hb75b,	&Ha77a,	&H9719,	&H8738,	&Hf7df,	&He7fe,	&Hd79d,	&Hc7bc, _
	&H48c4,	&H58e5,	&H6886,	&H78a7,	&H0840,	&H1861,	&H2802,	&H3823, _
	&Hc9cc,	&Hd9ed,	&He98e,	&Hf9af,	&H8948,	&H9969,	&Ha90a,	&Hb92b, _
	&H5af5,	&H4ad4,	&H7ab7,	&H6a96,	&H1a71,	&H0a50,	&H3a33,	&H2a12, _
	&Hdbfd,	&Hcbdc,	&Hfbbf,	&Heb9e,	&H9b79,	&H8b58,	&Hbb3b,	&Hab1a, _
	&H6ca6,	&H7c87,	&H4ce4,	&H5cc5,	&H2c22,	&H3c03,	&H0c60,	&H1c41, _
	&Hedae,	&Hfd8f,	&Hcdec,	&Hddcd,	&Had2a,	&Hbd0b,	&H8d68,	&H9d49, _
	&H7e97,	&H6eb6,	&H5ed5,	&H4ef4,	&H3e13,	&H2e32,	&H1e51,	&H0e70, _
	&Hff9f,	&Hefbe,	&Hdfdd,	&Hcffc,	&Hbf1b,	&Haf3a,	&H9f59,	&H8f78, _
	&H9188,	&H81a9,	&Hb1ca,	&Ha1eb,	&Hd10c,	&Hc12d,	&Hf14e,	&He16f, _
	&H1080,	&H00a1,	&H30c2,	&H20e3,	&H5004,	&H4025,	&H7046,	&H6067, _
	&H83b9,	&H9398,	&Ha3fb,	&Hb3da,	&Hc33d,	&Hd31c,	&He37f,	&Hf35e, _
	&H02b1,	&H1290,	&H22f3,	&H32d2,	&H4235,	&H5214,	&H6277,	&H7256, _
	&Hb5ea,	&Ha5cb,	&H95a8,	&H8589,	&Hf56e,	&He54f,	&Hd52c,	&Hc50d, _
	&H34e2,	&H24c3,	&H14a0,	&H0481,	&H7466,	&H6447,	&H5424,	&H4405, _
	&Ha7db,	&Hb7fa,	&H8799,	&H97b8,	&He75f,	&Hf77e,	&Hc71d,	&Hd73c, _
	&H26d3,	&H36f2,	&H0691,	&H16b0,	&H6657,	&H7676,	&H4615,	&H5634, _
	&Hd94c,	&Hc96d,	&Hf90e,	&He92f,	&H99c8,	&H89e9,	&Hb98a,	&Ha9ab, _
	&H5844,	&H4865,	&H7806,	&H6827,	&H18c0,	&H08e1,	&H3882,	&H28a3, _
	&Hcb7d,	&Hdb5c,	&Heb3f,	&Hfb1e,	&H8bf9,	&H9bd8,	&Habbb,	&Hbb9a, _
	&H4a75,	&H5a54,	&H6a37,	&H7a16,	&H0af1,	&H1ad0,	&H2ab3,	&H3a92, _
	&Hfd2e,	&Hed0f,	&Hdd6c,	&Hcd4d,	&Hbdaa,	&Had8b,	&H9de8,	&H8dc9, _
	&H7c26,	&H6c07,	&H5c64,	&H4c45,	&H3ca2,	&H2c83,	&H1ce0,	&H0cc1, _
	&Hef1f,	&Hff3e,	&Hcf5d,	&Hdf7c,	&Haf9b,	&Hbfba,	&H8fd9,	&H9ff8, _
	&H6e17,	&H7e36,	&H4e55,	&H5e74,	&H2e93,	&H3eb2,	&H0ed1,	&H1ef0  _
 } 

sub CRC_Init( crcvalue as ushort ptr)
	
	*crcvalue = CRC_INIT_VALUE 
	
End Sub
 
	
  
sub CRC_ProcessByte(  crcvalue as ushort ptr,_data as ubyte)
	
	 	*crcvalue  = (*crcvalue  shl 8) xor crctable((*crcvalue shr 8) xor _data) 
End Sub

 

 function CRC_Value(crcvalue as UShort) as ushort
 	
 	return crcvalue xor CRC_XOR_VALUE 
 	
 End Function
 
	
 

  function  CRC_Block (_start as ubyte ptr ,_count as integer ) as ushort
  	
   dim crc as ushort	 

	CRC_Init (@crc) 
	while  _count > 0
		 _count-=1
		
		crc = (crc shl 8) xor crctable((crc shr 8) xor *_start):_start+=1
		
	Wend
		

	return crc 
 
  	
  End Function
 

