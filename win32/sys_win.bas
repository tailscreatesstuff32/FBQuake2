
'MAIN QUAKE 2 FILE''''''''''''''''''''''''''''''



'__FB_DEBUG__

'__FB_WIN32__

'MIGHT DELETE''''''''''
'declare sub shut_down1()
'''''''''''''''''''''''


#include "qcommon/qcommon.bi"
#Include "win32\rw_win.bi"

 


#Include "winquake.bi"
#Include "resource.bi"
'#include "crt/errno.bi"
'#include "crt\math.bi"
''#include "float.bi"
' #include "crt\fcntl.bi"
'#include "crt/stdio.bi"
'#include "crt/dir.bi" '#include "dos\direct.bi" '#include "dir.bi"
'#include "crt\io.bi"
#include "crt.bi"
' #include "dos\conio.bi"
#Include "win32\conproc.bi"


#define MINIMUM_WIN_MEMORY	&H0a00000
#define MAXIMUM_WIN_MEMORY	&H1000000

'//#define DEMO

dim shared as qboolean s_win95 

dim shared as integer			starttime 
dim shared as integer			_ActiveApp 
dim shared as qboolean	      Minimized 

static shared as  HANDLE		hinput, houtput 

dim shared as UInteger	sys_msg_time 
dim shared as UInteger	sys_frame_time 


static shared as HANDLE		qwclsemaphore 

#define	MAX_NUM_ARGVS	128
dim shared as integer argc 
dim shared as zstring ptr argv(MAX_NUM_ARGVS)  


' This is just an empty declaration.  See below for the definition of this fuction
Declare function WinMain (hInstance as HINSTANCE ,hPrevInstance as  HINSTANCE ,lpCmdLine as LPSTR ,nCmdShow as integer ) as Integer

          
            

    End WinMain(GetModuleHandle(null), null,  command,SW_NORMAL)
    
    
    
static shared as zstring * 256 	console_text
static shared as integer 	console_textlen 
 
 

 
 
 
  
'  /*
'================
'Sys_ConsoleOutput
'
'Print text to the dedicated console
'================
'*/
sub Sys_ConsoleOutput (_string as zstring ptr)
	
	dim as integer		dummy 
	dim as zstring * 256	text  

	
	
if dedicated then
		 if (dedicated = NULL or  dedicated->value) then
	 	return
	 	
	 EndIf
 
	
EndIf
 


	if (console_textlen) then
 
		text[0] = asc(!"\r")
		memset(@text[1], asc(!" "), console_textlen) 
		text[console_textlen+1] = asc(!"\r")
		text[console_textlen+2] = 0 
		WriteFile(houtput, @text, console_textlen+2, @dummy, NULL) 
	end if

	WriteFile(houtput, _string, strlen(_string), @dummy, NULL) 

	if (console_textlen) then
				WriteFile(houtput, @console_text, console_textlen, @dummy, NULL) 
	EndIf

 End Sub
    
    
    

    '
    

    
    
    
    
    
    
'/*
'================
'Sys_SendKeyEvents
'
'Send Key_Event calls
'================
'*/
sub Sys_SendKeyEvents ( )
 
   dim as  MSG        msg 

	while (PeekMessage (@msg, NULL, 0, 0, PM_NOREMOVE))
		if ( GetMessage (@msg, NULL, 0, 0) = 0) then
				Sys_Quit () 
		EndIf		
		
		   sys_msg_time = msg.time 
      	TranslateMessage (@msg)  
      	DispatchMessage (@msg) 
	 
	Wend
	 
	'// grab frame time 
	sys_frame_time = timeGetTime() 	'// FIXME: should this be at start?
end sub



'/*
'================
'Sys_ConsoleInput
'================
'*/
function Sys_ConsoleInput () as zstring ptr
 
	dim as INPUT_RECORD	recs(1024)
	dim as integer		dummy 
	dim as integer		ch, numread, numevents 


 if dedicated then
 		if (dedicated = NULL or  dedicated->value = NULL) then
		return NULL
	EndIf
		 
 EndIf



	'for ( ;; )
	'{
		
	'}
	do while true
		if ( GetNumberOfConsoleInputEvents (hinput, @numevents) = NULL) then
			Sys_Error ("Error getting # of console events") 

		if (numevents <= 0) then
			'exit for 'do
			exit do
		EndIf
			 

		if ( ReadConsoleInput(hinput, @recs(0), 1, @numread)) = NULL then
			Sys_Error ("Error reading console input")
		EndIf
 
	 

		if (numread <> 1) then
			Sys_Error ("Couldn't read console input") 
		EndIf
			

	 	if (recs(0).EventType =  KEY_EVENT) then
 
	 	if ( recs(0).Event.KeyEvent.bKeyDown = NULL) then
 
	 			ch = recs(0).Event.KeyEvent.uChar.AsciiChar 

	 		 select case (ch)
	'			 
	 		 	case asc(!"\r")
	 					WriteFile(houtput,  @!"\r\n", 2, @dummy, NULL) 	

	 					if (console_textlen) then
 
	 						console_text[console_textlen] = 0 
	 						console_textlen = 0 
	 						return @console_text 
	               end if
 

					case asc(!"\b")
						if (console_textlen) then
							
	 						console_textlen-=1
	 						WriteFile(houtput,  @!"\b \b", 3, @dummy, NULL)	
						EndIf


	 		 	case else
	 		 		
	 		 		if ch >= asc(!" ") then
	 		 			
	 		 					if (console_textlen < sizeof(console_text)-2) then
	 							WriteFile(houtput, @ch, 1, @dummy, NULL) 
	 							console_text[console_textlen] = ch 
	    						console_textlen+=1
	 						EndIf
	 		 		EndIf

	 		 		
	 				 end select 
 		end if
	 	 
 
	 end if
	end if
loop
	return NULL 
 end function


' /*
'================
'Sys_GetClipboardData
'
'================
'*/
 function  Sys_GetClipboardData() as zstring ptr
 	
 	dim as 	zstring ptr _data = NULL 
   dim as 	zstring ptr cliptext 

	if ( OpenClipboard( NULL ) <> 0 ) then
	 
		dim as HANDLE hClipboardData 

		if ( ( hClipboardData = GetClipboardData( CF_TEXT ) ) <> 0 ) then
	 
			if ( ( cliptext = GlobalLock( hClipboardData ) ) <> 0 )  then
			 
				_data = malloc( GlobalSize( hClipboardData ) + 1 ) 
				strcpy( _data, cliptext ) 
				GlobalUnlock( hClipboardData ) 
			end if
		end if
		CloseClipboard() 
	end if
	return _data 
 
 	
 	
 End Function
 


 
'/*
'==============================================================================
'
' WINDOWS CRAP
'
'==============================================================================
'*/
'
'/*
'=================
'Sys_AppActivate
'=================
'*/
sub Sys_AppActivate ()
		ShowWindow ( cl_hwnd, SW_RESTORE) 
	SetForegroundWindow ( cl_hwnd ) 
 
 
End Sub
 

' /*
'========================================================================
'
'GAME DLL
'
'========================================================================
'*/

static shared as HINSTANCE	game_library 
    
    
'  /*
'=================
'Sys_UnloadGame
'=================
'*/
sub Sys_UnloadGame ()
 
	 
	if ( FreeLibrary (game_library) = 0) then
			Com_Error (ERR_FATAL, "FreeLibrary failed for game library") 
	game_library = NULL 
 
		
	EndIf
	
  
    
	
End Sub

    
'    
'  /*
'=================
'Sys_GetGameAPI
'
'Loads the game dll
'=================
'*/
function Sys_GetGameAPI (parms as any ptr) as any ptr
 
	dim  GetGameAPI as function( as any ptr) as any ptr
	
	
	
	dim as zstring * MAX_OSPATH	_name 
	dim as zstring ptr path 
	dim as zstring * MAX_OSPATH	cwd  
	
 '#if defined (_M_IX86 ) 
 #if defined (__FB_WIN32__)
 	dim as const zstring ptr gamename = @"gamex86.dll" 

 
 #ifndef __FB_DEBUG__  
	dim as const zstring  ptr  debugdir = @"release" 
#else
	dim as const zstring  ptr  debugdir = @"debug" 
#endif


 #elseif defined (_M_ALPHA)
 dim as  const zstring  ptr  gamename = @"gameaxp.dll" 

 
 
 #ifndef __FB_DEBUG__
 	dim as  const zstring  ptr  debugdir = @"releaseaxp" 
 #else
 	dim as  const zstring  ptr  debugdir = @"debugaxp" 
 #endif

 #endif


printf ("%s",debugdir)


	if (game_library) then
		Com_Error (ERR_FATAL, !"Sys_GetGameAPI without Sys_UnloadingGame")
    end if
	'// check the current debug directory first for development purposes
	 _getcwd (cwd, sizeof(cwd)) 
	 Com_sprintf (_name, sizeof(_name), !"%s/%s/%s", cwd, debugdir, gamename) 
	 game_library = LoadLibrary ( _name ) 
	 if (game_library) then
	  
' 		Com_DPrintf ("LoadLibrary (%s)\n", name);
	 
	 else
 
'		// check the current directory for other development purposes
	 Com_sprintf (_name, sizeof(_name), !"%s/%s", cwd, gamename) 
	 	game_library = LoadLibrary ( _name ) 
	 	if (game_library) then
 
	 	Com_DPrintf (!"LoadLibrary (%s)\n", _name) 
	 
   	else
	 
	'		// now run through the search paths
	 		path = NULL 
	 		while (1)
 
	'			path = FS_NextPath (path) 
	 			if ( path = NULL) then
	 				return NULL 	'// couldn't find one anywhere
	 			end if
	    		Com_sprintf (_name, sizeof(_name), !"%s/%s", path, gamename) 
	 			game_library = LoadLibrary (_name) 
	 			if (game_library) then
 
	 				Com_DPrintf (!"LoadLibrary (%s)\n",_name) 
 
	 			endif
        wend
	  endif
	endif

	 GetGameAPI = cast(any ptr, GetProcAddress (game_library, "GetGameAPI") )
	 'if (GetGameAPI = NULL) then
	 	Sys_UnloadGame ()
	 	return NULL
	' EndIf
 
	return GetGameAPI (parms) 
	
	
End Function
 

 

'//=======================================================================
  
    
    
    
    
    
 sub Sys_Quit
    	
  'Final area before it exits program
     
    timeEndPeriod( 1 ) 

	CL_Shutdown()
	Qcommon_Shutdown ()
	CloseHandle (qwclsemaphore)
	
	if (dedicated) then 
	  if  dedicated->value then
	  	FreeConsole ()
	  EndIf
	endIf
	
	
    if freeconsole() = 0 then
   	MessageBox( 0,"failed to close console!" ,"error"  , MB_ICONERROR )
   EndIf

'// shut down QHOST hooks if necessary
	DeinitConProc () 
 
 
 
 
	end  0  
   
   

   
   
'  ' beep
'   
''MIGHT DELETE'''''''''''''
'shut_down1()
'''''''''''''''''''''''''''''''''''
'
'
'     'game completely ends here
'    	end 0
    	
 End Sub     
 
