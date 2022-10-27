'FINISHED FOR NOW TEMP FIX''''''''''''''''''''''''''''''''''''''



#ifndef __REF_H
#define __REF_H

'temporary fixes
 type image_s  as image_s_
 type model_s  as model_s_	
 type surfcache_s   as surfcache_s_	 
 


#Include "qcommon\qcommon.bi"



''''''''''''''''''''''''''''''''''''''''

#define	MAX_DLIGHTS		32
#define	MAX_ENTITIES	128
#define	MAX_PARTICLES	4096
#define	MAX_LIGHTSTYLES	256

#define POWERSUIT_SCALE		4.0F

#define SHELL_RED_COLOR		&HF2
#define SHELL_GREEN_COLOR	&HD0
#define SHELL_BLUE_COLOR	&HF3

#define SHELL_RG_COLOR		&HDC
'#define SHELL_RB_COLOR		&H86
#define SHELL_RB_COLOR		&H68
#define SHELL_BG_COLOR		&H78


#define SHELL_DOUBLE_COLOR	&HDF
#define	SHELL_HALF_DAM_COLOR	&H90
#define SHELL_CYAN_COLOR	&H72

#define SHELL_WHITE_COLOR	&HD7

#define ENTITY_FLAGS  68

#define	API_VERSION		3








type entity_s
 
  	model as model_s  ptr 		
	angles(3) as float
	origin(3) as float
	frame as Integer
	oldorigin(3) as float
	oldframe as Integer
	backlerp as float	
	skinnum as Integer
	lightstyle as Integer
	alpha_ as float	
 	skin as image_s  ptr
	flags as integer

end type: type entity_t as entity_s 


type dlight_t
	origin(3) as vec3_t
	_color(3) as vec3_t	 
	intensity as float

End Type
 

type particle_t 
 
	origin(3) as vec3_t	
	_color   as integer	 
	alpha_   as float	
end type 

type lightstyle_t 
 
	_rgb(3) as float 
	white as float 
end type 



type refdef_t
	
	as integer		x, y, _width, _height 
	as float		    fov_x, fov_y 
	vieworg(3) as float 
	viewangles(3) as float		
	blend(4)   as float		
	_time      as float  
	rdflags    as integer	 

	areabits  as ubyte ptr		

	lightstyles  As lightstyle_t ptr	

	num_entities as Integer			
	entities  as entity_t ptr	

	num_dlights as integer			 
	dlights as dlight_t	 ptr	

	num_particles as Integer 
	particles as particle_t ptr
End Type
 



type refexport_t
	dim _api_version as Integer
	
	Shutdown as sub()
	Init as function(hInstance as any ptr, wndproc as any ptr) as qboolean 

	BeginRegistration as sub(_map as zstring ptr) 
    RegisterModel as function(_name as zstring ptr) as model_s  ptr 
 	 RegisterSkin as  function(_name as ZString ptr) as image_s  ptr
	 RegisterPic as  function( _name as ZString ptr) as image_s  ptr
	SetSky as sub(_name as ZString, _rotate as float ,  axis as vec3_t) 
	EndRegistration as sub()

	RenderFrame as sub (fd as refdef_t ptr ) 

	 DrawGetPicSize as sub( w as integer ptr, h as integer ptr,_name as zstring ptr) 
	 DrawPic as sub(x as Integer,y as Integer,_name as zstring ptr) 
	 DrawStretchPic as sub (x as integer,y as integer, w as integer , h as integer, _name as ZString) 
	 DrawChar as sub(x as integer,y as integer,c as integer) 
	 DrawTileClear as sub  (x as integer,y as integer, w as integer , h as integer, _name as ZString) 
	 DrawFill as sub  (x as integer,y as integer, w as integer , h as integer,c as Integer) 
    DrawFadeScreen as sub() 

	 DrawStretchRaw  as sub(x as integer,y as integer,w as integer,h as integer,cols as integer, rows as integer ,_data as ubyte) 

 
	 CinematicSetPalette as sub( _palette as const zstring ptr) 
	 BeginFrame as sub(camera_separation as float ) 
	 EndFrame as sub()

	AppActivate as sub(_activate as qboolean)  

	
End Type

type refimport_t
	
	dim _api_version as Integer
	Con_Printf as Function cdecl(print_level as integer,_str as zstring ptr,...)  as integer
	Cmd_AddCommand as sub(_name as ZString ptr, _cmd as sub()) 
	Cmd_RemoveCommand as sub(_name as ZString ptr)
	Cmd_ArgC as function() as integer
	Cmd_ArgV as function(arg as integer )as zstring ptr
	Cmd_ExecuteText as Sub(exec_when as Integer, text as ZString ptr)  
	Sys_Error as Function cdecl(err_level as integer,_str  as zstring ptr,...)  as integer
	
	FS_LoadFile as function(_name as ZString ptr, buffer as any ptr ptr) as integer
	FS_FreeFile as  sub(buf as any ptr) 

	FS_Gamedir  as function() as ZString ptr

   Cvar_Get as function (_name as ZString ptr, value as ZString ptr, flags as Integer) as cvar_t ptr
	Cvar_Set as function (_name as zstring ptr, value as ZString ptr ) as cvar_t ptr	
	Cvar_SetValue as sub(_name as zstring ptr, value as float ) 

	Vid_GetModeInfo as function(_width as Integer ptr, height as Integer ptr,mode as Integer) as qboolean	
	Vid_MenuInit as sub() 
	Vid_NewWindow as sub( _width as Integer, _height as Integer )
	
	
End Type

type	GetRefAPI_t as function(as refimport_t)  as refexport_t





#endif
