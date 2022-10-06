'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''

 

#ifdef __FB_WIN32__
#include  "windows.bi"
#endif


#include "crt\stdio.bi"

#include "gl\gl.bi"
#include "gl\glu.bi"
#include "crt\math.bi"


#ifndef __linux__
#ifndef GL_COLOR_INDEX8_EXT
#define GL_COLOR_INDEX8_EXT GL_COLOR_INDEX
#endif
#endif


'temporary fixes
 type image_s_ as image_s
 type model_s_ as model_s	
 	
 
'FINISHED FOR NOW
'''''''''''''''''''''''''''''''
#include "client\ref.bi"

'''''''''''''''''''''''''''''''


#include "qgl.bi"






#define	REF_VERSION	"GL 0.01"


#define	PITCH				0		
#define	YAW				1		
#define	ROLL				2	

#ifndef __VIDDEF_T
#define __VIDDEF_T
type viddef_t
	
	as uinteger _width, _height 
	
End Type
#endif


extern vid as viddef_t


 enum imagetype_t
   it_skin,
	it_sprite,
	it_wall,
	it_pic,
	it_sky
 End Enum
 
 
' print it_sky
 
 'temporary fix
 type msurface_s_ as msurface_s
 
 type image_s
	 _name as zstring * MAX_QPATH 
	_type as imagetype_t
	as integer _width, _height 
	as integer upload_width, upload_height 
   registration_sequence as integer ptr		
 	texturechain as msurface_s_ ptr
   texnum  as Integer
	as float	_sl, _tl, _sh, _th 
	scrap as qboolean	 
	has_alpha  as qboolean
	paletted as qboolean
	
	pic_d(3) as ubyte ptr
	pal_d as UByte ptr
	
	
end Type:  type image_t as  image_s
 
 
 
#define	TEXNUM_LIGHTMAPS	1024
#define	TEXNUM_SCRAPS		1152
#define	TEXNUM_IMAGES		1153

#define	MAX_GLTEXTURES	1024


enum rserr_t
	rserr_ok,

	rserr_invalid_fullscreen,
	rserr_invalid_mode,

	rserr_unknown


End Enum
 

 

 
#include "gl_model.bi"

declare sub GL_BeginRendering (x as integer ptr, y as integer ptr,w  as integer ptr,h  as integer ptr) 
declare sub GL_EndRendering ()



declare sub GL_SetDefaultState() 
declare sub GL_UpdateSwapInterval()

extern as float	gldepthmin, gldepthmax 

type  glvert_t 
	
	as float	x, y, z 
	as float	s, t 
	as float	r, g, b 

End Type
 
#define	MAX_LBM_HEIGHT		480

#define BACKFACE_EPSILON	0.01
 
extern   r_notexture as image_t	ptr	
extern	r_particletexture  as  image_t ptr 
extern	currententity as entity_t	ptr
extern	currentmodel as model_t	ptr	
extern	r_visframecount as integer	
extern	r_framecount 	as integer		
extern	frustum(4) as cplane_t	
extern	as integer			c_brush_polys, c_alias_polys


extern	as integer			gl_filter_min, gl_filter_max

