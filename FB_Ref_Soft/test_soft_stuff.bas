 
#Include "win32\resource.bi"


 '#Include "qcommon\qcommon.bi"
 #Include "client\client.bi"
 #Include "win32\winquake.bi"
 
 '#include "crt\setjmp.bi"


#define	Z_MAGIC		&H1d1d


type  zhead_s
as zhead_s ptr	_prev, _next 
as short magic
as short tag 
as Integer _size	
End Type: type zhead_t as zhead_s
 
 
extern  as zhead_t		z_chain 
extern  as integer		z_count, z_bytes 



dim  shared ri as refimport_t
dim  shared re as refExport_t
dim  shared GetRefAPI as GetRefAPI_t
dim shared ref_lib as hinstance 



''declare function GetRefAPI (rimp as refimport_t ) as refexport_t
'
'
''
''dim re as refexport_t
''dim ri as refimport_t
'
'
'  'GetRefAPI(ri)
'
'     ' re.Init()
'
'     'VID_LoadRefresh("soft")
'
'
'      Qcommon_Init ( __FB_ARGC__, __FB_ARGV__ )
'
'
'
'      'ri.Sys_Error(ERR_FATAL,!"test\ntest")
'      'ri.Con_Printf(PRINT_ALL,!"test")
'
'     're.RegisterPic("conchars")















#define Decl_Win Declare function WinMain (hInstance as HINSTANCE ,hPrevInstance as  HINSTANCE ,lpCmdLine as LPSTR ,nCmdShow as integer ) as Integer
#define Start_Win End WinMain(GetModuleHandle(null), null,  command,SW_NORMAL)
#define Win_Begin_  Decl_Win:Start_Win:function WinMain (hInstance as HINSTANCE ,hPrevInstance as  HINSTANCE ,lpCmdLine as LPSTR ,nCmdShow as integer ) as Integer:Dim As MSG				msg
#define _Win_End  return false:End Function





dim shared as HINSTANCE	global_hInstance
'dim shared cl_hwnd as hwnd

'/*
'** VID_GetModeInfo
'*/
type vidmode_s
	as const zstring ptr description 
	as integer         _width, _height 
	as integer         mode 
	
End Type: type vidmode_t as vidmode_s
 

  

dim shared as vidmode_t vid_modes(11) => _
{ _
	(@"Mode 0: 320x240",   320, 240,   0),_
	(@"Mode 1: 400x300",   400, 300,   1 ),_
	( @"Mode 2: 512x384",   512, 384,   2 ),_
	( @"Mode 3: 640x480",   640, 480,   3 ),_
	( @"Mode 4: 800x600",   800, 600,   4 ),_
	( @"Mode 5: 960x720",   960, 720,   5 ),_
	( @"Mode 6: 1024x768",  1024, 768,  6 ),_
	( @"Mode 7: 1152x864",  1152, 864,  7 ),_
	( @"Mode 8: 1280x960",  1280, 960, 8 ),_
	( @"Mode 9: 1600x1200", 1600, 1200, 9 ),_
	( @"Mode 10: 2048x1536", 2048, 1536, 10 )_
} 




 


'/*
'================
'Sys_Init
'================
'*/
sub Sys_Init ()
 
