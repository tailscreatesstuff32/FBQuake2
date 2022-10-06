
#Include "client\client.bi"

 





#define		MAXCMDLINE	256
dim shared as zstring * MAXCMDLINE	key_lines(32)
dim shared as integer		key_linepos
dim shared as integer 		shift_down=_false
dim shared as integer 	anykeydown

dim shared as integer edit_line=0
dim shared as integer	history_line=0


dim shared as integer	key_waiting
dim shared as zstring ptr	 keybindings(256)
dim shared as qboolean	consolekeys(256) 	'// if _true, can't be rebound while in console
dim shared as qboolean	menubound(256) 	'// if _true, can't be rebound while in menu
dim shared as integer		keyshift(256)		'// key to map to if shift held down in console
dim shared as integer		key_repeats(256) '// if > 1, it is autorepeating
dim shared as qboolean	keydown(256)


type  keyname_t

	as zstring ptr  _name
	as integer		keynum

End Type



dim shared keynames(89) as keyname_t  => _
{ _
(@"TAB", K_TAB) , _
(@"ENTER", K_ENTER), _
(@"ESCAPE", K_ESCAPE), _
(@"SPACE", K_SPACE), _
(@"BACKSPACE", K_BACKSPACE), _
(@"UPARROW", K_UPARROW), _
(@"DOWNARROW", K_DOWNARROW), _
(@"LEFTARROW", K_LEFTARROW), _
(@"RIGHTARROW", K_RIGHTARROW), _
(@"ALT", K_ALT), _
(@"CTRL", K_CTRL), _
(@"SHIFT", K_SHIFT), _
(@"F1", K_F1), _
(@"F2", K_F2), _
(@"F3", K_F3), _
(@"F4", K_F4), _
(@"F5", K_F5), _
(@"F6", K_F6), _
(@"F7", K_F7), _
(@"F8", K_F8), _
(@"F9", K_F9), _
(@"F10", K_F10), _
(@"F11", K_F11), _
(@"F12", K_F12), _
(@"INS", K_INS), _
(@"DEL", K_DEL), _
(@"PGDN", K_PGDN), _
(@"PGUP", K_PGUP), _
(@"HOME", K_HOME), _
(@"END", K_END), _
(@"MOUSE1", K_MOUSE1), _
(@"MOUSE2", K_MOUSE2), _
(@"MOUSE3", K_MOUSE3), _
(@"JOY1", K_JOY1), _
(@"JOY2", K_JOY2), _
(@"JOY3", K_JOY3), _
(@"JOY4", K_JOY4), _
(@"AUX1", K_AUX1), _
(@"AUX2", K_AUX2), _
(@"AUX3", K_AUX3), _
(@"AUX4", K_AUX4), _
(@"AUX5", K_AUX5), _
(@"AUX6", K_AUX6), _
(@"AUX7", K_AUX7), _
(@"AUX8", K_AUX8), _
(@"AUX9", K_AUX9), _
(@"AUX10", K_AUX10), _
(@"AUX11", K_AUX11), _
(@"AUX12", K_AUX12), _
(@"AUX13", K_AUX13), _
(@"AUX14", K_AUX14), _
(@"AUX15", K_AUX15), _
(@"AUX16", K_AUX16), _
(@"AUX17", K_AUX17), _
(@"AUX18", K_AUX18), _
(@"AUX19", K_AUX19), _
(@"AUX20", K_AUX20), _
(@"AUX21", K_AUX21), _
(@"AUX22", K_AUX22), _
(@"AUX23", K_AUX23), _
(@"AUX24", K_AUX24), _
(@"AUX25", K_AUX25), _
(@"AUX26", K_AUX26), _
(@"AUX27", K_AUX27), _
(@"AUX28", K_AUX28), _
(@"AUX29", K_AUX29), _
(@"AUX30", K_AUX30), _
(@"AUX31", K_AUX31), _
(@"AUX32", K_AUX32), _
(@"KP_HOME",			K_KP_HOME ), _
(@"KP_UPARROW",		K_KP_UPARROW ), _
(@"KP_PGUP",			K_KP_PGUP ), _
(@"KP_LEFTARROW",	K_KP_LEFTARROW ), _
(@"KP_5",			K_KP_5 ), _
(@"KP_RIGHTARROW",	K_KP_RIGHTARROW ), _
(@"KP_END",			K_KP_END ), _
(@"KP_DOWNARROW",	K_KP_DOWNARROW ), _
(@"KP_PGDN",			K_KP_PGDN ), _
(@"KP_ENTER",		K_KP_ENTER ), _
(@"KP_INS",			K_KP_INS ), _
(@"KP_DEL",			K_KP_DEL ), _
(@"KP_SLASH",		K_KP_SLASH ), _
(@"KP_MINUS",		K_KP_MINUS ), _
(@"KP_PLUS",			K_KP_PLUS ), _
(@"MWHEELUP", K_MWHEELUP ), _
(@"MWHEELDOWN", K_MWHEELDOWN ), _
(@"PAUSE", K_PAUSE), _
(@"SEMICOLON", asc(";")), _	'// because a raw semicolon seperates commands
(NULL,0)  _
}







