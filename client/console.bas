#Include "client\client.bi"




dim shared as console_t con  	

dim shared as cvar_t ptr  con_notifytime 


#define	MAXCMDLINE	256
extern	as zstring * MAXCMDLINE 	key_lines(32)
extern   as	integer		edit_line 
extern   as	integer		key_linepos 
		

sub Con_CheckResize()
	
End Sub

sub  Con_ClearNotify () 
	
   dim i as integer
	
	for  i=0 to NUM_CON_TIMES - 1 
	con.times(i) = 0 
	Next
		
	
End Sub
 
 
 
 
sub Con_Clear_f
	
	
	
	memset (@con.text, asc(" "), CON_TEXTSIZE)
	
	
	

End Sub

sub Con_ToggleConsole_f
	
	
	
End Sub


sub Con_Togglechat_f
	
	
	
End Sub

sub Con_MessageMode_f
	
	
	
End Sub

 sub Con_MessageMode2_f
	
	
	
End Sub

 sub Con_Dump_f
	
	
	
 End Sub
'void Con_Print (char *txt)
'{'
'	int		y;'
	'int		c, l;
'	static int	cr;
'	int		mask;
'
'	if (!con.initialized)
'		return;
'
'	if (txt[0] == 1 || txt[0] == 2)
'	{
'		mask = 128;		// go to colored text
'		txt++;
'	}
'	else
'		mask = 0;
'
'
'	while ( (c = *txt) )
'	{
'	// count word length
'		for (l=0 ; l< con.linewidth ; l++)
'			if ( txt[l] <= ' ')
'				break;
'
'	// word wrap
'		if (l != con.linewidth && (con.x + l > con.linewidth) )
'			con.x = 0;
'
'		txt++;
'
'		if (cr)
'		{
'			con.current--;
'			cr = _false;
'		}
'
'		
'		if (!con.x)
'		{
'			Con_Linefeed ();
'		// mark time for transparent overlay
'			if (con.current >= 0)
'				con.times[con.current % NUM_CON_TIMES] = cls.realtime;
'		}
'
'		switch (c)
'		{
'		case '\n':
'			con.x = 0;
'			break;
'
'		case '\r':
'			con.x = 0;
'			cr = 1;
'			break;
'
'		default:	// display character and advance
'			y = con.current % con.totallines;
'			con.text[y*con.linewidth+con.x] = c | mask | con.ormask;
'			con.x++;
'			if (con.x >= con.linewidth)
'				con.x = 0;
'			break;
'		}
'		
'	}
'}


'/*
'================
'Con_Init
'================
'*/
sub Con_Init ()
	 con.linewidth = -1 

	 Con_CheckResize () 
 
	 Com_Printf (!"Console initialized.\n") 

'//
'// register our commands
'//
   con_notifytime = Cvar_Get ("con_notifytime", "3", 0) 

	Cmd_AddCommand ("toggleconsole", @Con_ToggleConsole_f) 
	Cmd_AddCommand ("togglechat", @Con_ToggleChat_f) 
	Cmd_AddCommand ("messagemode", @Con_MessageMode_f) 
	Cmd_AddCommand ("messagemode2", @Con_MessageMode2_f) 
	Cmd_AddCommand ("clear", @Con_Clear_f) 
	Cmd_AddCommand ("condump", @Con_Dump_f) 
	con.initialized = _true 
 

	
End Sub
 
