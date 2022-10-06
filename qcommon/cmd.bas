#Include "qcommon\qcommon.bi"





type cmd_function_s
 
	as  cmd_function_s ptr _next 
	as zstring ptr			_name 
	as xcommand_t				_function 
end type:type  cmd_function_t as cmd_function_s


static shared as integer			_cmd_argc 
static shared as	zstring	 ptr  _cmd_argv(MAX_STRING_TOKENS)
static shared	as	zstring	 ptr cmd_null_string = @"" 
static shared	as	zstring	* MAX_STRING_CHARS	_cmd_args 

static shared	as cmd_function_t	ptr cmd_functions 		'// possible commands to execute




'declare sub Cmd_ForwardToServer () 

#define	MAX_ALIAS_NAME	32

type  cmdalias_s
	as cmdalias_s	ptr _next
	
	as zstring * MAX_ALIAS_NAME	_name   
	as zstring ptr	value 
   
End Type :type  cmdalias_t as  cmdalias_s 
 


dim shared as  cmdalias_t ptr cmd_alias  

dim shared as  qboolean	cmd_wait 

#define	ALIAS_LOOP_COUNT	16
dim shared as  integer		alias_count		'// for detecting runaway loops




'/*
'=============================================================================
'
'						COMMAND BUFFER
'
'=============================================================================
'*/

dim shared as  sizebuf_t	cmd_text 
dim shared as ubyte		cmd_text_buf(8192) 

dim shared  as ubyte defer_text_buf(8192)

 


'/*
'=============================================================================
'
'					COMMAND EXECUTION
'
'=============================================================================
'*/
'


'/*
'============
'Cmd_Argc
'============
'*/
 function Cmd_Argc () as integer
   ' print "in Cmd_Argc " & _cmd_argc
 	 return _cmd_argc
 End Function
 

'/*
'============
'Cmd_Argv
'============
'*/
function Cmd_Argv (arg as integer ) as  zstring ptr 
		if ( cast(uinteger,arg) >= _cmd_argc ) then
			 return cmd_null_string 
		EndIf
		
		   
	return _cmd_argv(arg)	
 
	
End Function


 
'/*
'============
'Cmd_Args
'
'Returns a single string containing argv(1) to argv(argc()-1)
'============
'*/
function Cmd_Args () as ZString ptr
		return @_cmd_args 
End Function
 

'/*
'============
'Cbuf_Init
'============
'*/
sub Cbuf_Init ()
	
		SZ_Init (@cmd_text, @cmd_text_buf(0), sizeof(cmd_text_buf) * ubound(cmd_text_buf)) 
End Sub



'/*
'=============================================================================
'
'				COMMAND EXECUTION
'
'=============================================================================
'*/

'/*
'============
'Cmd_AddCommand
'============
'*/
sub	Cmd_AddCommand (cmd_name as zstring ptr, _function as xcommand_t )
 
 dim	cmd as cmd_function_t	 ptr 
 
 
	
 '// fail if the command is a variable name
 	if (Cvar_VariableString(cmd_name)[0]) then
 				Com_Printf (!"Cmd_AddCommand: %s already defined as a var\n", cmd_name) 
      return 
  
 	EndIf
 
 
 cmd=cmd_functions
 
 

 
 do while cmd
 	
 	if (strcmp (cmd_name, cmd->_name) = 0) then
 				Com_Printf (!"Cmd_AddCommand: %s already defined\n", cmd_name) 
 			return 
 		
 	EndIf
 
   cmd=cmd->_next
 
 Loop
 
 
 	cmd = Z_Malloc (sizeof(cmd_function_t)) 
 	cmd->_name = cmd_name 
 	cmd->_function = _function 
 	cmd->_next = cmd_functions 
 	cmd_functions = cmd 
 end sub





sub Cmd_List_f
   dim as cmd_function_t	ptr cmd 
	 dim as integer				i 

	i = 0
	cmd=cmd_functions
	do while cmd
		Com_Printf (!"%s\n", cmd->_name)
		cmd = cmd->_next
		i+=1
	Loop
	
 
		
	Com_Printf (!"%i commands\n", i) 
	
	
End Sub

sub Cmd_Exec_f
	 dim as zstring ptr f,f2 
	  dim as integer		_len 
