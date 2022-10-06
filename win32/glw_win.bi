 
'FINISHED


#ifndef __FB_WIN32__
#error You should not be including this file on this platform
#endif

#ifndef __GLW_WIN_H__
#define __GLW_WIN_H__

type glwstate_t
 
 
	hInstance as HINSTANCE	
	wndproc as any ptr	 

	hDC  as HDC    		 
	hWnd 	as HWND  		 
	hGLRC as	HGLRC  		 

	hinstOpenGL  as HINSTANCE 

   minidriver as qboolean  
	allowdisplaydepthchange as qboolean 
	mcd_accelerated as qboolean 

   log_fp as  FILE ptr
 



end type

Extern glw_state as glwstate_t


#endif