#Include "client\client.bi"
#Include "win32\winquake.bi"
 
dim shared re as refexport_t	

#define	MAXPRINTMSG	4096

'// Structure containing functions exported from refresh DLL
'dim shared  as refexport_t	re 

dim shared  as cvar_t ptr win_noalttab 

#ifndef WM_MOUSEWHEEL
#define WM_MOUSEWHEEL (WM_MOUSELAST+1)  '// message that will be supported by the OS 
#endif

static shared as UINT MSH_MOUSEWHEEL 

'// Console variables that we need to access from this module
dim shared  as cvar_t ptr vid_gamma 
dim shared  as cvar_t ptr vid_ref 		'// Name of Refresh DLL loaded
dim shared  as cvar_t ptr vid_xpos 			'// X coordinate of window position
dim shared  as cvar_t ptr vid_ypos 			'// Y coordinate of window position
dim shared  as cvar_t ptr vid_fullscreen 

'// Global variables used internally by this module
dim shared as  viddef_t	viddef 			'// global video state; used by other modules
dim shared as  HINSTANCE	reflib_library 		'// Handle to refresh DLL 
dim shared as qboolean	reflib_active = 0 

dim shared as  HWND        cl_hwnd           ' // Main window handle for life of program



declare function MainWndProc(hWnd as HWND ,uMsg as  UINT , wParam as WPARAM,lParam as  LPARAM  ) as LONG

declare sub SWimp_Shutdown()

declare function GetRefAPI (rimp as refimport_t ) as refexport_t





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



 #define VID_NUM_MODES ( sizeof( vid_modes ) / sizeof( vid_modes(0) ) )




''	/* Start the graphics mode and load refresh DLL */
'	VID_CheckChanges() 
'	
'	

 sub Vid_FreeRefLib
 	 if ( FreeLibrary( reflib_library ) = 0) then
 	 		 'Com_Error( ERR_FATAL, "Reflib FreeLibrary failed" )
 	 		return
 	 end if
 	 	memset (@re, 0, sizeof(re))
 	 	reflib_library = NULL
 	 	reflib_active  = _false
 	 	
 
 
 End Sub
 
Function MainWndProc (ByVal  hWnd As HWND, _
                   ByVal uMsg As UINT, _
                   ByVal wParam As WPARAM, _
                   ByVal lParam As LPARAM) As LONG

	dim as LONG			lRet = 0 

	if ( uMsg = MSH_MOUSEWHEEL ) then
	
	 
		if ( ( cast( integer,  wParam ) > 0 )) then
		 
			'Key_Event( K_MWHEELUP, _true, sys_msg_time ) 
			'Key_Event( K_MWHEELUP, _false, sys_msg_time ) 
		 
		else
		 
			'Key_Event( K_MWHEELDOWN, _true, sys_msg_time ) 
			'Key_Event( K_MWHEELDOWN, _false, sys_msg_time ) 
		 
        return DefWindowProc (hWnd, uMsg, wParam, lParam) 
	end if
	end if
	
	
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
 
 		MSH_MOUSEWHEEL = RegisterWindowMessage("MSWHEEL_ROLLMSG") 
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
 		
 		 'beep
 		 
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
sub VID_shutdown()
  if ( reflib_active)then
 	
    re.Shutdown()
    VID_FreeReflib  
  EndIf
 
	
End Sub



sub  VID_Error cdecl (err_level as integer ,fmt as zstring ptr, ...)
	dim  as cva_list		argptr 
	dim  as zstring * MAXPRINTMSG	 msg 
	static as qboolean	inupdate 
	
	cva_start (argptr,fmt) 
	vsprintf (msg,fmt,argptr) 
	cva_end (argptr) 

	Com_Error (err_level,"%s", msg) 
	
	
End Sub
 
 sub  VID_Printf cdecl (print_level as integer ,fmt as zstring ptr, ...)
	dim  as cva_list		argptr 
	dim  as zstring * MAXPRINTMSG	 msg 
	static as qboolean	inupdate 
	
	cva_start (argptr,fmt) 
	vsprintf (msg,fmt,argptr) 
	cva_end (argptr) 
	
	if (print_level = PRINT_ALL) then
 
		Com_Printf (!"%s", msg) 
	 
	elseif ( print_level = PRINT_DEVELOPER ) then
	
		'Com_DPrintf (!"%s", msg);
	
	elseif ( print_level = PRINT_ALERT ) then
			MessageBox( 0, msg, "PRINT_ALERT", MB_ICONWARNING ) 
		OutputDebugString( msg ) 
	 
	
	end if

 	
 	
 End Sub
 
 