' /*
'================
'Sys_ScanForCD
'
'================
'*/
function Sys_ScanForCD () as zstring ptr
 
	static as zstring *	MAX_OSPATH cddir
	static as qboolean	done 
 #ifndef DEMO
 	dim as zstring * 4	drive 
 	dim as FILE		ptr f
 	dim as zstring	* MAX_QPATH	test  
'
 	if (done) then		'// don't re-check
 		return @cddir 
 	end if
 
'	// no abort/retry/fail errors
 	SetErrorMode (SEM_FAILCRITICALERRORS) 
 
 	drive[0] = asc("c")
 	drive[1] = asc(":") 
 	drive[2] = asc(!"\\")
 	drive[3] = 0 
 	
 	done = true

'	// scan the drives
 drive[0] = asc("c")
    do while   drive[0] <= asc("z")
    	
 
'		// where activision put the stuff...
   	sprintf (cddir, !"%sinstall\\data", drive) 
 		sprintf (test, !"%sinstall\\data\\quake2.exe", drive) 
 		f = fopen(test, "r") 
 		if (f) then
  
   		fclose (f) 
   		if (GetDriveType (drive) =  DRIVE_CDROM) then
 				return @cddir
 			end if 
 		end if 
 		drive[0] += 1
  Loop
 #endif

	cddir[0] = 0 
	
	return NULL 
