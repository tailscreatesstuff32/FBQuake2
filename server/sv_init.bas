#Include "server\server.bi"

dim shared as server_t		sv 




sub SV_SpawnServer(server as zstring ptr)
	
		
	printf(!"------- Server Initialization -------\n")
	
	
	
	
			printf (!"%i entities inhibited\n", 0)
 'printf ("%i entities inhibited\n", inhibit)
	
	
	printf (!"%i teams with %i entities\n", 0, 0)
	
	strcpy (sv._name, server)
	
	
	Cvar_FullSet ("mapname", sv._name, _CVAR_SERVERINFO or CVAR_NOSET) 
	
		printf (!"-------------------------------------\n")
	
End Sub


sub SV_Initgame()
	
	
	
	SV_InitGameProgs()
	
			
	
End Sub

sub SV_Map (attractloop as qboolean ,levelstring as zstring ptr,loadgame as qboolean ) 
	
	dim as zstring * MAX_QPATH level
	
	
	
	strcpy (level, levelstring)
	
	
	Cvar_Set ("nextserver", "")
	
	
	SV_Initgame()
	SV_SpawnServer(level) 
	
	
	
End Sub




















 