'/*
'===================
'Key_SetBinding
'===================
'*/
sub Key_SetBinding (keynum as integer ,binding as  zstring ptr)
	 	dim as zstring ptr _new
	 	dim l as integer
	 	
	 	if keynum = -1 then
	 		return
	 	EndIf
  
	'// free old bindings
	if (keybindings(keynum)) then
		Z_Free (keybindings(keynum))
		keybindings(keynum) = NULL
	EndIf
	
	'// allocate memory for new binding
	l = strlen (binding)
	_new = Z_Malloc (l+1)
	
	
	strcpy (_new, binding)
	
	
   _new[l] = 0
   keybindings(keynum) = _new
    
End Sub
 
 







sub Key_Unbindall_f
	'print Cmd_Argc
	'print  * Cmd_Argv(0) & " "  &  * Cmd_Argv(1) & "  " & * Cmd_Argv(2)& "  " & * Cmd_Argv(3) & " "  &  * Cmd_Argv(4) & "  " & * Cmd_Argv(5)
dim as	integer		i 
	
	for  i=0  to 256 -1
		if (keybindings(i)) then
			Key_SetBinding (i, "") 
		EndIf
			
next
End Sub

'/*
'===================
'Key_StringToKeynum
'
'Returns a key number to be used to index keybindings[] by looking at
'the given string.  Single ascii characters return themselves, while
'the K_* names are matched up.
'===================
'*/
function Key_StringToKeynum (_str as zstring ptr) as integer
	   dim as keyname_t ptr kn 
	   
	   
 	if ( _str = NULL or  _str[0] = NULL) then
 		return -1
 	EndIf
		
		
	if ( _str[1] = NULL) then
		return _str[0]
		
	EndIf
		 
  
	 kn=@keynames(0)
	 do while kn->_name 
	 		if ( Q_strcasecmp(_str,kn->_name) = 0) then
			return kn->keynum	
		EndIf
 
	 	
	 	kn+=1
	 Loop
	 
	 
	 
	
		return -1 
End Function
 
 

'/*
'===================
'Key_KeynumToString
'
'Returns a string (either a single ascii char, or a K_* name) for the
'given keynum.
'FIXME: handle quote special (general escape sequence?)
'===================
'*/
function Key_KeynumToString (keynum as integer )as zstring ptr
   dim as keyname_t ptr kn 	
	static as zstring ptr	tinystr(2)
	if (keynum = -1) then
		
		return @"<KEY NOT FOUND>"
	EndIf
	 	if (keynum > 32 and keynum < 127) then
	   '// printable ascii
		tinystr(0) = keynum 
		tinystr(1) = 0 
		return  @tinystr(0) 
	 
	 		
	 	EndIf
	 	
	 	
	kn= @keynames(0)
	do while kn->_name
		
	 if (keynum =  kn->keynum) then
	 	return kn->_name
	 EndIf
 
		kn+=1
	Loop 
 
	return @"<UNKNOWN KEYNUM>" 
	
	
End Function
 
 


sub Key_Bindlist_f()
	'print Cmd_Argc
	print  * Cmd_Argv(0) & " "  &  * Cmd_Argv(1) & "  " & * Cmd_Argv(2)& "  " & * Cmd_Argv(3) & " "  &  * Cmd_Argv(4) & "  " & * Cmd_Argv(5)
 
 
 
 
	 dim as integer		i 

	 for  i=0 to 256-1
	 if   keybindings(i) <> NULL then
    if  keybindings(i)[0] <> NULL then
    		 	Com_Printf (!"%s \"%s\"\n", Key_KeynumToString(i), keybindings(i)) 
    EndIf
    	
	  EndIf
	 		
 

	
	 Next
		
End Sub


'/*
'============
'Key_WriteBindings
'
'Writes lines containing "bind key value"
'============
'*/
sub Key_WriteBindings (f as FILE ptr)
	dim as integer		i
	
	for i = 0 to 256-1
	if  keybindings(i) <> NULL then
	if keybindings(i)[0] <> NULL then
		fprintf (f, !"bind %s \"%s\"\n", Key_KeynumToString(i), keybindings(i)) 
	EndIf
	EndIf		
next
End Sub
 

sub Key_Bind_f
 'print Cmd_Argc
 
 
 'print  * Cmd_Argv(0) & " "  &  * Cmd_Argv(1) & "  " & * Cmd_Argv(2)& "  " & * Cmd_Argv(3) & " "  &  * Cmd_Argv(4) & "  " & * Cmd_Argv(5)
 
 	dim as integer			i, c, b 
 	dim as zstring *	1024	cmd 
 	
 	c = Cmd_Argc() 
'
 	if (c < 2) then
 		Com_Printf (!"bind <key> [command] : attach a command to a key\n")
 		return
 	EndIf
 
 
 	 b = Key_StringToKeynum (Cmd_Argv(1)) 
  	if (b= -1) then
 		Com_Printf (!"\"%s\" isn't a valid key\n", Cmd_Argv(1))
   	return
  	EndIf
