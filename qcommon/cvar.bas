#Include "qcommon\qcommon.bi"


dim shared as cvar_t	ptr cvar_vars



dim shared as qboolean userinfo_modified 

'/*
'============
'Cvar_FindVar
'============
'*/
function Cvar_FindVar (var_name as zstring ptr) as cvar_t ptr static 
 
	dim as cvar_t ptr	_var 
	
	
	_var = cvar_vars
	
	
	do while _var
		
	 if ( strcmp (var_name, _var->_name) = 0) then
	 	return _var 
	 	
	 EndIf
			
		_var=_var->_next
	Loop
	
	
 
	return NULL 
end function

'/*
'============
'Cvar_InfoValidate
'============
'*/
function Cvar_InfoValidate (s as zstring ptr) as qboolean static 

 
	if (strstr (s, !"\\")) then
		return _false 
	EndIf
		
	if (strstr (s, !"\"")) then
		return _false 
	end if	
		
	if (strstr (s, !";")) then
		return _false 
   end if		
		
	return _true 
 
end function


'/*
'============
'Cvar_List_f
'
'============
'*/
sub Cvar_List_f ()
	dim  as cvar_t	ptr _var 
	dim as integer		i 
	i = 0
	 
	 
	 _var = cvar_vars 
	 do while _var
	 	if  _var->flags and CVAR_ARCHIVE  then
	 		Com_Printf ("*")
	 	else
	 		Com_Printf (" ")
	 	EndIf
	 	
	 	if  _var->flags   and _CVAR_USERINFO  then
	 		Com_Printf ("U")
	 	else
	 		Com_Printf (" ")
	 	EndIf
	 	 
	 	if  _var->flags and _CVAR_SERVERINFO  then
	 		Com_Printf ("S") 
   	else
	 		Com_Printf (" ") 
	 	end if
	 	 
	 	if  _var->flags and CVAR_NOSET  then
	 		Com_Printf ("-") 
	 	elseif  _var->flags and CVAR_LATCH  then
	 		Com_Printf ("L") 
	 	else
	 		Com_Printf (" ") 
	 	end if
	 	
	 	
 
	 Com_Printf (!" %s \"%s\"\n", _var->_name, _var->_string) 
	 
	 _var = _var->_next
	
	    i+=1
	 
	 loop
	
	Com_Printf (!"%i cvars\n", i) 
	
End Sub
 
 


	 
function Cvar_FullSet(var_name as zstring ptr,value as zstring ptr, flags as integer)  as cvar_t ptr
	dim as cvar_t	ptr _var 
	
	_var = Cvar_FindVar (var_name) 
	if ( _var = NULL) then
		 	'// create it
		return Cvar_Get (var_name, value, flags) 
		
	EndIf
	
	 

	_var->modified = _true 

	if (_var->flags and _CVAR_USERINFO) then
			userinfo_modified = _true 	'// transmit at next oportunity
	EndIf
	
	
	Z_Free (_var->_string) 	'// free the old value string
	
	_var->_string = CopyString(value) 
	_var->value = atof (_var->_string) 
	_var->flags = flags 

	return _var 
	
	
	
	
End function



'/*
'============
'Cvar_Set_f
'
'Allows setting and defining of arbitrary cvars from console
'============
'*/
sub Cvar_Set_f ()
	dim as integer	c 
	dim as integer	flags 

	c =   Cmd_Argc() 
  
  
  
' print *Cmd_Argv(0) & " " &  *Cmd_Argv(1) & " " &  *Cmd_Argv(2) 
 
 
 
 'print "in Cvar_Set_f"
 
  'print Cmd_Argc()
 'print  "RIGHT HERE: " & *Cmd_Argv(0) & " " &  *Cmd_Argv(1) & " " &  *Cmd_Argv(2) 

 
 'sleep

	if (c <> 3 and c <> 4) then
		 
		Com_Printf (!"usage: set <variable> <value> [u / s]\n") 
		return 	
		
	EndIf

 
	if (c = 4) then
			if ( strcmp(Cmd_Argv(3), "u") = 0 ) then
			flags = _CVAR_USERINFO
			elseif (strcmp(Cmd_Argv(3), "s") = 0) then
			flags = _CVAR_SERVERINFO 
		else
		 
			Com_Printf (!"flags can only be 'u' or 's'\n") 
			return 
			end if
		 Cvar_FullSet (Cmd_Argv(1), Cmd_Argv(2), flags) 
	 
	else
		 Cvar_Set (Cmd_Argv(1), Cmd_Argv(2)) 
		
	EndIf
 
	
		
		
		
