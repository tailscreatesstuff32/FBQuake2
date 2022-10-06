#Include "client\client.bi"


 
'//=============
'//
'// development tools for weapons
'//
'int			gun_frame;
'struct model_s	*gun_model;
'
'//=============

dim shared as cvar_t	ptr    crosshair 
dim shared as cvar_t	ptr cl_testparticles 
dim shared as cvar_t	ptr cl_testentities 
dim shared as cvar_t	ptr cl_testlights 
dim shared as cvar_t	ptr cl_testblend 

dim shared as cvar_t	ptr cl_stats 





'/*
'=============
'V_Viewpos_f
'=============
'*/
sub V_Viewpos_f ()
		'Com_Printf (!"(%i %i %i) : %i\n", cast(integer,mcl.refdef.vieworg(0) )
		'(int)cl.refdef.vieworg[1], (int)cl.refdef.vieworg[2]  
		'(int)cl.refdef.viewangles[YAW]);
	
End Sub


sub V_Gun_Prev_f ()
	
	
End Sub


sub V_Gun_Next_f
	
	
	
End Sub

sub V_Gun_Model_f
	
	
	
End Sub




'/*
'=============
'V_Init
'=============
'*/
sub V_Init ()
	Cmd_AddCommand ("gun_next", @V_Gun_Next_f) 
	Cmd_AddCommand ("gun_prev", @V_Gun_Prev_f) 
	Cmd_AddCommand ("gun_model", @V_Gun_Model_f) 

	Cmd_AddCommand ("viewpos", @V_Viewpos_f) 

	crosshair = Cvar_Get ("crosshair", "0", CVAR_ARCHIVE) 

	cl_testblend = Cvar_Get ("cl_testblend", "0", 0) 
	cl_testparticles = Cvar_Get ("cl_testparticles", "0", 0) 
	cl_testentities = Cvar_Get ("cl_testentities", "0", 0) 
	cl_testlights = Cvar_Get ("cl_testlights", "0", 0) 

	cl_stats = Cvar_Get ("cl_stats", "0", 0) 

End Sub


