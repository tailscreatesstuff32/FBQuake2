#Include "client\client.bi"

dim shared as client_static_t	_cls
'dim shared as client_state_t	cl

dim shared as cvar_t	ptr freelook

dim shared as cvar_t	ptr adr0
dim shared as cvar_t	ptr adr1
dim shared as cvar_t	ptr adr2
dim shared as cvar_t	ptr adr3
dim shared as cvar_t	ptr adr4
dim shared as cvar_t	ptr adr5
dim shared as cvar_t	ptr adr6
dim shared as cvar_t	ptr adr7
dim shared as cvar_t	ptr adr8

dim shared as cvar_t	ptr cl_stereo_separation
dim shared as cvar_t	ptr cl_stereo

dim shared as cvar_t	ptr rcon_client_password
dim shared as cvar_t	ptr rcon_address

dim shared as cvar_t	ptr cl_noskins
dim shared as cvar_t	ptr cl_autoskins
dim shared as cvar_t	ptr cl_footsteps
dim shared as cvar_t	ptr cl_timeout
dim shared as cvar_t	ptr cl_predict
'//dim shared as cvar_t	ptr cl_minfps
dim shared as cvar_t	ptr cl_maxfps
dim shared as cvar_t	ptr cl_gun

dim shared as cvar_t	ptr cl_add_particles
dim shared as cvar_t	ptr cl_add_lights
dim shared as cvar_t	ptr cl_add_entities
dim shared as cvar_t	ptr cl_add_blend

dim shared as cvar_t	ptr cl_shownet
dim shared as cvar_t	ptr cl_showmiss
dim shared as cvar_t	ptr cl_showclamp

dim shared as cvar_t	ptr cl_paused
dim shared as cvar_t	ptr cl_timedemo

dim shared as cvar_t	ptr lookspring
dim shared as cvar_t	ptr lookstrafe
dim shared as cvar_t	ptr sensitivity

dim shared as cvar_t	ptr m_pitch
dim shared as cvar_t	ptr m_yaw
dim shared as cvar_t	ptr m_forward
dim shared as cvar_t	ptr m_side

dim shared as cvar_t	ptr cl_lightlevel

'//
'// userinfo
'//
dim shared as cvar_t	ptr info_password
dim shared as cvar_t	ptr info_spectator
dim shared as cvar_t	ptr _name
dim shared as cvar_t	ptr skin
dim shared as cvar_t	ptr rate
dim shared as cvar_t	ptr fov
dim shared as cvar_t	ptr msg
dim shared as cvar_t	ptr hand
dim shared as cvar_t	ptr gender
dim shared as cvar_t	ptr gender_auto

dim shared as cvar_t	ptr cl_vwep 







extern as	cvar_t ptr allow_download
extern as	cvar_t ptr allow_download_players
extern as	cvar_t ptr allow_download_models
extern as	cvar_t ptr allow_download_sounds
extern as	cvar_t ptr allow_download_maps


sub CL_Disconnect
	
	
	
End Sub

sub CL_Quit_f
	
	CL_Disconnect () 
	Com_Quit () 
End Sub


sub CL_ForwardToServer_f
	
	
	
End Sub


sub CL_Pause_f
	
End Sub

sub CL_PingServers_f
	
End Sub

sub CL_Skins_f
	
End Sub

sub CL_Userinfo_f
	
End Sub


sub CL_Snd_Restart_f
	
End Sub


sub CL_Changing_f
	
End Sub

sub CL_Disconnect_f
	
End Sub

sub CL_Record_f
	
	
End Sub

sub CL_Stop_f
	
	
End Sub

sub CL_Connect_f
	
End Sub

sub CL_Reconnect_f
	
End Sub


sub CL_Rcon_f
	
	
End Sub


sub CL_Setenv_f 
	
	
End Sub

sub CL_Precache_f
	
	
End Sub

