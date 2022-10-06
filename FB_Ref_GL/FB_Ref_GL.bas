'WORK IN PROGRESS''''''''''''''''''''''''''''''''''''''

#include "gl_local.bi"


'
'
declare sub R_Clear()

dim shared vid as viddef_t
'
 dim shared	ri as refimport_t
'
dim as integer GL_TEXTURE0, GL_TEXTURE1 

dim shared  r_worldmodel as model_t	ptr	

dim shared as float gldepthmin, gldepthmax 
'
 dim shared gl_config as glconfig_t
 dim shared gl_state as  glstate_t  
'
'
 dim shared r_notexture as image_t ptr	
 dim shared r_particletexture as image_t ptr	
 
 	
''
dim shared currententity as entity_t ptr	
dim shared currentmodel as model_t ptr	

dim shared frustrum(4) as cplane_t

dim shared r_visframecount as Integer
dim shared r_framecount as Integer 

dim shared as integer c_brush_polys, c_alias_polys 

dim shared v_blend(4) as float 

declare sub GL_Strings_f()

dim shared vup as vec3_t
dim shared vpn as vec3_t
dim shared vright as vec3_t	
dim shared r_origin as vec3_t	
'
dim shared r_world_matrix(16) as float 
dim shared r_base_world_matrix(16) as float	 

dim shared  r_newrefdef as refdef_t	

dim shared as integer	r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2

dim shared r_norefresh as cvar_t ptr
dim shared r_drawentities as cvar_t ptr
dim shared r_drawworld as cvar_t ptr
dim shared r_speeds as cvar_t ptr
dim shared r_fullbright as cvar_t ptr
dim shared r_novis as cvar_t ptr
dim shared r_nocull as cvar_t ptr
dim shared r_lerpmodels as cvar_t ptr
dim shared  r_lefthand as cvar_t ptr

dim shared  r_lightlevel as cvar_t ptr

dim shared  gl_nosubimage as cvar_t ptr
dim shared  gl_allow_software as cvar_t ptr

dim shared  gl_vertex_arrays as cvar_t ptr

dim shared  gl_particle_min_size as cvar_t ptr
dim shared  gl_particle_max_size as cvar_t ptr
dim shared  gl_particle_size as cvar_t ptr
dim shared  gl_particle_att_a as cvar_t ptr
dim shared  gl_particle_att_b as cvar_t ptr
dim shared  gl_particle_att_c as cvar_t ptr

dim shared gl_ext_swapinterval as cvar_t ptr
dim shared gl_ext_palettedtexture as cvar_t ptr
dim shared gl_ext_multitexture as cvar_t ptr
dim shared gl_ext_pointparameters as cvar_t ptr
dim shared gl_ext_compiled_vertex_array as cvar_t ptr

dim shared gl_log as cvar_t ptr
dim shared gl_bitdepth as cvar_t ptr
dim shared gl_drawbuffer as cvar_t ptr
dim shared gl_driver as cvar_t ptr
dim shared gl_lightmap as cvar_t ptr
dim shared gl_shadows as cvar_t ptr
dim shared gl_mode as cvar_t ptr
dim shared gl_dynamic as cvar_t ptr
dim shared gl_monolightmap as cvar_t ptr
dim shared _gl_modulate as cvar_t ptr
dim shared gl_nobind as cvar_t ptr
dim shared gl_round_down as cvar_t ptr
dim shared gl_picmip as cvar_t ptr	
dim shared gl_skymip as cvar_t ptr
dim shared gl_showtris as cvar_t ptr	
dim shared gl_ztrick as cvar_t ptr	
dim shared gl_finish as cvar_t ptr	
dim shared _gl_clear as cvar_t ptr
dim shared gl_cull as cvar_t ptr
dim shared gl_polyblend as cvar_t ptr
dim shared gl_flashblend as cvar_t ptr
dim shared gl_playermip as cvar_t ptr

