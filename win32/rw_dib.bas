#Include "FB_Ref_Soft\r_local.bi"
#Include "win32\rw_win.bi"


#ifndef __FB_WIN32__
#  error You should not be trying to compile this file on this platform
#endif

static shared as  qboolean affinetridesc_t

static shared as  qboolean s_systemcolors_saved

static shared as  HGDIOBJ previously_selected_GDI_obj

static shared as integer s_syspalindices(19) => _ 
{ _
  COLOR_ACTIVEBORDER, _
  COLOR_ACTIVECAPTION, _
  COLOR_APPWORKSPACE, _
  COLOR_BACKGROUND, _
  COLOR_BTNFACE, _
  COLOR_BTNSHADOW, _
  COLOR_BTNTEXT, _
  COLOR_CAPTIONTEXT, _
  COLOR_GRAYTEXT, _
  COLOR_HIGHLIGHT, _
  COLOR_HIGHLIGHTTEXT, _
  COLOR_INACTIVEBORDER, _
  COLOR_INACTIVECAPTION, _
  COLOR_MENU, _
  COLOR_MENUTEXT, _
  COLOR_SCROLLBAR, _
  COLOR_WINDOW, _
  COLOR_WINDOWFRAME, _
  COLOR_WINDOWTEXT _
}

#define NUM_SYS_COLORS ( (sizeof( s_syspalindices )*ubound(s_syspalindices)) / sizeof( integer ) )

static shared  as integer s_oldsyscolors(NUM_SYS_COLORS)

type dibinfo
	 
	as BITMAPINFOHEADER	header 
	as RGBQUAD				acolors(256) 
  
End Type:type dibinfo_t  as dibinfo


type identitypalette_t
		as WORD palVersion 
	as WORD palNumEntries 
	as PALETTEENTRY palEntries(256)
End Type
 

 

static shared as  identitypalette_t s_ipal 

declare sub DIB_SaveSystemColors() 'static
declare sub DIB_RestoreSystemColors()  'static
 
 
 
 
 
 
 
 
 
 
 
 
 
' /*
'** DIB_Init
'**
'** Builds our DIB section
'*/
function DIB_Init(ppbuffer as  ubyte ptr ptr, ppitch as integer ptr) as qboolean 
 
	dim as dibinfo_t   dibheader 
	dim as BITMAPINFO ptr pbmiDIB = cast( BITMAPINFO ptr,@dibheader) 
	dim as integer i 

	memset( @dibheader, 0, sizeof( dibheader ) ) 

	'/*
	'** grab a DC
	'*/
	if ( sww_state.hDC ) then
		if ( ( sww_state.hDC = GetDC( sww_state.hWnd ) ) = NULL ) then
			return false
		EndIf
 	EndIf
 

	'/*
	'** figure out if we're running in an 8-bit display mode
	'*/
 	if ( GetDeviceCaps( sww_state.hDC, RASTERCAPS ) and RC_PALETTE ) then
 
		sww_state.palettized = true 

		'// save system colors
		if (  s_systemcolors_saved = NULL) then
	 
			DIB_SaveSystemColors() 
			s_systemcolors_saved = true 
		end if
	 
	else
	 
		sww_state.palettized = false 
	end if

	'/*
	'** fill in the BITMAPINFO struct
	'*/
	pbmiDIB->bmiHeader.biSize          = sizeof(BITMAPINFOHEADER)
	pbmiDIB->bmiHeader.biWidth         = vid._width
	pbmiDIB->bmiHeader.biHeight        = vid._height
	pbmiDIB->bmiHeader.biPlanes        = 1
	pbmiDIB->bmiHeader.biBitCount      = 8
	pbmiDIB->bmiHeader.biCompression   = BI_RGB
	pbmiDIB->bmiHeader.biSizeImage     = 0
	pbmiDIB->bmiHeader.biXPelsPerMeter = 0
	pbmiDIB->bmiHeader.biYPelsPerMeter = 0
	pbmiDIB->bmiHeader.biClrUsed       = 256
	pbmiDIB->bmiHeader.biClrImportant  = 256

	'/*
	'** fill in the palette
	'*/
	for i = 0 to 256-1
		dibheader.acolors(i).rgbRed   = ( d_8to24table(i) shr 0 )  and &Hff 
		dibheader.acolors(i).rgbGreen = ( d_8to24table(i) shr 8 )  and &Hff 
		dibheader.acolors(i).rgbBlue  = ( d_8to24table(i) shr 16 ) and &Hff 
		
		
	Next
 

 
	'/*
	'** create the DIB section
	'*/
	sww_state.hDIBSection = CreateDIBSection( sww_state.hDC, _
		                                     	pbmiDIB, _
											 			 	DIB_RGB_COLORS, _
											 			 	@sww_state.pDIBBase, _
											 			 	NULL, _
														 	0 ) 

	if ( sww_state.hDIBSection = NULL ) then
				ri.Con_Printf( PRINT_ALL, !"DIB_Init() - CreateDIBSection failed\n" ) 
		goto fail
		
	EndIf
 
	if ( pbmiDIB->bmiHeader.biHeight > 0 ) then
		'// bottom up
		*ppbuffer	= sww_state.pDIBBase + ( vid._height - 1 ) * vid._width
		*ppitch		= -vid._width
 
    else
   
		'// top down
		*ppbuffer	= sww_state.pDIBBase 
		*ppitch		= vid._width 
 end if

	'/*
	'** clear the DIB memory buffer
	'*/
	memset( sww_state.pDIBBase, &Hff, vid._width * vid._height ) 
	
    sww_state.hdcDIBSection = CreateCompatibleDC( sww_state.hDC ) 
	 if (   sww_state.hdcDIBSection  = NULL ) then
	 			ri.Con_Printf( PRINT_ALL, !"DIB_Init() - CreateCompatibleDC failed\n" ) 
	 			goto fail 
	 EndIf
 
 
     previously_selected_GDI_obj = SelectObject( sww_state.hdcDIBSection, sww_state.hDIBSection )
	 if ( previously_selected_GDI_obj = NULL ) then
 
 		ri.Con_Printf( PRINT_ALL, !"DIB_Init() - SelectObject failed\n" ) 
	 	goto fail 
	end if

	return true 

