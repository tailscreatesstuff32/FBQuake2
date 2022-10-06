'FINISHED''''''''''''''''''''''''



''''''''''''''''''''''''''''''''''''''''''''''''










type glstate_t
	inverse_intensity  as float 
	 fullscreen as qboolean

   prev_mode as integer

	d_16to8table as ubyte ptr
	lightmap_textures as integer

	currenttextures(2) as Integer
   currenttm  as Integer

	 camera_separation as float 
	 stereo_enabled as qboolean 

	 originalRedGammaTable(256) as ubyte
	 originalGreenGammaTable(256) as ubyte
    originalBlueGammaTable(256) as ubyte
 
End Type







type vrect_s
	 x as Integer
	 y as Integer
	_wid as Integer
	_hght as Integer
End Type: type vrect_t as vrect_S


type viddef_t
as UInteger _width,_height
End Type


extern viddef as viddef_t



declare sub VID_Init()
declare sub VID_Shutdown()
declare sub VID_CheckChanges()
declare sub VID_MenuInit()
declare sub VID_MenuDraw()
declare sub VID_MenuKey( as integer)
