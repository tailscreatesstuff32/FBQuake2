#Include "..\FB_Ref_Soft\r_local.bi"
#Include "win32\rw_win.bi"
#Include "win32\winquake.bi"

dim shared as swwstate_t sww_state

#define	WINDOW_CLASS_NAME "Quake 2"
 
 sub VID_CreateWindow(_width as  integer , _height as integer,stylebits as integer )
 	dim as WNDCLASS		wc 
	dim as RECT			r 
	dim as cvar_t ptr vid_xpos, vid_ypos,  vid_fullscreen 
	dim as integer				x, y, w, h 
	dim as integer				exstyle 


 
	  vid_xpos = ri.Cvar_Get ("vid_xpos", "0", 0) 
	  vid_ypos = ri.Cvar_Get ("vid_ypos", "0", 0) 
	  vid_fullscreen = ri.Cvar_Get ("vid_fullscreen", "0", CVAR_ARCHIVE ) 
     'print vid_fullscreen->value 
     'sleep
     
	 if ( vid_fullscreen->value ) then
	 	exstyle = WS_EX_TOPMOST 
	 else
	 	exstyle = 0 
	 EndIf
 

	'/* Register the frame class */
    wc.style         = 0 
    wc.lpfnWndProc   = cast(WNDPROC, sww_state.wndproc)
    wc.cbClsExtra    = 0 
    wc.cbWndExtra    = 0 
    wc.hInstance     = sww_state.hInstance 
    wc.hIcon         = 0  
    wc.hCursor       = LoadCursor (NULL,IDC_ARROW) 
	 wc.hbrBackground = cast(any ptr  ,COLOR_GRAYTEXT) 
    wc.lpszMenuName  = 0 
    wc.lpszClassName = @WINDOW_CLASS_NAME 

    if ( RegisterClass (@wc)  = 0) then
		 ri.Sys_Error (ERR_FATAL, "Couldn't register window class")
    end if

	r.left = 0 
	r.top = 0 
	r.right  = _width 
	r.bottom = _height 

	AdjustWindowRect (@r, stylebits, _false) 

	w = r.right - r.left 
	h = r.bottom - r.top 
	x =  vid_xpos->value 
	y =  vid_ypos->value 

	sww_state.hWnd = CreateWindowEx ( _
		exstyle, _
		 WINDOW_CLASS_NAME, _
		 "Quake 2", _
		 stylebits, _
		 x, y, w, h, _
		 NULL, _
		 NULL, _
		 sww_state.hInstance, _
		 NULL) 

	if ( sww_state.hWnd = NULL) then
	' ri.Sys_Error (ERR_FATAL, "Couldn't create window")
		
	EndIf
	
	
	ShowWindow( sww_state.hWnd, SW_SHOWNORMAL ) 
	UpdateWindow( sww_state.hWnd ) 
	SetForegroundWindow( sww_state.hWnd ) 
	SetFocus( sww_state.hWnd ) 
 
	'// let the sound and input subsystems know about the new window
	 ri.Vid_NewWindow (_width, _height) 
end sub

function SWimp_Init( hInstance as any ptr , wndProc as any ptr ) as Integer
	sww_state.hInstance = cast( HINSTANCE,   hInstance)
	sww_state.wndproc = wndProc 

	return _false 
	
End Function
 ' /*
'** SWimp_InitGraphics
'**
'** This initializes the software refresh's implementation specific
'** graphics subsystem.  In the case of Windows it creates DIB or
'** DDRAW surfaces.
'**
'** The necessary width and height parameters are grabbed from
'** vid.width and vid.height.
'*/
  function SWimp_InitGraphics( fullscreen as qboolean  ) as qboolean static 
 
	'// free resources in use
	  SWimp_Shutdown () 

	'// create a new window
	VID_CreateWindow (vid._width, vid._height, WINDOW_STYLE) 
	

	'// initialize the appropriate subsystem
 if (  fullscreen  ) then
	'{
'		if ( !DIB_Init( &vid.buffer, &vid.rowbytes ) )
	'	{
	'		vid.buffer = 0;
	'		vid.rowbytes = 0;

	'		return _false;
	'	}
	'}
	 else
	'{
'		if ( !DDRAW_Init( &vid.buffer, &vid.rowbytes ) )
	'	{
	'		vid.buffer = 0;
	'		vid.rowbytes = 0;

	'		return _false;
	'	}
	end if

	return _true 
