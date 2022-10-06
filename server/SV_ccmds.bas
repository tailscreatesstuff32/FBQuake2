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

sub SV_InitOperatorCommands	()
	
	
   Cmd_AddCommand ("map", @SV_Map_f) 
	Cmd_AddCommand ("demomap", @SV_DemoMap_f) 
	
	
End Sub