'dim 	vinfo as OSVERSIONINFO	 
'
' #if 0
''	// allocate a named semaphore on the client so the
''	// front end can tell if it is alive
'
''	// mutex will fail if semephore already exists
'    qwclsemaphore = CreateMutex( _
'        NULL, _        
'        0, _            
'        "qwcl") 
'        
'	if ( qwclsemaphore = NULL) then
'		Sys_Error ("QWCL is already running on this system") 
'	EndIf
'	
'		
'	CloseHandle (qwclsemaphore) 
'
'    qwclsemaphore = CreateSemaphore( _
'        NULL, _         
'        0, _           
'        1, _            
'        "qwcl") 
' #endif
'
' 	timeBeginPeriod( 1 ) 
' 
' 	vinfo.dwOSVersionInfoSize = sizeof(vinfo) 
' 
'  	if ( GetVersionEx (@vinfo) = 0) then
'  		 Sys_Error ("Couldn't get OS info") 
' 	end if
' 
'  	if (vinfo.dwMajorVersion < 4) then
' 	  Sys_Error ("Quake2 requires windows version 4 or greater") 
'  	end if 
'  	if (vinfo.dwPlatformId = VER_PLATFORM_WIN32s) then
'  		 		Sys_Error ("Quake2 doesn't run on Win32s") 
'  	elseif ( vinfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS ) then
' 		s_win95 = true 
'  	EndIf
'
' 	
''
''if dedicated then
'    	
'
' 	if (dedicated->value) then
' 
' 		if ( AllocConsole () = 0) then
' 			Sys_Error ("Couldn't create dedicated server console") 
' 		endif	
' 			
' 		hinput = GetStdHandle (STD_INPUT_HANDLE) 
' 		houtput = GetStdHandle (STD_OUTPUT_HANDLE) 
' 	
''		// let QHOST hook in
'
'       ' NOT COMPLETE''''''''''
' 		 'InitConProc (argc, argv)
' 		 '''''''''''''''''''''''' 
' 		end if
''EndIf		
 		
end sub

'//================================================================







 

 sub Sys_Quit
    	
'  'Final area before it exits program
'     
     timeEndPeriod( 1 ) 
'
'	CL_Shutdown()
'	Qcommon_Shutdown ()
'	'CloseHandle (qwclsemaphore)
'	
'	if (dedicated) then 
'	  if  dedicated->value then
'	  	FreeConsole ()
'	  EndIf
'	endIf
'	
'	
'    if freeconsole() = 0 then
'   	MessageBox( 0,"failed to close console!" ,"error"  , MB_ICONERROR )
'   EndIf
'
''// shut down QHOST hooks if necessary
''	DeinitConProc () 
' 
' 
' 
' 
'	end  0  
   
   

   
   
'  ' beep
'   
''MIGHT DELETE'''''''''''''
'shut_down1()
'''''''''''''''''''''''''''''''''''
'
'
'     'game completely ends here
    	end 0
    	
 End Sub     
 













Function MainWndProc2 (ByVal  hWnd As HWND, _
ByVal uMsg As UINT, _
ByVal wParam As WPARAM, _
ByVal lParam As LPARAM) As LONG

dim as LONG			lRet = 0



select case  uMsg

case WM_MOUSEWHEEL
'		/*
'		** this chunk of code theoretically only works under NT4 and Win98
'		** since this message doesn't exist under Win95
'		*/
if ( cast (short , HIWORD( wParam )) > 0 ) then
	'		{
	'			Key_Event( K_MWHEELUP, _true, sys_msg_time );
	'			Key_Event( K_MWHEELUP, _false, sys_msg_time );
	'		}
else
	'		{
	'			Key_Event( K_MWHEELDOWN, _true, sys_msg_time );
	'			Key_Event( K_MWHEELDOWN, _false, sys_msg_time );
end if


case WM_HOTKEY
return 0

case WM_CREATE
cl_hwnd = hWnd

return DefWindowProc (hWnd, uMsg, wParam, lParam)
'
case WM_PAINT
'		SCR_DirtyScreen ();	// force entire screen to update next frame
'        return DefWindowProc (hWnd, uMsg, wParam, lParam);

'temporary''''''''''''''
case WM_CLOSE

postquitmessage(0)
''''''''''''''''''''''''''''''

case WM_DESTROY



'MessageBox(NULL,"destroying","info",MB_ICONERROR)
'ri.Con_Printf( PRINT_ALL ,!"...destroying window\n" )
'// let sound and input know about this?
 cl_hwnd = NULL
return DefWindowProc (hWnd, uMsg, wParam, lParam)
 

'
'	case WM_ACTIVATE:
'		{
'			int	fActive, fMinimized;
'
'			// KJB: Watch this for problems in fullscreen modes with Alt-tabbing.
'			fActive = LOWORD(wParam);
'			fMinimized = (BOOL) HIWORD(wParam);
'
'			AppActivate( fActive != WA_INACTIVE, fMinimized);
'
'			if ( reflib_active )
'				re.AppActivate( !( fActive == WA_INACTIVE ) );
'		}
'        return DefWindowProc (hWnd, uMsg, wParam, lParam);
'
case WM_MOVE

