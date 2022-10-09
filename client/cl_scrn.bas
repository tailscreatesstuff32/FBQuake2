#Include "client\client.bi"

dim shared as qboolean	scr_initialized


dim shared as cvar_t	ptr scr_viewsize 
dim shared as cvar_t	ptr scr_conspeed 
dim shared as cvar_t	ptr scr_centertime 
dim shared as cvar_t	ptr scr_showturtle 
dim shared as cvar_t	ptr scr_showpause 
dim shared as cvar_t	ptr scr_printspeed 

dim shared as cvar_t	ptr scr_netgraph 
dim shared as cvar_t	ptr scr_timegraph 
dim shared as cvar_t	ptr _scr_debuggraph 
dim shared as cvar_t	ptr scr_graphheight 
dim shared as cvar_t	ptr scr_graphscale 
dim shared as cvar_t	ptr scr_graphshift 
dim shared as cvar_t	ptr scr_drawall 



declare sub SCR_TimeRefresh_f ()
declare sub SCR_Loading_f ()




 
sub SCR_EndLoadingPlaque ()
  _cls.disable_screen = 0 
	 Con_ClearNotify () 
 
	
End Sub
 
 
 
 
' 
' /*
'=================
'SCR_SizeUp_f
'
'Keybinding command
'=================
'*/
sub SCR_SizeUp_f ()
	
	Cvar_SetValue ("viewsize",scr_viewsize->value+10) 
End Sub
 
'/*
'=================
'SCR_SizeDown_f
'
'Keybinding command
'=================
'*/
sub SCR_SizeDown_f ()
 
	Cvar_SetValue ("viewsize",scr_viewsize->value-10) 
End Sub

'/*
'=================
'SCR_Sky_f
'
'Set a specific sky and rotation speed
'=================
'*/
sub SCR_Sky_f ()
 
	'float	rotate;
	'vec3_t	axis;

	'if (Cmd_Argc() < 2)
	'{
'		Com_Printf ("Usage: sky <basename> <rotate> <axis x y z>\n");
	'	return;
	'}
	'if (Cmd_Argc() > 2)
	'	rotate = atof(Cmd_Argv(2));
	'else
	'	rotate = 0;
	'if (Cmd_Argc() == 6)
	'{
'		axis[0] = atof(Cmd_Argv(3));
	'	axis[1] = atof(Cmd_Argv(4));
	'	axis[2] = atof(Cmd_Argv(5));
	'}
	'else
	'{
'		axis[0] = 0;
	'	axis[1] = 0;
	'	axis[2] = 1;
	'}

	're.SetSky (Cmd_Argv(1), rotate, axis);
end sub

sub SCR_TimeRefresh_f
	
End Sub

sub SCR_Loading_f
	
	
End Sub

 


'/*
'==================
'SCR_Init
'==================
'*/
sub SCR_Init ()
	scr_viewsize = Cvar_Get ("viewsize", "100", CVAR_ARCHIVE)
	scr_conspeed = Cvar_Get ("scr_conspeed", "3", 0)
	scr_showturtle = Cvar_Get ("scr_showturtle", "0", 0)
	scr_showpause = Cvar_Get ("scr_showpause", "1", 0)
	scr_centertime = Cvar_Get ("scr_centertime", "2.5", 0)
	scr_printspeed = Cvar_Get ("scr_printspeed", "8", 0)
	scr_netgraph = Cvar_Get ("netgraph", "0", 0)
	scr_timegraph = Cvar_Get ("timegraph", "0", 0)
	_scr_debuggraph = Cvar_Get ("debuggraph", "0", 0)
	scr_graphheight = Cvar_Get ("graphheight", "32", 0)
	scr_graphscale = Cvar_Get ("graphscale", "1", 0)
	scr_graphshift = Cvar_Get ("graphshift", "0", 0)
	scr_drawall = Cvar_Get ("scr_drawall", "0", 0)
	
	
	
'	//
'// register our commands
'//
	Cmd_AddCommand ("timerefresh",@SCR_TimeRefresh_f) 
	Cmd_AddCommand ("loading",@SCR_Loading_f) 
	Cmd_AddCommand ("sizeup",@SCR_SizeUp_f) 
	Cmd_AddCommand ("sizedown",@SCR_SizeDown_f) 
	Cmd_AddCommand ("sky",@SCR_Sky_f) 

	scr_initialized = true 
End Sub
 
