
 #Include "qcommon\qcommon.bi"
 #include "crt\setjmp.bi"
 
#define	MAXPRINTMSG	4096

#define MAX_NUM_ARGVS	50


dim shared as integer		_com_argc 
dim shared as zstring ptr _com_argv(MAX_NUM_ARGVS+1)

dim shared as integer		realtime 

dim shared as jmp_buf abortframe   	'// an ERR_DROP occured, exit the entire frame


dim shared as FILE ptr log_stats_file 

dim shared as cvar_t ptr host_speeds 
dim shared as cvar_t ptr log_stats 
dim shared as cvar_t ptr developer 
dim shared as cvar_t ptr timescale 
dim shared as cvar_t ptr fixedtime 
dim shared as cvar_t ptr logfile_active 	'// 1 = buffer log, 2 = flush after each print
dim shared as cvar_t ptr showtrace 
dim shared as cvar_t ptr dedicated 

dim shared as FILE ptr logfile 

dim shared as integer			server_state 

'// host_speeds times
dim shared as integer		time_before_game 
dim shared as integer		time_after_game 
dim shared as integer		time_before_ref 
dim shared as integer		time_after_ref 



'extern registration_sequence as integer 

#define	Z_MAGIC		&H1d1d


type  zhead_s
as zhead_s ptr	_prev, _next 
as short magic
as short tag 
as Integer _size	
End Type: type zhead_t as zhead_s
 
 
 
extern  as zhead_t		z_chain 
extern  as integer		z_count, z_bytes 

 
dim shared as zhead_t		z_chain 
dim shared as integer		z_count, z_bytes 


type packfile_t
  _name as zstring * MAX_QPATH  
  as integer _filepos, _filelen 
	
End Type
 
 
type pack_s
	filename  as zstring * MAX_OSPATH 
	handle  as FILE ptr
	 numfiles  as Integer
	 _files  as packfile_t ptr
	
	
End Type: type  pack_t  as pack_s
 
 


 dim shared pak_ as pack_t ptr

  declare function FS_LoadPackFile (packfile as zstring ptr) as pack_t ptr
  
  
  #define	MAXPRINTMSG	4096
  
 sub Com_Printf cdecl(_fmt as ZString ptr, ...)
 
	dim argptr  as va_list		 
	dim msg as zstring  * MAXPRINTMSG   

	cva_start (argptr,_fmt) 
	vsprintf (msg,_fmt,argptr) 
	cva_end (argptr) 

	'if (rd_target)
	'{
