#Include "client\client.bi"



dim shared as cvar_t ptr cl_nodelta


'//==========================================================================

dim shared as cvar_t ptr cl_upspeed
dim shared as cvar_t ptr cl_forwardspeed
dim shared as cvar_t ptr cl_sidespeed

dim shared as cvar_t ptr cl_yawspeed
dim shared as cvar_t ptr cl_pitchspeed

dim shared as cvar_t ptr cl_run

dim shared as cvar_t ptr cl_anglespeedkey

sub IN_KLookDown ():/'KeyDown(&in_klook);'/:End Sub
sub IN_KLookUp ():/'KeyUp(&in_klook);'/:End Sub
sub IN_DownDown():/'KeyDown(&in_down);;'/ :End Sub
sub IN_DownUp():/'KeyUp(&in_down);'/ :End Sub
sub IN_UpDown():/'KeyDown(&in_up);'/ :End Sub
sub IN_UpUp():/'KeyUp(&in_up);'/ :End Sub
sub IN_LeftDown():/'KeyDown(&in_left);'/:End Sub
sub IN_LeftUp():/'KeyUp(&in_left);'/ :End Sub
sub IN_RightDown()/'{KeyDown(&in_right);'/:End Sub
sub IN_RightUp():/'KeyUp(&in_right);'/:End Sub
sub IN_ForwardDown:/'KeyDown(&in_forward);'/:End Sub
sub IN_ForwardUp(): /'KeyUp(&in_forward'/:End Sub	
sub IN_BackDown():/'KeyDown(&in_back);'/:End Sub
sub IN_BackUp():/'KeyUp(&in_back);'/:End Sub
sub IN_LookupDown():/'KeyDown(&in_lookup);'/:End Sub
sub IN_LookupUp():/'KeyUp(&in_lookup);'/:End Sub
sub IN_LookdownDown():/'KeyDown(&in_lookdown);'/:End Sub
sub IN_LookdownUp():/'KeyUp(&in_lookdown);'/:End Sub
sub IN_MoveleftDown():/'KeyDown(&in_moveleft);'/:End Sub
sub IN_MoveleftUp():/'KeyUpn(&in_moveleft);'/:End Sub
sub IN_MoverightDown():/'KeyDown(&in_moveright);'/:End Sub
sub IN_MoverightUp():/'KeyUp(&in_moveright);'/:End Sub

sub IN_SpeedDown():/'KeyDown(&in_speed);'/:End Sub
sub IN_SpeedUp():/'KeyUp(&in_speed);'/:End Sub
sub IN_StrafeDown():/'KeyDown(&in_strafe);'/:End Sub
sub IN_StrafeUp():/'KeyUp(&in_strafe);'/:End Sub

sub IN_AttackDown():/'KeyDown(&in_attack);'/:End Sub
sub IN_AttackUp():/'KeyUp(&in_attack);'/:End Sub

sub IN_UseDown():/'KeyDown(&in_use);'/:End Sub
sub IN_UseUp (): /'KeyUp(&in_use);'/:End Sub

sub IN_Impulse ():/'in_impulse=atoi(Cmd_Argv(1));'/:End Sub


	

sub IN_CenterView ()
	
End Sub
 






'	/*
'============
'CL_InitInput
'============
'*/
sub CL_InitInput ()

	Cmd_AddCommand ("centerview",@IN_CenterView)

	Cmd_AddCommand ("+moveup", @IN_UpDown)
	Cmd_AddCommand ("-moveup", @IN_UpUp)
	Cmd_AddCommand ("+movedown", @IN_DownDown)
	Cmd_AddCommand ("-movedown", @IN_DownUp)
	Cmd_AddCommand ("+left", @IN_LeftDown)
	Cmd_AddCommand ("-left", @IN_LeftUp)
	Cmd_AddCommand ("+right", @IN_RightDown)
	Cmd_AddCommand ("-right", @IN_RightUp)
	Cmd_AddCommand ("+forward", @IN_ForwardDown)
	Cmd_AddCommand ("-forward", @IN_ForwardUp)
	Cmd_AddCommand ("+back", @IN_BackDown)
	Cmd_AddCommand ("-back", @IN_BackUp)
	Cmd_AddCommand ("+lookup", @IN_LookupDown)
	Cmd_AddCommand ("-lookup", @IN_LookupUp)
	Cmd_AddCommand ("+lookdown", @IN_LookdownDown)
	Cmd_AddCommand ("-lookdown", @IN_LookdownUp)
	Cmd_AddCommand ("+strafe", @IN_StrafeDown)
	Cmd_AddCommand ("-strafe", @IN_StrafeUp)
	Cmd_AddCommand ("+moveleft", @IN_MoveleftDown)
	Cmd_AddCommand ("-moveleft", @IN_MoveleftUp)
	Cmd_AddCommand ("+moveright", @IN_MoverightDown)
	Cmd_AddCommand ("-moveright", @IN_MoverightUp)
	Cmd_AddCommand ("+speed", @IN_SpeedDown)
	Cmd_AddCommand ("-speed", @IN_SpeedUp)
	Cmd_AddCommand ("+attack", @IN_AttackDown)
	Cmd_AddCommand ("-attack", @IN_AttackUp)
	Cmd_AddCommand ("+use", @IN_UseDown)
	Cmd_AddCommand ("-use", @IN_UseUp)
	Cmd_AddCommand ("impulse", @IN_Impulse)
	Cmd_AddCommand ("+klook", @IN_KLookDown)
	Cmd_AddCommand ("-klook", @IN_KLookUp)

	cl_nodelta = Cvar_Get ("cl_nodelta", "0", 0)



End Sub