fail:
	DIB_Shutdown() 
	return false 
	
 end function
 
 
'/*
'** DIB_SetPalette
'**
'** Sets the color table in our DIB section, and also sets the system palette
'** into an identity mode if we're running in an 8-bit palettized display mode.
'**
'** The palette is expected to be 1024 bytes, in the format:
'**
'** R = offset 0
'** G = offset 1
'** B = offset 2
'** A = offset 3
'*/
sub DIB_SetPalette( _pal as const ubyte ptr )
	
	dim as const ubyte ptr pal = _pal
	dim as LOGPALETTE	ptr pLogPal = cast( LOGPALETTE ptr, @s_ipal)
	dim as RGBQUAD			colors(256)
	dim as integer				i
	dim as integer				ret
	dim as HDC				hDC = sww_state.hDC 
	
'	/*
'	** set the DIB color table
'	*/
	
	if ( sww_state.hdcDIBSection ) then
		i = 0
     do while i < 256-1
     	
     	
     	     
			colors(i).rgbRed   = pal[0]
			colors(i).rgbGreen = pal[1]
			colors(i).rgbBlue  = pal[2]
			colors(i).rgbReserved = 0 
     	
     	
     	i+=1
     	pal+=1
     Loop

    
    		colors(0).rgbRed   = 0
			colors(0).rgbGreen = 0
			colors(0).rgbBlue  = 0
 
     	
     		colors(255).rgbRed   = &HFF
			colors(255).rgbGreen = &HFF
			colors(255).rgbBlue  = &HFF
 
				if ( SetDIBColorTable( sww_state.hdcDIBSection, 0, 256, @colors(0) ) = 0 ) then
					ri.Con_Printf( PRINT_ALL, !"DIB_SetPalette() - SetDIBColorTable failed\n" )
					
				EndIf
 
	EndIf
	
	
	if ( sww_state.palettized ) then
	   dim as integer i 
		dim as HPALETTE hpalOld 
		
		
		if ( SetSystemPaletteUse( hDC, SYSPAL_NOSTATIC ) = SYSPAL_ERROR ) then
			
			ri.Sys_Error( ERR_FATAL, !"DIB_SetPalette() - SetSystemPaletteUse() failed\n" )
		EndIf
 
 
		'/*
		'** destroy our old palette
		'*/
		if ( sww_state.hPal ) then
		   DeleteObject( sww_state.hPal ) 
			sww_state.hPal = 0 
			
		EndIf
 
		
      '/*
		'** take up all physical palette entries to flush out anything that's currently
		'** in the palette
		'*/
		pLogPal->palVersion		= &H300 
		pLogPal->palNumEntries	= 256 

	 	 i = 0
	 	 pal = _pal
		 do while i <256
			pLogPal->palPalEntry(i).peRed	=    pal[0]
			pLogPal->palPalEntry(i).peGreen	= pal[1]
			pLogPal->palPalEntry(i).peBlue	= pal[2]
			pLogPal->palPalEntry(i).peFlags	= PC_RESERVED or PC_NOCOLLAPSE 
			i+=1 
			pal += 4
		loop
		
		
		
		pLogPal->palPalEntry(0).peRed		= 0 
		pLogPal->palPalEntry(0).peGreen		= 0 
		pLogPal->palPalEntry(0).peBlue		= 0 
		pLogPal->palPalEntry(0).peFlags		= 0 
		pLogPal->palPalEntry(255).peRed		= &Hff 
		pLogPal->palPalEntry(255).peGreen	= &Hff  
		pLogPal->palPalEntry(255).peBlue	= &Hff  
		pLogPal->palPalEntry(255).peFlags	= 0 
		sww_state.hPal = CreatePalette( pLogPal )
		
		if ( sww_state.hPal = NULL ) then
	  
			ri.Sys_Error( ERR_FATAL, !"DIB_SetPalette() - CreatePalette failed(%x)\n", GetLastError() ) 
		end if

		if ( ( hpalOld = SelectPalette( hDC, sww_state.hPal, FALSE ) ) =  NULL ) then 
			
				ri.Sys_Error( ERR_FATAL, !"DIB_SetPalette() - SelectPalette failed(%x)\n",GetLastError() ) 

		EndIf
 

		 if ( sww_state.hpalOld = NULL ) then
		 	sww_state.hpalOld = hpalOld 
		 EndIf
          ret = RealizePalette( hDC )  
		 if (   ret  <> pLogPal->palNumEntries )  then
		 	
		 	ri.Sys_Error( ERR_FATAL, !"DIB_SetPalette() - RealizePalette set %d entries\n", ret )
		 EndIf
 
		
		
		
		
		
		
		
		
	EndIf
	