'		if ((strlen (msg) + strlen(rd_buffer)) > (rd_buffersize - 1))
	'	{
	'		rd_flush(rd_target, rd_buffer);
	'		*rd_buffer = 0;
	'	}
	'	strcat (rd_buffer, msg);
	'	return;
	'}

	'Con_Print (msg)
	
 
	'temporary fix''''''''''
	printf(msg)
	'printf(!"\n") 
	''''''''''''''''''''''''' 
	
	'// also echo to debugging console
	'Sys_ConsoleOutput (msg);

	'// logfile
	'if (logfile_active && logfile_active->value)
	'{
'		char	name[MAX_QPATH];
	'	
	'	if (!logfile)
	'	{
	'		Com_sprintf (name, sizeof(name), "%s/qconsole.log", FS_Gamedir ());
	'		if (logfile_active->value > 2)
	'			logfile = fopen (name, "a");
	'		else
	'			logfile = fopen (name, "w");
	'	}
	'	if (logfile)
	'		fprintf (logfile, "%s", msg);
	'	if (logfile_active->value > 1)
	'		fflush (logfile);		// force it to save every time
	'}
end sub 
  
  
  

  
  
sub Z_Free (_ptr as any ptr)
	
		dim z as zhead_t ptr

	z = cast( zhead_t ptr,_ptr) - 1 
 	'print  z->magic
 	 
	if (z->magic <> Z_MAGIC) then

		'Com_Error (ERR_FATAL, "Z_Free: bad magic");
	print "Z_Free: bad magic"
	end if

	z->_prev->_next = z->_next 
	z->_next->_prev = z->_prev 

	z_count-=1
	z_bytes -= z->_size 
   
	free(z) 
	
	
	'z->_size = 1234
	'print  z->magic
	
  'sleep
End Sub
 

' /*
'========================
'Z_TagMalloc
'========================
'*/
function Z_TagMalloc ( _size as integer,_tag as integer ) as any ptr
	
	dim z as zhead_t ptr 
	
   _size = _size + sizeof(zhead_t) 
 	z = malloc(_size) 
 
 
   if ( z = NULL) then
 
 	Com_Error (ERR_FATAL, !"Z_Malloc: failed on allocation of %i bytes",_size) 	 	 
   EndIf
 	 memset (z, 0, _size)
 	 z_count+=1
	 z_bytes += _size 
	 z->magic = Z_MAGIC 
	 z->tag = _tag 
	 z->_size = _size 

	 z->_next = z_chain._next
	 z->_prev = @z_chain 
	 z_chain._next->_prev = z 
	 z_chain._next = z 
 	 
 
 
 
  return cast(any ptr , z+1) 
 
	
	
End Function
 
 
 
'/*
'========================
'Z_Stats_f
'========================
'*/
sub Z_Stats_f ()
	Com_Printf (!"%i bytes in %i blocks\n", z_bytes, z_count) 
	
End Sub
 
	
 
'
'/*
'========================
'Z_Malloc
'========================
'*/
function Z_Malloc (_size as Integer ) as any ptr
	  return Z_TagMalloc (_size, 0) 
End function
 
 
 
 
 
sub SZ_Init (buf as sizebuf_t ptr ,_data as  ubyte ptr, length as integer )
	
	memset (buf, 0, sizeof(*buf)) 
	buf->_data = _data 
	buf->maxsize = length 
 
End Sub




sub SZ_Clear (buf as sizebuf_t ptr)
	buf->cursize = 0
	buf->overflowed = _false
	
End Sub
 

function SZ_GetSpace (buf as sizebuf_t ptr ,length as  integer ) as any ptr
 
	dim _data as any	ptr
	
	
	

	
	if (buf->cursize + length > buf->maxsize) then
		
 
		
	 if (length > buf->maxsize) then
			Com_Error (ERR_FATAL, "SZ_GetSpace: %i is > full buffer size", length)
		end if
		
		Com_Printf ("SZ_GetSpace: overflow\n")
		SZ_Clear (buf)  
		buf->overflowed = _true 
	
	 
		if ( buf->allowoverflow = NULL) then
			Com_Error (ERR_FATAL, "SZ_GetSpace: overflow without allowoverflow set") 
		EndIf
			
		
EndIf
			
	 
		
		


	_data = buf->_data + buf->cursize 
	buf->cursize += length 
	
	

	
	return _data 
end function


'/*
'=============
'Com_Error_f
'
'Just throw a fatal error to
'test error shutdown procedures
'=============
'*/
sub Com_Error_f ()
	
	Com_Error (ERR_FATAL, !"%s", Cmd_Argv(1)) 
End Sub



sub SZ_Write (buf as sizebuf_t ptr, _data as any ptr,length as integer )
	
	

	memcpy (SZ_GetSpace(buf,length),_data,length) 
 
 
   
End Sub
 
		
function COM_Argc () as Integer
	return _com_argc 
End Function


function COM_Argv (arg as integer ) as ZString ptr
	if (arg < 0 or arg >= com_argc or  _com_argv(arg) = NULL) then
		
		return @""
		
		
	EndIf
	
	return _com_argv(arg)
End Function


declare sub SCR_EndLoadingPlaque () 
declare sub Key_Init () 
 

 
'MIGHT DELETE''''''''''''
'declare sub shut_down1()
'''''''''''''''''''''''''

 sub	Qcommon_Init (argc as integer , argv as ubyte ptr ptr) 
 	
' 	registration_sequence = 1
 	
 		dim s as zstring ptr
 		
  if (setjmp (@abortframe) ) then
  	'NOT COMPLETE''''''''''''
  	Sys_Error ("Error during initialization")
  	''''''''''''''''''''''''
  EndIf

 	z_chain._prev  = @z_chain
	z_chain._next = z_chain._prev 
 	 
 	'// prepare enough of the subsystems to handle
	'// cvar and command buffer management
	
	 'works fine''''
	 COM_InitArgv (argc, argv) 
	 ''''''''''''''''''''''''
	 
   'works fine''''
	 Swap_Init ()
 	''''''''''''''''''''''''
 	'works fine''''
 	 Cbuf_Init () 
 	  ''''''''''''''''''''''''
 	 
 	 'works fine''''
	 Cmd_Init () 
	 ''''''''''''''''''''''''
	 
	 'works fine''''
	 Cvar_Init () 
    ''''''''''''''''''''''''
    
    'works fine''''
	 Key_Init () 
 	 '''''''''''''''
 	
 	
 	
 	'// we need to add the early commands twice, because
	'// a basedir or cddir needs to be set before execing
	'// config files, but we want other parms to override
	'// the settings of the config files
	
	 'works fine'''''''''''''
	 Cbuf_AddEarlyCommands (_false) 
	 ''''''''''''''''''''''''
	 
	  'WORKS FINE FOR NOW'''''''''''''
	 Cbuf_Execute () 
	 ''''''''''''''''''''''''
	 
  'WORKS FINE FOR NOW'''''''''''''
	 FS_InitFilesystem() 
   ''''''''''''''''''''''''''''''''
     'WORKS FINE FOR NOW'''''''''''''
    Cbuf_AddText (!"exec default.cfg\n")
     ''''''''''''''''''''''''''''''''
    Cbuf_AddText (!"exec config.cfg\n") 
    
    Cbuf_AddEarlyCommands (_true) 
  	 Cbuf_Execute () 
 
     'cvar_setvalue("sw_mode", 3 )
     
     'cvar_setvalue("vid_fullscreen", 0 )
 
