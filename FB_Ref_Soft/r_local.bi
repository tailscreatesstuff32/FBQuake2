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
'*/
'  
'#include "crt/stdio.bi" 
'#include "crt/stdlib.bi"
'#include  string.bi 
'#include <math.h>
'#include <stdarg.h>

 
'MIGHT BE FINISHED FOR NOW'''''''''''''''''''''''''''''''''''

  
 

#ifdef __FB_WIN32__
#include  "windows.bi"
#endif


#include "crt\stdio.bi"
#include "crt\math.bi"
#include "string.bi" 

#ifndef __linux__
#ifndef GL_COLOR_INDEX8_EXT
#define GL_COLOR_INDEX8_EXT GL_COLOR_INDEX
#endif
#endif


 
 
 extern	registration_sequence as integer	
 
 

extern as integer	r_dlightframecount

 
#Include "client\ref.bi" 


#define REF_VERSION     "SOFT 0.01"

''// up / down
'#define PITCH   0
'
''// left / right
'#define YAW             1
'
''// fall over
'#define ROLL    2


'''/*
''
'''  skins will be outline flood filled and mip mapped
'''  pics and sprites with alpha will be outline flood filled
'''  pic won't be mip mapped
'''
'''  model skin
'''  sprite frame
'''  wall texture
'''  pic
'''
'''*/
''
enum imagetype_t 
	it_skin,
	it_sprite,
	it_wall,
	it_pic,
	it_sky
End Enum

''
''
'' 
''
 type image_s_
	 _name as zstring * MAX_QPATH 
	_type as imagetype_t
	as integer _width, _height 
	transparent as qboolean
   registration_sequence as integer ptr
   pixels(4) as ubyte ptr
   
 end Type:  type image_t as  image_s


'//===================================================================

type pixel_t as zstring ptr

 

type vrect_s
		as integer x,y,_width,_height 
      pnext as vrect_s ptr
 
End Type:type  vrect_t as  vrect_s 
 
extern "C"
extern colormap as any ptr  
end extern


type viddef_t
	as pixel_t ptr          buffer               '  // invisible buffer'
	as pixel_t ptr          colormap              '// 256 * VID_GRADES size
	as pixel_t ptr          alphamap               '// 256 * 256 translucency map
	as integer              rowbytes                '// may be > width if displayed in a window
									                       '// can be negative for stupid dibs
	as integer 					_width           
	as integer 					_height 
 
End Type



 enum rserr_t
   rserr_ok, 

   rserr_invalid_fullscreen,
   rserr_invalid_mode,
 
   rserr_unknown
 End Enum
 

 
 
 extern vid as viddef_t 
 
'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type oldrefdef_t
	
	as vrect_t         vrect                       '   // subwindow in video for refresh'
																		'// FIXME: not need vrect next field here?
	as vrect_t         aliasvrect                          ' // scaled Alias version
	as integer          vrectright, vrectbottom         '// right & bottom screen coords
	as integer           aliasvrectright, aliasvrectbottom       '// scaled Alias versions
	as float           vrectrightedge                              '   // rightmost right edge we care about,
										                                    '//  for use in edge list
	as float           fvrectx, fvrecty               '// for floating-point compares
	as float           fvrectx_adj, fvrecty_adj           '// left and top edges, for clamping
	as integer                     vrect_x_adj_shift20     '// (vrect.x + 0.5 - epsilon) << 20
	as integer                     vrectright_adj_shift20    '// (vrectright + 0.5 - epsilon) << 20
	as float           fvrectright_adj, fvrectbottom_adj 
										                         '// right and bottom edges, for clamping
	as float           fvrectright                     '// rightmost edge, for Alias clamping
	as float           fvrectbottom                  ' // bottommost edge, for Alias clamping
	as float           horizontalFieldOfView           '// at Z = 1.0, this many X is visible 
										'                     // 2.0 = 90 degrees
	as float           xOrigin                        '// should probably always be 0.5
	as float           yOrigin                                  ' // between be around 0.3 to 0.5
 
	as vec3_t         vieworg 
	as vec3_t         viewangles 
	
	as integer  ambientlight 
 
	
End Type





 extern "C"
 extern r_refdef as oldrefdef_t  
 end extern
     




#Include "FB_Ref_Soft\r_model.bi"


#define CACHE_SIZE      32


'/*
'====================================================
'
'  CONSTANTS
'
'====================================================
'*/