'cls	  

'print "in Cmd_Exec_f"
' print  "RIGHT HERE: " & *Cmd_Argv(0) & " " &  *Cmd_Argv(1) & " " &  *Cmd_Argv(2) 
'sleep 

'print "in Cmd_Exec_f"
 'print  "RIGHT HERE: " & *Cmd_Argv(0) & " " &  *Cmd_Argv(1) & " " &  *Cmd_Argv(2) 






	 if (Cmd_Argc () <> 2) then
 
	 	Com_Printf (!"exec <filename> : execute a script file\n") 
	 	return 
	 end if
	 
	         '   print *Cmd_Argv(1)
           'sleep
	 
	 _len = FS_LoadFile (Cmd_Argv(1), cast(any ptr ptr, @f)) 
	  if ( f = NULL) then
	    Com_Printf (!"couldn't exec %s\n",Cmd_Argv(1)) 
	 	return 
	  EndIf
 
 
 
    ' print *Cmd_Argv(0) & " " &  *Cmd_Argv(1) & " " &  *Cmd_Argv(2) 
    
    
'sleep 

	 
	 Com_Printf (!"execing %s\n",Cmd_Argv(1))  
	 
	'// the file doesn't have a trailing 0, so we need to copy it off
	 f2 = Z_Malloc(_len+1) 
	 memcpy (f2, f, _len) 
	 f2[_len] = 0 

	 Cbuf_InsertText (f2) 

	 Z_Free (f2) 
	FS_FreeFile (f) 
	
	

End Sub


 

sub Cmd_Wait_f
	
		cmd_wait = _true
	
End Sub




'/*
'===============
'Cmd_Echo_f
'
'Just prints the rest of the line to the console
'===============
'*/
sub Cmd_Echo_f ()
'print "IN ECHO"
 
	dim as	integer		i 
 
	for  i = 1  to  Cmd_Argc() -1
		Com_Printf (!"%s ",Cmd_Argv(i)) 
	next	
	Com_Printf (!"\n") 

 

End Sub
 



'/*
'============
'Cbuf_AddText
'
'Adds command text at the end of the buffer
'============
'*/
sub Cbuf_AddText (text as zstring ptr )
	dim as	integer		l 

	if (cmd_text.cursize + l >= cmd_text.maxsize) then
		Com_Printf (!"Cbuf_AddText: overflow\n") 
		return 
 
		
	EndIf
	 
		
	SZ_Write (@cmd_text, text, strlen (text)) 
 
 
End Sub
 
 
'/*
'======================
'Cmd_MacroExpandString
'======================
'*/
function Cmd_MacroExpandString (text as zstring ptr) as zstring ptr
 
	dim as integer		i, j, count, _len 
	dim as qboolean	inquote 
	dim as zstring ptr scan 
	static as 	zstring	* MAX_STRING_CHARS expanded 
	static as 	zstring	* MAX_STRING_CHARS	temporary 
	dim as zstring ptr token,start 

	inquote = _false 
	scan = text 

	_len = strlen (scan) 
	if (_len >= MAX_STRING_CHARS) then
		Com_Printf (!"Line exceeded %i chars, discarded.\n", MAX_STRING_CHARS) 
		return NULL 
	EndIf
	
	count = 0 

 
	 for i = 0 to _len-1
	 	if (scan[i] = asc(!"\"")) then
			inquote xor= 1 
		end if
		if (inquote) then
			continue for 	'// don't expand inside quotes
		end if	
	 	
 			
			
		if (scan[i] <> asc("$")) then
			continue for
		EndIf
			
		'// scan out the complete macro
		start = scan+i+1 
		token = COM_Parse (@start) 
		if (start = NULL) then
			continue for
		EndIf
			
	
		 token = Cvar_VariableString (token) 

		j = strlen(token) 
		_len += j 
		if (_len >= MAX_STRING_CHARS) then
				 
			Com_Printf (!"Expanded line exceeded %i chars, discarded.\n", MAX_STRING_CHARS) 
			return NULL 
		EndIf
	 

		 strncpy (@temporary, scan, i) 
		  strcpy (@temporary+i, token) 
		 strcpy (@temporary+i+j, start) 

		strcpy (@expanded, temporary) 
		scan = @expanded 
		i-=1
		
      count+=1
		if (count = 100) then
			Com_Printf (!"Macro expansion loop, discarded.\n")
			
		EndIf
 
			return NULL 
		 
	next

	if (inquote) then
			Com_Printf (!"Line has unmatched quote, discarded.\n")  
		return NULL 
		
	EndIf
 

	return scan 