'
'	//
'	// init commands and vars
'	//

 'WORKS FINE FOR NOW'''''''''''''
   Cmd_AddCommand ("z_stats", @Z_Stats_f) 
   ''''''''''''''''''''''''''''''
   Cmd_AddCommand ("error", @Com_Error_f) 
 
	host_speeds = Cvar_Get ("host_speeds", "0", 0) 
	 	 
	log_stats = Cvar_Get ("log_stats", "0", 0) 
	developer = Cvar_Get ("developer", "0", 0) 
	timescale = Cvar_Get ("timescale", "1", 0) 
	fixedtime = Cvar_Get ("fixedtime", "0", 0) 
	logfile_active = Cvar_Get ("logfile", "0", 0) 
	showtrace = Cvar_Get ("showtrace", "0", 0) 
#ifdef DEDICATED_ONLY
	dedicated = Cvar_Get ("dedicated", "1", CVAR_NOSET) 
#else
   dedicated = Cvar_Get ("dedicated", "0", CVAR_NOSET) 
#endif
 
 
      
  
 
	s = _va(!"%4.2f %s %s %s", _VERSION, CPUSTRING, __DATE__, BUILDSTRING)
	'WORKS FINE FOR NOW''''''''''''' 
	Cvar_Get ("version", s, _CVAR_SERVERINFO or CVAR_NOSET) 
   ''''''''''''''''''''''''''''''''
   
   com_printf(s)
   com_printf(!"\n")
   
    'if dedicated then
    	
    	
   if (dedicated->value) then
   	 
  		Cmd_AddCommand ("quit", @Com_Quit) 
  		beep
   EndIf
   
   
  
   
  ' else
   'com_error(ERR_FATAL,"dedicated is null")
   'EndIf

 		
 		'
 		'  Cbuf_AddText (!"cmdlist\n")
 	 	''Cbuf_AddText (!"echo this echoed\n")
 	 	''
 	 	''	 Cbuf_AddText (!"wait\n")
  
 	 	''Cbuf_AddText (!"alias\n")
 	 	''
 	 	' Cbuf_AddText (!"cvarlist\n")
 		'   Cbuf_Execute () 
 
 		

     'FINISHED fOR NOW''''''
 	 Sys_Init () 
 	 ''''''''''''''''''''''''
 	
 'FINISHED fOR NOW''''''
 	NET_Init () 
 	''''''''''''''''''''''
 	Netchan_Init () 
 
 
  'FINISHED fOR NOW''''''
	SV_Init () 
	''''''''''''''''''''''
	
	
	
	CL_Init ()
	
	
	
	
	
	
