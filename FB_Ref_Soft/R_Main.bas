
 '#define id386	1

#Include "FB_Ref_Soft\r_local.bi"

dim shared vid as viddef_t
dim shared	ri as refimport_t

dim shared as  uinteger d_8to24table(256)

dim shared as entity_t	r_worldentity

dim shared as zstring * MAX_QPATH skyname 
dim shared as float skyrotate
dim shared as vec3_t skyaxis
dim shared as image_t ptr sky_images(6)

dim shared  r_newrefdef as refdef_t
dim shared currentmodel as model_t ptr

dim shared  r_worldmodel as model_t	ptr

dim shared as ubyte r_warpbuffer(WARP_WIDTH * WARP_HEIGHT)

dim shared sw_state as swstate_t

dim shared as any ptr   colormap 
dim shared as vec3_t		viewlightvec 
dim shared as alight_t	r_viewlighting: r_viewlighting.ambientlight = 128:r_viewlighting.shadelight = 192:r_viewlighting.plightvec = cast(float ptr,@viewlightvec) 
dim shared as float		r_time1 
dim shared as integer   r_numallocatededges 
dim shared as float		r_aliasuvscale = 1.0
dim shared as integer   r_outofsurfaces 
dim shared as integer   r_outofedges 

dim shared as qboolean	r_dowarp 

dim shared as mvertex_t	ptr r_pcurrentvertbase 

dim shared as integer   c_surf 
dim shared as integer   r_maxsurfsseen, r_maxedgesseen, r_cnumsurfs 
dim shared as qboolean	r_surfsonstack 
dim shared as integer   r_clipflags 


dim shared vup as vec3_t
dim shared vpn as vec3_t
dim shared as vec3_t	vright, base_vright
dim shared r_origin as vec3_t

dim shared as oldrefdef_t	r_refdef
dim shared as float		xcenter, ycenter 
dim shared as float		xscale, yscale 
dim shared as float		xscaleinv, yscaleinv 
dim shared as float		xscaleshrink, yscaleshrink 
dim shared as float		aliasxscale, aliasyscale, aliasxcenter, aliasycenter 

dim shared as integer r_screenwidth

dim shared as float	xOrigin, yOrigin
dim shared as float	verticalFieldOfView

dim shared as mplane_t	screenedge(4)

'//
'// refresh flags
'//
dim shared as integer		r_framecount = 1 	'// so frame counts initialized to 0 don't match
dim shared as integer		r_visframecount 
dim shared as integer	   d_spanpixcount 
dim shared as integer		r_polycount 
dim shared as integer		r_drawnpolycount 
dim shared as integer		r_wholepolycount 

dim shared as integer ptr    pfrustum_indexes(4)  
dim shared as integer		  r_frustum_indexes(4*6) 

dim shared as mleaf_t ptr r_viewleaf
dim shared as integer	r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2


dim shared as image_t ptr  r_notexture_mip

dim shared as float	da_time1, da_time2, dp_time1, dp_time2, db_time1, db_time2, rw_time1, rw_time2 
dim shared as float	se_time1, se_time2, de_time1, de_time2 


declare sub R_MarkLeaves ()

extern as cvar_t ptr sw_allow_modex
dim shared as cvar_t ptr r_lefthand
dim shared as cvar_t ptr sw_aliasstats
dim shared as cvar_t ptr sw_allow_modex
dim shared as cvar_t ptr sw_clearcolor
dim shared as cvar_t ptr sw_drawflat
dim shared as cvar_t ptr sw_draworder
dim shared as cvar_t ptr sw_maxedges
dim shared as cvar_t ptr sw_maxsurfs
dim shared as cvar_t ptr sw_mode
dim shared as cvar_t ptr sw_reportedgeout
dim shared as cvar_t ptr sw_reportsurfout
dim shared as cvar_t ptr sw_stipplealpha
dim shared as cvar_t ptr sw_surfcacheoverride
dim shared as cvar_t ptr sw_waterwarp

dim shared as cvar_t ptr r_drawworld
dim shared as cvar_t ptr r_drawentities
dim shared as cvar_t ptr r_dspeeds
dim shared as cvar_t ptr r_fullbright
dim shared as cvar_t ptr r_lerpmodels
dim shared as cvar_t ptr r_novis

dim shared as cvar_t ptr r_speeds
dim shared as cvar_t ptr r_lightlevel	'//FIXME HACK

