
#include "crt/ctype.bi"
#ifdef __FB_WIN32__
#include "crt.bi"
#endif

#Include "client\client.bi"
#Include "client\qmenu.bi"






sub M_Menu_Main_f
	
End Sub


sub M_Menu_Game_f
	
	
End Sub



sub  M_Menu_LoadGame_f
	
	
End Sub

sub menu_savegame
	
	
End Sub


sub M_Menu_SaveGame_f

End Sub


sub M_Menu_JoinServer_f

End Sub

sub M_Menu_AddressBook_f

End Sub

sub M_Menu_StartServer_f
	
End Sub

sub M_Menu_DMOptions_f

End Sub

sub M_Menu_PlayerConfig_f
	
	
End Sub



sub M_Menu_DownloadOptions_f
	
	
	
End Sub


sub M_Menu_Multiplayer_f 
	
	
End Sub


sub M_Menu_Credits_f
	
	
End Sub

sub M_Menu_Video_f
	
	
	
End Sub

sub M_Menu_Options_f


End Sub

sub M_Menu_Keys_f


End Sub


sub M_Menu_Quit_f
	
	
End Sub

'//=============================================================================
'/* Menu Subsystem */
'
'
'/*
'=================
'M_Init
'=================
'*/
sub M_Init ()
	Cmd_AddCommand ("menu_main",@M_Menu_Main_f)
	Cmd_AddCommand ("menu_game",@M_Menu_Game_f)
	Cmd_AddCommand ("menu_loadgame",@M_Menu_LoadGame_f)
	Cmd_AddCommand ("menu_savegame",@M_Menu_SaveGame_f)
	Cmd_AddCommand ("menu_joinserver",@M_Menu_JoinServer_f)
	Cmd_AddCommand ("menu_addressbook",@M_Menu_AddressBook_f)
	Cmd_AddCommand ("menu_startserver",@M_Menu_StartServer_f)
	Cmd_AddCommand ("menu_dmoptions",@M_Menu_DMOptions_f)
	Cmd_AddCommand ("menu_playerconfig",@M_Menu_PlayerConfig_f)
	Cmd_AddCommand ("menu_downloadoptions",@M_Menu_DownloadOptions_f)
	Cmd_AddCommand ("menu_credits",@M_Menu_Credits_f )
	Cmd_AddCommand ("menu_multiplayer",@M_Menu_Multiplayer_f )
	Cmd_AddCommand ("menu_video",@M_Menu_Video_f)
	Cmd_AddCommand ("menu_options",@M_Menu_Options_f)
	Cmd_AddCommand ("menu_keys",@M_Menu_Keys_f)
	Cmd_AddCommand ("menu_quit",@M_Menu_Quit_f)
End Sub