#define VID_CBITS       6
#define VID_GRADES      (1 shl VID_CBITS)
'// r_shared.h: general refresh-related stuff shared between the refresh and the
'// driver


#define MAXVERTS        64              '// max points in a surface polygon
#define MAXWORKINGVERTS (MAXVERTS+4)   ' // max points in an intermediate
										          '//  polygon (while processing)
'// !!! if this is changed, it must be changed in d_ifacea.h too !!!
#define MAXHEIGHT       1200
#define MAXWIDTH        1600

#define INFINITE_DISTANCE       &H10000        ' // distance that's always guaranteed to
										'//  be farther away than anything in
										'//  the scene


'// d_iface.h: interface header file for rasterization driver modules

#define WARP_WIDTH              320
#define WARP_HEIGHT             240

#define MAX_LBM_HEIGHT  480


#define PARTICLE_Z_CLIP 8.0

'// !!! must be kept the same as in quakeasm.h !!!
#define TRANSPARENT_COLOR       &HFF


'// !!! if this is changed, it must be changed in d_ifacea.h too !!!
#define TURB_TEX_SIZE   64             ' // base turbulent texture size

'// !!! if this is changed, it must be changed in d_ifacea.h too !!!
#define CYCLE                   128             '// turbulent cycle size

#define SCANBUFFERPAD           &H1000

#define DS_SPAN_LIST_END        -128

#define NUMSTACKEDGES           2000
#define MINEDGES                        NUMSTACKEDGES
#define NUMSTACKSURFACES        1000
#define MINSURFACES                     NUMSTACKSURFACES
#define MAXSPANS                        3000

'// flags in finalvert_t.flags
#define ALIAS_LEFT_CLIP                         &H0001
#define ALIAS_TOP_CLIP                          &H0002
#define ALIAS_RIGHT_CLIP                        &H0004
#define ALIAS_BOTTOM_CLIP                       &H0008
#define ALIAS_Z_CLIP                            &H0010
#define ALIAS_XY_CLIP_MASK                      &H000F

#define SURFCACHE_SIZE_AT_320X240    1024*768

#define BMODEL_FULLY_CLIPPED    &H10 '// value returned by R_BmodelCheckBBox ()
									 '//  if bbox is trivially rejected

#define XCENTERING      (1.0 / 2.0)
#define YCENTERING      (1.0 / 2.0)

#define CLIP_EPSILON            0.001

#define BACKFACE_EPSILON        0.01

'// !!! if this is changed, it must be changed in asm_draw.h too !!!
#define NEAR_CLIP       0.01


#define MAXALIASVERTS           2000   ' // TODO: tune this
#define ALIAS_Z_CLIP_PLANE      4

'// turbulence stuff

#define AMP             8*&H10000
#define AMP2    3
#define SPEED   20


declare sub R_SetupFrame ()

'/*
'====================================================
'
'TYPES
'
'====================================================
'*/

type emitpoint_t
	as float   u, v 
	as float   s, t 
	as float   zi 
End Type

'/*
'** if you change this structure be sure to change the #defines
'** listed after it!
'*/
#define SMALL_FINALVERT 0

#if SMALL_FINALVERT

type  finalvert_s 
	as short           u, v, s, t 
	as integer         l 
	as integer         zi 
	as integer         flags 
	as float           xyz(3) '// eye space
End Type: type finalvert_t as finalvert_s 



#define FINALVERT_V0     0
#define FINALVERT_V1     2
#define FINALVERT_V2     4
#define FINALVERT_V3     6
#define FINALVERT_V4     8
#define FINALVERT_V5    12
#define FINALVERT_FLAGS 16
#define FINALVERT_X     20
#define FINALVERT_Y     24
#define FINALVERT_Z     28
#define FINALVERT_SIZE  32


#else


type  finalvert_s 
	as short           u, v, s, t 
	as integer         l 
	as integer         zi 
	as integer         flags 
	as float           xyz(3) '// eye space
End Type: type finalvert_t as finalvert_s 


#define FINALVERT_V0     0
#define FINALVERT_V1     4
#define FINALVERT_V2     8
#define FINALVERT_V3    12
#define FINALVERT_V4    16
#define FINALVERT_V5    20
#define FINALVERT_FLAGS 24
#define FINALVERT_X     28
#define FINALVERT_Y     32
#define FINALVERT_Z     36
#define FINALVERT_SIZE  40

#endif