function VID_GetModeInfo(  _width as integer ptr, _height as integer ptr,_mode as  integer  ) as qboolean
 
	if ( _mode < 0 or _mode >= VID_NUM_MODES ) then
		return _false 
		
	EndIf
	
	*_width  = vid_modes(_mode)._width 
	*_height = vid_modes(_mode)._height 

	return _true
 
End Function


'/*
'** VID_NewWindow
'*/
sub VID_NewWindow ( _width as integer ,_height as integer )
   viddef._width  = _width 
	viddef._height = _height 

'	 _cl.force_refdef = _true 

	
End Sub
 
 


 
 
 
 
 
 
 
 
function VID_LoadRefresh(_name as zstring ptr) as qboolean
	dim as refimport_t	ri 
	dim as GetRefAPI_t	_GetRefAPI 
	
	 if ( reflib_active ) then
	 
	 	 	  re.Shutdown() 
	        VID_FreeReflib () 
	 
	 EndIf
 


	 Com_Printf(!"------- Loading %s -------\n", _name ) 
	 
    reflib_library = LoadLibrary( _name )  
	if  ( reflib_library =  0 )then
			Com_Printf( !"LoadLibrary(\"%s\") failed\n", _name ) 

		return false 
		
	EndIf
 'sleep

	 ri.Cmd_AddCommand = @Cmd_AddCommand 
	 ri.Cmd_RemoveCommand = @Cmd_RemoveCommand 
	 ri.Cmd_Argc = @Cmd_Argc 
	 ri.Cmd_Argv = @Cmd_Argv 
	 ri.Cmd_ExecuteText = @Cbuf_ExecuteText 
	 ri.Con_Printf = @VID_Printf 
	 ri.Sys_Error =   @VID_Error 
	 ri.FS_LoadFile = @FS_LoadFile 
	 ri.FS_FreeFile = @FS_FreeFile 
	 ri.FS_Gamedir = @FS_Gamedir 
	 ri.Cvar_Get = @Cvar_Get 
	 ri.Cvar_Set = @Cvar_Set 
	 ri.Cvar_SetValue = @Cvar_SetValue 
	 ri.Vid_GetModeInfo = @VID_GetModeInfo 
	 ri.Vid_MenuInit = @VID_MenuInit 
	 ri.Vid_NewWindow = @VID_NewWindow 

   '_GetRefAPI = @GetRefAPI
    
    _GetRefAPI =   cast(any ptr,GetProcAddress( reflib_library, "GetRefAPI" ))
	 if ( _GetRefAPI  =  0 ) then
	 Com_Error( ERR_FATAL, "GetProcAddress failed on %s", _name ) 
	 ' com_printf( ERR_FATAL, "GetProcAddress failed on %s", _name )
	 else
	 	'print "LOADED"
	 	'sleep
	 end if
 
	re =  _GetRefAPI( ri ) 
 
	 if (re._api_version <> API_VERSION) then
	     VID_FreeReflib ()
	 	Com_Error (ERR_FATAL, "%s has incompatible api_version", _name)
	 EndIf
  

	 if   (re.Init(global_hInstance, @MainWndProc )  = -1)   then
 			  re.Shutdown() 
	 	     VID_FreeReflib () 
	 	return _false 
	 EndIf
 'sleep 	
 

 

 	Com_Printf( !"------------------------------------\n") 
 	reflib_active = _true 
'
''//======
''//PGM
 	vidref_val = VIDREF_OTHER 
 	if(vid_ref) then
 				if( strcmp (vid_ref->_string, "gl") = 0) then
 			vidref_val = VIDREF_GL 
 				elseif( strcmp(vid_ref->_string, "Soft") = 0) then
 					
 			vidref_val = VIDREF_SOFT 
 	 	EndIf
 	EndIf
' 
''//PGM
''//======

	return _true 
	
End function





sub VID_Restart_f()
	
	
	
End Sub
 
sub VID_Front_f()
	
End Sub


