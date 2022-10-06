#Include "client\client.bi"
#Include "win32\winquake.bi"



dim shared as Integer originalmouseparms(3) 

dim shared as qboolean	mouseactive 	'// _false when not focus app

dim shared as  qboolean	restore_spi 
dim shared as  qboolean	mouseinitialized 

dim shared as Cvar_t ptr in_mouse
dim shared as Cvar_t ptr in_joystick

sub IN_StartupJoystick ()
	
	Com_Printf (!"\njoystick detected\n\n")
	
	
End Sub



sub IN_init
	'	// mouse variables
	'm_filter				= Cvar_Get ("m_filter",					"0",		0);
  in_mouse				= Cvar_Get ("in_mouse",					"1",		CVAR_ARCHIVE) 

	'// joystick variables
	 in_joystick				= Cvar_Get ("in_joystick",				"0",		CVAR_ARCHIVE) 
	'joy_name				= Cvar_Get ("joy_name",					"joystick",	0);
	'joy_advanced			= Cvar_Get ("joy_advanced",				"0",		0);
	'joy_advaxisx			= Cvar_Get ("joy_advaxisx",				"0",		0);
	'joy_advaxisy			= Cvar_Get ("joy_advaxisy",				"0",		0);
	'joy_advaxisz			= Cvar_Get ("joy_advaxisz",				"0",		0);
	'joy_advaxisr			= Cvar_Get ("joy_advaxisr",				"0",		0);
	'joy_advaxisu			= Cvar_Get ("joy_advaxisu",				"0",		0);
	'joy_advaxisv			= Cvar_Get ("joy_advaxisv",				"0",		0);
	'joy_forwardthreshold	= Cvar_Get ("joy_forwardthreshold",		"0.15",		0);
	'joy_sidethreshold		= Cvar_Get ("joy_sidethreshold",		"0.15",		0);
	'joy_upthreshold  		= Cvar_Get ("joy_upthreshold",			"0.15",		0);
	'joy_pitchthreshold		= Cvar_Get ("joy_pitchthreshold",		"0.15",		0);
	'joy_yawthreshold		= Cvar_Get ("joy_yawthreshold",			"0.15",		0);
	'joy_forwardsensitivity	= Cvar_Get ("joy_forwardsensitivity",	"-1",		0);
	'joy_sidesensitivity		= Cvar_Get ("joy_sidesensitivity",		"-1",		0);
	'joy_upsensitivity		= Cvar_Get ("joy_upsensitivity",		"-1",		0);
	'joy_pitchsensitivity	= Cvar_Get ("joy_pitchsensitivity",		"1",		0);
	'joy_yawsensitivity		= Cvar_Get ("joy_yawsensitivity",		"-1",		0);

	'// centering
	'v_centermove			= Cvar_Get ("v_centermove",				"0.15",		0);
	'v_centerspeed			= Cvar_Get ("v_centerspeed",			"500",		0);

	'Cmd_AddCommand ("+mlook", IN_MLookDown);
	'Cmd_AddCommand ("-mlook", IN_MLookUp);

	'Cmd_AddCommand ("joy_advancedupdate", Joy_AdvancedUpdate_f);

	'IN_StartupMouse ();
	 IN_StartupJoystick () 
	 
	
End Sub





'/*
'===========
'IN_DeactivateMouse
'
'Called when the window loses focus
'===========
'*/
sub IN_DeactivateMouse ()
 
	if ( mouseinitialized = NULL) then
		return
	EndIf
  
	if (mouseactive = NULL) then
			return
	EndIf
	

	if (restore_spi) then
				SystemParametersInfo (SPI_SETMOUSE, 0, @originalmouseparms(0), 0)
	EndIf
	
	
	mouseactive = _false 

	ClipCursor (NULL) 
	ReleaseCapture () 
	while (ShowCursor (_true) < 0) 
		
		
	Wend
		 
end sub


'/*
'===========
'IN_Shutdown
'===========
'*/

sub IN_Shutdown ()
	
		IN_DeactivateMouse ()
End Sub
 