'			int		xPos, yPos;
'			RECT r;
'			int		style;
'
'			if ( vid_fullscreen->value = NULL)
'			{
'				xPos = (short) LOWORD(lParam);    // horizontal position
'				yPos = (short) HIWORD(lParam);    // vertical position
'
'				r.left   = 0;
'				r.top    = 0;
'				r.right  = 1;
'				r.bottom = 1;
'
'				style = GetWindowLong( hWnd, GWL_STYLE );
'				AdjustWindowRect( &r, style, _false );
'
'				Cvar_SetValue( "vid_xpos", xPos + r.left);
'				Cvar_SetValue( "vid_ypos", yPos + r.top);
'				vid_xpos->modified = _false;
'				vid_ypos->modified = _false;
'				if (ActiveApp)
'					IN_Activate (_true);
'			}
'		}
'        return DefWindowProc (hWnd, uMsg, wParam, lParam);
'
'// this is complicated because Win32 seems to pack multiple mouse events into
'// one update sometimes, so we always check all states and look for events
'	case WM_LBUTTONDOWN:
'	case WM_LBUTTONUP:
'	case WM_RBUTTONDOWN:
'	case WM_RBUTTONUP:
'	case WM_MBUTTONDOWN:
'	case WM_MBUTTONUP:
'	case WM_MOUSEMOVE:
'		{
'			int	temp;
'
'			temp = 0;
'
'			if (wParam & MK_LBUTTON)
'				temp |= 1;
'
'			if (wParam & MK_RBUTTON)
'				temp |= 2;
'
'			if (wParam & MK_MBUTTON)
'				temp |= 4;
'
'			IN_MouseEvent (temp);
'		}
'		break;
'
'	case WM_SYSCOMMAND:
'		if ( wParam == SC_SCREENSAVE )
'			return 0;
'        return DefWindowProc (hWnd, uMsg, wParam, lParam);
'	case WM_SYSKEYDOWN:
'		if ( wParam == 13 )
'		{
'			if ( vid_fullscreen )
'			{
'				Cvar_SetValue( "vid_fullscreen", !vid_fullscreen->value );
'			}
'			return 0;
'		}
'		// fall through
'	case WM_KEYDOWN:
'		Key_Event( MapKey( lParam ), _true, sys_msg_time);
'		break;
'
'	case WM_SYSKEYUP:
'	case WM_KEYUP:
'		Key_Event( MapKey( lParam ), _false, sys_msg_time);
'		break;
'
'	case MM_MCINOTIFY:
'		{
'			LONG CDAudio_MessageHandler(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
'			lRet = CDAudio_MessageHandler (hWnd, uMsg, wParam, lParam);
'		}
'		break;
'
'	default:	// pass all unhandled messages to DefWindowProc
'        return DefWindowProc (hWnd, uMsg, wParam, lParam);
'    }
'
'    /* return 0 if handled message, 1 if not */

end select
return DefWindowProc( hWnd, uMsg, wParam, lParam )
End Function
















 sub  VID_Printf2 cdecl (print_level as integer ,fmt as zstring ptr, ...)
	 dim  as cva_list		argptr 
	 dim  as zstring * 1024	 msg 
	 static as qboolean	inupdate 
	'
	 cva_start (argptr,fmt) 
	 vsprintf (msg,fmt,argptr) 
	 cva_end (argptr)  
	'
	'if (print_level = PRINT_ALL) then
 
	'	Com_Printf (!"%s", msg) 
	' 
	'elseif ( print_level = PRINT_DEVELOPER ) then
	'
	'	'Com_DPrintf (!"%s", msg);
	'
	'elseif ( print_level = PRINT_ALERT ) then
	'		MessageBox( 0, msg, "PRINT_ALERT", MB_ICONWARNING ) 
	'	OutputDebugString( msg ) 
	' 
	'
	'end if

 	
 	printf (!"%s", msg)
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




	' if (qwclsemaphore) then
	' 	 CloseHandle (qwclsemaphore) 
	' EndIf
	'	
   ''// shut down QHOST hooks if necessary
   ' 
   ' 'NOT FINISHED'''''''''''''''
	' DeinitConProc () 
    ''''''''''''''''''''''''''''
	end 1 
