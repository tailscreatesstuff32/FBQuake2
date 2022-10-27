'
'/*
'Copyright (C) 1997-2001 Id Software, Inc.
'
'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
'
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
'






'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#ifndef __RW_WIN_H__
#define __RW_WIN_H__

#include "windows.bi"

#include "win/ddraw.bi"





type swwstate_t
	as HINSTANCE		hInstance 
	as any ptr			wndproc 
	as HDC				hDC 			'	// global DC we're using
	as HWND			  hWnd 				'// HWND of parent window

	as HDC				hdcDIBSection 		'// DC compatible with DIB section
	as HBITMAP			hDIBSection 		'// DIB section
	as ubyte ptr	 pDIBBase 			'// DIB base pointer, NOT used directly for rendering!

	as HPALETTE		hPal 				'// palette we're using
	as HPALETTE		hpalOld 		'// original system palette
	as COLORREF		oldsyscolors(20) 	'// original system colors

	as HINSTANCE		hinstDDRAW 		'// library instance for DDRAW.DLL
	as LPDIRECTDRAW 	lpDirectDraw 		'// pointer to DirectDraw object

	as LPDIRECTDRAWSURFACE lpddsFrontBuffer 	'// video card display memory front buffer
	as LPDIRECTDRAWSURFACE lpddsBackBuffer 	'// system memory backbuffer
	as LPDIRECTDRAWSURFACE lpddsOffScreenBuffer 	'// system memory backbuffer
	as LPDIRECTDRAWPALETTE	lpddpPalette 		'// DirectDraw palette

	as qboolean		palettized 		'// _true if desktop is paletted
	as qboolean		modex 

	as qboolean		initializing 
  
	
	
	
	
End Type
 


extern as swwstate_t sww_state 

'/*
'** DIB code
'*/
declare function DIB_Init( ppbuffer as ubyte ptr ptr,ppitch as  integer ptr)  as qboolean
declare sub DIB_Shutdown( ) 
declare sub DIB_SetPalette( _palette as const ubyte ptr ) 

declare function DDRAW_Init(  ppbuffer as ubyte ptr ptr,ppitch as  integer ptr )   as qboolean
declare sub DDRAW_Shutdown() 
declare sub DDRAW_SetPalette( _palette as const ubyte ptr  ) 

#endif






