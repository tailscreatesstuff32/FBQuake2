'FINISHED fOR NOW ''''''''''''''''''''''''''''''''''''''''''''''''''''


type  vrect_s
 
	as integer				x,y,_width,_height 
end type type vrect_t as vrect_s 

type viddef_t
	as integer		_width		
	as integer		_height
 End Type

extern as	viddef_t	viddef 				'// global video state

'// Video module initialisation etc
declare sub	VID_Init () 
void	VID_Shutdown () 
void	VID_CheckChanges ()

void	VID_MenuInit()
void	VID_MenuDraw()
declare function VID_MenuKey( as Integer ) as const zstring ptr