'not fixed''''''''''''''''''
extern vup as vec3_t
extern vpn as vec3_t
extern vright as vec3_t	
extern r_origin as vec3_t
''''''''''''''''''

extern  r_newrefdef as refdef_t	
extern as integer	r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2

extern r_norefresh as cvar_t ptr
extern r_lefthand as cvar_t ptr
extern r_drawentities as cvar_t ptr
extern r_drawworld as cvar_t ptr
extern r_speeds as cvar_t ptr
extern r_fullbright as cvar_t ptr
extern r_novis as cvar_t ptr
extern r_nocull as cvar_t ptr
extern r_lerpmodels as cvar_t ptr

extern  r_lightlevel as cvar_t ptr

extern  gl_vertex_arrays as cvar_t ptr

extern gl_ext_swapinterval as cvar_t ptr
extern gl_ext_palettedtexture as cvar_t ptr
extern gl_ext_multitexture as cvar_t ptr
extern gl_ext_pointparameters as cvar_t ptr
extern gl_ext_compiled_vertex_array as cvar_t ptr

extern  gl_particle_min_size as cvar_t ptr
extern  gl_particle_max_size as cvar_t ptr
extern  gl_particle_size as cvar_t ptr
extern  gl_particle_att_a as cvar_t ptr
extern  gl_particle_att_b as cvar_t ptr
extern  gl_particle_att_c as cvar_t ptr

extern gl_nosubimage as cvar_t ptr
extern gl_bitdepth as cvar_t ptr
extern gl_mode as cvar_t ptr
extern gl_log as cvar_t ptr
extern gl_lightmap as cvar_t ptr
extern gl_shadows as cvar_t ptr
extern gl_dynamic as cvar_t ptr
extern gl_monolightmap as cvar_t ptr
extern gl_nobind as cvar_t ptr
extern gl_round_down as cvar_t ptr
extern gl_picmip as cvar_t ptr
extern gl_skymip as cvar_t ptr
extern gl_showtris as cvar_t ptr	
extern gl_finish as cvar_t ptr
extern gl_ztrick as cvar_t ptr
extern _gl_clear as cvar_t ptr
extern gl_cull as cvar_t ptr
extern gl_poly as cvar_t ptr
extern gl_texsort as cvar_t ptr
extern gl_polyblend as cvar_t ptr
extern gl_flashblend as cvar_t ptr
extern gl_lightmaptype as cvar_t ptr
extern _gl_modulate as cvar_t ptr
extern gl_playermip as cvar_t ptr
extern gl_drawbuffer as cvar_t ptr
extern gl_3dlabs_broken as cvar_t ptr
extern gl_driver as cvar_t ptr
extern gl_swapinterval as cvar_t ptr
extern _gl_texturemode as cvar_t ptr
extern _gl_texturealphamode as cvar_t ptr
extern _gl_texturesolidmode as cvar_t ptr
extern gl_saturatelighting as cvar_t ptr
extern gl_lockpvs as cvar_t ptr	

extern vid_fullscreen as cvar_t ptr
extern vid_gamma as cvar_t ptr

extern intensity as cvar_t ptr

extern gl_lightmap_format as Integer
extern gl_solid_format as Integer
extern gl_alpha_format as Integer
extern gl_tex_solid_format as Integer
extern gl_tex_alpha_format as Integer

extern c_visible_lightmaps as Integer
extern c_visible_textures as Integer

extern r_world_matrix(16) as float

declare sub R_TranslatePlayerSkin (playernum as Integer) 
declare sub GL_Bind (texnum as integer ) 
declare sub GL_MBind(_target as GLenum ,texnum as integer  ) 
declare sub GL_TexEnv(value as GLenum ) 
declare sub GL_EnableMultitexture(enable as qboolean  ) 
declare sub GL_SelectTexture(as GLenum ) 

declare sub R_LightPoint ( p as vec3_t, _color as vec3_t) 
declare sub R_PushDlights () 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

extern	r_worldmodel as model_t ptr

extern	d_8to24table(256) as uinteger

extern	registration_sequence as integer		

declare sub V_AddBlend ( r as float,g as float , b as float,a as float ,v_blend as float ptr)

declare sub R_Init(hinstance as any ptr, hwnd as any ptr)
declare sub R_Shutdown()


declare sub  R_RenderView (fd as refdef_t  ptr) 
declare sub GL_ScreenShot_f () 
declare sub R_DrawAliasModel (e as entity_t ptr) 
declare sub R_DrawBrushModel (e as entity_t ptr) 
declare sub R_DrawSpriteModel (e as entity_t  ptr)  
declare sub R_DrawBeam(e as entity_t  ptr ) 
declare sub _R_DrawWorld ()
declare sub R_RenderDlights () 
declare sub R_DrawAlphaSurfaces ()
declare sub R_RenderBrushPoly (fa as msurface_t ptr) 
declare sub R_InitParticleTexture ()
declare sub Draw_InitLocal ()
declare sub GL_SubdivideSurface (fa as msurface_t ptr) 
declare function R_CullBox (mins as vec3_t ,maxs as vec3_t ) as qboolean 
declare sub R_RotateForEntity (e as entity_t ptr ) 
declare sub R_MarkLeaves () 
 
declare function WaterWarpPolyVerts (p as glpoly_t ptr) as glpoly_t ptr
declare sub EmitWaterPolys (fa as msurface_t ptr) 
declare sub R_AddSkySurface (fa as msurface_t ptr) 
declare sub R_ClearSkyBox () 
declare sub  R_DrawSkyBox ()
declare sub R_MarkLights (light as dlight_t ptr,_bit as integer ,node as mnode_t ptr) 

#if 0
declare function LittleShort (l as short ) as short 
declare function  BigShort (l as short ) as short  
declare function LittleLong (l as integer ) as integer
declare function  LittleFloat (l as float ) as float  

 
declare  function va cdecl (_format as ZString ptr, ...) as ZString ptr 

 
#endif


declare sub	 COM_StripExtension (_in as ZString ptr, _out  as ZString ptr) 
 
declare sub	 Draw_GetPicSize (w as Integer ptr, h  as Integer ptr, _name as ZString ptr) 
declare sub  Draw_Pic (x as integer ,y as integer ,_name as  ZString ptr) 
declare sub  Draw_StretchPic (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
declare sub  Draw_Char (x as integer, y as integer, c as integer) 
declare sub  Draw_TileClear (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
declare sub  Draw_Fill (x as integer, y as integer,w  as integer,h  as integer,c as integer ) 
declare sub	 Draw_FadeScreen () 
declare sub	 Draw_StretchRaw ( x as integer, y as integer,w  as integer,h  as integer,cols as integer, rows  as integer,_data as ubyte ptr) 
declare sub	R_BeginFrame( camera_separation as float) 
declare sub	R_SwapBuffers(as integer ) 
declare sub R_SetPalette ( _palette as const ZString ptr) 
 
declare function Draw_GetPalette () as Integer
 
declare sub GL_ResampleTexture ( _in as UInteger ptr,inwidth as integer , inheight as integer,_out as UInteger ptr,outwidth as  integer ,outheight as integer )
 
declare function R_RegisterSkin (_name as ZString ptr ) as image_s ptr
 
declare sub	LoadPCX (filename as ZString ptr, _pic as ubyte ptr ptr, _palette as ubyte ptr ptr ,_width as integer ptr, _height as integer ptr) 
declare function GL_LoadPic ( _name as zstring ptr, pic as ubyte ptr,_width as integer ,_height  as integer , _type as  imagetype_t, _bits as Integer) as image_t ptr
declare function GL_FindImage (_name as zstring ptr,_type as imagetype_t ) as image_t ptr
declare sub GL_TextureMode(  _string as ZString ptr )
declare sub GL_ImageList_f () 

declare sub	GL_SetTexturePalette( _palette() as UInteger ) 

declare sub GL_InitImages()
declare sub GL_ShutdownImages()
 
declare sub GL_FreeUnusedImages () 

declare sub GL_TextureAlphaMode(  _string as ZString ptr )
declare sub GL_TextureSolidMode(  _string as ZString ptr )


declare sub GL_DrawParticles(n as integer ,particles() as  const particle_t , colortable() as const uinteger ) 

#define GL_RENDERER_VOODOO		&H00000001
#define GL_RENDERER_VOODOO2   	&H00000002
#define GL_RENDERER_VOODOO_RUSH	&H00000004
#define GL_RENDERER_BANSHEE		&H00000008
#define GL_RENDERER_3DFX		&H0000000F

#define GL_RENDERER_PCX1		&H00000010
#define GL_RENDERER_PCX2		&H00000020
#define GL_RENDERER_PMX			&H00000040
#define GL_RENDERER_POWERVR		&H00000070

#define GL_RENDERER_PERMEDIA2	&H00000100
#define GL_RENDERER_GLINT_MX	&H00000200
#define GL_RENDERER_GLINT_TX	&H00000400
#define GL_RENDERER_3DLABS_MISC	&H00000800
#define GL_RENDERER_3DLABS	&H00000F00

#define GL_RENDERER_REALIZM		&H00001000
#define GL_RENDERER_REALIZM2		&H00002000
#define GL_RENDERER_INTERGRAPH	&H00003000

#define GL_RENDERER_3DPRO		&H00004000
#define GL_RENDERER_REAL3D		&H00008000
#define GL_RENDERER_RIVA128		&H00010000
#define GL_RENDERER_DYPIC		&H00020000

#define GL_RENDERER_V1000		&H00040000
#define GL_RENDERER_V2100		&H00080000
#define GL_RENDERER_V2200		&H00100000
#define GL_RENDERER_RENDITION	&H001C0000

#define GL_RENDERER_O2          &H00100000
#define GL_RENDERER_IMPACT      &H00200000
#define GL_RENDERER_RE			&H00400000
#define GL_RENDERER_IR			&H00800000
#define GL_RENDERER_SGI			&H00F00000

#define GL_RENDERER_MCD			&H01000000
#define GL_RENDERER_OTHER		&H80000000


extern	ri as refimport_t	


 type glconfig_t 
 
	renderer as integer
	renderer_string as const string 
	 vendor_string as const string 
	version_string as const string  
	 extensions_string as const string 

	allow_cds as qboolean 
 end type
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
type glstate_t
 
   inverse_intensity	as float 
	fullscreen as qboolean 

   prev_mode as integer      

	d_16to8table as ubyte ptr

   lightmap_textures	as integer  

	currenttextures(2)	as integer 
	currenttmu	as integer 

   camera_separation as float
	stereo_enabled  as qboolean 

	  originalRedGammaTable(256)  as UByte
	  originalGreenGammaTable(256) as UByte 
	  originalBlueGammaTable(256) as UByte
end type

extern  gl_config  as glconfig_t
extern gl_state as  glstate_t   




'#Include "win32\winquake.bi"



extern		ri as refimport_t

 
 
  




declare sub GLimp_BeginFrame(camera_separation as float)
declare sub GLimp_EndFrame() 
declare function GLimp_Init(hinstance as any ptr,hWnd as any ptr) as integer
declare sub  GLimp_Shutdown() 
declare function GLimp_SetMode(pwidth as integer ptr, pheight as integer ptr,_mode as integer ptr , fullscreen as qboolean)  as integer
declare sub  GLimp_AppActivate(active as qboolean) 
declare sub  GLimp_EnableLogging(enable as qboolean )
declare sub  GLimp_LogNewFrame()