type affinetridesc_t
 
	as any ptr                          pskin 
	as integer                          pskindesc 
	as integer                          skinwidth 
	as integer                          skinheight 
	as dtriangle_t ptr                  ptriangles 
	as finalvert_t ptr                  pfinalverts 
	as integer                          numtriangles 
	as integer                          drawtype 
	as integer                          seamfixupX16 
	as qboolean                         do_vis_thresh 
	as integer                          vis_thresh 
end type

type drawsurf_t
 
	as ubyte ptr            surfdat                '// destination for generated surface
	as integer              rowbytes               ' // destination logical width in bytes
	as msurface_t ptr       surf                    '// description for surface to generate
	as fixed8_t             lightadj(MAXLIGHTMAPS) 
							                      '// adjust for lightmap levels for dynamic lighting
	as image_t ptr			   _image 
	as integer              surfmip        '// mipmapped ratio of surface texels / world pixels
	as integer              surfwidth       '// in mipmapped texels
	as integer              surfheight      '// in mipmapped texels
 
end type


type alight_t
   as integer           ambientlight 
	as integer           shadelight 
	as float  ptr        plightvec 
 
	
End Type


'// clipped bmodel edges

type bedge_s
	as mvertex_t  v(2) 
	as bedge_s ptr  bepnext 
End Type:type bedge_t as  bedge_s
 
 
'
'// !!! if this is changed, it must be changed in asm_draw.h too !!!
 type clipplane_s
 
	as vec3_t          normal 
	as float           dist 
   as clipplane_s ptr _next 
	as ubyte            leftedge 
	as ubyte            rightedge 
	as ubyte             reserved(2)
 End Type:type clipplane_t as clipplane_s


type surfcache_s_
 
	as  surfcache_s ptr      _next 
	as surfcache_s ptr ptr   owner                '// NULL is an empty chunk of memory
	as integer               lightadj(MAXLIGHTMAPS) '// checked for strobe flush
	as integer               dlight 
	as integer               size            '// including header
	as UInteger                _width 
	as UInteger                _height          '// DEBUG only needed for debug
	as float                 mipscale 
	as image_t ptr           _image 
	as ubyte                 _data(4)        '// width*height elements
end type: type surfcache_t as surfcache_s

'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type  espan_s
 
	as integer                             u, v, count 
	as espan_s ptr pnext 
end type: type espan_t as espan_s 

'// used by the polygon drawer (R_POLY.C) and sprite setup code (R_SPRITE.C)
type polydesc_t
	as integer          nump 
	as emitpoint_t ptr  pverts 
	as ubyte ptr        pixels                        ' // image
	as integer          pixel_width            '// image width
	as integer          pixel_height        '// image height
	as vec3_t           vup, vright, vpn        '// in worldspace, for plane eq
	as float            dist 
	as float            s_offset, t_offset 
	as float            viewer_position(3)
	drawspanlet         as     sub() 
	as integer          stipple_parity 
 
	
	
End Type
 

'// FIXME: compress, make a union if that will help
'// insubmodel is only 1, flags is fewer than 32, spanstate could be a byte
type surf_s
 
	as surf_s ptr   _next                   '// active surface stack in r_edge.c
	as surf_s ptr   _prev                   '// used in r_edge.c for active surf stack
	as espan_s ptr      spans                  '// pointer to linked list of spans to draw
	as integer        key                            '// sorting key (BSP order)
	as integer        last_u                          '// set during tracing
	as integer        spanstate                       '// 0 = not in span
									                                  '// 1 = in span
									                                  '// -1 = in inverted span (end before
									'                                //  start)
	as integer         flags                          ' // currentface flags
	as msurface_t ptr  msurf 
	as entity_t ptr    entity 
	as float           nearzi                        ' // nearest 1/z on surface, for mipmapping
	as qboolean        insubmodel 
	as float           d_ziorigin, d_zistepu, d_zistepv 

	as integer                pad(2)                        ' // to 64 bytes
 end type: type surf_t as surf_s




'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type  edge_s
 
	as fixed16_t               u 
	as fixed16_t               u_step 
	as edge_s ptr   _prev, _next 
	as ushort  surfs(2)
	as edge_s ptr   nextremove 
	as float         nearzi 
	as medge_t ptr     owner 
 end type: type edge_t as edge_s



'/*
'====================================================
'
'VARS
'
'====================================================
'*/


extern "C"

extern as integer             d_spanpixcount 
extern as integer              r_framecount           ' // sequence # of current frame since Quake
									'//  started
extern as float    r_aliasuvscale        ' // scale-up factor for screen u and v
									'//  on Alias vertices passed to driver
extern as qboolean r_dowarp 