dim shared gl_saturatelighting as cvar_t ptr
dim shared gl_swapinterval as cvar_t ptr
dim shared _gl_texturemode as cvar_t ptr
dim shared _gl_texturealphamode as cvar_t ptr
dim shared _gl_texturesolidmode as cvar_t ptr
dim shared gl_lockpvs as cvar_t ptr


dim shared gl_3dlabs_broken as cvar_t ptr

dim shared vid_fullscreen as cvar_t ptr
dim shared vid_gamma as cvar_t ptr
dim shared vid_ref as cvar_t ptr
 
#define	PITCH				0		 
#define	YAW					1		 
#define	ROLL				2		 

#define	MAX_STRING_CHARS	1024	 
#define	MAX_STRING_TOKENS	80		 
#define	MAX_TOKEN_CHARS		128		 

#define	MAX_QPATH			64		 
#define	MAX_OSPATH			128		 

 
#define	MAX_CLIENTS			256		 
#define	MAX_EDICTS			1024 
#define	MAX_LIGHTSTYLES		256
#define	MAX_MODELS			256		 
#define	MAX_SOUNDS			256	 
#define	MAX_IMAGES			256
#define	MAX_ITEMS			256
#define MAX_GENERAL			(MAX_CLIENTS*2)	 

 
#define	PRINT_LOW			0		 
#define	PRINT_MEDIUM		1		 
#define	PRINT_HIGH			2		 
#define	PRINT_CHAT			3		 


#define	ERR_FATAL			0		 
#define	ERR_DROP			1		 
#define	ERR_DISCONNECT		2		 

#define PRINT_ALL			0
#define PRINT_DEVELOPER		1		 
#define PRINT_ALERT			2		