end function

 
 
 
'/*
'============
'Cmd_TokenizeString
'
'Parses the given string into command line tokens.
'$Cvars will be expanded unless they are in a quoted token
'============
'*/
sub Cmd_TokenizeString (text as zstring ptr,macroExpand as  qboolean )
 
	dim as integer		i 
	dim as zstring ptr com_token

 
 
'// clear the args from the last string
	for i = 0 to _cmd_argc - 1
 
		Z_Free (_cmd_argv(i)) 
		
	Next
	
	

 
	_cmd_argc  = 0 
	_cmd_args[0] = 0 
	
'	'// macro expand the text
 	if (macroExpand) then
  		 text = Cmd_MacroExpandString (text) 
   end if
 	if (text = NULL) then
 			return 
 	EndIf
 	

 
 	while (1)
'	{
'// skip whitespace up to a /n
 		while (*text and *text <= asc(" ") and *text <> asc(!"\n"))
 		
  
 		 
 			text+=1
 		Wend

 

'		
 		if (*text = asc(!"\n")) then
 		 
'		 	// a newline seperates commands in the buffer
   		text+=1
 		end if
 		

 		
 		if ( *text = NULL) then

 			return
 		EndIf
 		
 		
 

''
'		// set cmd_args to everything after the first arg
 		if (_cmd_argc =  1) then
 
 		dim as integer		l 
 
   		strcpy (_cmd_args, text) 
 

'			// strip off any trailing whitespace
 			l = strlen(_cmd_args) - 1
 			
 			do while l >= 0 
 				if (_cmd_args[l] <= asc(" ")) then
  					_cmd_args[l] = 0 
 				else
 					exit do
           end if
 				
 				l-=1
 			Loop
 			 
 		end if 
       
  


 		 com_token = COM_Parse (@text)
 		 

 
   	  if (text = NULL) then

   	  	return 
   	  EndIf
 

 	if (cmd_argc < MAX_STRING_TOKENS) then
 		
 			  			''	print "in tokenization"

 		  _cmd_argv(_cmd_argc) = Z_Malloc (strlen(com_token)+1) 
 		  strcpy (_cmd_argv(_cmd_argc), com_token) 
  
 			 
 			_cmd_argc+=1
 
 	 
 	EndIf
 wend
 	 		 
 
 
end sub
  
 
 
 
 
' /*
'============
'Cbuf_InsertText
'
'Adds command text immediately after the current command
'Adds a \n to the text
'FIXME: actually change the command buffer to do less copying
'============
'*/
sub Cbuf_InsertText (text as zstring ptr)
	
	
   dim as zstring ptr temp 
	 dim as integer		templen 

'// copy off any commands still remaining in the exec buffer
	templen = cmd_text.cursize 
	if (templen) then
		temp = Z_Malloc (templen)
		memcpy (temp, cmd_text._data, templen)
		SZ_Clear (@cmd_text)
	else	
		temp = NULL
	EndIf
 
		
'// add the entire text of the file
	Cbuf_AddText (text) 
	
'// add the copied off data
	if (templen) then
			SZ_Write (@cmd_text, temp, templen) 
		Z_Free (temp) 
		
	EndIf
 
 
	
End Sub




 
 
 
 