end sub

sub  VID_Error2 cdecl (err_level as integer ,fmt as zstring ptr, ...)
	dim  as cva_list		argptr 
	dim  as zstring * 1024  msg 
	static as qboolean	inupdate 
	
	cva_start (argptr,fmt) 
	vsprintf (msg,fmt,argptr) 
	cva_end (argptr) 

	 Com_Error (err_level,"%s", msg) 
 
End Sub
 


sub VID_NewWindow2 ( _width as integer ,_height as integer )
   viddef._width  = _width 
	viddef._height = _height 

'	 _cl.force_refdef = _true 

	
End Sub
 
 
 
 
  #define VID_NUM_MODES ( (sizeof( vid_modes ) * ubound(vid_modes)) / sizeof( vid_modes(0) ) )
 
 
 



function VID_GetModeInfo2(  _width as integer ptr, _height as integer ptr,_mode as  integer  ) as qboolean
 
	if ( _mode < 0 or _mode >= VID_NUM_MODES ) then
		return _false 
		
	EndIf
		

	*_width  =  vid_modes(_mode)._width 
	*_height =  vid_modes(_mode)._height 

	return _true 
 
End Function





sub load_lib(_lib as hinstance ptr) 
	
	


 	z_chain._prev  = @z_chain
	z_chain._next = z_chain._prev 

 
ri.Cmd_AddCommand = @Cmd_AddCommand
ri.Cmd_RemoveCommand = @Cmd_RemoveCommand
ri.Cmd_Argc = @Cmd_Argc
ri.Cmd_Argv = @Cmd_Argv
ri.Cmd_ExecuteText = @Cbuf_ExecuteText
ri.Con_Printf = @VID_Printf2
ri.Sys_Error = @VID_Error2
ri.FS_LoadFile = @FS_LoadFile
ri.FS_FreeFile = @FS_FreeFile
ri.FS_Gamedir = @FS_Gamedir
ri.Cvar_Get = @Cvar_Get
ri.Cvar_Set = @Cvar_Set
ri.Cvar_SetValue = @Cvar_SetValue
ri.Vid_GetModeInfo = @VID_GetModeInfo2
'ri.Vid_MenuInit = @VID_MenuInit
ri.Vid_NewWindow = @VID_NewWindow2
 
 
*_lib = loadlibrary("FBRef_Soft.dll")

if *_lib = NULL then
	beep
else
	print "LOADED"
EndIf

GetRefAPI = cast(any ptr, GetProcAddress( *_lib, "GetRefAPI" ))


if   (GetRefAPI  = 0)   then
	beep
EndIf


 

 re = GetRefAPI(ri)

re.Init(global_hInstance,@MainWndProc2)

End Sub
 
 
 
 
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

 
 
 
 
 
 
 
 
'''''''''''''''''''''''''''''''''''''''''''''''''''
Win_Begin_




If (hPrevInstance) Then
	Return 0
End If

global_hInstance = hInstance


 New_Console()
 
 
 
load_lib(@ref_lib)


     



While (1)

	While (PeekMessage (@Msg, NULL, 0, 0, PM_NOREMOVE))
		
		
		 if ( GetMessage (@Msg, NULL, 0, 0) = 0) then
   		if freeconsole() = 0 then
   	MessageBox( 0,"failed to close console!" ,"error"  , MB_ICONERROR )
   EndIf
         
			re.Shutdown()
			freelibrary(ref_lib)
		   end 0
		 EndIf

		If msg.message = WM_CLOSE Then
			
			
		if freeconsole() = 0 then
   	MessageBox( 0,"failed to close console!" ,"error"  , MB_ICONERROR )
   EndIf
         
			re.Shutdown()
			freelibrary(ref_lib)
         end 0
		EndIf


		TranslateMessage (@Msg)
		DispatchMessage (@Msg)
 
	Wend
Wend


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
_Win_End



