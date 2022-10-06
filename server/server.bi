
#Include "qcommon\qcommon.bi"
#Include "Game\Game.bi"

#define	MAX_MASTERS	8				'// max recipients for heartbeat packets










enum client_state_t
 
	cs_free,		'// can be reused for a new connection
	cs_zombie,		'// client has been disconnected, but don't reuse
					'// connection for a couple seconds
	cs_connected,	'// has been assigned to a client_t, but not in game yet
	cs_spawned		'// client is fully in game
 


End Enum
	
 

type client_frame_t
	as integer					areabytes 
	as ubyte				areabits(MAX_MAP_AREAS/8)		'// portalarea visibility bits
	as player_state_t		ps 
	as integer					num_entities 
	as integer					first_entity 		'// into the circular sv_packet_entities[]
	as integer					senttime 			'// for ping calculations
 
End Type
 
	

#define	LATENCY_COUNTS	16
#define	RATE_MESSAGES	10





type  client_s
 
	as client_state_t	state 

	as zstring *	MAX_INFO_STRING  userinfo '		'// name, etc

	as integer				lastframe 			'// for delta compression
	as usercmd_t		lastcmd 		'// for filling in big drops

	as integer				commandMsec 		'// every seconds this is reset, if user
										'// commands exhaust it, assume time cheating

		as integer					frame_latency(LATENCY_COUNTS) 
		as integer				ping 

		as integer					message_size(RATE_MESSAGES) '	// used to rate drop packets
		as integer				rate 
		as integer					surpressCount 		'// number of messages rate supressed

	as edict_t		ptr edict 				'// EDICT_NUM(clientnum+1)
	as ZString *	32		_name 		'// extracted from userinfo, high bits masked
	as integer				messagelevel 		'// for filtering printed messages

	'// The datagram is written to by sound calls, prints, temp ents, etc.
	'// It can be harmlessly overflowed.
	as sizebuf_t		datagram 
	as ubyte			datagram_buf(MAX_MSGLEN)

	As client_frame_t	frames(UPDATE_BACKUP) 	'// updates can be delta'd from here

	as ubyte			  ptr download 			'// file being downloaded
	as integer				downloadsize 		'// total bytes (can't use EOF because of paks)
	as integer				downloadcount 		'// bytes sent

	as integer				lastmessage 		'// sv.framenum when packet was last received
	as integer				lastconnect 

	as integer				challenge 			'// challenge of this user, randomly generated

	as netchan_t		netchan 
end type:type client_t  as  client_s






'//
'// sv_init.c
'//
declare sub SV_InitGameProgs()
declare sub SV_InitGame ()
declare sub SV_Map (attractloop as qboolean ,levelstring as zstring ptr,loadgame as qboolean ) 






extern as	netadr_t	net_from 
extern	as sizebuf_t	net_message 

extern	as netadr_t	master_adr(MAX_MASTERS)	'// address of the master server

'extern	as server_static_t	svs 		'	// persistant server info
'extern	as server_t		sv 					'// local server
'
extern as	client_t	ptr sv_paused 
extern as	client_t	ptr maxclients 
extern as	client_t	ptr sv_noreload 			'// don't reload level state when reentering
extern as	client_t	ptr sv_airaccelerate 	'	// don't reload level state when reentering
											'// development tool
extern as	client_t	ptr sv_enforcetime 
 
 extern as	client_t	ptr sv_client 
  extern	as edict_t	ptr	 sv_player 

declare sub SV_InitOperatorCommands	()