extern as affinetridesc_t  r_affinetridesc 

extern as vec3_t   r_pright, r_pup, r_ppn 

end extern

extern "c"

 

extern as integer								a_sstepxfrac, a_tstepxfrac, r_lstepx, a_ststepxwhole 
extern as integer								r_sstepx, r_tstepx, r_lstepy, r_sstepy, r_tstepy 
extern as integer								r_zistepx, r_zistepy 
extern as integer								d_aspancount, d_countextrastep 





extern  as UInteger fpu_sp24_ceil_cw, fpu_ceil_cw, fpu_chop_cw
end extern

extern as integer              r_amodels_drawn 

declare sub R_PushDlights( model as model_t ptr )

declare sub  R_DrawAlphaSurfaces()
declare sub R_SetLightLevel()

declare sub R_PrintAliasStats()

declare sub R_PrintTimes()


declare sub R_DrawParticles ()



declare sub D_DrawSurfaces () 
declare sub R_DrawParticle naked () 
declare sub D_ViewChanged () 
declare sub D_WarpScreen () 
declare sub R_PolysetUpdateTables () 

extern as any  ptr acolormap  '// FIXME: should go away

'//=======================================================================//

'// callbacks to Quake

extern as drawsurf_t   r_drawsurf 

declare sub R_DrawSurface () 

extern as integer              c_surf 

extern as ubyte  r_warpbuffer(WARP_WIDTH * WARP_HEIGHT)


 declare sub R_ScreenShot_f


extern as float    scale_for_mip 

extern as qboolean         d_roverwrapped 
extern as surfcache_t ptr       sc_rover 
extern as surfcache_t ptr       d_initial_rover 

extern as float    d_sdivzstepu, d_tdivzstepu, d_zistepu 
extern as float    d_sdivzstepv, d_tdivzstepv, d_zistepv 
extern as float    d_sdivzorigin, d_tdivzorigin, d_ziorigin 

extern as  fixed16_t       sadjust, tadjust 
extern as fixed16_t       bbextents, bbextentt 


declare sub D_DrawSpans16 (pspans as espan_t ptr)
declare sub D_DrawZSpans (pspans as espan_t ptr)
declare sub Turbulent8 (pspan as espan_t ptr)
declare sub NonTurbulent8 (pspan as espan_t ptr)	'//PGM

declare function D_CacheSurface (surface as msurface_t ptr, miplevel as integer ) as surfcache_t ptr

extern as integer      d_vrectx, d_vrecty, d_vrectright_particle, d_vrectbottom_particle 

extern "c"
extern as integer      d_pix_min, d_pix_max, d_pix_shift 





extern as short ptr  d_pzbuffer 

extern as pixel_t ptr d_viewbuffer 

extern  as UInteger  d_zrowbytes, d_zwidth 
extern as short ptr   zspantable(MAXHEIGHT) 
extern as integer      d_scantable(MAXHEIGHT)
end extern



extern as integer              d_minmip 
extern as float    d_scalemip(3) 

'//===================================================================
extern "c"
extern as integer              cachewidth 
extern as pixel_t  ptr            cacheblock 
extern as integer              r_screenwidth 

extern as integer              r_drawnpolycount 

extern as integer      sintable(1280) 
extern as integer      intsintable(1280) 
extern as integer		blanktable(1280) 		'// PGM

extern as vec3_t			r_entorigin



extern as vec3_t  vup, base_vup 
extern as vec3_t  vpn, base_vpn 
extern as vec3_t  vright, base_vright 

 
extern  as surf_t ptr  surfaces,  surface_p,  surf_max 
end extern


declare sub R_RotateBmodel ()

'// surfaces are generated in back to front order by the bsp, so if a surf
'// pointer is greater than another one, it should be drawn in front
'// surfaces[1] is the background, and is used as the active surface stack.
'// surfaces[0] is a dummy, because index 0 is used to indicate no surface
'//  attached to an edge_t
'
'//===================================================================
extern "C"
extern as vec3_t   sxformaxis(4)   '// s axis transformed into viewspace
extern as vec3_t   txformaxis(4)   '// t axis transformed into viewspac

extern as float   xcenter, ycenter 
extern as float   xscale, yscale 
extern as float   xscaleinv, yscaleinv 
extern as float   xscaleshrink, yscaleshrink 

end extern


'extern void TransformVector (vec3_t in, vec3_t out);
'extern void SetUpForLineScan(fixed8_t startvertu, fixed8_t startvertv,
'	fixed8_t endvertu, fixed8_t endvertv);