End Sub







function CopyString ( in as zstring ptr) as zstring ptr
	
		dim as zstring ptr _out 
	
	_out = Z_Malloc (strlen(in)+1) 
	strcpy (_out, in) 
	return _out 
	
End Function





'/*
'============
'Cvar_Set2
'============
'*/
function Cvar_Set2 (var_name as zstring ptr,  value as zstring ptr,force as qboolean ) as cvar_t ptr
 
	dim   as  cvar_t ptr _var 

 	_var = Cvar_FindVar (var_name) 
 	if (_var = NULL) then
 		
 		return Cvar_Get (var_name, value, 0)
 	EndIf
 
 	if (_var->flags and (_CVAR_USERINFO or _CVAR_SERVERINFO)) then
 		
 				if ( Cvar_InfoValidate (value) = 0) then
 					Com_Printf(!"invalid info cvar value\n")
 					
 						return _var 
 					 
 				EndIf
 				
 			EndIf		
	 

 
 	if ( force = NULL) then
 	if (_var->flags and CVAR_NOSET) then
 
 			Com_Printf (!"%s is write protected.\n", var_name) 
 			return _var 
 
 	EndIf
 		
 	EndIf
 

 
   	if (_var->flags and CVAR_LATCH) then
 
 			if (_var->latched_string) then
 		 
 				if (strcmp(value, _var->latched_string) = 0) then
 					
 					Z_Free (_var->latched_string)
 					return _var
 				EndIf
 
 
 		 
 		  else
 
 				if (strcmp(value, _var->_string)  = 0) then
 					return _var
 					
 				EndIf
 
 			end if
 
'			if (Com_ServerState())
'			{
'				Com_Printf ("%s will be changed for next game.\n", var_name);
'				var->latched_string = CopyString(value);
'			}
'			else
'			{
'				var->string = CopyString(value);
'				var->value = atof (var->string);
'				if (!strcmp(var->name, "game"))
'				{
'					FS_SetGamedir (var->string);
'					FS_ExecAutoexec ();
'				}
'			}

 			'return _var 
 	'	end if
 
 	else
 
 		if (_var->latched_string) then
 		 
 			Z_Free (_var->latched_string) 
 			_var->latched_string = NULL 
 		end if
 end if
'
  if ( strcmp(value, _var->_string) = 0) then
  	return _var
  	
  EndIf
 
 	_var->modified = _true 
'
 	if (_var->flags and  _CVAR_USERINFO) then
 		userinfo_modified = _true         '// transmit at next oportunity
 	EndIf
 
 	Z_Free (_var->_string) 	'// free the old value string
 
 
 	_var->_string = CopyString(value) 
 	_var->value = atof (_var->_string) 
 
 	return _var 
	
	
End Function

 


'/*
'============
'Cvar_Set
'============
'*/
function Cvar_Set (var_name as zstring ptr,  value as zstring ptr) as cvar_t ptr
		 return Cvar_Set2 (var_name, value, _false) 
	
	
End Function
 
 
'/*
'============
'Cvar_VariableString
'============
'*/
function Cvar_VariableString (var_name as ZString ptr) as zstring ptr
	dim as	cvar_t ptr _var 
	
	_var = Cvar_FindVar (var_name) 
	if (_var = NULL) then
		return @"" 
		
	EndIf
		
	return _var->_string 
