#Include "client\client.bi"
#Include "client\snd_loc.bi"
#Include "win32\winquake.bi"



'#define iDirectSoundCreate(a,b,c)	pDirectSoundCreate(a,b,c)
'
''HRESULT (WINAPI *pDirectSoundCreate)(GUID FAR *lpGUID, LPDIRECTSOUND FAR *lplpDS, IUnknown FAR *pUnkOuter);
'
''// 64K is > 1 second at 16-bit, 22050 Hz
'#define	WAV_BUFFERS				     64
'#define	WAV_MASK				      &H3F
'#define	WAV_BUFFER_SIZE	      &H0400
'#define  SECONDARY_BUFFER_SIZE	&H10000
'
  enum sndinitstat  
  
  SIS_SUCCESS, SIS_FAILURE, SIS_NOTAVAIL
  
  End Enum
' 
'cvar_t	*s_wavonly 
'
'static qboolean	dsound_init;
'static qboolean	wav_init;
'static qboolean	snd_firsttime = true, snd_isdirect, snd_iswave;
'static qboolean	primary_format_set;
'
''// starts at 0 for disabled
'static int	snd_buffer_count = 0;
'static int	sample16;
'static int	snd_sent, snd_completed;
'
''/* 
'' * Global variables. Must be visible to window-procedure function 
'' *  so it can unlock and free the data block after it has been played. 
'' */ 
'
'
'HANDLE		hData;
'HPSTR		lpData, lpData2;
'
'HGLOBAL		hWaveHdr;
'LPWAVEHDR	lpWaveHdr;
'
'HWAVEOUT    hWaveOut; 
'
'WAVEOUTCAPS	wavecaps;
'
'DWORD	gSndBufSize;
'
'MMTIME		mmstarttime;
'
'LPDIRECTSOUND pDS;
'LPDIRECTSOUNDBUFFER pDSBuf, pDSPBuf;
'
'HINSTANCE hInstDS;
'

'

function DS_CreateBuffers() as qboolean static
	printf( !"Creating DS buffers\n" ) 
	printf (!"...using secondary sound buffer\n") 
	
	
End Function


 

'*
'==================
'SNDDMA_InitDirect
'
'Direct-Sound support
'==================
'*/
function SNDDMA_InitDirect () as  sndinitstat 
	dim as DSCAPS		dscaps 	
	dim as HRESULT		hresult  	
	
	 dma.speed = 11025
	 
	 
    'Com_Printf( "Initializing DirectSound\n")
	  printf( !"Initializing DirectSound\n") 
	
	
	DS_CreateBuffers()
	
	
	
End Function
 

'	dma.channels = 2;
'	dma.samplebits = 16;
'
'	'if (s_khz->value == 44)
'	'	dma.speed = 44100;
'	'if (s_khz->value == 22)
'	'	dma.speed = 22050;
'	'else
'		dma.speed = 11025 
'
'	Com_Printf( "Initializing DirectSound\n");
'        printf( "Initializing DirectSound\n");
'	if ( !hInstDS )
'	{
'		Com_DPrintf( "...loading dsound.dll: " );
'
'		hInstDS = LoadLibrary("dsound.dll");
'		
'		if (hInstDS == NULL)
'		{
'			Com_Printf ("failed\n");
'			return SIS_FAILURE;
'		}
'
'		Com_DPrintf ("ok\n");
'		pDirectSoundCreate = (void *)GetProcAddress(hInstDS,"DirectSoundCreate");
'
'		if (!pDirectSoundCreate)
'		{
'			Com_Printf ("*** couldn't get DS proc addr ***\n");
'			return SIS_FAILURE;
'		}
'	}
'
'	Com_DPrintf( "...creating DS object: " );
'	while ( ( hresult = iDirectSoundCreate( NULL, &pDS, NULL ) ) != DS_OK )
'	{
'		if (hresult != DSERR_ALLOCATED)
'		{
'			Com_Printf( "failed\n" );
'			return SIS_FAILURE;
'		}
'
'		if (MessageBox (NULL,
'						"The sound hardware is in use by another app.\n\n"
'					    "Select Retry to try to start sound again or Cancel to run Quake with no sound.",
'						"Sound not available",
'						MB_RETRYCANCEL | MB_SETFOREGROUND | MB_ICONEXCLAMATION) != IDRETRY)
'		{
'			Com_Printf ("failed, hardware already in use\n" );
'			return SIS_NOTAVAIL;
'		}
'	}
'	Com_DPrintf( "ok\n" );
'
'	dscaps.dwSize = sizeof(dscaps);
'
'	if ( DS_OK != pDS->lpVtbl->GetCaps( pDS, &dscaps ) )
'	{
'		Com_Printf ("*** couldn't get DS caps ***\n");
'	}
'
'	if ( dscaps.dwFlags & DSCAPS_EMULDRIVER )
'	{
'		Com_DPrintf ("...no DSound driver found\n" );
'		FreeSound();
'		return SIS_FAILURE;
'	}
'
'	if ( !DS_CreateBuffers() )
'		return SIS_FAILURE;
'
'	dsound_init = true;
'
'	Com_DPrintf("...completed successfully\n" );
'
'	return SIS_SUCCESS;
'}'