End Sub

 

 
 
 
' /*
'** DIB_Shutdown
'*/
sub DIB_Shutdown()
	if ( sww_state.palettized and s_systemcolors_saved ) then
		DIB_RestoreSystemColors()
	EndIf
	 

	 if ( sww_state.hPal ) then
	 		DeleteObject( sww_state.hPal ) 
		sww_state.hPal = 0 
	 EndIf
	 
	
	 
	if ( sww_state.hpalOld ) then
				SelectPalette( sww_state.hDC, sww_state.hpalOld, FALSE ) 
				RealizePalette( sww_state.hDC ) 
				sww_state.hpalOld = NULL 
	EndIf
 

	 
	 
	if ( sww_state.hdcDIBSection )then
				SelectObject( sww_state.hdcDIBSection, previously_selected_GDI_obj )  
				DeleteDC( sww_state.hdcDIBSection ) 
				sww_state.hdcDIBSection = NULL 
		
	EndIf
	 

 
	if ( sww_state.hDIBSection ) then
		DeleteObject( sww_state.hDIBSection ) 
		sww_state.hDIBSection = NULL
		sww_state.pDIBBase = NULL
	EndIf
 
 
		if ( sww_state.hDC ) then
	       ReleaseDC( sww_state.hWnd, sww_state.hDC ) 
		    sww_state.hDC = 0 
		EndIf
	 

 
End Sub
 
	


 

 
 
' 
' /*
'** DIB_Save/RestoreSystemColors
'*/
sub DIB_RestoreSystemColors() static
    SetSystemPaletteUse( sww_state.hDC, SYSPAL_STATIC ) 
    SetSysColors( NUM_SYS_COLORS, @s_syspalindices(0), @s_oldsyscolors(0) ) 
End Sub
 

sub DIB_SaveSystemColors()static 
		dim as integer i 

	for   i = 0 to NUM_SYS_COLORS - 1 
		s_oldsyscolors(i) = GetSysColor( s_syspalindices(i) ) 
	Next
		
 
End Sub
 