sub CL_Download_f
	
	
End Sub

 
'/*
'=================
'CL_InitLocal
'=================
'*/
sub CL_InitLocal ()
'{'
'cls.state = ca_disconnected;'
'cls.realtime = Sys_Milliseconds ();
'
CL_InitInput ()
'
	adr0 = Cvar_Get( "adr0", "", CVAR_ARCHIVE ) 
	adr1 = Cvar_Get( "adr1", "", CVAR_ARCHIVE ) 
	adr2 = Cvar_Get( "adr2", "", CVAR_ARCHIVE ) 
	adr3 = Cvar_Get( "adr3", "", CVAR_ARCHIVE ) 
	adr4 = Cvar_Get( "adr4", "", CVAR_ARCHIVE ) 
	adr5 = Cvar_Get( "adr5", "", CVAR_ARCHIVE ) 
	adr6 = Cvar_Get( "adr6", "", CVAR_ARCHIVE ) 
	adr7 = Cvar_Get( "adr7", "", CVAR_ARCHIVE ) 
	adr8 = Cvar_Get( "adr8", "", CVAR_ARCHIVE ) 
'
'//
'// register our variables
'//
	cl_stereo_separation = Cvar_Get( "cl_stereo_separation", "0.4", CVAR_ARCHIVE )
	cl_stereo = Cvar_Get( "cl_stereo", "0", 0 )

	cl_add_blend = Cvar_Get ("cl_blend", "1", 0)
	cl_add_lights = Cvar_Get ("cl_lights", "1", 0)
	cl_add_particles = Cvar_Get ("cl_particles", "1", 0)
	cl_add_entities = Cvar_Get ("cl_entities", "1", 0)
	cl_gun = Cvar_Get ("cl_gun", "1", 0)
	cl_footsteps = Cvar_Get ("cl_footsteps", "1", 0)
	cl_noskins = Cvar_Get ("cl_noskins", "0", 0)
	cl_autoskins = Cvar_Get ("cl_autoskins", "0", 0)
	cl_predict = Cvar_Get ("cl_predict", "1", 0)
'//	cl_minfps = Cvar_Get ("cl_minfps", "5", 0)
	cl_maxfps = Cvar_Get ("cl_maxfps", "90", 0)

	cl_upspeed = Cvar_Get ("cl_upspeed", "200", 0)
	cl_forwardspeed = Cvar_Get ("cl_forwardspeed", "200", 0)
	cl_sidespeed = Cvar_Get ("cl_sidespeed", "200", 0)
	cl_yawspeed = Cvar_Get ("cl_yawspeed", "140", 0)
	cl_pitchspeed = Cvar_Get ("cl_pitchspeed", "150", 0)
	cl_anglespeedkey = Cvar_Get ("cl_anglespeedkey", "1.5", 0)

	cl_run = Cvar_Get ("cl_run", "0", CVAR_ARCHIVE)
	freelook = Cvar_Get( "freelook", "0", CVAR_ARCHIVE )
	lookspring = Cvar_Get ("lookspring", "0", CVAR_ARCHIVE)
	lookstrafe = Cvar_Get ("lookstrafe", "0", CVAR_ARCHIVE)
	sensitivity = Cvar_Get ("sensitivity", "3", CVAR_ARCHIVE)

	m_pitch = Cvar_Get ("m_pitch", "0.022", CVAR_ARCHIVE)
	m_yaw = Cvar_Get ("m_yaw", "0.022", 0)
	m_forward = Cvar_Get ("m_forward", "1", 0)
	m_side = Cvar_Get ("m_side", "1", 0)

	cl_shownet = Cvar_Get ("cl_shownet", "0", 0)
	cl_showmiss = Cvar_Get ("cl_showmiss", "0", 0)
	cl_showclamp = Cvar_Get ("showclamp", "0", 0)
	cl_timeout = Cvar_Get ("cl_timeout", "120", 0)
	cl_paused = Cvar_Get ("paused", "0", 0)
	cl_timedemo = Cvar_Get ("timedemo", "0", 0)

	rcon_client_password = Cvar_Get ("rcon_password", "", 0)
	rcon_address = Cvar_Get ("rcon_address", "", 0)

	cl_lightlevel = Cvar_Get ("r_lightlevel", "0", 0)