'
 '	// add + commands from command line
   if (Cbuf_AddLateCommands () = NULL) then
   	 	'// if the user didn't give any commands, run default action
 	 	if ( dedicated->value = NULL) then
 	 		Cbuf_AddText (!"d1\n")
 
 	 	else

 
 		Cbuf_AddText (!"dedicated_start\n") 
 
 	 	 EndIf
 	  Cbuf_Execute () 
   else	
 	'// the user asked for something explicit
	'// so drop the loading plaque
 
    SCR_EndLoadingPlaque ()
   	
   EndIf
   
    ' print"DONE"


 	'Com_Printf (!"====== Quake2 Initialized ======\n\n") 
 	

 	
 	 Printf (!"====== Quake2 Initialized ======\n\n")
 	
 	'print "====== Quake2 Initialized ======"
 	'print ""
 	



      'Cbuf_addtext(!"unbindall\n")
     
  
  
  
       'Cbuf_addtext("bindlist")
       'Cbuf_Execute ()

     



 		'Cbuf_AddText (!"d1\n")
 		'Cbuf_Execute ()
 		'
 		   ' Cvar_SetValue("vid_fullscreen", 0 )
 
 		
 		' sleep
		  
 	 	'Cbuf_AddText (!"echo this echoed\n")
 	 	'
 	 	'	 Cbuf_AddText (!"wait\n")
  
 	 	'Cbuf_AddText (!"alias\n")
 	 	
 	 	
		 'Cbuf_AddText (!"cmdlist\n")
 	 	 'Cbuf_AddText (!"cvarlist\n")
 		 '  Cbuf_Execute () 
 




 	  
 End Sub

sub Qcommon_Shutdown()
	
	
	
End Sub
' /*
'================
'COM_InitArgv
'================
'*/
sub COM_InitArgv (argc as integer ,argv as zstring ptr ptr)
		dim i as integer		 






	if (argc > MAX_NUM_ARGVS) then
		Com_Error (ERR_FATAL, "argc > MAX_NUM_ARGVS")
	end if	
		
	_com_argc = argc 
	
	
	
	for i = 0 to argc - 1
		
		if ( argv[i] = null or strlen(argv[i]) >= MAX_TOKEN_CHARS ) then
		   _com_argv(i) = @"" 
	 	else
	 		_com_argv(i) = argv[i] 
		EndIf
 
	Next
	
 
 
	
	
End Sub
 
sub COM_ClearArgv (arg as integer )
 
		if (arg < 0 or arg >= com_argc or  com_argv(arg) = 0) then
		return
		end if
 
	_com_argv(arg) = @"" 
 
End Sub
 

 

'
'/*
'================
'Com_DPrintf
'
'A Com_Printf that only shows up if the "developer" cvar is set
'================
'*/
sub Com_DPrintf cdecl (fmt as zstring ptr, ...)
	
		dim as cva_list		argptr 
	 dim as zstring * MAXPRINTMSG	msg 
		
	if (developer = NULL or developer->value = NULL) then
			return 			'// don't confuse non-developers with techie stuff...
	EndIf

	cva_start (argptr,fmt) 
	vsprintf (msg,fmt,argptr) 
	cva_end (argptr) 
	
	Com_Printf ("%s", msg)  
 

	
End Sub
 



sub Qcommon_Frame (msec as integer)
	
	
	
	
End Sub





'/*
'=============
'Com_Error
'
'Both client and server can use this, and it will
'do the apropriate things.
'=============
'*/


