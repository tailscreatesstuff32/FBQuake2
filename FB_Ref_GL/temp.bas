
'dim shared vup as vec3_t
'dim shared vpn as vec3_t
'dim shared vright as vec3_t	
'dim shared r_origin as vec3_t	
''
'dim shared r_world_matrix(16) as float 
'dim shared r_base_world_matrix(16) as float	 
'
declare	 sub CinematicSetPalette  ( _palette as const zstring ptr) 
declare	 sub BeginFrame  (camera_separation as float ) 
declare	 sub EndFrame()



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#include "Client\Vid.bi"


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



#include "win32\glw_win.bi"


#include "win32\qgl_win.bi"






declare sub R_BeginFrame(camera_separation as float ) 
declare sub R_SetPalette ( _palette as const zstring ptr)
declare sub Draw_GetPicSize( w as integer ptr, h as integer ptr,_name as zstring ptr) 
declare sub Draw_StretchPic (x as integer,y as integer, w as integer , h as integer, _name as ZString) 
declare sub Draw_StretchRaw (x as integer,y as integer,w as integer,h as integer,cols as integer, rows as integer ,_data as ubyte) 
declare sub	R_Init(hinstance as any ptr, hwnd as any ptr ) 
declare sub R_Shutdown( ) 