dim shared as cvar_t ptr vid_fullscreen
dim shared as cvar_t ptr vid_gamma


'//PGM
dim shared as cvar_t ptr sw_lockpvs
'//PGM


#define	STRINGER(x) "x"


 'dim shared as short ptr d_pzbuffer 
 
 'asm
 '	
 '	 
 '	
 '	
 '	
 '	
 '  d_pzbuffer:.LONG 100
 ' 	
 '
 'End Asm
 ''
 '' dim shared i as short 
 ' d_pzbuffer =  @i
 
 
 
'#if !id386 
#ifndef id386 
''''''''''''''''''''''''''''''''''''''''''''''''''

 
dim shared as float	d_sdivzstepu, d_tdivzstepu, d_zistepu 
dim shared as float	d_sdivzstepv, d_tdivzstepv, d_zistepv 
dim shared as float	d_sdivzorigin, d_tdivzorigin, d_ziorigin 

dim shared as fixed16_t	sadjust, tadjust, bbextents, bbextentt 

dim shared as pixel_t ptr cacheblock 
dim shared as integer cachewidth 
dim shared as pixel_t ptr d_viewbuffer 
dim shared as short ptr d_pzbuffer 
dim shared as uinteger d_zrowbytes 
dim shared as uinteger d_zwidth 


#endif	'// !id386

dim shared as ubyte	r_notexture_buffer(1024)



sub	R_InitTextures ()

dim as integer		x,y, m
dim as ubyte ptr  dest

'// create a simple checkerboard texture for the default
r_notexture_mip = cast(image_t ptr , @r_notexture_buffer(0) )

r_notexture_mip->_height = 16
r_notexture_mip->_width = r_notexture_mip->_height
r_notexture_mip->pixels(0) = @r_notexture_buffer(sizeof(image_t))
r_notexture_mip->pixels(1) = r_notexture_mip->pixels(0) + 16*16
r_notexture_mip->pixels(2) = r_notexture_mip->pixels(1) + 8*8
r_notexture_mip->pixels(3) = r_notexture_mip->pixels(2) + 4*4

for m = 0 to 4-1
	dest = r_notexture_mip->pixels(m)
	for  y=0  to (16 shr m) - 1
		for  x=0 to (16 shr m)-1
			if (  (y < (8 shr m) ) xor (x < (8 shr m) ) ) then


				*dest = 0:dest+=1
			else
				*dest  = &Hff:dest+=1
			EndIf



		Next

	Next
Next








end sub










'/*
'@@@@@@@@@@@@@@@@@@@@@
'GetRefAPI
'
'@@@@@@@@@@@@@@@@@@@@@
'*/




declare sub R_BeginRegistration (_map as ZString ptr)
declare function R_RegisterModel (_name as ZString) as model_s ptr
'declare function R_RegisterSkin (_name as ZString) as image_s
declare sub R_SetSky (_name as ZString ptr,rotate as float , axis as  vec3_t)


'
declare sub R_RenderFrame (fd as refdef_t ptr)
'
declare function Draw_FindPic(_name as ZString) as image_s
'
'
'declare sub Draw_Pic (x as Integer,y as Integer,_name as zstring ptr)
'declare sub Draw_Char (x as Integer, y as Integer, c as Integer)
'declare sub	Draw_TileClear (x as Integer, y as Integer, w  as Integer, h  as Integer,_name as zstring ptr)
'declare sub Draw_Fill (x as Integer,y  as Integer,w  as Integer, h  as Integer,c  as Integer)
'declare sub Draw_FadeScreen ()
'
'

declare sub R_CinematicSetPalette( _palette as const zstring ptr  )



function Draw_GetPalette () as integer
	dim as ubyte ptr 	 _out,  _pal
	dim i  as integer
	dim as integer 	r, g, b


	LoadPCX ("pics/colormap.pcx", @vid.colormap, @_pal, NULL, NULL)
	if (vid.colormap = NULL) then
		'ri.Sys_Error (ERR_FATAL, "Couldn't load pics/colormap.pcx")
		print "Couldn't load pics/colormap.pcx"
		return 0
	EndIf
	vid.alphamap = vid.colormap + 64*256

	for i = 0 to 256-1

		r = _pal[i*3+0]
		g = _pal[i*3+1]
		b = _pal[i*3+2]


	Next



	free (_pal)

	return 0

End Function





declare sub R_ImageList_f()



sub R_register