'
'	//
'	// userinfo
'	//
	info_password = Cvar_Get ("password", "", _CVAR_USERINFO) 
	info_spectator = Cvar_Get ("spectator", "0", _CVAR_USERINFO) 
	_name = Cvar_Get ("name", "unnamed", _CVAR_USERINFO or CVAR_ARCHIVE) 
	skin = Cvar_Get ("skin", "male/grunt", _CVAR_USERINFO or CVAR_ARCHIVE) 
	rate = Cvar_Get ("rate", "25000", _CVAR_USERINFO or CVAR_ARCHIVE) 	'// FIXME
	msg = Cvar_Get ("msg", "1", _CVAR_USERINFO or CVAR_ARCHIVE) 
	hand = Cvar_Get ("hand", "0", _CVAR_USERINFO or CVAR_ARCHIVE) 
	fov = Cvar_Get ("fov", "90", _CVAR_USERINFO or CVAR_ARCHIVE) 
	gender = Cvar_Get ("gender", "male", _CVAR_USERINFO or CVAR_ARCHIVE) 
	gender_auto = Cvar_Get ("gender_auto", "1", CVAR_ARCHIVE) 
	gender->modified = false  '// clear this so we know when user sets it manually

	cl_vwep = Cvar_Get ("cl_vwep", "1", CVAR_ARCHIVE) 
'
'
'	//
'	// register our commands
'	//
	Cmd_AddCommand ("cmd", @CL_ForwardToServer_f)
	Cmd_AddCommand ("pause", @CL_Pause_f)
	Cmd_AddCommand ("pingservers", @CL_PingServers_f)
	Cmd_AddCommand ("skins", @CL_Skins_f)

	Cmd_AddCommand ("userinfo", @CL_Userinfo_f)
	Cmd_AddCommand ("snd_restart", @CL_Snd_Restart_f)

	Cmd_AddCommand ("changing", @CL_Changing_f)
	Cmd_AddCommand ("disconnect", @CL_Disconnect_f)
	Cmd_AddCommand ("record", @CL_Record_f)
	Cmd_AddCommand ("stop", @CL_Stop_f)

 	Cmd_AddCommand ("quit", @CL_Quit_f) 

	Cmd_AddCommand ("connect", @CL_Connect_f)
	Cmd_AddCommand ("reconnect", @CL_Reconnect_f)

	Cmd_AddCommand ("rcon", @CL_Rcon_f)

'// 	Cmd_AddCommand ("packet", @CL_Packet_f) // this is dangerous to leave in

	Cmd_AddCommand ("setenv", @CL_Setenv_f )

	Cmd_AddCommand ("precache", @CL_Precache_f)

	Cmd_AddCommand ("download", @CL_Download_f)
'
'	//
'	// forward to server commands
'	//
'	// the only thing this does is allow command completion
'	// to work -- all unknown commands are automatically
'	// forwarded to the server
	Cmd_AddCommand ("wave", NULL)
	Cmd_AddCommand ("inven", NULL)
	Cmd_AddCommand ("kill", NULL)
	Cmd_AddCommand ("use", NULL)
	Cmd_AddCommand ("drop", NULL)
	Cmd_AddCommand ("say", NULL)
	Cmd_AddCommand ("say_team", NULL)
	Cmd_AddCommand ("info", NULL)
	Cmd_AddCommand ("prog", NULL)
	Cmd_AddCommand ("give", NULL)
	Cmd_AddCommand ("god", NULL)
	Cmd_AddCommand ("notarget", NULL)
	Cmd_AddCommand ("noclip", NULL)
	Cmd_AddCommand ("invuse", NULL)
	Cmd_AddCommand ("invprev", NULL)
	Cmd_AddCommand ("invnext", NULL)
	Cmd_AddCommand ("invdrop", NULL)
	Cmd_AddCommand ("weapnext", NULL)
	Cmd_AddCommand ("weapprev", NULL)