'/*
'============
'Cmd_ExecuteString
'
'A complete command line has been parsed, so try to execute it
'FIXME: lookupnoadd the token to speed search?
'============
'*/
sub	Cmd_ExecuteString (text as zstring ptr)
 
	dim as cmd_function_t ptr cmd
	dim as cmdalias_t ptr  a 
	
 
	Cmd_TokenizeString (text, _true) 

 

	'// execute the command line
 
  if (Cmd_Argc() = NULL) then
	 		 return 	'// no tokens
	 EndIf
	
	'// check functions
	cmd=cmd_functions
	


  
	do while cmd
 
		if ( Q_strcasecmp (_cmd_argv(0), cmd->_name) = 0) then
  
       'print *cmd->_name
   
			if ( cmd->_function = NULL) then
				'print "NOT IN FUNCTION"
				Cmd_ExecuteString (_va("cmd %s", text)) 
			else
				'print "IN FUNCTION"
				cmd->_function ()
				return
			EndIf
			
		 
	 	end if
		
   'print *cmd->_name
		cmd=cmd->_next
	Loop
	
   
	'// check alias
	
	a = cmd_alias
	do while a 
				if ( Q_strcasecmp (_cmd_argv(0),  a->_name) = 0) then
 	
		 alias_count +=1
			if alias_count = ALIAS_LOOP_COUNT  then
				  
				Com_Printf (!"ALIAS_LOOP_COUNT\n") 
				return 
				
			End If
	 
			 Cbuf_InsertText (a->value) 
			 
			 
	 
			return 
	
			 End If
			
		
		a = a->_next
	Loop
	
 
	'// check cvars
	 if (Cvar_Command ()) then
	 	return
	 EndIf
	 
	'// send it as a server command if we are connected
	 Cmd_ForwardToServer () 
end sub 


sub Cbuf_ExecuteText (exec_when as integer ,  text as ZString ptr)
	
	
	
End Sub 






' 
' /*
'============
'Cbuf_Execute
'============
'*/
sub Cbuf_Execute ()
	dim as integer		i 
	dim as zstring ptr  text
	dim as zstring  * 1024  	_line
	dim as integer		quotes 

	alias_count = 0 		'// don't allow infinite alias loops
	
 



 	while (cmd_text.cursize)
' 
''// find a \n or ; line break
 	text = cast(zstring ptr,  cmd_text._data)

 	
 	 
		quotes = 0 
		for i = 0 to	cmd_text.cursize -1
			if (text[i] = asc(!"\"")) then
			
			quotes+=1
			
			end if
			'print (quotes and 1)
			'sleep
			
			if ((quotes and 1) = NULL) and text[i] = asc(";") then
				exit for
			EndIf
			if text[i] = asc(!"\n") then
				
				exit for
				
			EndIf
			
		Next

						
				
		memcpy (@_line, text, i) 
		
				'print "in Cbuf_Execute ()"


		
		_line[i] = 0 
		
		
		


		

		
		
		'	

'// delete the text from the command buffer and move remaining commands down
'// this is necessary because commands (exec, alias) can insert data at the
'// beginning of the text buffer

		if (i = cmd_text.cursize)  then
			cmd_text.cursize = 0 
		else
		 
			i+=1
			cmd_text.cursize -= i 
			memmove (text, text+i, cmd_text.cursize) 
		end if

 
		

'// execute the command line
		Cmd_ExecuteString (_line)
		
		

 
		
		if (cmd_wait) then
			 
			'// skip out while text still remains in buffer, leaving it
			'// for next frame
			cmd_wait = _false 
			exit while
			
		EndIf
		
		 
 	wend
 
End Sub
 

 
 
 
 

 

' /*
'===============
'Cbuf_AddEarlyCommands
'
'Adds command line parameters as script statements
'Commands lead with a +, and continue until another +
'
'Set commands are added early, so they are guaranteed to be set before
'the client and server initialize for the first time.
'
'Other commands are added late, after all initialization is complete.
'===============
'*/
sub Cbuf_AddEarlyCommands (_clear as qboolean )
 
	dim as integer		i 
	dim as 	zstring ptr s
 
 
   for i = 0 to COM_Argc()-1 
    
    
   	s = COM_Argv(i)
   	
   	
   	 	if (strcmp (s, "+set")) then
   	 		continue for
   	 		
   	 	EndIf
   	 	Cbuf_AddText (_va(!"set %s %s\n", COM_Argv(i+1), COM_Argv(i+2)))
   		
   		
	      if (_clear) then
	      	'print *_va(!"set %s %s\n", COM_Argv(i+1), COM_Argv(i+2))
	      	'sleep
	    	COM_ClearArgv(i)
	 		COM_ClearArgv(i+1) 
	 		COM_ClearArgv(i+2) 
	      '	
	      EndIf
 
	 	i+=2 
	
	
   Next

 