'/*
'** VID_UpdateWindowPosAndSize
'*/

 
sub VID_UpdateWindowPosAndSize( x as integer ,  y as integer )
	
   dim as RECT r 
	dim as integer		style 
	dim as integer		w, h 

	r.left   = 0 
	r.top    = 0
	r.right  = viddef._width
	r.bottom = viddef._height

	style = GetWindowLong( cl_hwnd, GWL_STYLE ) 
	AdjustWindowRect( @r, style, _false ) 

	w = r.right - r.left 
	h = r.bottom - r.top 

 
 
	MoveWindow( cl_hwnd, vid_xpos->value, vid_ypos->value, w, h, _true ) 
 
	
End Sub
sub VID_CheckChanges()
	' 
	'VID_LoadRefresh( "FBRef_Soft.dll" ) 


 	'VID_UpdateWindowPosAndSize( vid_xpos->value, vid_ypos->value )
	'
	'
	'
	
	dim as zstring * 100 _name 

	if   (win_noalttab->modified ) then
	 
		if ( win_noalttab->value ) then
		 
		'	WIN_DisableAltTab() 
		 
		else
		  
			'WIN_EnableAltTab() 
		end if
		win_noalttab->modified = false 
	end if

	if ( vid_ref->modified ) then
				'cl.force_refdef = true 	'// can't use a paused refdef
		'S_StopAllSounds();
	EndIf

	while (vid_ref->modified)
	 
		'/*
		'** refresh has changed
		'*/
		vid_ref->modified = false 
		vid_fullscreen->modified = true 
		'cl.refresh_prepped = false 
		'_cls.disable_screen = true 
'
		Com_sprintf( _name, sizeof(_name), "FBRef_%s.dll", vid_ref->_string ) 
 
	 'print  _name
	 ' print  *vid_ref->_string
		if ( VID_LoadRefresh( _name ) = NULL) then
	 
		 
			if ( strcmp (vid_ref->_string, "FBRef_Soft") =  0 ) then
				Com_Error (ERR_FATAL, "Couldn't fall back to software refresh!") 
			end if
			Cvar_Set( "vid_ref", "FBRef_Soft" ) 

			'/*
			'** drop the console if we fail to load a refresh
			'*/
			'if ( cls.key_dest != key_console )
			'{
			'	Con_ToggleConsole_f();
			'}
	 
	
	end if
		'_cls.disable_screen = false 
		
	wend	
		
	'/*
	'** update our window position
	'*/
	if ( vid_xpos->modified or vid_ypos->modified ) then
		if (vid_fullscreen->value = NULL) then
			VID_UpdateWindowPosAndSize( vid_xpos->value, vid_ypos->value ) 

	EndIf
 
		
		vid_xpos->modified = false 
		vid_ypos->modified = false 
	EndIf
	
	
	
	
End Sub




sub VID_Init
	

 
 
'		/* Create the video variables so we know how to start the graphics drivers */
 	vid_ref = Cvar_Get ("vid_ref", "soft", CVAR_ARCHIVE) 
 	vid_xpos = Cvar_Get ("vid_xpos", "3", CVAR_ARCHIVE) 
 	vid_ypos = Cvar_Get ("vid_ypos", "22", CVAR_ARCHIVE) 
 	vid_fullscreen = Cvar_Get ("vid_fullscreen", "0", CVAR_ARCHIVE) 
 	vid_gamma = Cvar_Get( "vid_gamma", "1", CVAR_ARCHIVE ) 
 	win_noalttab = Cvar_Get( "win_noalttab", "0", CVAR_ARCHIVE ) 
'
'	/* Add some console commands that we want to handle */
 	Cmd_AddCommand ("vid_restart", @VID_Restart_f) 
 	Cmd_AddCommand ("vid_front", @VID_Front_f) 

 '
 'print *vid_ref->_string
 'sleep
 '
 
 
'	/*
'	** this is a gross hack but necessary to clamp the mode for 3Dfx
'	*/

#if 0
	 
	 dim as 	cvar_t ptr gl_driver = Cvar_Get( "gl_driver", "opengl32", 0 ) 
	 dim as 	cvar_t ptr gl_mode = Cvar_Get( "gl_mode", "3", 0 ) 

		if ( stricmp( gl_driver->_string, "3dfxgl" ) = 0 ) then
			Cvar_SetValue( "gl_mode", 3 ) 
			viddef.width  = 640 
			viddef.height = 480 
			
		EndIf
 
#endif
'
'	/* Disable the 3Dfx splash screen */
 	putenv("FX_GLIDE_NO_SPLASH=0") 
 		

	 VID_CheckChanges()


End Sub






