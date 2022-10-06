
#Include "client\client.bi"
#Include "client\snd_loc.bi"




dim shared as qboolean	snd_initialized = false 
dim shared as integer			sound_started=0 

dim shared as integer			num_sfx

dim shared as cvar_t	ptr s_volume 
dim shared as cvar_t	ptr s_nosound 
dim shared as cvar_t	ptr s_loadas8bit 
dim shared as cvar_t	ptr s_khz 
dim shared as cvar_t	ptr s_show 
dim shared as cvar_t	ptr s_mixahead 
dim shared as cvar_t	ptr s_testsound 
dim shared as cvar_t	ptr s_primary 

dim shared as integer			soundtime 	'// sample PAIRS
dim shared as integer   		paintedtime  	'// sample PAIRS



  declare function SNDDMA_InitDirect () as qboolean
 declare function SNDDMA_InitWav () as qboolean
'
dim shared as dma_t		dma 



 
function SNDDMA_Init() as qboolean
'function SNDDMA_Init() as integer
	
	
	SNDDMA_InitDirect()
	
End Function
 
 
sub S_Play
	
	
	
End Sub

sub S_StopAllSounds
	
	
	
End Sub

sub S_SoundList
	
	
	
End Sub
sub S_SoundInfo_f
	
	
End Sub

sub S_InitScaletable ()
	
	
End Sub

'/*
'================
'S_Init
'================
'*/
sub S_Init ()
  dim cv as cvar_t ptr
  
 	Com_Printf(!"\n------- sound initialization -------\n") 
 	cv = Cvar_Get ("s_initsound", "1", 0)
	
 		if (cv->value = NULL) then
 			Com_Printf (!"not initializing.\n")
 	
 	   else
  
		s_volume = Cvar_Get ("s_volume", "0.7", CVAR_ARCHIVE) 
		s_khz = Cvar_Get ("s_khz", "11", CVAR_ARCHIVE) 
		s_loadas8bit = Cvar_Get ("s_loadas8bit", "1", CVAR_ARCHIVE) 
		s_mixahead = Cvar_Get ("s_mixahead", "0.2", CVAR_ARCHIVE) 
		s_show = Cvar_Get ("s_show", "0", 0) 
		s_testsound = Cvar_Get ("s_testsound", "0", 0) 
		s_primary = Cvar_Get ("s_primary", "0", CVAR_ARCHIVE) 	'// win32 specific
 

     SNDDMA_Init









    printf(!"sound sampling rate: %i\n", dma.speed) 



 
 	end if
 	
 	Com_Printf(!"------------------------------------\n")
 
 
 
		Cmd_AddCommand("play", @S_Play) 
		Cmd_AddCommand("stopsound", @S_StopAllSounds) 
		Cmd_AddCommand("soundlist", @S_SoundList) 
		Cmd_AddCommand("soundinfo", @S_SoundInfo_f) 
 
 		if ( SNDDMA_Init() = NULL) then
 			return 
 		EndIf
 
   	S_InitScaletable () 
 
 		sound_started = 1 
 		num_sfx = 0 
 
 		soundtime = 0 
 		paintedtime = 0 
 
 		Com_Printf (!"sound sampling rate: %i\n", dma.speed) 
 
 		S_StopAllSounds () 
 
 End Sub