sub Com_Error cdecl (code as integer ,fmt as ZString ptr, ...)
	dim as cva_list		argptr 
	static as zstring	* MAXPRINTMSG 	msg 
	static as qboolean	recursive 

	if (recursive) then
		 Sys_Error ("recursive error after: %s", msg) 
	recursive = _true 
	EndIf


	cva_start (argptr,fmt) 
	vsprintf (msg,fmt,argptr) 
	cva_end (argptr) 
	
	 if (code =  ERR_DISCONNECT) then
 
'		CL_Drop ();
	 	recursive = _false 
	 	longjmp (@abortframe, -1) 
	 
	 elseif (code = ERR_DROP) then
 
 		Com_Printf ("********************\nERROR: %s\n********************\n", msg) 
	'	SV_Shutdown (va("Server crashed: %s\n", msg), _false);
	'	CL_Drop ();
	   recursive = _false 
	 	longjmp (@abortframe, -1) 
	 
	 else
	 
'		SV_Shutdown (va("Server fatal crashed: %s\n", msg), _false);
	 	CL_Shutdown () 
	 end if

	  if (logfile) then
	  fclose (logfile) 
	  	logfile = NULL 
	  EndIf
 
 	
 	
	 

	Sys_Error ("%s", msg) 
End Sub
 
 sub Com_Quit
 	
 		'SV_Shutdown ("Server quit\n", _false);
	CL_Shutdown () 

	if (logfile) then
		
			fclose (logfile) 
		logfile = NULL 
	EndIf
 
 
	Sys_Quit () 
	
	
	
	
 End Sub
 
 
 
 
 
 



  sub	Qcommon_Init2 (argc as integer , argv as ubyte ptr ptr) 
' 	
' 	registration_sequence = 1
 	
 		dim s as zstring ptr
 		
  if (setjmp (@abortframe) ) then
  	'NOT COMPLETE''''''''''''
  	Sys_Error ("Error during initialization")
  	''''''''''''''''''''''''
  EndIf

 	z_chain._prev  = @z_chain
	z_chain._next = z_chain._prev 
 	 
 	'// prepare enough of the subsystems to handle
	'// cvar and command buffer management
	
	 'works fine''''
	 COM_InitArgv (argc, argv) 
	 ''''''''''''''''''''''''
	 
   'works fine''''
	 Swap_Init ()
 	''''''''''''''''''''''''
 	'works fine''''
 	 Cbuf_Init () 
 	  ''''''''''''''''''''''''
 	 
 	 'works fine''''
	 Cmd_Init () 
	 ''''''''''''''''''''''''
	 
	 'works fine''''
	 Cvar_Init () 
    ''''''''''''''''''''''''
    
    'works fine''''
	 Key_Init () 
 	 '''''''''''''''
 	
 	
 	
 	'// we need to add the early commands twice, because
	'// a basedir or cddir needs to be set before execing
	'// config files, but we want other parms to override
	'// the settings of the config files
	
	 'works fine'''''''''''''
	 Cbuf_AddEarlyCommands (_false) 
	 ''''''''''''''''''''''''
	 
	  'WORKS FINE FOR NOW'''''''''''''
	 Cbuf_Execute () 
	 ''''''''''''''''''''''''
	 
  'WORKS FINE FOR NOW'''''''''''''
	 FS_InitFilesystem() 
   ''''''''''''''''''''''''''''''''
     'WORKS FINE FOR NOW'''''''''''''
    Cbuf_AddText (!"exec default.cfg\n")
     ''''''''''''''''''''''''''''''''
    Cbuf_AddText (!"exec config.cfg\n") 
    
    Cbuf_AddEarlyCommands (_true) 
  	 Cbuf_Execute () 
 
     'cvar_setvalue("sw_mode", 3 )
     
     'cvar_setvalue("vid_fullscreen", 0 )
 
