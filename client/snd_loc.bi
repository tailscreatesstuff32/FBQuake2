extern as cvar_t	ptr s_volume 
extern as cvar_t	ptr s_nosound 
extern as cvar_t	ptr s_loadas8bit 
extern as cvar_t	ptr s_khz 
extern as cvar_t	ptr s_show 
extern as cvar_t	ptr s_mixahead 
extern as cvar_t	ptr s_testsound 
extern as cvar_t	ptr s_primary 



type dma_t
	as integer			channels 
	as integer			samples 				'// mono samples in buffer
	as integer			submission_chunk 		'// don't mix less than this #
	as integer			samplepos  				'// in mono samples
	as integer			samplebits 
	as integer			speed 
	as ubyte		  ptr buffer 
	
	
End Type
 

extern	as dma_t	dma 

'/*
'====================================================================
'
'  SYSTEM SPECIFIC FUNCTIONS
'
'====================================================================
'*/







'// initializes cycling through a DMA buffer and returns information on it
declare function SNDDMA_Init() as qboolean 