declare sub TransformVector (_in as vec3_t ptr,_out as vec3_t ptr)
declare sub SetUpForLineScan(startvertu as fixed8_t ,startvertv as fixed8_t ,endvertu as fixed8_t ,endvertv as fixed8_t ) 
 
 	
declare sub D_FlushCaches()
 
	 
extern as fixed8_t endvertu, endvertv 

 extern "C"

 extern as float fv
 extern as integer current_iv 
 extern as integer edge_head_u_shift20, edge_tail_u_shift20 
 extern as edge_t edge_head  
 extern as espan_t	ptr span_p,  max_span_p 
 extern as integer ubasestep, errorterm, erroradjustup, erroradjustdown
 
 
 
 
end extern



'//===========================================================================

extern sw_aliasstats as cvar_t ptr
extern sw_clearcolor as cvar_t ptr 
extern sw_drawflat  as cvar_t ptr
extern sw_draworder as cvar_t ptr
extern sw_maxedges as cvar_t ptr
extern sw_maxsurfs as cvar_t ptr
extern sw_mipcap as cvar_t ptr
extern sw_mipscale as cvar_t ptr
extern sw_mode as cvar_t ptr
extern sw_reportsurfout as cvar_t ptr 
extern sw_reportedgeout as cvar_t ptr 
extern sw_stipplealpha as cvar_t ptr
extern sw_surfcacheoverride as cvar_t ptr 
extern sw_waterwarp as cvar_t ptr

extern r_fullbright as cvar_t ptr
extern r_lefthand as cvar_t ptr
extern r_drawentities as cvar_t ptr 
extern r_drawworld as cvar_t ptr
extern r_dspeeds as cvar_t ptr
extern r_lerpmodels as cvar_t ptr

extern r_speeds       as cvar_t ptr 

extern r_lightlevel   as cvar_t ptr   '//FIXME HACK

extern vid_fullscreen as cvar_t	ptr
extern vid_gamma	    as cvar_t	ptr 


extern  view_clipplanes(4) as clipplane_t      
extern  pfrustum_indexes(4)  as integer ptr              


extern as surfcache_s ptr sc_base 



'//=============================================================================

declare sub R_RenderWorld ()

'//=============================================================================

declare  sub R_UnRegister () 

extern as mplane_t        screenedge(4)

extern as  vec3_t        r_origin

extern as entity_t	   r_worldentity 
extern as model_t ptr   currentmodel 
extern as entity_t ptr    currententity 

extern "c"
extern as vec3_t  modelorg 
end extern

extern as vec3_t  r_entorigin 

extern as float   verticalFieldOfView 
extern as float   xOrigin, yOrigin 

extern as integer             r_visframecount 

extern as msurface_t ptr r_alpha_surfaces 
'//=============================================================================
declare sub R_ClearPolyList () 
declare sub R_DrawPolyList ()

extern as  image_t ptr          r_notexture_mip 
extern as  model_t   ptr        r_worldmodel 



extern "c"
declare sub R_EdgeCodeStart()
declare sub R_EdgeCodeEnd()



extern edge_aftertail as edge_t
extern edge_tail as edge_t





end extern
















'//
'// current entity info
'//
extern as  qboolean  insubmodel 

extern as  uinteger d_8to24table(256)



declare sub  R_RenderFace (fa as msurface_t ptr, clipflags as integer ) 
declare sub  R_RenderBmodelFace (pedges as bedge_t ptr,psurf as  msurface_t ptr)
declare sub  R_TransformPlane (p as mplane_t ptr ,   normal as float ptr,dist as  float ptr)
declare sub  R_TransformFrustum ()
declare sub  R_DrawSurfaceBlock16 ()
declare sub  R_DrawSurfaceBlock8 () 

extern as mtexinfo_t  ptr sky_texinfo(6)

declare sub R_InitImages ()
declare sub	R_ShutdownImages () 
 
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
 



declare function R_FindImage (_name as zstring ptr,_type as imagetype_t ) as image_t ptr

declare sub	LoadPCX (filename as ZString ptr, _pic as ubyte ptr ptr, _palette as ubyte ptr ptr ,_width as integer ptr, _height as integer ptr)
declare sub Draw_InitLocal ()

declare sub	R_EndRegistration () 

declare sub  R_InitSkyBox () 

declare sub  Sys_MakeCodeWriteable (startaddr as ulong , length as ulong ) 
declare sub   Sys_SetFPCW ()