end function
 
 function SWimp_SetMode(pwidth as  integer ptr, pheight as integer ptr, _mode as integer,fullscreen as qboolean  ) as rserr_t
 	dim as  const zstring ptr win_fs(2) => { @"W", @"FS" } 
 	
	dim as rserr_t retval = rserr_ok 

 	
 	ri.Con_Printf (PRINT_ALL, "setting mode %d:", _mode )
 	
 
 if (  ri.Vid_GetModeInfo( pwidth, pheight, _mode ) = NULL) then
 	ri.Con_Printf( PRINT_ALL, !" invalid mode\n" )
  	return rserr_invalid_mode
 EndIf
 
 
    ri.Con_Printf( PRINT_ALL, !" %d %d %s\n", *pwidth, *pheight, win_fs(fullscreen) )
 
 sww_state.initializing = true
 
 
 if ( fullscreen ) then
 	
 	if (  SWimp_InitGraphics( 1 ) = NULL) then
 		if ( SWimp_InitGraphics( 0 ) ) then
 			fullscreen = 0 
 			retval = rserr_invalid_fullscreen
 		else
 			retval = rserr_unknown
 			
 			
 		EndIf
 		
 		
 	EndIf
 
 else
 	
 	'// failure to set a valid mode in windowed mode
		if (  SWimp_InitGraphics( fullscreen )= NULL ) then
		
 
			sww_state.initializing = true 
			return rserr_unknown 
		end if
 	
 	
 EndIf
 
  	
 sw_state.fullscreen = fullscreen  
#if 0
	if ( retval <> rserr_unknown ) then
	 
		if ( retval =  rserr_invalid_fullscreen or _
			 ( retval =  rserr_ok and  fullscreen = false ) ) then
		 
			SetWindowLong( sww_state.hWnd, GWL_STYLE, WINDOW_STYLE ) 
		endif
	endif
#endif
 
 
 
 R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @d_8to24table(0) ) )
 
 
 	sww_state.initializing = true

 		return retval
 End Function
 

' /*
'** SWimp_Shutdown
'**
'** System specific graphics subsystem shutdown routine.  Destroys
'** DIBs or DDRAW surfaces as appropriate.
'*/
sub SWimp_Shutdown()
		ri.Con_Printf( PRINT_ALL,!"Shutting down SW imp\n" ) 
	'DIB_Shutdown();
	'DDRAW_Shutdown();
	 

	if ( sww_state.hWnd ) then
   
		ri.Con_Printf( PRINT_ALL ,!"...destroying window\n" ) 
		ShowWindow( sww_state.hWnd, SW_SHOWNORMAL ) 	'// prevents leaving empty slots in the taskbar
		DestroyWindow (sww_state.hWnd) 
		sww_state.hWnd = NULL 
		UnregisterClass (WINDOW_CLASS_NAME, sww_state.hInstance) 
	end if
End Sub
 

 
 
 

'/*
'================
'Sys_MakeCodeWriteable
'================
'*/
sub Sys_MakeCodeWriteable (startaddr as ulong ,length as ulong )
		dim as DWORD  flOldProtect 
 
  ' print cast(LPVOID,startaddr)
    
	if  (VirtualProtect(cast(LPVOID,startaddr), length, PAGE_READWRITE, @flOldProtect) = NULL) then
		ri.Sys_Error(ERR_FATAL, !"Protection change failed\n") 
	EndIf
 		
End Sub
 

 
 
' /*
'** SWimp_SetPalette
'**
'** System specific palette setting routine.  A NULL palette means
'** to use the existing palette.  The palette is expected to be in
'** a padded 4-byte xRGB format.
'*/
sub SWimp_SetPalette(_palette as const ubyte ptr  )
 
	'// MGL - what the fuck was kendall doing here?!
	'// clear screen to black and change palette
	'//	for (i=0 ; i<vid.height ; i++)
	'//		memset (vid.buffer + i*vid.rowbytes, 0, vid.width);

	if ( _palette = null) then
		_palette = cast(const ubyte ptr, @sw_state.currentpalette(0) )
	end if

	if ( sw_state.fullscreen = false) then
	 
	 DDRAW_SetPalette(cast(const ubyte ptr,_palette) ) 
	else
	 DIB_SetPalette( cast(const ubyte ptr,_palette)) 
		' DDRAW_SetPalette(cast(const ubyte ptr,_palette) ) 
	end if
end sub

 
 
 
 
 #ifndef id386
 
 
sub Sys_SetFPCW( )
	
	
	
	
	
End Sub
 
 #else
dim shared as uinteger  fpu_ceil_cw, fpu_chop_cw, fpu_full_cw, fpu_cw, fpu_pushed_cw 
dim shared as uinteger  fpu_sp24_cw, fpu_sp24_ceil_cw 


sub Sys_SetFPCW( )
	
  asm
     xor eax, eax

	  fnstcw  word ptr fpu_cw
	  mov ax, word ptr fpu_cw

	   and ah, 0x0f0
	   or  ah, 0x003          '; round to nearest mode, extended precision
	  mov fpu_full_cw, eax

	  and ah, 0x0f0 
	  or  ah, 0x00f           '; RTZ/truncate/chop mode, extended precision
	  mov fpu_chop_cw, eax

	  and ah, 0x0f0
	  or  ah, 0x00b          '; ceil mode, extended precision
	  mov fpu_ceil_cw, eax

	  and ah, 0x0f0          '; round to nearest, 24-bit single precision
	  mov fpu_sp24_cw, eax

	  and ah, 0x0f0          '; ceil mode, 24-bit single precision
	  or  ah, 0x008           '; 
     mov fpu_sp24_ceil_cw, eax
	
   end asm
	
	 
End Sub




#endif




sub SWimp_EndFrame() 
	
	
	
End Sub
sub  SWimp_AppActivate(active as qboolean) 
	
	
	
	
End Sub


