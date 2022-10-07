#Include "server\server.bi"


sub SV_Map_f()
	
	 ' print *cmd_argv(0) & " " & *cmd_argv(1)
	

	
End Sub
sub SV_DemoMap_f()
	
	 'print *cmd_argv(0) & " " & *cmd_argv(1)
	 'print 
	 
	'print " IN DEMO"
   'print cmd_argc()
	 SV_Map (true, Cmd_Argv(1), false )
End Sub




sub SV_Heartbeat_f
	
	
	
End Sub


sub SV_Kick_f
	
	
End Sub

sub SV_Status_f
	
	
End Sub
sub SV_ServerCommand_f
	
End Sub



sub SV_KillServer_f
	
End Sub

sub SV_Savegame_f
	
End Sub

sub SV_Loadgame_f
	
End Sub




sub SV_ServerStop_f
	
End Sub

sub SV_ServerRecord_f
	
End Sub

sub SV_ConSay_f
	
End Sub


sub SV_SetMaster_f
	
End Sub

sub SV_GameMap_f
	
End Sub



sub SV_Serverinfo_f
	
End Sub

sub SV_DumpUser_f
	
	
End Sub




sub SV_InitOperatorCommands	()
	

	
		Cmd_AddCommand ("heartbeat",@SV_Heartbeat_f) 
	Cmd_AddCommand ("kick",@SV_Kick_f)
	Cmd_AddCommand ("status",@SV_Status_f)
	Cmd_AddCommand ("serverinfo",@SV_Serverinfo_f)
	Cmd_AddCommand ("dumpuser",@SV_DumpUser_f)
 	
   Cmd_AddCommand ("map",@SV_Map_f) 
	Cmd_AddCommand ("demomap",@SV_DemoMap_f) 
	
	
	Cmd_AddCommand ("gamemap",@SV_GameMap_f)
	Cmd_AddCommand ("setmaster",@SV_SetMaster_f)

	if ( dedicated->value ) then
		Cmd_AddCommand ("say",@SV_ConSay_f)
	EndIf
		

	Cmd_AddCommand ("serverrecord",@SV_ServerRecord_f)
	Cmd_AddCommand ("serverstop",@SV_ServerStop_f)

	Cmd_AddCommand ("save",@SV_Savegame_f)
	Cmd_AddCommand ("load",@SV_Loadgame_f)

	Cmd_AddCommand ("killserver",@SV_KillServer_f)

	Cmd_AddCommand ("sv",@SV_ServerCommand_f)
	
	
	
End Sub



