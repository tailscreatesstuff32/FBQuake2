#Include "server\server.bi"


sub SV_SpawnServer()
	
		
	printf(!"------- Server Initialization -------\n")
	
	
	
	
			printf (!"%i entities inhibited\n", 0)
 'printf ("%i entities inhibited\n", inhibit)
	
	
	printf (!"%i teams with %i entities\n", 0, 0)
	
		printf (!"-------------------------------------\n")
	
End Sub


sub SV_Initgame()
	
	
	
	SV_InitGameProgs()
	
			
	
End Sub

sub SV_Map (attractloop as qboolean ,levelstring as zstring ptr,loadgame as qboolean ) 
	
	SV_Initgame()
	SV_SpawnServer() 
	
	
	
End Sub




















 