sw_aliasstats = ri.Cvar_Get ("sw_polymodelstats", "0", 0)
sw_allow_modex = ri.Cvar_Get( "sw_allow_modex", "1", CVAR_ARCHIVE )
sw_clearcolor = ri.Cvar_Get ("sw_clearcolor", "2", 0)
sw_drawflat = ri.Cvar_Get ("sw_drawflat", "0", 0)
sw_draworder = ri.Cvar_Get ("sw_draworder", "0", 0)
sw_maxedges = ri.Cvar_Get ("sw_maxedges", STRINGER(MAXSTACKSURFACES), 0)
sw_maxsurfs = ri.Cvar_Get ("sw_maxsurfs", "0", 0)
sw_mipcap = ri.Cvar_Get ("sw_mipcap", "0", 0)
sw_mipscale = ri.Cvar_Get ("sw_mipscale", "1", 0)
sw_reportedgeout = ri.Cvar_Get ("sw_reportedgeout", "0", 0)
sw_reportsurfout = ri.Cvar_Get ("sw_reportsurfout", "0", 0)
sw_stipplealpha = ri.Cvar_Get( "sw_stipplealpha", "0", CVAR_ARCHIVE )
sw_surfcacheoverride = ri.Cvar_Get ("sw_surfcacheoverride", "0", 0)
sw_waterwarp = ri.Cvar_Get ("sw_waterwarp", "1", 0)
sw_mode = ri.Cvar_Get( "sw_mode", "0", CVAR_ARCHIVE )

r_lefthand = ri.Cvar_Get( "hand", "0", _CVAR_USERINFO or CVAR_ARCHIVE )
r_speeds = ri.Cvar_Get ("r_speeds", "0", 0)
r_fullbright = ri.Cvar_Get ("r_fullbright", "0", 0)
r_drawentities = ri.Cvar_Get ("r_drawentities", "1", 0)
r_drawworld = ri.Cvar_Get ("r_drawworld", "1", 0)
r_dspeeds = ri.Cvar_Get ("r_dspeeds", "0", 0)
r_lightlevel = ri.Cvar_Get ("r_lightlevel", "0", 0)
r_lerpmodels = ri.Cvar_Get( "r_lerpmodels", "1", 0 )
r_novis = ri.Cvar_Get( "r_novis", "0", 0 )

vid_fullscreen = ri.Cvar_Get( "vid_fullscreen", "0", CVAR_ARCHIVE )
vid_gamma = ri.Cvar_Get( "vid_gamma", "1.0", CVAR_ARCHIVE )

 ri.Cmd_AddCommand ("modellist", @Mod_Modellist_f)
 
 ri.Cmd_AddCommand( "screenshot", @R_ScreenShot_f )
 ri.Cmd_AddCommand( "imagelist", @R_ImageList_f )

sw_mode->modified = true '// force us to do mode specific stuff later
vid_gamma->modified = true '// force us to rebuild the gamma table later

	sw_lockpvs = ri.Cvar_Get ("sw_lockpvs", "0", 0)


End Sub

'/*
'================
'R_InitTurb
'================
'*/
sub R_InitTurb ()
dim as	integer		i

for i = 0 to 1280-1
sintable(i) = AMP + sin(i*3.14159*2/CYCLE)*AMP
intsintable(i) = AMP2 + sin(i*3.14159*2/CYCLE)*AMP2	'// AMP2, not 20
blanktable(i) = 0			'//PGM

Next


End Sub