'
'	//
'	// init commands and vars
'	//

 'WORKS FINE FOR NOW'''''''''''''
   Cmd_AddCommand ("z_stats", @Z_Stats_f) 
   ''''''''''''''''''''''''''''''
   Cmd_AddCommand ("error", @Com_Error_f) 
 
	host_speeds = Cvar_Get ("host_speeds", "0", 0) 
	 	 
	log_stats = Cvar_Get ("log_stats", "0", 0) 
	developer = Cvar_Get ("developer", "0", 0) 
	timescale = Cvar_Get ("timescale", "1", 0) 
	fixedtime = Cvar_Get ("fixedtime", "0", 0) 
	logfile_active = Cvar_Get ("logfile", "0", 0) 
	showtrace = Cvar_Get ("showtrace", "0", 0) 
#ifdef DEDICATED_ONLY
	dedicated = Cvar_Get ("dedicated", "1", CVAR_NOSET) 
#else
   dedicated = Cvar_Get ("dedicated", "0", CVAR_NOSET) 
#endif
 
 
      
  
 
	s = _va(!"%4.2f %s %s %s", _VERSION, CPUSTRING, __DATE__, BUILDSTRING)
	'WORKS FINE FOR NOW''''''''''''' 
	Cvar_Get ("version", s, _CVAR_SERVERINFO or CVAR_NOSET) 
   ''''''''''''''''''''''''''''''''
   
   com_printf(s)
   com_printf(!"\n")
   
    'if dedicated then
    	
    	
   if (dedicated->value) then
   	 
  		Cmd_AddCommand ("quit", @Com_Quit) 
  		beep
   EndIf
   
   
  
   
  ' else
   'com_error(ERR_FATAL,"dedicated is null")
   'EndIf

 		
 		'
 		'  Cbuf_AddText (!"cmdlist\n")
 	 	''Cbuf_AddText (!"echo this echoed\n")
 	 	''
 	 	''	 Cbuf_AddText (!"wait\n")
  
 	 	''Cbuf_AddText (!"alias\n")
 	 	''
 	 	' Cbuf_AddText (!"cvarlist\n")
 		'   Cbuf_Execute () 
 
 		

     'FINISHED fOR NOW''''''
 	 Sys_Init () 
 	 ''''''''''''''''''''''''
 	
 'FINISHED fOR NOW''''''
 	NET_Init () 
 	''''''''''''''''''''''
 	Netchan_Init () 
 
 
  'FINISHED fOR NOW''''''
	SV_Init () 
	''''''''''''''''''''''
	
	
	
	CL_Init ()
	
	
	
	
	
	
'
 '	// add + commands from command line
   if (Cbuf_AddLateCommands () = NULL) then
   	 	'// if the user didn't give any commands, run default action
 	 	if ( dedicated->value = NULL) then
 	 		Cbuf_AddText (!"d1\n")
 
 	 	else

 
 		Cbuf_AddText (!"dedicated_start\n") 
 
 	 	 EndIf
 	  Cbuf_Execute () 
   else	
   
 	'// the user asked for something explicit
	'// so drop the loading plaque
 
    SCR_EndLoadingPlaque ()
   	
   EndIf
   
    ' print"DONE"


 	'Com_Printf (!"====== Quake2 Initialized ======\n\n") 
 	

 	
 	 Printf (!"====== Quake2 Initialized ======\n\n")
 	
 	'print "====== Quake2 Initialized ======"
 	'print ""
 	



      'Cbuf_addtext(!"unbindall\n")
     
  
  
  
       'Cbuf_addtext("bindlist")
       'Cbuf_Execute ()

     



 		'Cbuf_AddText (!"d1\n")
 		'Cbuf_Execute ()
 		'
 		   ' Cvar_SetValue("vid_fullscreen", 0 )
 
 		
 		' sleep
		  
 	 	'Cbuf_AddText (!"echo this echoed\n")
 	 	'
 	 	'	 Cbuf_AddText (!"wait\n")
  
 	 	'Cbuf_AddText (!"alias\n")
 	 	
 	 	
		 'Cbuf_AddText (!"cmdlist\n")
 	 	 'Cbuf_AddText (!"cvarlist\n")
 		 '  Cbuf_Execute () 
 



 	  
 End Sub