end sub

sub Cmd_Alias_f
	dim as	cmdalias_t	ptr a 
 	dim as zstring *	1024 cmd  
 dim as 	integer			i, c 
 dim as zstring ptr s 

 'print Cmd_Argc()
 'print  * Cmd_Argv(0) & " "  &  * Cmd_Argv(1) & "  " & * Cmd_Argv(2)
 
 
 
 	if (Cmd_Argc()  = 1) then
 		Com_Printf (!"Current alias commands:\n")
 		
 		
 		a = cmd_alias
 			 do while a
 			 	
 			 	Com_Printf (!"%s : %s\n", a->_name, a->value) 
 			 	a = a->_next	
 			 Loop
 	
   	return 
 		
 	EndIf
 
 s = Cmd_Argv(1)
 if (strlen(s) >= MAX_ALIAS_NAME) then
 	Com_Printf (!"Alias name is too long\n") 
		return 
 EndIf

  a = cmd_alias
   do while a
	'// if the alias already exists, reuse it
		if ( strcmp(s, a->_name) = 0) then
			Z_Free (a->value) 	
			
		EndIf
     a = a->_next
	loop
   
 
 	if (a = NULL) then
 	 
 	   a = Z_Malloc (sizeof(cmdalias_t)) 
 		a->_next = cmd_alias 
 		cmd_alias = a 
 		
 	EndIf  
 	 
 	 
 
   
   
 	strcpy (a->_name, s) 	
   	 
  
'// copy the rest of the command line
 	cmd[0] = 0 		'// start out with a null string
 	c = Cmd_Argc() 
	 for i = 2 to c-1
	 		strcat (cmd, Cmd_Argv(i)) 
      if (i <> (c - 1)) then
      	strcat (cmd, !" ") 
      EndIf
 				
	 	
	 Next 
 strcat (cmd, !"\n") 
 
 	a->value = CopyString (cmd) 
	
	
End Sub

sub Cmd_Init()
 
	 Cmd_AddCommand ("cmdlist",@Cmd_List_f)
	 Cmd_AddCommand ("exec",@Cmd_Exec_f) 
	 Cmd_AddCommand ("echo",@Cmd_Echo_f)
	 Cmd_AddCommand ("alias",@Cmd_Alias_f)
	 Cmd_AddCommand ("wait", @Cmd_Wait_f)	 

End Sub

' /*
'=================
'Cbuf_AddLateCommands
'
'Adds command line parameters as script statements
'Commands lead with a + and continue until another + or -
'quake +vid_ref gl +map amlev1
'
'Returns _true if any late commands were added, which
'will keep the demoloop from immediately starting
'=================
'*/
function Cbuf_AddLateCommands () as qboolean 
		dim as integer		i, j 
	dim as integer	 		s 
	dim as zstring ptr text,  build, c 
	dim as integer		argc 
	dim as qboolean	ret 
	
	

	'sleep
'// build the combined string to parse from
	s = 0 
	argc = COM_Argc() 
	for i = 1 to argc -1
		s += strlen (COM_Argv(i)) + 1
		
	Next
 
 
 
 
	if (s = NULL)  then
		return _false 
	EndIf
		
		text = Z_Malloc (s+1) 
	text[0] = 0 
	
	
	
 for i = 1 to argc -1
 	strcat (text,COM_Argv(i)) 
 if (i <> argc-1) then
 		strcat (text, " ") 
 EndIf
 
		
		Next
 
 
 
 
 
 
'// pull out the commands
	build = Z_Malloc (s+1) 
	build[0] = 0 
		
	for i = 0 to (s-1)-1
 
		if (text[i] = asc("+")) then
			i+=1
			
			j = i
			do while (text[j] <> asc("+")) and (text[j] <> asc("-")) and (text[j] <> 0)
			j+=1
			Loop
			
			*c = text[j] 
			text[j] = 0
			
			strcat (build, text+i) 
			strcat (build, !"\n") 
			text[j] = *c 
			i = j-1 
		EndIf

	 
	next

	
	
	
 ret = (build[0] <> 0) 
	if (ret) then
		Cbuf_AddText (build)
	EndIf
	 
	Z_Free (text) 
	Z_Free (build) 

	return ret 
	
End Function
  