'FINISHED FOR NOW''''''''''''''''''''''''''''''''''''''''''''''''''''''
function R_init(hinstance as any ptr,wndproc as any ptr) as qboolean

'COMPLETE ADDED''''''''''''''''''''''''''''''''''''




R_InitImages ()
Mod_Init ()
Draw_InitLocal ()
R_InitTextures

R_InitTurb ()






view_clipplanes(0).leftedge = true
view_clipplanes(1).rightedge = true
view_clipplanes(1).leftedge = view_clipplanes(2).leftedge = _
	view_clipplanes(3).leftedge = false
view_clipplanes(0).rightedge = view_clipplanes(2).rightedge = _
	view_clipplanes(3).rightedge = false

r_refdef.xOrigin = XCENTERING
r_refdef.yOrigin = YCENTERING

'// TODO: collect 386-specific code in one place
'#if

'NOT SURE IF I DID THIS RIGHT
#ifdef id386
'printf(!"%i\n",cast(long,@R_EdgeCodeStart ))
'printf(!"%i\n",cast(long,@R_EdgeCodeEnd ))

 
   'print  cast(long,@R_EdgeCodeStart ) 
  ' print  cast(long,@R_EdgeCodeEnd )
   'print  cast(long,@R_EdgeCodeEnd ) - cast(long,@R_EdgeCodeStart )
   
    
    
Sys_MakeCodeWriteable (cast(long,@R_EdgeCodeStart ), _
cast(long,@R_EdgeCodeEnd ) - cast(long,@R_EdgeCodeStart ))
Sys_SetFPCW () 		'// get bit masks for FPCW	(FIXME: is this id386?)

'printf(!"%i\n",cast(long,@R_EdgeCodeStart ))
'printf(!"%i\n",cast(long,@R_EdgeCodeEnd ))
' printf(!"%i\n",cast(long,@R_EdgeCodeEnd ) - cast(long,@R_EdgeCodeStart ))


#endif	'// id386

r_aliasuvscale = 1.0

R_Register
Draw_GetPalette ()
SWimp_Init( hInstance, wndProc )



'CREATE WINDOW
R_BeginFrame( 0 )
'''''''''''''''''''''''''''''''''''''''''''''''''

ri.Con_Printf (PRINT_ALL, !"ref_soft version: " REF_VERSION !"\n")

return _true


End function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''












sub R_CinematicSetPalette( _palette as const zstring ptr  )

End Sub

sub R_setSky(_name as zstring ptr,rotate as float, axis as vec3_t)


End Sub


sub R_RenderFrame (fd as refdef_t ptr)


End Sub





'FINISHED'''''''''''''''''''''
sub R_Shutdown ()
'// free z buffer
if (d_pzbuffer) then
	free (d_pzbuffer)
	d_pzbuffer = NULL
EndIf
'// free surface cache
if (sc_base) then
	D_FlushCaches ()
	free (sc_base)
	sc_base = NULL
EndIf


'// free colormap
if (vid.colormap) then
	free (vid.colormap)
	vid.colormap = NULL
EndIf



R_UnRegister () 'FINISHED
Mod_FreeAll () 'FINISHED
R_ShutdownImages () 'FINISHED



SWimp_Shutdown() 'FINISHED


