#Include "server\server.bi"

dim shared as  netadr_t	master_adr(MAX_MASTERS) 	'// address of group servers

dim shared  as client_t	 _sv_client 			'// current client

dim shared  as cvar_t	ptr _sv_paused
dim shared  as cvar_t	ptr sv_timedemo

dim shared  as cvar_t	ptr _sv_enforcetime

dim shared  as cvar_t	ptr timeout				'// seconds without any message
dim shared  as cvar_t	ptr zombietime			'// seconds to sink messages after disconnect

dim shared  as cvar_t	ptr rcon_password			'// password for remote server commands

dim shared  as cvar_t	ptr allow_download
dim shared  as cvar_t ptr allow_download_players
dim shared  as cvar_t ptr allow_download_models
dim shared  as cvar_t ptr allow_download_sounds
dim shared  as cvar_t ptr allow_download_maps

dim shared  as cvar_t ptr _sv_airaccelerate

dim shared  as cvar_t	ptr _sv_noreload			'// don't reload level state when reentering
 
dim shared  as cvar_t	ptr _maxclients			'// FIXME: rename sv_maxclients
dim shared  as cvar_t	ptr sv_showclamp

dim shared  as cvar_t	ptr hostname
dim shared  as cvar_t	ptr public_server			'// should heartbeats be sent

dim shared  as cvar_t	ptr sv_reconnect_limit	'// minimum seconds between connect messages


sub SV_Init()
	
	 
	
	
	SV_InitOperatorCommands	()
	
	rcon_password = Cvar_Get ("rcon_password", "", 0) 
	Cvar_Get ("skill", "1", 0) 
	Cvar_Get ("deathmatch", "0", CVAR_LATCH) 
	Cvar_Get ("coop", "0", CVAR_LATCH) 
	Cvar_Get ("dmflags", _va("%i", DF_INSTANT_ITEMS), _CVAR_SERVERINFO)
	Cvar_Get ("fraglimit", "0", _CVAR_SERVERINFO)
	Cvar_Get ("timelimit", "0", _CVAR_SERVERINFO)
	Cvar_Get ("cheats", "0", _CVAR_SERVERINFO  or CVAR_LATCH)
	Cvar_Get ("protocol", _va("%i", PROTOCOL_VERSION), _CVAR_SERVERINFO  or CVAR_NOSET)
	_maxclients = Cvar_Get ("maxclients", "1", _CVAR_SERVERINFO   or  CVAR_LATCH)
	hostname = Cvar_Get ("hostname", "noname", _CVAR_SERVERINFO   or  CVAR_ARCHIVE)
	timeout = Cvar_Get ("timeout", "125", 0)
	zombietime = Cvar_Get ("zombietime", "2", 0)
	sv_showclamp = Cvar_Get ("showclamp", "0", 0)
	_sv_paused = Cvar_Get ("paused", "0", 0)
	sv_timedemo = Cvar_Get ("timedemo", "0", 0)
	_sv_enforcetime = Cvar_Get ("sv_enforcetime", "0", 0)
	allow_download = Cvar_Get ("allow_download", "1", CVAR_ARCHIVE)
	allow_download_players  = Cvar_Get ("allow_download_players", "0", CVAR_ARCHIVE)
	allow_download_models = Cvar_Get ("allow_download_models", "1", CVAR_ARCHIVE)
	allow_download_sounds = Cvar_Get ("allow_download_sounds", "1", CVAR_ARCHIVE)
	allow_download_maps	  = Cvar_Get ("allow_download_maps", "1", CVAR_ARCHIVE)

	_sv_noreload = Cvar_Get ("sv_noreload", "0", 0)

	_sv_airaccelerate = Cvar_Get("sv_airaccelerate", "0", CVAR_LATCH)

	public_server = Cvar_Get ("public", "0", 0)

	sv_reconnect_limit = Cvar_Get ("sv_reconnect_limit", "3", CVAR_ARCHIVE) 
	
	
	
	SZ_Init (@net_message, @net_message_buffer(0), sizeof(net_message_buffer)) 
	
End Sub