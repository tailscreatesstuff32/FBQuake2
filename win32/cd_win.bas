
#define  WIN_INCLUDEALL
#include "windows.bi"
#Include "client\client.bi"





'IM NOT SURE HOW TO ACTUALLY PLAY THE MUSIC'''''''''''



extern as	HWND	cl_hwnd 

static shared as  qboolean cdValid = _false 
static shared as qboolean	playing = _false 
static shared as qboolean	wasPlaying = _false 
static shared as qboolean	initialized = _false 
static shared as qboolean	enabled = _false 
static shared as qboolean playLooping = _false 
static shared as ubyte 	remap(100) 
static shared as ubyte 	cdrom 
static shared as ubyte 	playTrack 
static shared as ubyte 	maxTrack 

dim shared as cvar_t ptr cd_nocd 
dim shared as  cvar_t  ptr cd_loopcount 
dim shared as  cvar_t ptr cd_looptrack 

dim shared as UINT	wDeviceID 

dim shared as integer 		loopcounter 


declare sub CDAudio_Pause()

sub CDAudio_Eject()
	
	dim	as DWORD	dwReturn 
      dwReturn =   mciSendCommand(wDeviceID, MCI_SET, MCI_SET_DOOR_OPEN, cast(DWORD,NULL))
    if (dwreturn) then
    	Com_DPrintf(!"MCI_SET_DOOR_OPEN failed (%i)\n", dwReturn)
    EndIf
    
	 
	
End Sub


sub CDAudio_CloseDoor()
	
	dim	as DWORD	dwReturn 
   dwReturn = mciSendCommand(wDeviceID, MCI_SET, MCI_SET_DOOR_CLOSED, cast(DWORD,NULL))
    if ( dwReturn ) then
    			Com_DPrintf(!"MCI_SET_DOOR_CLOSED failed (%i)\n", dwReturn) 
    	
    EndIf

	
	
End Sub

function CDAudio_GetAudioDiskInfo() as integer static
	 dim as DWORD				dwReturn 
	dim as MCI_STATUS_PARMS	mciStatusParms 


	cdValid = _false 

	mciStatusParms.dwItem = MCI_STATUS_READY 
    dwReturn = mciSendCommand(wDeviceID, MCI_STATUS, MCI_STATUS_ITEM or MCI_WAIT, cast(DWORD,cast(LPVOID,@mciStatusParms))) 
	if (dwReturn) then
		Com_DPrintf(!"CDAudio: drive ready test - get status failed\n")
		return -1
	EndIf
 
	if ( mciStatusParms.dwReturn = NULL) then
		Com_DPrintf(!"CDAudio: drive not ready\n")
		return -1
	EndIf
 

	mciStatusParms.dwItem = MCI_STATUS_NUMBER_OF_TRACKS 
    dwReturn = mciSendCommand(wDeviceID, MCI_STATUS, MCI_STATUS_ITEM or MCI_WAIT, cast(DWORD,cast(LPVOID,@mciStatusParms)) )
	if (dwReturn) then
			Com_DPrintf(!"CDAudio: get tracks - status failed\n") 
		return -1 
	EndIf
 
 
	if (mciStatusParms.dwReturn < 1) then
	 
		Com_DPrintf(!"CDAudio: no music tracks\n") 
		return -1 
	end if

	cdValid = _true 
	maxTrack = mciStatusParms.dwReturn 

	return 0 
	
End Function 

sub  CDAudio_Stop()
	dim as DWORD	dwReturn 

	if (enabled = _false) then
		return
	EndIf
  
	
	if (playing = _false) then
		return 
	EndIf
		 dwReturn = mciSendCommand(wDeviceID, MCI_STOP, 0, cast(DWORD,NULL))

    if (dwReturn) then
    	Com_DPrintf("MCI_STOP failed (%i)", dwReturn)
    EndIf 
	 
	wasPlaying = _false 
	playing = _false 
End Sub

sub CDAudio_Play2(track as Integer, looping as qboolean)
	dim as	DWORD				dwReturn 
    dim as	MCI_PLAY_PARMS		mciPlayParms 
	dim as	MCI_STATUS_PARMS	mciStatusParms 

	if (enabled = _false) then
		return
	EndIf
	 
	
	if (cdValid = _false) then
		CDAudio_GetAudioDiskInfo()
		if (cdValid = _false) then
			return
			
			
		EndIf
		
	EndIf
 
 

	track = remap(track) 

	if (track < 1 or track > maxTrack) then
		CDAudio_Stop()
		return
	EndIf


	''// don't try to play a non-audio track
	 mciStatusParms.dwItem = MCI_CDA_STATUS_TYPE_TRACK 
    mciStatusParms.dwTrack = track 
    dwReturn = mciSendCommand(wDeviceID, MCI_STATUS, MCI_STATUS_ITEM or MCI_TRACK or MCI_WAIT, cast(DWORD,cast(LPVOID, @mciStatusParms) ))
	 if (dwReturn) then
 
  		Com_DPrintf(!"MCI_STATUS failed (%i)\n", dwReturn) 
	 	return 
	 end if
	 if (mciStatusParms.dwReturn <> MCI_CDA_TRACK_AUDIO) then
	 	 Com_Printf(!"CDAudio: track %i is not audio\n", track) 
   	return 
	 	
	 EndIf
 
 
 

	'// get the length of the track to be played
	 mciStatusParms.dwItem = MCI_STATUS_LENGTH 
	 mciStatusParms.dwTrack = track 
    dwReturn = mciSendCommand(wDeviceID, MCI_STATUS, MCI_STATUS_ITEM or MCI_TRACK or MCI_WAIT, cast(DWORD,cast(LPVOID, @mciStatusParms))) 
	 if (dwReturn) then
	 	
	 	Com_DPrintf(!"MCI_STATUS failed (%i)\n", dwReturn)
	 	return
	 EndIf
 

	 if (playing) then
	 	if (playTrack  = track) then
	 		return
	 		
	 	EndIf
	 	
	 	CDAudio_Stop()
	 EndIf
 

    mciPlayParms.dwFrom = MCI_MAKE_TMSF(track, 0, 0, 0) 
	 mciPlayParms.dwTo = (mciStatusParms.dwReturn shl 8) or track 
     mciPlayParms.dwCallback = cast(DWORD,cl_hwnd) 
     dwReturn = mciSendCommand(wDeviceID, MCI_PLAY, MCI_NOTIFY or MCI_FROM or MCI_TO, cast(DWORD,cast(LPVOID, @mciPlayParms)) )
	 if (dwReturn) then
	 	Com_DPrintf("CDAudio: MCI_PLAY failed (%i)\n", dwReturn)
	 EndIf
	 
	 	return 
	 

	 playLooping = looping 
	 playTrack = track 
	 playing = _true 

	  if ( Cvar_VariableValue( "cd_nocd" ) ) then
	 		CDAudio_Pause () 
	  EndIf
	 
End Sub

sub CDAudio_Play(track as Integer, looping as qboolean)
	
	 loopcounter = 0 
	CDAudio_Play2(track, looping) 
	
End Sub





sub CDAudio_Pause()
	dim as	DWORD				dwReturn 
	dim as MCI_GENERIC_PARMS	mciGenericParms 

	if (enabled = _false) then
		return
	EndIf
		

	if ( playing = _false) then
		return 
	EndIf
		

	mciGenericParms.dwCallback = cast(DWORD,cl_hwnd)
	 dwReturn = mciSendCommand(wDeviceID, MCI_PAUSE, 0, cast(DWORD,cast(LPVOID, @mciGenericParms)))
    if (dwReturn) then
    	Com_DPrintf(!"MCI_PAUSE failed (%i)", dwReturn) 
    EndIf
		
		
	wasPlaying = playing 
	playing = _false 
	
	
End Sub

sub CDAudio_Resume()
		dim as DWORD			dwReturn 
    dim as 	MCI_PLAY_PARMS	mciPlayParms 

	if (enabled) then
		return 
	EndIf
		
	
	if (cdValid = _false) then
		return
	EndIf
		 

	if (wasPlaying = _false) then
		return
	EndIf
		 
	
    mciPlayParms.dwFrom = MCI_MAKE_TMSF(playTrack, 0, 0, 0) 
    mciPlayParms.dwTo = MCI_MAKE_TMSF(playTrack + 1, 0, 0, 0) 
    mciPlayParms.dwCallback = cast(DWORD,cl_hwnd) 
    dwReturn = mciSendCommand(wDeviceID, MCI_PLAY, MCI_TO or MCI_NOTIFY, cast(DWORD,cast(LPVOID, @mciPlayParms)))
	if (dwReturn) then
				Com_DPrintf(!"CDAudio: MCI_PLAY failed (%i)\n", dwReturn) 
		return 
	EndIf
 
	playing = _true 
	
End Sub



function CDAudio_MessageHandler(hWnd as HWND ,uMsg as UINT ,wParam as WPARAM ,lParam as LPARAM ) as LONG
	
		if (lParam <> wDeviceID) then
		 return 1 	
		EndIf
		select case (wParam)
 
		case MCI_NOTIFY_SUCCESSFUL 
			if (playing) then
		 
				playing = _false 
				if (playLooping) then
					'// if the track has played the given number of times,
					'// go to the ambient track
					   loopcounter+=1
						if (loopcounter >= cd_loopcount->value) then
						CDAudio_Play2(cd_looptrack->value, _true) 
					else
						CDAudio_Play2(playTrack, _true) 
		               EndIf
						EndIf
				 
						EndIf
				
	 
 

		case MCI_NOTIFY_ABORTED 
		case MCI_NOTIFY_SUPERSEDED 
	 

		case MCI_NOTIFY_FAILURE 
			Com_DPrintf(!"MCI_NOTIFY_FAILURE\n") 
			CDAudio_Stop ()  
			cdValid = _false 
	 

		case else
			Com_DPrintf(!"Unexpected MM_MCINOTIFY type (%i)\n", wParam) 
			return 1 
	end select
	
	
	
	
	
	
	
	
	
	
	
	return 0
End Function 
'{'
'	if (lParam != wDeviceID)'
'		return 1;
''
'	switch (wParam)
'	{
'		case MCI_NOTIFY_SUCCESSFUL:
'			if (playing)
'			{
'				playing = _false;
'				if (playLooping)
'				{
'					// if the track has played the given number of times,
'					// go to the ambient track
'					if (++loopcounter >= cd_loopcount->value)
'						CDAudio_Play2(cd_looptrack->value, _true);
'					else
'						CDAudio_Play2(playTrack, _true);
'				}
'			}
'			break;
'
'		case MCI_NOTIFY_ABORTED:
'		case MCI_NOTIFY_SUPERSEDED:
'			break;
'
'		case MCI_NOTIFY_FAILURE:
'			Com_DPrintf("MCI_NOTIFY_FAILURE\n");
'			CDAudio_Stop ();
'			cdValid = _false;
'			break;
'
'		default:
'			Com_DPrintf("Unexpected MM_MCINOTIFY type (%i)\n", wParam);
'			return 1;
'	}
'
'	return 0;
'}










sub CDAudio_Update()
	
	if ( cd_nocd->value <>  (enabled = _false )) then
		
		
		if ( cd_nocd->value ) then
	 
			CDAudio_Stop() 
			enabled = _false 
		 
		else
	 
			enabled = _true 
			CDAudio_Resume () 
		end if
		
	EndIf
	
	
End Sub
 
 








sub CD_f () static
 
	dim as zstring ptr	_command 
	dim as integer		ret 
	dim as integer		n 

	if (Cmd_Argc() < 2) then
		return
	EndIf
 
	_command = Cmd_Argv (1) 

	if (Q_strcasecmp(_command, "on") =  0) then
	 
		enabled = _true 
		return 
	end if

	if (Q_strcasecmp(_command, "off") =  0) then
	 
		if (playing) then
				 CDAudio_Stop() 
		EndIf
		
		enabled = _false 
		return 
	end if
 
 	if (Q_strcasecmp(_command, "reset") =  0) then
 
 		enabled = _true 
	if (playing) then
			 CDAudio_Stop() 
	EndIf
 	for n = 0 to 100 - 1 
	
	remap(n) = n 
	
	Next
		
 		CDAudio_GetAudioDiskInfo() 
 		return
 end if
  
 	if (Q_strcasecmp(_command, "remap") =  0) then
 		ret = Cmd_Argc() - 2
 		 		if (ret <= 0) then
 		  for n = 1 to 100-1
 				if (remap(n) <> n) then
 					Com_Printf(!"  %u -> %u\n", n, remap(n))
              return
 					
 				EndIf

 			Next
 		 		
 		 		EndIf
 		 	 do while n <= ret
 				remap(n) = atoi(Cmd_Argv (n+1))
 				n+=1
 			Loop
 
'
 	EndIf
 	

 	if (Q_strcasecmp(_command, "close") = 0) then
 		CDAudio_CloseDoor()
 		
 	EndIf

 	if (cdValid = NULL) then
 		CDAudio_GetAudioDiskInfo()
 		if (cdValid = NULL) then
 			
 			Com_Printf(!"No CD in player.\n")
 			return
 		EndIf
 	EndIf
 
 	if (Q_strcasecmp(command, "play")  = 0) then
 		'CDAudio_Play(atoi(Cmd_Argv (2)), _false)
 		return
 	EndIf
 
 	if (Q_strcasecmp(_command, "loop") = 0) then
 		'CDAudio_Play(atoi(Cmd_Argv (2)) , _true)
 		return
 	EndIf
 
 
	if (Q_strcasecmp(_command, "stop") =  0) then
		CDAudio_Stop()
		return
	EndIf
 
	if (Q_strcasecmp(_command, "pause") =  0) then
      CDAudio_Pause() 
		return 
	EndIf
 
 
 	if (Q_strcasecmp(_command, "resume")  = 0) then
 		CDAudio_Resume()
 		return
 	EndIf
 
 	if (Q_strcasecmp(_command, "eject") = 0) then
 		if (playing) then
 			CDAudio_Stop()
 			CDAudio_Eject()
 			cdValid = _false
 			return
 		EndIf
 		
 	EndIf
 
 
 	if (Q_strcasecmp(_command, "info")  = 0) then
 		Com_Printf(!"%u tracks\n", maxTrack)
 		if (playing) then
 			
 			Com_Printf("!Currently %s track %u\n", iif(playLooping,  "looping" , "playing"), playTrack)
 		elseif (wasPlaying) then
 			
 			Com_Printf(!"Paused %s track %u\n", iif(playLooping,  "looping" , "playing"), playTrack) 

 		EndIf
 		
 		return
 	EndIf
 
End Sub



 

function CDAudio_Init() as Integer
	
	dim as DWORD	dwReturn 
	dim as MCI_OPEN_PARMS	mciOpenParms 
   dim as  MCI_SET_PARMS	mciSetParms 
	dim as integer				n 

	cd_nocd = Cvar_Get ("cd_nocd", "0", CVAR_ARCHIVE ) 
	cd_loopcount = Cvar_Get ("cd_loopcount", "4", 0) 
	cd_looptrack = Cvar_Get ("cd_looptrack", "11", 0) 
	if ( cd_nocd->value) then
		return -1 
	EndIf
		
		

	mciOpenParms.lpstrDeviceType = @"cdaudio" 
	
	dwReturn = mciSendCommand(0, MCI_OPEN, MCI_OPEN_TYPE or MCI_OPEN_SHAREABLE, cast(DWORD, cast(LPVOID,@mciOpenParms)))
	if (dwReturn) then
		Com_Printf(!"CDAudio_Init: MCI_OPEN failed (%i)\n", dwReturn) 
		return -1 
	EndIf
 
	wDeviceID = mciOpenParms.wDeviceID 

    ''// Set the time format to track/minute/second/frame (TMSF).
    mciSetParms.dwTimeFormat = MCI_FORMAT_TMSF 
    if (dwReturn) then
  
	'	Com_Printf("MCI_SET_TIME_FORMAT failed (%i)\n", dwReturn);
         mciSendCommand(wDeviceID, MCI_CLOSE, 0, cast(DWORD,NULL)) 
		 return -1 
     end if

	for n = 0 to 100 - 1 
	
	remap(n) = n 
	
	Next
		
	initialized = _true 
	enabled = _true 

	 if (CDAudio_GetAudioDiskInfo()) then
		
   	 Com_Printf(!"CDAudio_Init: No CD in player.\n") 
		cdValid = _false 
		enabled = _false 
		
	 EndIf
	 

	 

	 Cmd_AddCommand ("cd", @CD_f) 
	Com_Printf(!"CD Audio Initialized\n") 

	return 0 
	
	
End Function
 
 
'/*
'===========
'CDAudio_Activate
'
'Called when the main window gains or loses focus.
'The window have been destroyed and recreated
'between a deactivate and an activate.
'===========
'*/
sub CDAudio_Activate (active as qboolean )
  if (active) then
		CDAudio_Resume () 
	else
		CDAudio_Pause () 
	end if
End Sub
 
 