End Sub
''''''''''''''''''''''''''''''''''''''''

'/*
'** R_GammaCorrectAndSetPalette
'*/
sub R_GammaCorrectAndSetPalette( _palette as const ubyte ptr)
	dim as integer i

	for  i = 0 to 256-1
		sw_state.currentpalette(i*4+0) = sw_state.gammatable(_palette[i*4+0])
		sw_state.currentpalette(i*4+1) = sw_state.gammatable(_palette[i*4+1])
		sw_state.currentpalette(i*4+2) = sw_state.gammatable(_palette[i*4+2])

	Next


	 SWimp_SetPalette( @sw_state.currentpalette(0) )

End Sub




'/*
'** R_InitGraphics
'*/
sub R_InitGraphics(_width as integer , _height as integer )
vid._width  = _width
vid._height = _height

 'd_pzbuffer = NULL
'print @d_pzbuffer
'sleep
'// free z buffer
if ( d_pzbuffer ) then
	free( d_pzbuffer )
	d_pzbuffer = NULL
EndIf


'// free surface cache
if ( sc_base ) then
	D_FlushCaches ()
	free( sc_base )
	sc_base = NULL
EndIf


 d_pzbuffer = malloc(vid._width*vid._height*2)

R_InitCaches ()

 R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @d_8to24table(0) ) )
 'print "PASSED!!!!!!!!!!!"
End Sub


'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''

'extern declare sub Draw_BuildGammaTable()
declare sub Draw_BuildGammaTable()
sub R_BeginFrame(camera_separation as float )



'printf("d_pzbuffer %i",sizeof(d_pzbuffer)) 



'/*
'** rebuild the gamma correction palette if necessary
'*/
if ( vid_gamma->modified ) then

	Draw_BuildGammaTable()
	R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @d_8to24table(0) ))

	vid_gamma->modified = false

EndIf

 

while ( sw_mode->modified or vid_fullscreen->modified )

dim as rserr_t _err

'/*
'** if this returns rserr_invalid_fullscreen then it set the mode but not as a
'	** fullscreen mode, e.g. 320x200 on a system that doesn't support that res
'	*/

_err = SWimp_SetMode(@vid._width,@vid._height,sw_mode->value,vid_fullscreen->value)

'print vid._width
'print vid._height
'print _err
'print sw_mode->value
'print rserr_ok 
'
'sleep


if (  _err = rserr_ok ) then

R_InitGraphics( vid._width, vid._height )

sw_state.prev_mode = sw_mode->value
vid_fullscreen->modified = false
sw_mode->modified = false

else

if ( _err = rserr_invalid_mode ) then

ri.Cvar_SetValue( "sw_mode", sw_state.prev_mode )
ri.Con_Printf( PRINT_ALL, !"ref_soft::R_BeginFrame() - could not set mode\n" )

elseif ( _err = rserr_invalid_fullscreen ) then

R_InitGraphics( vid._width, vid._height )

ri.Cvar_SetValue( "vid_fullscreen", 0)
ri.Con_Printf( PRINT_ALL, !"ref_soft::R_BeginFrame() - fullscreen unavailable in this mode\n" )
sw_state.prev_mode = sw_mode->value
'//				vid_fullscreen->modified = false;
'//				sw_mode->modified = false;

else

ri.Sys_Error( ERR_FATAL, !"ref_soft::R_BeginFrame() - catastrophic mode change failure\n" )
end if
end if
wend















End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



sub R_UnRegister ()
	ri.Cmd_RemoveCommand( "screenshot" )
	ri.Cmd_RemoveCommand ("modellist")
	ri.Cmd_RemoveCommand( "imagelist" )
End Sub








extern "C"

function GetRefAPI alias "GetRefAPI" (rimp as refimport_t ) as refexport_t export

	dim re  as refexport_t


	ri = rimp

	re._api_version = API_VERSION
	re.BeginRegistration = @R_BeginRegistration
	re.RegisterModel = @R_RegisterModel
	re.RegisterSkin = @R_RegisterSkin
	re.RegisterPic = @Draw_FindPic
	re.SetSky = @R_SetSky
	re.EndRegistration = @R_EndRegistration

	re.RenderFrame = @R_RenderFrame

	re.DrawGetPicSize = @Draw_GetPicSize
	re.DrawPic = @Draw_Pic
	re.DrawStretchPic = @Draw_StretchPic
	re.DrawChar = @Draw_Char
	re.DrawTileClear = @Draw_TileClear
	re.DrawFill = @Draw_Fill
	re.DrawFadeScreen= @Draw_FadeScreen

	re.DrawStretchRaw = @Draw_StretchRaw

	re.Init = @R_Init
	re.Shutdown = @R_Shutdown

	re.CinematicSetPalette = @R_CinematicSetPalette
	re.BeginFrame = @R_BeginFrame
	re.EndFrame = @SWimp_EndFrame

	re.AppActivate = @SWimp_AppActivate

	Swap_Init ()
	return re




End Function

end extern


'/*
'================
'Draw_BuildGammaTable
'================
'*/
sub Draw_BuildGammaTable ()



	dim as integer		i, inf
	dim as float	g

	g = vid_gamma->value

	if (g = 1.0) then

		for i = 0 to 256-1
			sw_state.gammatable(i) = i
		next
		return
	end if

	for i = 0 to 256-1
		inf = 255 * pow ( (i+0.5)/255.5 , g ) + 0.5
		if (inf < 0) then
			inf = 0
		EndIf

		if (inf > 255) then
			inf = 255
		EndIf

		sw_state.gammatable(i) = inf
							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  								  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  							  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  						  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  					  	  		  	  			  	  		  	  				  	  		  	  			  	  		  	  									Next

End Sub
#ifndef REF_HARD_LINKED



'FINISHED
sub Com_Printf CDecl (fmt as zstring ptr,...)
	dim argptr as cva_list
	
	dim text as zstring * 1024
	
	 
	 cva_start(argptr,fmt)
	 vsprintf (text, fmt, argptr)
	 cva_end(argptr)
	 
	 ri.Con_Printf (PRINT_ALL, "%s", text)
	 
End Sub


'
''FINISHED
sub sys_error CDecl (_error as zstring ptr,...)
	dim argptr as cva_list
	
	dim text as zstring * 1024
	
	 
	 cva_start(argptr,_error)
	 vsprintf (text, _error, argptr)
	 cva_end(argptr)
	 
	
	 ri.Sys_Error (ERR_FATAL, "%s", text) 
	 
End Sub

 #endif



  
'sleep 