extern	as integer			r_viewcluster, r_oldviewcluster 
'extern as integer      ubasestep, errorterm, erroradjustup, erroradjustdown 
 
declare sub R_InitCaches ()
declare sub SWimp_SetPalette( _palette as const ubyte ptr  )

type swstate_s
 
	fullscreen as  qboolean 
	prev_mode as integer    				'// last valid SW mode
 
 	gammatable(256)  as ubyte	
 	currentpalette(1024) as ubyte	
 	
end type: type swstate_t as swstate_s
 

extern sw_state as swstate_t
 
''/*
''===================GL=================================GL============
''
'R_RegisterSkin'IMPORTED FUNCTIONS
''
''=====================================GL=============================
''*/

extern		ri as refimport_t

''/*
''====================================================================
''
''IMPLEMENTATION FUNCTIONS
''
''===GL==================================================GL===========
''*/

 declare sub R_GammaCorrectAndSetPalette( _palette as const ubyte ptr)
declare sub SWimp_BeginFrame(camera_separation as float)
declare sub SWimp_EndFrame() 
declare function SWimp_Init(hinstance as any ptr,hWnd as any ptr) as integer
declare sub  SWimp_Shutdown() 
declare function SWimp_SetMode(pwidth as integer ptr, pheight as integer ptr,_mode as integer , fullscreen as qboolean)  as rserr_t
declare sub  SWimp_AppActivate(active as qboolean) 
declare sub  SWimp_EnableLogging(enable as qboolean )
declare sub  SWimp_LogNewFrame()




declare sub R_IMFlatShadedQuad(  a as vec3_t ptr, b as vec3_t ptr,c as  vec3_t ptr ,d as vec3_t ptr , _color as  integer ,alpha_ as  float  ) 
 



extern "C"
extern as qboolean		r_lastvertvalid

extern as integer				r_emitted 
extern as float			  r_nearzi 
extern as float			r_u1, r_v1, r_lzi1 
extern as integer	      r_ceilv1
extern as qboolean		r_nearzionly
extern as integer		   cacheoffset 



extern as edge_t	ptr auxedges 
extern as edge_t	ptr r_edges,  edge_p,  edge_max 
 
extern as edge_t	 newedges(MAXHEIGHT) 
extern as edge_t	 removeedges(MAXHEIGHT) 
 
end extern


extern "C"
extern as ubyte irtable(256)
end extern
 

type aliastriangleparms_t
	as finalvert_t ptr a,  b,  c 
End Type
 
 
extern as float    aliasxscale, aliasyscale, aliasxcenter, aliasycenter 


extern "C"
extern  as UByte iractive		
end extern

declare sub R_SurfacePatch()
declare sub R_LightPoint (p as vec3_t ptr ,_color as vec3_t ptr )



declare sub R_PrintDSpeeds()
 
declare function R_RegisterModel (_name as ZString ptr) as model_s ptr

declare sub R_BeginRegistration (_map as ZString ptr)


  declare sub R_SetSky (_name as ZString ptr,rotate as float , axis as  vec3_t ptr)

declare sub R_DrawSprite ()
 
'declare function Draw_FindPic(_name as ZString) as image_s
 
'declare sub Draw_Pic (x as Integer,y as Integer,_name as zstring ptr)
'declare sub Draw_Char (x as Integer, y as Integer, c as Integer)
'declare sub	Draw_TileClear (x as Integer, y as Integer, w  as Integer, h  as Integer,_name as zstring ptr)
'declare sub Draw_Fill (x as Integer,y  as Integer,w  as Integer, h  as Integer,c  as Integer)
'declare sub Draw_FadeScreen ()
'
'
 declare sub R_DrawBeam(e as entity_t ptr )
 declare function Draw_FindPic (_name as ZString ptr ) as image_s ptr

extern	as mtexinfo_t		r_skytexinfo(6)


declare sub R_DrawSubmodelPolygons (pmodel as model_t ptr,clipflags as integer ,topnode as mnode_t ptr)
declare sub R_DrawSolidClippedSubmodelPolygons (pmodel as model_t ptr, topnode as mnode_t ptr)

 declare sub R_BeginEdgeFrame ()
 	
 declare sub  R_ScanEdges
 
declare sub R_AliasDrawModel ()
'
'declare sub R_RenderFrame (fd as refdef_t ptr)



 extern as  vec5_t	r_clip_verts(2,MAXWORKINGVERTS+2) 

 extern as polydesc_t  r_polydesc