end function
 ' /*
'================
'Sys_CopyProtect
'
'================
'*/


sub	Sys_CopyProtect ()
	#ifndef DEMO
	dim as zstring ptr	 cddir 

	cddir = Sys_ScanForCD() 
	if ( cddir[0] = NULL) then
		Com_Error (ERR_FATAL, !"You must have the Quake2 CD in the drive to play.")
	EndIf
		
#endif
   
    
	
	
	
End Sub
 
    
sub Sys_Error cdecl (_error as zstring ptr, ...)

 
 
 	dim as cva_list		argptr 
	dim as zstring * 1024  text 
 
 	CL_Shutdown () 
	Qcommon_Shutdown () 

	cva_start (argptr, _error) 
	vsprintf (text, _error, argptr) 
	cva_end (argptr) 

 		
MessageBox(NULL, text, "Error", 0 ) 




	 if (qwclsemaphore) then
	 	 CloseHandle (qwclsemaphore) 
	 EndIf
		
   '// shut down QHOST hooks if necessary
    
    'NOT FINISHED'''''''''''''''
	 DeinitConProc () 
    ''''''''''''''''''''''''''''
	end 1 
end sub



sub WinError ()
	
		dim as LPVOID lpMsgBuf 

	FormatMessage( _
		FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, _
		NULL, _
		GetLastError(), _
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), _  '// Default language
		cast(LPTSTR, @lpMsgBuf), _
		0, _
		NULL  _
	) 

	'// Display the string.
	MessageBox( NULL, lpMsgBuf, "GetLastError", MB_OK or MB_ICONINFORMATION ) 

	'// Free the buffer.
	LocalFree( lpMsgBuf ) 
 
	
End Sub
 
    
'/*
'================
'Sys_Init
'================
'*/
sub Sys_Init ()
 
dim 	vinfo as OSVERSIONINFO	 

 #if 0
'	// allocate a named semaphore on the client so the
'	// front end can tell if it is alive

'	// mutex will fail if semephore already exists
    qwclsemaphore = CreateMutex( _
        NULL, _        
        0, _            
        "qwcl") 
        
	if ( qwclsemaphore = NULL) then
		Sys_Error ("QWCL is already running on this system") 
	EndIf
	
		
	CloseHandle (qwclsemaphore) 

    qwclsemaphore = CreateSemaphore( _
        NULL, _         
        0, _           
        1, _            
        "qwcl") 
 #endif

 	timeBeginPeriod( 1 ) 
 
 	vinfo.dwOSVersionInfoSize = sizeof(vinfo) 
 
  	if ( GetVersionEx (@vinfo) = 0) then
  		 Sys_Error ("Couldn't get OS info") 
 	end if
 
  	if (vinfo.dwMajorVersion < 4) then
 	  Sys_Error ("Quake2 requires windows version 4 or greater") 
  	end if 
  	if (vinfo.dwPlatformId = VER_PLATFORM_WIN32s) then
  		 		Sys_Error ("Quake2 doesn't run on Win32s") 
  	elseif ( vinfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS ) then
 		s_win95 = true 
  	EndIf

 	
'
'if dedicated then
    	

 	if (dedicated->value) then
 
 		if ( AllocConsole () = 0) then
 			Sys_Error ("Couldn't create dedicated server console") 
 		endif	
 			
 		hinput = GetStdHandle (STD_INPUT_HANDLE) 
 		houtput = GetStdHandle (STD_OUTPUT_HANDLE) 
 	
'		// let QHOST hook in

       ' NOT COMPLETE''''''''''
 		 'InitConProc (argc, argv)
 		 '''''''''''''''''''''''' 
 		end if