' 
''
 	if (c = 2) then
 				if (keybindings(b)) then
 		   Com_Printf (!"\"%s\" = \"%s\"\n", Cmd_Argv(1), keybindings(b) ) 
 		else
   		Com_Printf (!"\"%s\" is not bound\n", Cmd_Argv(1) ) 
 		return 
 		
 	EndIf
 	EndIf
	
'// copy the rest of the command line
  cmd[0] = 0 		'// start out with a null string
  
  
  for i = 2 to c -1
  	strcat (cmd, Cmd_Argv(i))
  	if (i <> (c-1)) then
  		strcat (cmd, " ")
  	EndIf
  	
 		 
  	
  Next
 
 
 	Key_SetBinding (b, cmd) 

End Sub



sub Key_Unbind_f
	'print Cmd_Argc
	'print  * Cmd_Argv(0) & " "  &  * Cmd_Argv(1) & "  " & * Cmd_Argv(2)& "  " & * Cmd_Argv(3) & " "  &  * Cmd_Argv(4) & "  " & * Cmd_Argv(5)
	dim as integer		b 

	if (Cmd_Argc() <> 2) then
 
		Com_Printf (!"unbind <key> : remove commands from a key\n") 
		return 
	end if
	
	b = Key_StringToKeynum (Cmd_Argv(1)) 
	if (b = -1) then
			Com_Printf (!"\"%s\" isn't a valid key\n", Cmd_Argv(1)) 
		return
	EndIf
 
	Key_SetBinding (b, "") 

End Sub

sub Key_Init ()
dim as integer i

for i=0 to 32-1
	key_lines(i)[0] = asc("]")
	key_lines(i)[1] = 0

	i+=1
Next



key_linepos = 1

'	//
'// init ascii characters in console mode
'//
for  i= 32 to 128 -1
	consolekeys(i) = _true
Next
	consolekeys(K_ENTER) = _true
	consolekeys(K_KP_ENTER) = _true
	consolekeys(K_TAB) = _true
	consolekeys(K_LEFTARROW) = _true
	consolekeys(K_KP_LEFTARROW) = _true
	consolekeys(K_RIGHTARROW) = _true
	consolekeys(K_KP_RIGHTARROW) = _true
	consolekeys(K_UPARROW) = _true
	consolekeys(K_KP_UPARROW) = _true
	consolekeys(K_DOWNARROW) = _true
	consolekeys(K_KP_DOWNARROW) = _true
	consolekeys(K_BACKSPACE) = _true
	consolekeys(K_HOME) = _true
	consolekeys(K_KP_HOME) = _true
	consolekeys(K_END) = _true
	consolekeys(K_KP_END) = _true
	consolekeys(K_PGUP) = _true
	consolekeys(K_KP_PGUP) = _true
	consolekeys(K_PGDN) = _true
	consolekeys(K_KP_PGDN) = _true
	consolekeys(K_SHIFT) = _true
	consolekeys(K_INS) = _true
	consolekeys(K_KP_INS) = _true
	consolekeys(K_KP_DEL) = _true
	consolekeys(K_KP_SLASH) = _true
	consolekeys(K_KP_PLUS) = _true
	consolekeys(K_KP_MINUS) = _true
	consolekeys(K_KP_5) = _true




consolekeys(asc("`")) = _false
consolekeys(asc("~")) = _false

for  i=0 to 256-1
	keyshift(i) = i

Next


i= asc("a")
do while  i <= asc("z")
	keyshift(i) = i - asc("a") + asc("A")
	i+=1
loop


	keyshift(asc("1")) = asc("!")
	keyshift(asc("2")) = asc("@")
	keyshift(asc("3")) = asc("#")
	keyshift(asc("4")) = asc("$")
	keyshift(asc("5")) = asc("%")
	keyshift(asc("6")) = asc("^")
	keyshift(asc("7")) = asc("&")
	keyshift(asc("8")) = asc("*")
	keyshift(asc("9")) = asc("(")
	keyshift(asc("0")) = asc(")")
 
	keyshift(asc("-")) = asc("_")
	keyshift(asc("=")) = asc("+")
	keyshift(asc(",")) = asc("<")
	keyshift(asc(".")) = asc(">")
	keyshift(asc("/")) = asc("?")
	keyshift(asc(";")) = asc(":")
	keyshift(asc(!"\'")) = asc(!"\"")
	keyshift(asc("[")) = asc("{")
	keyshift(asc("]")) = asc("}")
	keyshift(asc("`")) = asc("~")
	keyshift(asc(!"\\")) = asc("|")

menubound(K_ESCAPE) = _true
for i=0 to 12 - 1
	menubound(K_F1+i) = _true
Next
 
'//
'// register our functions
'//
Cmd_AddCommand (@"bind",@Key_Bind_f)
Cmd_AddCommand (@"unbind",@Key_Unbind_f)
Cmd_AddCommand (@"unbindall",@Key_Unbindall_f)
Cmd_AddCommand (@"bindlist",@Key_Bindlist_f)





End Sub