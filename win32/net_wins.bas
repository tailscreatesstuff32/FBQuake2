
#include "win\winsock.bi"
#include "win\wsipx.bi"
#Include "qcommon\qcommon.bi"

dim shared as cvar_t ptr net_shownet 
static shared as   cvar_t	ptr noudp 
static  shared as  cvar_t	ptr noipx 

 static shared as WSADATA		winsockdata 
'
'/*
'====================
'NET_Init
'====================
'*/
sub NET_Init  ()
	 
dim as WORD	wVersionRequested 
dim as integer		r 
'
 	wVersionRequested = MAKEWORD(1, 1)  
'
'	r = WSAStartup (MAKEWORD(1, 1), @winsockdata) 

'	if (r) then
'		Com_Error (ERR_FATAL,"Winsock initialization failed.") 
 'end if
'	Com_Printf(!"Winsock Initialized\n") 
'
 	noudp = Cvar_Get ("noudp", "0", CVAR_NOSET) 
 	noipx = Cvar_Get ("noipx", "0", CVAR_NOSET) 
'
 	net_shownet = Cvar_Get ("net_shownet", "0", 0) 
'}
End Sub
