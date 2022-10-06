

'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''
'#pragma warning( disable : 4229 )  // mgraph gets this

#include "windows.bi"
#include once "win/mmsystem.bi"
#include once "win/d3d.bi"
#include "win\dsound.bi"

#define	WINDOW_STYLE	(WS_OVERLAPPED or WS_BORDER or WS_CAPTION or WS_VISIBLE)

extern global_hInstance  as HINSTANCE	

extern pDS as LPDIRECTSOUND  
extern pDSBuf as LPDIRECTSOUNDBUFFER  

extern gSndBufSize  as DWORD

extern cl_hwnd  as HWND			
extern as qboolean ActiveApp, Minimized 

declare sub  IN_Activate (active as qboolean ) 
declare sub  IN_MouseEvent(mstate as integer ) 

extern as integer		window_center_x, window_center_y 
extern window_rect as RECT 