'EndIf		
 		
end sub

'//================================================================


sub ParseCommandLine (lpCmdLine as LPSTR )
 
	argc = 1 
	argv(0) = @"exe" 
	 
    'temporary fix''''''''''''''''''''''
    
    if lpcmdline <> NULL then
    	
    
   
	  while (*lpCmdLine <> 0 and (argc < MAX_NUM_ARGVS))
 
	 	while (*lpCmdLine <> 0 and ((*lpCmdLine <= 32) or (*lpCmdLine > 126)))
	 	lpCmdLine+=1
	 	wend
 
		if (*lpCmdLine <> 0) then
		 
			 argv(argc) = lpCmdLine 
			argc+=1

			while (*lpCmdLine <> 0 and ((*lpCmdLine > 32) and (*lpCmdLine <= 126))) 
				lpCmdLine+=1
	    wend
			
			if (*lpCmdLine <> 0) then
			 
				*lpCmdLine = 0 
				lpCmdLine+=1
			end if
		end if
		
	
		 
	 wend
	 EndIf
end sub

 
#ifndef WM_MOUSEWHEEL
#define WM_MOUSEWHEEL (WM_MOUSELAST+1)  '// message that will be supported by the OS 
#endif

static shared as UINT MSH_MOUSEWHEEL 


 #define	WINDOW_CLASS_NAME "Quake 2"
''/*
''==================
''WinMain
''
''==================
''*/
dim shared as HINSTANCE	global_hInstance 

 
  declare  function  SWimp_InitGraphics(fullscreen  as  qboolean ) as qboolean 

#define WINDOWWIDTH1 550





 
sub New_Console()
 static as HWND consolehandle
		AllocConsole() 
	   freopen("conin$","r",stdin) 
	   freopen("conout$","w",stdout) 
	   freopen("conout$","w",stderr) 
	   consoleHandle = GetConsoleWindow()
	   MoveWindow(consoleHandle,1,1,680,480,1) 
	   printf(!"[sys_win.c] Console initialized.\n") 
End Sub



'COMPLETED ADDED''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function WinMain (hInstance as HINSTANCE ,hPrevInstance as  HINSTANCE ,lpCmdLine as LPSTR ,nCmdShow as integer ) as Integer
	
	dim as MSG				msg 
	dim as integer			_time, oldtime, newtime 
	dim as  zstring ptr cddir 

    '/* previous instances do not exist in Win32 */
    if (hPrevInstance) then
        return 0
    end if

		global_hInstance = hInstance
		 New_Console()
		 ParseCommandLine (lpCmdLine)
	 	 cddir =  Sys_ScanForCD()  
	 	
     SetConsoleTitle("FBQuake2")

    	if  cddir <> NULL and argc < MAX_NUM_ARGVS - 3  then
    		dim as integer		i 
   	'// don't override a cddir on the command line
      	for  i=0 to argc-1
      	if ( strcmp(argv(i), "cddir") = 0) then
	   		exit for
	   	EndIf
      	
      	Next
	   	
 
    		if (i =  argc) then
    			 argv(argc) = @"+set":argc+=1
    			  argv(argc) = @"cddir":argc+=1
    			  argv(argc) =   cddir:argc+=1 
    		EndIf
 
 
    		
    	EndIf
    	
    	 'print "how much " & argc
    	 'print *argv(0)
    	 'print *argv(1)
    	 'print *argv(2)
    	 'print *argv(3)
    	
    	 'sleep
    	'
    	
    	
    Qcommon_Init (argc, @argv(0))
    oldtime = Sys_Milliseconds ()

    
    
' put this in its proper place
'Sys_CopyProtect ()


	while (1)
	 
		''// if at a full screen console, don't update unless needed
		
	 	'if dedicated then
		  if (Minimized or (dedicated <> null and dedicated->value) )then
		  	Sleep (1) 
		  EndIf
	' end if

		while (PeekMessage (@Msg, NULL, 0, 0, PM_NOREMOVE))
		
		 
       
		 if ( GetMessage (@Msg, NULL, 0, 0) = 0) then
    	       
			 Com_Quit ()
		
		 EndIf		
	    

	 'temporary''''''''''''''
	    if msg.message = WM_CLOSE then
	    	Com_Quit ()
	    	
	    EndIf
	''''''''''''''''''''''''''''''
				sys_msg_time = msg.time
			   TranslateMessage (@Msg) 
   			DispatchMessage (@Msg) 

   			
   			
			'
		Wend
		
		'main loop'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 			do
 	 
  		 newtime = Sys_Milliseconds () 
  		 _time = newtime - oldtime 
 		  loop while (_time < 1) 
  		 	'Con_Printf (!"time:%5.2f - %5.2f = %5.2f\n", newtime, oldtime, _time) 
  		 	'Printf (!"time:%5.2f - %5.2f = %5.2f\n", newtime, oldtime, _time)
  			'printf(!"%d\n",_time)
  			'printf(!"%d\n",newtime )
  		  ' printf(!"%d\n",oldtime )
   
''		//	_controlfp( ~( _EM_ZERODIVIDE /*| _EM_INVALID*/ ), _MCW_EM );

  	 	_controlfp( _PC_24, _MCW_PC ) 
  	 	
  	 	
  	 	'game starts starts here''''
  		Qcommon_Frame (_time) 
      ''''''''''''''''''''''''''''
      
  		oldtime = newtime 
   

	Wend
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
   
   
    ''
    '' Program has ended
    ''

    return false

End Function
 



 