' 
''not sure....''''''''''''''''''''''
function R_CullBox(mins as vec3_t,maxs as vec3_t) as qboolean
	dim i as Integer
	
	if r_nocull->value then
		return _false 
	EndIf
	
	for i = 0 to 4-1
		
'		if BOX_ON_PLANE_SIDE(mins,maxs,@frustrum(i)) = 2 then
	'		return _false	
	'	EndIf
		
	Next
	
	return _false
	
	
End function
''''''''''''''''''''''''''''''''
'
declare sub R_BeginRegistration (_map as ZString ptr)
declare function R_RegisterModel (_name as ZString) as model_s ptr
'declare function R_RegisterSkin (_name as ZString) as image_s
declare sub R_SetSky (_name as ZString ptr,rotate as float , axis as  vec3_t) 
declare sub	R_EndRegistration () 

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
''declare sub Draw_FadeScreen () 
'
'
''''''''''''''''''''''''''''
'
'
'
'
'
'
'
'
'
''''''''''''''''''''''''''''
sub R_Shutdown ()
	ri.Cmd_RemoveCommand ("modellist") 
	ri.Cmd_RemoveCommand ("screenshot") 
	ri.Cmd_RemoveCommand ("imagelist") 
	ri.Cmd_RemoveCommand ("gl_strings") 

Mod_FreeAll ()

'GL_ShutdownImages ()

'GLimp_Shutdown()


'QGL_Shutdown()




End Sub
 
'
'
'
'
'
'
function GetRefAPI(rimp as refimport_t) as refexport_t Export

	dim re as refexport_t

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

	re.CinematicSetPalette = @R_SetPalette
	re.BeginFrame = @R_BeginFrame
	re.EndFrame = @GLimp_EndFrame

	re.AppActivate = @GLimp_AppActivate


	
End Function

sub R_DrawBeam( e as entity_t ptr )
 
#define NUM_BEAM_SEGS 6

   dim	 i as Integer
	dim as float r, g, b 

	dim as vec3_t perpvec(3) 
	dim as vec3_t direction(3), normalized_direction (3)
	dim as vec3_t	start_points(NUM_BEAM_SEGS), end_points(NUM_BEAM_SEGS)
	dim as vec3_t oldorigin(3), origin(3)

	*cast(float ptr,@oldorigin(0)) = e->oldorigin(0)
	*cast(float ptr,@oldorigin(1))  = e->oldorigin(1)
	*cast(float ptr,@oldorigin(2)) = e->oldorigin(2) 

	*cast(float ptr,@origin(0)) = e->origin(0)
	*cast(float ptr,@origin(1)) = e->origin(1)
	*cast(float ptr,@origin(2)) = e->origin(2)



	 *cast(float ptr,@direction(0))= *cast(float ptr,@oldorigin(0)) - *cast(float ptr,@origin(0))
    *cast(float ptr,@normalized_direction(0)) = *cast(float ptr,@direction(0))

	 *cast(float ptr,@direction(1))= *cast(float ptr,@oldorigin(1)) - *cast(float ptr,@origin(1))
    *cast(float ptr,@normalized_direction(1)) = *cast(float ptr,@direction(1))

 	 *cast(float ptr,@direction(2))= *cast(float ptr,@oldorigin(2)) - *cast(float ptr,@origin(2))
    *cast(float ptr,@normalized_direction(2)) = *cast(float ptr,@direction(2))



	 if ( VectorNormalize( normalized_direction() )  = 0 ) then
	 	return 
	 EndIf
	 	
	 	

	 PerpendicularVector( perpvec(), normalized_direction() ) 
	 VectorScale( perpvec(), e->frame / 2, perpvec() ) 

	'for ( i = 0; i < 6; i++ )
	'{
'		RotatePointAroundVector( start_points[i], normalized_direction, perpvec, (360.0/NUM_BEAM_SEGS)*i );
	'	VectorAdd( start_points[i], origin, start_points[i] );
	'	VectorAdd( start_points[i], direction, end_points[i] );
	'}

	 'qglDisable( GL_TEXTURE_2D ) 
	' qglEnable( GL_BLEND ) 
	 
	 
	 	glEnable( GL_TEXTURE_2D )
	glDisable( GL_BLEND  ) 
	
	
	'qglDepthMask( GLfalse );

	'r = ( d_8to24table[e->skinnum & &HFF] ) & &HFF;
	'g = ( d_8to24table[e->skinnum & &HFF] >> 8 ) & &HFF;
	'b = ( d_8to24table[e->skinnum & &HFF] >> 16 ) & &HFF;

	r *= 1/255.0F 
	g *= 1/255.0F 
	b *= 1/255.0F 

	 'qglColor4f( r, g, b, e->alpha_ ) 
    glColor4f( r, g, b, e->alpha_ ) 
	'qglBegin( GL_TRIANGLE_STRIP )
	 glBegin( GL_TRIANGLE_STRIP )
	 
	'for ( i = 0; i < NUM_BEAM_SEGS; i++ )
	'{
		'qglVertex3fv( start_points[i]  
		'qglVertex3fv( end_points[i] );
		'qglVertex3fv( start_points[(i+1)%NUM_BEAM_SEGS] ) 
		'qglVertex3fv( end_points[(i+1)%NUM_BEAM_SEGS] ) 
	'}
	' qglEnd() 

	'qglEnable( GL_TEXTURE_2D ) 
	'qglDisable( GL_BLEND  ) 
	
	glEnable( GL_TEXTURE_2D )
	glDisable( GL_BLEND  ) 
	
'	qglDepthMask( GLfalse ) 
end sub

'finished''''''''''''''''''''''''''''''''''''''''''''''''''''''
sub R_RotateForEntity (e as entity_t ptr)
     'qglTranslatef (e->origin(0),  e->origin(1),  e->origin(2))
     'qglRotatef (e->angles(1),  0, 0, 1) 
     'qglRotatef (-e->angles(0),  0, 1, 0) 
     'qglRotatef (-e->angles(2),  1, 0, 0) 
     '
     
     
     glTranslatef (e->origin(0),  e->origin(1),  e->origin(2))
     glRotatef (e->angles(1),  0, 0, 1) 
     glRotatef (-e->angles(0),  0, 1, 0) 
     glRotatef (-e->angles(2),  1, 0, 0) 
     
     
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

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

