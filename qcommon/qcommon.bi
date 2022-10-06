'FINISHED FOR NOW''''''''''''''''''''''''''''''''''''''''



'the first include
#Include once "Game\qshared.bi"


#define	_VERSION		3.21
#define	BASEDIRNAME	"baseq2"



'FINISHED FOR NOW'''''''''''''''''
#Include once "qcommon\qfiles.bi"
''''''''''''''''''''''''''''''''''

#ifdef __FB_WIN32__

#ifndef __FB_DEBUG__
#define BUILDSTRING "Win32 RELEASE"
#else
#define BUILDSTRING "Win32 DEBUG"
#endif

'#ifdef _M_IX86
#ifdef __FB_WIN32__
#define	CPUSTRING	"x86"
#elseif defined (_M_ALPHA)
#define	CPUSTRING	"AXP"
#endif


#elseif defined (__linux__)

#define BUILDSTRING "Linux"

#ifdef __i386__
#define CPUSTRING "i386"
#elseif defined __alpha__
#define CPUSTRING "axp"
#else
#define CPUSTRING "Unknown"
#endif

#elseif defined (__sun__)

#define BUILDSTRING "Solaris"

#ifdef __i386__
#define CPUSTRING "i386"
#else
#define CPUSTRING "sparc"
#endif

#else	 

#define BUILDSTRING "NON-WIN32"
#define	CPUSTRING	"NON-WIN32"

#endif


type  sizebuf_s
	
	allowoverflow as qboolean 
	overflowed as qboolean	
	 _data as ubyte ptr
	maxsize  as integer		
	cursize  as integer		
  readcount	as integer		 	
End Type :type sizebuf_t as  sizebuf_s
 

   declare sub SZ_Init (buf as sizebuf_t ptr,_data as ubyte ptr,length as integer ) 
   declare sub SZ_Clear (buf as sizebuf_t ptr) 
   declare function SZ_GetSpace (buf as sizebuf_t ptr,  _length as integer) as any ptr
   declare sub SZ_Write (buf as sizebuf_t ptr,_data as any ptr, _length as integer ) 
   declare sub SZ_Print (buf as sizebuf_t ptr,_data as any ptr) 
'
'//============================================================================
'

'struct usercmd_s;
'struct entity_state_s;
'type usercmd_s as any ptr
'type entity_state_s as any ptr


declare sub MSG_WriteChar (sb as sizebuf_t ptr,c as  integer ) 
declare sub MSG_WriteByte (sb as sizebuf_t ptr,c as  integer) 
declare sub MSG_WriteShort (sb as sizebuf_t ptr,c as  integer) 
declare sub MSG_WriteLong (sb as sizebuf_t ptr,c as  integer) 
declare sub MSG_WriteFloat (sb as sizebuf_t ptr,f as float ) 
declare sub MSG_WriteString (sb as sizebuf_t ptr,s as  zstring ptr) 
declare sub MSG_WriteCoord (sb as sizebuf_t ptr,f as float )
declare sub MSG_WritePos (sb as sizebuf_t ptr, pos as vec3_t ) 
declare sub MSG_WriteAngle (sb as sizebuf_t ptr,f as float ) 
declare sub MSG_WriteAngle16 (sb as sizebuf_t ptr,f as float ) 
declare sub MSG_WriteDeltaUsercmd (sb as sizebuf_t ptr,_from as usercmd_s ptr , cmd as usercmd_s ptr) 
declare sub MSG_WriteDeltaEntity (_from as entity_state_s ptr ,  _to  as entity_state_s,msg as  sizebuf_t ptr, force as qboolean,newentity as qboolean ) 
declare sub MSG_WriteDir (sb as sizebuf_t ptr,_vector as vec3_t ) 


declare sub 	MSG_BeginReading (sb as sizebuf_t ptr)

declare function	MSG_ReadChar (sb as sizebuf_t ptr) as integer	 
declare function		MSG_ReadByte (sb as sizebuf_t ptr) as integer	
declare function	MSG_ReadShort (sb as sizebuf_t ptr) as integer	
declare function		MSG_ReadLong (sb as sizebuf_t ptr) as integer	
declare function	MSG_ReadFloat (sb as sizebuf_t ptr) as float	
declare function MSG_ReadString (sb as sizebuf_t ptr)  as zstring ptr	
declare function MSG_ReadStringLine (sb as sizebuf_t ptr) as zstring ptr	

declare function MSG_ReadCoord (sb as sizebuf_t ptr) as float	
declare sub MSG_ReadPos (sb as sizebuf_t ptr, _pos as vec3_t) 
declare function	MSG_ReadAngle (sb as sizebuf_t ptr) as  float
declare function MSG_ReadAngle16 (sb as sizebuf_t ptr) as  float
declare sub MSG_ReadDeltaUsercmd (sb as sizebuf_t ptr,_from as usercmd_s ptr , cmd as usercmd_s ptr)
declare sub MSG_ReadDir (sb as sizebuf_t ptr, _vector as vec3_t ) 

declare sub 	MSG_ReadData (sb as sizebuf_t ptr,buffer as  any ptr,size as integer ) 







'extern	bigendien  as qboolean		

 'extern	BigShort (l as short ) as short
 'extern	LittleShort (l as short ) as short
 'extern	BigLong ( l as integer) as integer		
 'extern	LittleLong (l as integer ) as integer	
 'extern	BigFloat (l as float ) as float
 'extern	LittleFloat (l as float ) as float	
 
 
 
 
 
declare function	COM_Argc () as integer
declare function COM_Argv (arg as integer)  as zstring ptr
declare sub COM_ClearArgv (arg as integer ) 
declare function COM_CheckParm (param as zstring ptr) as Integer
declare sub COM_AddParm (param as zstring ptr) 
 
declare sub COM_Init ()
declare sub COM_InitArgv (argc as integer , argv as zstring ptr ptr ) 
 
declare function  CopyString (_in as zstring ptr) as zstring ptr
 
'//============================================================================
 
declare sub Info_Print (s as zstring ptr ) 
 
declare sub CRC_Init(crcvalue as ushort ptr)
declare sub CRC_ProcessByte(crcvalue as ushort ptr ,_data as ubyte ) 
declare function CRC_Value( crcvalue as ushort) as ushort
declare function CRC_Block (_start as ubyte ptr, _count as integer ) as ushort



 
 
 
 
 
 
 
 
 
 
 
 
'==============================================================

' PROTOCOL
'
'==============================================================
'*/
'
'// protocol.h -- communications protocols
'
#define	PROTOCOL_VERSION	34
'
'//=========================================

#define	PORT_MASTER	27900
#define	PORT_CLIENT	27901
#define	PORT_SERVER	27910

'//=========================================

#define	UPDATE_BACKUP	16	
						
#define	UPDATE_MASK		(UPDATE_BACKUP-1)
 
 
 
 
 
 
 
 
 
'//
'// server to client
'//
enum svc_ops_e

	svc_bad,
	svc_muzzleflash,
	svc_muzzleflash2,
	svc_temp_entity,
	svc_layout,
	svc_inventory,
	svc_nop,
	svc_disconnect,
	svc_reconnect,
	svc_sound,					
	svc_print,					
	svc_stufftext,				
	svc_serverdata,				
	svc_configstring,			
	svc_spawnbaseline,		
	svc_centerprint,			
	svc_download,				
	svc_playerinfo,				
	svc_packetentities,			
	svc_deltapacketentities,	
	svc_frame


End Enum
 
 
 
 
 
 
 


enum clc_ops_e
	clc_bad,
	clc_nop, 		
	clc_move,			 
	clc_userinfo,		 
	clc_stringcmd	

End Enum
 
		 
 

#define	PS_M_TYPE			(1 shl 0)
#define	PS_M_ORIGIN			(1 shl 1)
#define	PS_M_VELOCITY		(1 shl 2)
#define	PS_M_TIME			(1 shl 3)
#define	PS_M_FLAGS			(1 shl 4)
#define	PS_M_GRAVITY		(1 shl 5)
#define	PS_M_DELTA_ANGLES	(1 shl 6)

#define	PS_VIEWOFFSET		(1 shl 7)
#define	PS_VIEWANGLES		(1 shl 8)
#define	PS_KICKANGLES		(1 shl 9)
#define	PS_BLEND			   (1 shl 10)
#define	PS_FOV				(1 shl 11)
#define	PS_WEAPONINDEX		(1 shl 12)
#define	PS_WEAPONFRAME		(1 shl 13)
#define	PS_RDFLAGS			(1 shl 14)


#define	CM_ANGLE1 	(1 shl 0)
#define	CM_ANGLE2 	(1 shl 1)
#define	CM_ANGLE3 	(1 shl 2)
#define	CM_FORWARD	(1 shl 3)
#define	CM_SIDE		(1 shl 4)
#define	CM_UP		   (1 shl 5)
#define	CM_BUTTONS	(1 shl 6)
#define	CM_IMPULSE	(1 shl 7)

#define	SND_VOLUME		(1 shl 0)		// a byte
#define	SND_ATTENUATION	(1 shl 1)		// a byte
#define	SND_POS			(1 shl 2)		// three coordinates
#define	SND_ENT			(1 shl 3)		// a short 0-2: channel, 3-12: entity
#define	SND_OFFSET		(1 shl 4)

#define DEFAULT_SOUND_PACKET_VOLUME	1.0
#define DEFAULT_SOUND_PACKET_ATTENUATION 1.0


#define	U_ORIGIN1	(1 shl 0)
#define	U_ORIGIN2	(1 shl 1)
#define	U_ANGLE2	   (1 shl 2)
#define	U_ANGLE3	   (1 shl 3)
#define	U_FRAME8	(1 shl 4)		 
#define	U_EVENT		(1 shl 5)
#define	U_REMOVE	(1 shl 6)		 
#define	U_MOREBITS1	(1 shl 7)		 

 
#define	U_NUMBER16	(1 shl 8)	 
#define	U_ORIGIN3	(1 shl 9)
#define	U_ANGLE1	   (1 shl 10)
#define	U_MODEL		(1 shl 11)
#define U_RENDERFX8	(1 shl 12)		 
#define	U_EFFECTS8	(1 shl 14)		 
#define	U_MOREBITS2	(1 shl 15)		 

 
#define	U_SKIN8		(1 shl 16)
#define	U_FRAME16	(1 shl 17)		 
#define	U_RENDERFX16 (1 shl 18)	 
#define	U_EFFECTS16	(1 shl 19)		 
#define	U_MODEL2	   (1 shl 20)		 
#define	U_MODEL3	  (1 shl 21)
#define	U_MODEL4	   (1 shl 22)
#define	U_MOREBITS3	(1 shl 23)		 

 
#define	U_OLDORIGIN	(1 shl 24)		 
#define	U_SKIN16	   (1 shl 25)
#define	U_SOUND		(1 shl 26)
#define	U_SOLID		(1 shl 27)

declare sub Netchan_Init ()


'/*
'==============================================================
'
'CMD
'
'Command text buffering and command execution
'
'==============================================================


#define	EXEC_NOW	0		 
#define	EXEC_INSERT	1	 
#define	EXEC_APPEND	2	 
'
declare sub Cbuf_Init () 
declare sub Cbuf_AddText (text as ZString ptr) 
declare sub Cbuf_InsertText (text as ZString ptr) 
declare sub Cbuf_ExecuteText (exec_when as integer ,  text as ZString ptr) 
declare sub	Cbuf_AddEarlyCommands (_clear as qboolean ) 
declare function Cbuf_AddLateCommands () as qboolean
declare sub	Cbuf_Execute () 
declare sub	 Cbuf_CopyToDefer ()
declare sub	Cbuf_InsertFromDefer ()

type xcommand_t as sub()

declare sub		Cmd_Init () 
declare sub	Cmd_AddCommand (cmd_name  as ZString ptr, _function as  xcommand_t ) 
declare sub	Cmd_RemoveCommand (cmd_name as ZString ptr) 
  declare function  Cmd_Exists (cmd_name as ZString ptr)  as qboolean
 declare function Cmd_CompleteCommand ( partial as ZString ptr ) as ZString ptr 
 declare function Cmd_Argc ()as integer
  declare function  Cmd_Argv (arg as integer ) as zstring ptr 
 declare function	Cmd_Args ()  as zstring ptr 

declare sub	Cmd_TokenizeString (text as zstring ptr,macroExpand as  qboolean ) 

declare sub		Cmd_ExecuteString (text as zstring ptr)  

declare sub	Cmd_ForwardToServer ()

'/*
'==============================================================

'CVAR

'==============================================================


extern	cvar_vars  as cvar_t ptr

 declare function Cvar_Get (var_name as zstring ptr,value as zstring ptr,  flags as integer) as cvar_t ptr

  declare function Cvar_Set (var_name as zstring ptr,value as zstring ptr)  as cvar_t ptr

 declare function Cvar_ForceSet (var_name as zstring ptr,value as zstring ptr)  as cvar_t ptr

 declare function  Cvar_FullSet (var_name as zstring ptr,value as zstring ptr, flags as integer)  as cvar_t ptr

 declare sub Cvar_SetValue (var_name as zstring ptr,value as float ) 

 declare function  Cvar_VariableValue (var_name as ZString ptr) as float	

  declare function Cvar_VariableString (var_name as zstring ptr ) as zstring ptr

  declare function Cvar_CompleteVariable (partial  as zstring ptr)  as zstring ptr

 declare sub Cvar_GetLatchedVars () 

 declare function Cvar_Command () as qboolean

 declare sub Cvar_WriteVariables(path as zstring ptr) 

 declare sub Cvar_Init() 

  declare function Cvar_Userinfo() as zstring ptr

  declare function Cvar_Serverinfo () as zstring ptr

 extern	userinfo_modified  as qboolean	




'/*
'==============================================================
'
'NET
'
'==============================================================
'*/


'


#define	PORT_ANY	-1

#define	MAX_MSGLEN		1400		
#define	PACKET_HEADER	10		



enum netadrtype_t 

NA_LOOPBACK, NA_BROADCAST, NA_IP, NA_IPX, NA_BROADCAST_IPX
End Enum

enum netsrc_t 
NS_CLIENT, NS_SERVER
end  enum


type netadr_t
		_type as netadrtype_t 

	ip(4)as ubyte	
	ipx(10) as UByte	
port as ushort	
	
End Type


declare sub 	NET_Init () 
declare sub 	NET_Shutdown () 

declare sub 	NET_Config ( multiplayer as qboolean) 

declare function	NET_GetPacket (sock as netsrc_t , net_from as netadr_t ptr,net_message as  sizebuf_t ptr) as qboolean
declare sub 		NET_SendPacket (sock as netsrc_t ,length as integer ,_data as any ptr, _to as netadr_t ) 

declare function 	NET_CompareAdr ( a as netadr_t,b as  netadr_t ) as qboolean
declare function 	NET_CompareBaseAdr (a as netadr_t,b as  netadr_t) as qboolean
declare function  NET_IsLocalAddress (adr as netadr_t ) as qboolean	
declare function  NET_AdrToString (a as netadr_t) as ZString ptr
declare function 	NET_StringToAdr (s as zstring ptr, a  as zstring ptr) as qboolean
declare sub 	   NET_Sleep( msec as integer) 


#define	OLD_AVG		0.99		 

#define	MAX_LATENT	32



 

	
 
type netchan_t
	
	
	fatal_error  as qboolean

	sock  as netsrc_t	

	dropped as integer			 

	last_received  as integer			
	last_sent  as integer	

	remote_address as	netadr_t 
	qport  as integer			

 
	incoming_sequence  as integer			
	incoming_acknowledged  as integer			
   incoming_reliable_acknowledged as	integer			

	incoming_reliable_sequence as	integer	

	outgoing_sequence as	integer	
	reliable_sequence as	integer	
	last_reliable_sequence as	integer	

 
	message  as sizebuf_t	
	message_buf(MAX_MSGLEN-16) as ubyte 

 
	reliable_length as Integer 
	reliable_buf(MAX_MSGLEN-16)  as ubyte 
	
 
	
	
	
End Type




extern	net_from  as netadr_t	
extern	net_message  as sizebuf_t	
extern	net_message_buffer(MAX_MSGLEN) as ubyte	 


 
declare sub Netchan_Setup (sock as netsrc_t , chan as  netchan_t ptr ,adr as  netadr_t ,qport as integer ) 

declare function  Netchan_NeedReliable (chan as netchan_t ptr) as qboolean
declare sub Netchan_Transmit (chan as netchan_t ptr, length as integer ,_data as  ubyte ptr ) 
declare sub Netchan_OutOfBand (net_socket as integer ,adr as netadr_t ,length as integer ,_data as  ubyte ptr ) 
declare sub Netchan_OutOfBandPrint cdecl ( net_socket as integer, adr as netadr_t ,_format as  zstring ptr, ...) 
declare function Netchan_Process (chan as netchan_t ptr, msg as sizebuf_t ptr) as qboolean  

 declare function Netchan_CanReliable (chan as netchan_t ptr ) as  qboolean


'FINISHED FOR NOW'''''''''''''''''
#Include once "qcommon\qfiles.bi"
''''''''''''''''''''''''''''''''''


declare function  CM_LoadMap(_name as ZString ptr,clientload as qboolean ,  checksum as UInteger ptr) as  cmodel_t ptr 
declare function  CM_InlineModel (_name as zstring ptr) as  cmodel_t	ptr
 
declare function  CM_NumClusters () as integer
declare function  CM_NumInlineModels () as Integer
declare function  CM_EntityString() as ZString ptr
 
declare function  CM_HeadnodeForBox (mins as vec3_t ,maxs as vec3_t ) as  integer
 
declare function   CM_PointContents ( p as vec3_t,headnode as integer ) as integer
declare function   CM_TransformedPointContents (p as vec3_t ,headnode as integer ,origin as vec3_t ,angles as vec3_t ) as Integer
 
declare function  	CM_BoxTrace ( _start as vec3_t, _end as vec3_t, _
 						  mins as vec3_t ,maxs as vec3_t , _
 					    headnode as integer ,  brushmask as integer)as  trace_t	
 					  
 					  
 					  
 					  
declare function  CM_TransformedBoxTrace ( _start as vec3_t, _end as vec3_t, _
						  									 mins as vec3_t ,maxs as vec3_t , _
						 									 headnode as integer ,  brushmask as integer, _
															 origin as vec3_t ,angles as vec3_t )as trace_t		
 
declare function CM_ClusterPVS ( cluster as integer) as ubyte ptr
declare function CM_ClusterPHS (cluster as integer) as ubyte ptr
 
 declare function      CM_PointLeafnum (p as vec3_t ) as integer
 
  declare function   CM_BoxLeafnums (mins as vec3_t ,maxs as vec3_t ,_list as integer ptr, _
   						       listsize as integer ,topnode as integer ptr) as integer			
 
declare function  CM_LeafContents ( leafnum as integer)  as Integer
declare function  CM_LeafCluster (leafnum as integer)   as Integer
declare function  CM_LeafArea (leafnum as integer)   as Integer
 
 declare sub CM_SetAreaPortalState (portalnum as integer ,_open as qboolean ) 
 declare function CM_AreasConnected (area1 as integer , _in  as integer) as qboolean	

declare function CM_WriteAreaBits (buffer as ubyte ptr,area as integer ) as Integer
declare function 	CM_HeadnodeVisible (headnode as integer , visbits as ubyte ptr) as qboolean

declare sub CM_WritePortalState (f as FILE ptr) 
declare sub CM_ReadPortalState (f as FILE ptr) 



extern pm_airaccelerate as float 

declare sub	Pmove (pmove as pmove_t ptr) 


declare sub	FS_InitFilesystem () 
declare sub	FS_SetGamedir (_dir as zstring ptr) 
declare function FS_Gamedir () as zstring ptr
declare function FS_NextPath (prevpath  as zstring ptr) as zstring ptr 
declare sub	FS_ExecAutoexec () 
declare function FS_FOpenFile (filename as ZString ptr ,file as  FILE ptr ptr) as Integer 
declare sub	FS_FCloseFile (f as FILE ptr)
declare function FS_LoadFile (path as ZString ptr,buffer as any ptr ptr) as Integer 
declare sub	FS_Read (buffer as  any ptr,_len as integer , f as FILE ptr) 
declare sub	FS_FreeFile(buffer as any ptr) 
declare sub	FS_CreatePath (path as zstring ptr)

#define	ERR_FATAL	0	 
#define	ERR_DROP	1		 
#define	ERR_QUIT	2		 

'#define	EXEC_NOW	0		 
'#define	EXEC_INSERT	1		 
'#define	EXEC_APPEND	2		 

#define	PRINT_ALL		0
#define  PRINT_DEVELOPER	1	 

declare sub	Com_BeginRedirect (_target as integer , buffer as zstring ptr,buffersize as integer ,  flush as sub()) 
declare sub	Com_EndRedirect ()
declare sub	Com_Printf cdecl(fmt as ZString ptr, ...)
declare sub	Com_DPrintf cdecl (fmt as ZString ptr, ...)
declare sub	Com_Error cdecl (_code as integer ,fmt as ZString ptr, ...)
declare sub	Com_Quit ()

declare function 	Com_ServerState () as	integer	
declare sub	Com_SetServerState (state as integer ) 

declare function Com_BlockChecksum (buffer as any ptr,length as integer ) as UInteger
declare function COM_BlockSequenceCRCByte (_base as UByte ptr,length as integer ,sequence as integer ) as ubyte

declare function frand() as float	
declare function crand() as float	  

extern	developer as cvar_t	ptr
extern	dedicated as cvar_t	ptr	 
extern	host_speeds as cvar_t	ptr 
extern	log_stats as cvar_t	ptr 

extern	log_stats_file as FILE ptr

 
extern	time_before_game  as integer		
extern	time_after_game  as integer
extern	time_before_ref  as integer
extern	time_after_ref  as integer

declare sub	Z_Free (as any ptr) 
declare function Z_Malloc (_size as integer) as any ptr
declare function Z_TagMalloc (_size as integer,_tag as integer ) as any ptr
declare sub	Z_FreeTags ( tag as integer)  

declare sub	Qcommon_Init (argc as integer , argv as ubyte ptr ptr) 
declare sub	Qcommon_Frame (msec as integer ) 
declare sub	Qcommon_Shutdown () 

#define NUMVERTEXNORMALS	162
extern	bytedirs(NUMVERTEXNORMALS) as vec3_t 
 
declare sub	SCR_DebugGraph (value as float ,_color as integer ) 



declare sub Sys_Init () 

declare sub	Sys_AppActivate () 

declare sub	Sys_UnloadGame () 
declare function Sys_GetGameAPI (params as any ptr) as any ptr 

declare function Sys_ConsoleInput () as ZString ptr
declare sub	Sys_ConsoleOutput (_string as ZString ptr) 
declare sub	Sys_SendKeyEvents () 
declare sub	 Sys_Error  cdecl (_error as ZString ptr , ...)
declare sub	Sys_Quit () 
declare function Sys_GetClipboardData() as ZString ptr 
declare sub	Sys_CopyProtect () 




declare sub CL_Init() 
declare sub CL_Drop() 
declare sub CL_Shutdown () 
declare sub CL_Frame (msec as integer ) 
declare sub Con_Print (text as ZString ptr) 
declare sub SCR_BeginLoadingPlaque () 

declare sub SV_Init ()
declare sub SV_Shutdown (finalmsg as zstring ptr,reconnect as  qboolean ) 
declare sub SV_Frame (msec as integer ) 


