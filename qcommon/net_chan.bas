#Include "qcommon\qcommon.bi"




dim shared as cvar_t ptr showpackets 


dim shared as cvar_t ptr showdrop 


dim shared as cvar_t ptr qport 


dim shared as netadr_t	net_from 

dim shared as sizebuf_t	net_message 

dim shared as ubyte		net_message_buffer(MAX_MSGLEN) 

'/*
'===============
'Netchan_Init
'
'===============
'*/
sub Netchan_Init ()
		dim as integer		port 
	'// pick a port value that should be nice and random
	port = Sys_Milliseconds() and &Hffff 
	showpackets = Cvar_Get ("showpackets", "0", 0) 
	qport = Cvar_Get ("qport", _va("%i", port), CVAR_NOSET) 
   showdrop = Cvar_Get ("showdrop", "0", 0) 
End Sub
 

 