End Function
 
 
''/*
''============
''Cvar_Command
''
''Handles variable inspection and changing from the console
''============
''*/
function Cvar_Command () as qboolean 
 
	dim as cvar_t ptr			 v 

'// check variables
	v = Cvar_FindVar (Cmd_Argv(0)) 
	if (v = NULL) then
		return _false
		
	EndIf
	 
		
'// perform a variable print or set
	if (Cmd_Argc() =  1) then
		Com_Printf (!"\"%s\" is \"%s\"\n", v->_name, v->_string)
		return _false
	EndIf
 

	 Cvar_Set (v->_name, Cmd_Argv(1)) 
	return _false 
end function



'/*
'============
'Cvar_Get
'
'If the variable already exists, the value will not be set
'The flags will be or'ed in if the variable exists.
'============
'*/
function Cvar_Get (var_name as  zstring ptr,var_value as  zstring ptr,flags as  integer ) as cvar_t ptr
 
	dim as cvar_t ptr _var 
	
	if (flags and (_CVAR_USERINFO or _CVAR_SERVERINFO)) then
		 if (Cvar_InfoValidate (var_name) = NULL) then
		 	
			Com_Printf(!"invalid info cvar name\n") 
		 	return NULL 
		 EndIf
		 
			
	 
	EndIf
  

	_var = Cvar_FindVar (var_name) 
	if (_var) then
			_var->flags or= flags 
		return _var 
	EndIf
	 
	
	
	 

	if (var_value = NULL) then
		return NULL 
	EndIf
		

	if (flags and (_CVAR_USERINFO or _CVAR_SERVERINFO)) then
	 
		if (Cvar_InfoValidate (var_value) = NULL) then
		 
			Com_Printf(!"invalid info cvar value\n") 
			return NULL 
		end if
	end if
	

  _var = Z_Malloc (sizeof(*_var))

	_var->_name = CopyString (var_name) 
	_var->_string = CopyString (var_value) 
	_var->modified = _true 
	_var->value = atof(_var->_string) 

	'// link the variable in
	_var->_next = cvar_vars 
	cvar_vars = _var 

	_var->flags = flags 
	
 


	return _var 
 
 


end function


sub Cvar_SetValue (var_name as zstring ptr,value as float ) 
	
	dim as zstring * 32 	_val 

	if (value =  cast(integer,value)) then
		 Com_sprintf (_val, sizeof(_val), "%i",cast(integer,value))
	else
		Com_sprintf (_val, sizeof(_val), "%f",value) 
	EndIf
	
		Cvar_Set (var_name, _val) 

End Sub


sub	Cmd_RemoveCommand (cmd_name as ZString ptr)
	
	
	
End Sub

'/*
'============
'Cvar_WriteVariables
'
'Appends lines containing "set variable value" for all variables
'with the archive flag set to _true.
'============
'*/
sub Cvar_WriteVariables (path as ZString ptr)
   dim as cvar_t	ptr _var 
	dim as zstring * 1024   buffer 
	dim as FILE	ptr  f 
	
	
	
	f = fopen (path, "a")
	
	_var =  cvar_vars
	do while _var 
		
		
		if _var->flags and CVAR_ARCHIVE then
			
			Com_sprintf (buffer, sizeof(buffer), !"set %s \"%s\"\n", _var->_name, _var->_string) 
			fprintf (f, "%s", buffer) 

			
		EndIf
		
		
		
		_var = _var->_next
	Loop
	
		fclose (f) 
End Sub
 
 
	 
	 
'/*
'============
'Cvar_Init
'
'Reads in all archived cvars
'============
'*/
sub Cvar_Init ()
	
   Cmd_AddCommand ("set", @Cvar_Set_f) 
	Cmd_AddCommand ("cvarlist", @Cvar_List_f) 
	
End Sub
 

function Cvar_VariableValue(var_name as zstring ptr) as float
	
		dim as cvar_t	ptr  _var 
	
	_var = Cvar_FindVar (var_name) 
	if (_var = NULL) then
		return 0
	EndIf
	 
	return atof (_var->_string) 
End function