end sub







'//======================================================================
'
'/*
'===================
'Cmd_ForwardToServer
'
'adds the current command line as a clc_stringcmd to the client message.
'things like godmode, noclip, etc, are commands directed to the server,
'so when they are typed in at the console, they will need to be forwarded.
'===================
'*/
sub Cmd_ForwardToServer ()
	dim as zstring ptr cmd

	cmd = Cmd_Argv(0)

	if (_cls.state <= ca_connected or *cmd = asc("-") or *cmd =  asc("+")) then
		Com_Printf (!"Unknown  command \"%s\"\n", cmd)
		return
	EndIf

	'MSG_WriteByte (&cls.netchan.message, clc_stringcmd);
	'SZ_Print (&cls.netchan.message, cmd);
	if (Cmd_Argc() > 1) then

		'	SZ_Print (@_cls.netchan.message, " ")
		'SZ_Print (@_cls.netchan.message, Cmd_Args())

	EndIf

End Sub




sub cl_init

if (dedicated->value) then
return		'// nothing running on the client
EndIf

'
'	// all archived variables will now be loaded
'

'FINISHED FOR NOW''''
Con_Init ()
''''''''''''''''''''

#if defined (__linux__) or defined (__sgi)
'	S_Init ()
VID_Init ()
#else

'FINISHED FOR NOW''''
VID_Init ()
'''''''''''''''''''''

'FINISHED FOR NOW''''
S_Init () 	'// sound must be initialized after window is created
'''''''''''''''''''''

#endif


'FINISHED FOR NOW''''
V_Init ()
''''''''''''''''''''

'FINISHED FOR NOW''''
net_message._data = @net_message_buffer(0)
net_message.maxsize = sizeof(net_message_buffer)
''''''''''''''''''''

'FINISHED FOR NOW''''
M_Init ()
'''''''''''''''''''''

'FINISHED FOR NOW''''
SCR_Init ()
'''''''''''''''''''''

'FINISHED FOR NOW''''
 _cls.disable_screen = _true 	'// don't draw yet
'''''''''''''''''''''

'FINISHED FOR NOW''''
CDAudio_Init ()
'''''''''''''''''''''

'FINISHED FOR NOW''''
CL_InitLocal ()
'''''''''''''''''''''



'NOT FINISHED''''''''
IN_Init ()
'''''''''''''''''''''
 
'FINISHED FOR NOW''''
'//Cbuf_AddText ("exec autoexec.cfg\n");
FS_ExecAutoexec ()
'''''''''''''''''''''

'FINISHED FOR NOW''''
Cbuf_Execute ()
'''''''''''''''''''''

End Sub



'/*
'===============
'CL_WriteConfiguration
'
'Writes key bindings and archived cvars to config.cfg
'===============
'*/
sub CL_WriteConfiguration ()
	dim as FILE	ptr f
	'sleep

	dim as zstring *	MAX_QPATH path


	'temporary''''''''''
	_cls.state = ca_connecting
	''''''''''''''''''''


	if (_cls.state = ca_uninitialized) then
		return
	EndIf

	Com_sprintf (path, sizeof(path),!"%s/config.cfg",FS_Gamedir())

	'	'print  path
	'
	'
	'
	f = fopen (path, "w" )
	if ( f = NULL) then
		Com_Printf (!"Couldn't write config.cfg.\n")
		return
	EndIf


	'
	fprintf (f, !"// generated by quake, do not modify\n")
	'
	Key_WriteBindings (f)
	fclose (f)

	Cvar_WriteVariables (path)


End Sub













sub  CL_Shutdown()

	static  as	qboolean isdown = _false




	if (isdown) then

		printf (!"recursive shutdown\n")
  
		return
	EndIf

	isdown = _true

	CL_WriteConfiguration ()

	CDAudio_Shutdown () 
	'S_Shutdown();
	IN_Shutdown () 'FINISHED
	VID_Shutdown()

End Sub
