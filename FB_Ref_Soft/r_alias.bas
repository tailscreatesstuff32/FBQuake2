#Include "FB_Ref_Soft\r_local.bi"



							
'''''''''''''''''''''''''''''''''''''''''''''''''''''' 

dim shared r_refdef_aliasvrectbottom as Integer ptr
 r_refdef_aliasvrectbottom = @r_refdef.aliasvrectbottom
 
 
dim shared r_refdef_aliasvrectright as Integer ptr
 r_refdef_aliasvrectright  = @r_refdef.aliasvrectright 
 
dim shared r_refdef_aliasvrect_x as Integer ptr 
r_refdef_aliasvrect_x = @r_refdef.aliasvrect.x

dim shared r_refdef_aliasvrect_y as Integer ptr
r_refdef_aliasvrect_y = @r_refdef.aliasvrect.y

''''''''''''''''''''''''''''''''''''''''''''''''''	

#define LIGHT_MIN	5		'// lowest light value we'll allow, to avoid the
							'//  need for inner-loop light clamping							
							
'extern "C"
'extern  as UByte iractive		
'end extern							
 

dim shared as integer				r_amodels_drawn 	

							
dim shared as affinetridesc_t	r_affinetridesc


dim shared as vec3_t			   r_plightvec
dim shared as vec3_t          r_lerped(1024) 
dim shared as vec3_t          r_lerp_frontv, r_lerp_backv, r_lerp_move 

dim shared as integer				r_ambientlight 
dim shared as integer				r_aliasblendcolor 
dim shared as float					r_shadelight 

dim shared as daliasframe_t	ptr r_thisframe,  r_lastframe 
dim shared as dmdl_t			   ptr s_pmdl 

dim shared as float	 aliastransform(3,4)
dim shared as float   aliasworldtransform(3,4) 
dim shared as float   aliasoldworldtransform(3,4)

static shared as float s_ziscale
static shared as vec3_t	s_alias_forward, s_alias_right, s_alias_up 


#define NUMVERTEXNORMALS	162
dim shared as  float	r_avertexnormals(NUMVERTEXNORMALS,3) ' => _
'#include "anorms.h"
'};



declare sub R_AliasSetUpLerpData(pmdl as dmdl_t  ptr,backlerp as float  ) 
declare sub R_AliasSetUpTransform () 
'declare sub R_AliasTransformVector (_in as vec3_t ,_out as vec3_t , m() as float ) 'm[3][4] as float
declare sub R_AliasTransformVector (_in as vec3_t ptr,_out as vec3_t ptr, m() as float ) 'm[3][4] as float

declare sub R_AliasProjectAndClipTestFinalVert (fv as finalvert_t ptr) 
 
declare sub R_AliasTransformFinalVerts( numpoints as integer , fv as finalvert_t ptr,oldv as dtrivertx_t ptr,newv as dtrivertx_t ptr ) 
 
declare sub R_AliasLerpFrames(paliashdr as  dmdl_t ptr,backlerp  as float ) 
 
 '/*
'================
'R_AliasCheckBBox
'================
'*/
type aedge_t  
   as integer	index0 
	as integer	index1 
End Type

 static shared as aedge_t	aedges(12) => { _
(0, 1), (1, 2), (2, 3), (3, 0), _
(4, 5), (5, 6), (6, 7), (7, 4), _ 
(0, 5), (1, 4), (2, 7), (3, 6) _
} 
 

#define BBOX_TRIVIAL_ACCEPT 0
#define BBOX_MUST_CLIP_XY   1
#define BBOX_MUST_CLIP_Z    2
#define BBOX_TRIVIAL_REJECT 8




'/*
'================
'R_AliasTransformVector
'================
'*/
'sub R_AliasTransformVector(_in as vec3_t , _out as vec3_t ,xf() as  float  ) 'xf[3][4]
sub R_AliasTransformVector(_in as vec3_t ptr , _out as  vec3_t ptr  ,/'xf[3][4]'/ xf() as  float  ) 
   '_out[0] = DotProduct(in, xf[0])' + xf[0][3];
	'_out[1] = DotProduct(in, xf[1])' + xf[1][3];
	'_out[2] = DotProduct(in, xf[2])' + xf[2][3];
	
	' _out.x = DotProduct(_in, xf(0,0)  ) + xf(0,3)
	' _out.y = DotProduct(_in, xf(1,0)  )  + xf(1,3)
	' _out.z = DotProduct(_in, xf(2,0)  )  + xf(2,3)
	
     _out->v(0) = DotProduct(_in, @xf(0,0)  ) + xf(0,3)
	  _out->v(1) = DotProduct(_in, @xf(1,0)  )  + xf(1,3)
	  _out->v(2) = DotProduct(_in, @xf(2,0)  )  + xf(2,3)
	
	
End Sub
 

extern d_pdrawspans as sub(as any ptr)
   	
declare sub R_PolysetDrawSpans8_Opaque(as any ptr) 
declare sub R_PolysetDrawSpans8_33(as any ptr ) 
declare sub R_PolysetDrawSpans8_66(as any ptr) 
declare sub R_PolysetDrawSpansConstant8_33(as any ptr) 
declare sub R_PolysetDrawSpansConstant8_66(as any ptr) 
  
/'
================
R_AliasDrawModel
================
'/
sub R_AliasDrawModel ()
'		s_pmdl = (dmdl_t *)currentmodel->extradata;
'
'	if ( r_lerpmodels->value == 0 )
'		currententity->backlerp = 0;
'
'	if ( currententity->flags & RF_WEAPONMODEL )
'	{
'		if ( r_lefthand->value == 1.0F )
'			aliasxscale = -aliasxscale;
'		else if ( r_lefthand->value == 2.0F )
'			return;
'	}
'
'	/*
'	** we have to set our frame pointers and transformations before
'	** doing any real work
'	*/
'	R_AliasSetupFrames( s_pmdl );
'	R_AliasSetUpTransform();
'
'	// see if the bounding box lets us trivially reject, also sets
'	// trivial accept status
'	if ( R_AliasCheckBBox() == BBOX_TRIVIAL_REJECT )
'	{
'		if ( ( currententity->flags & RF_WEAPONMODEL ) && ( r_lefthand->value == 1.0F ) )
'		{
'			aliasxscale = -aliasxscale;
'		}
'		return;
'	}
'
'	// set up the skin and verify it exists
'	if ( !R_AliasSetupSkin () )
'	{
'		ri.Con_Printf( PRINT_ALL, "R_AliasDrawModel %s: NULL skin found\n",
'			currentmodel->name);
'		return;
'	}
'
'	r_amodels_drawn++;
'	R_AliasSetupLighting ();
'
'	/*
'	** select the proper span routine based on translucency
'	*/
'	// PMM - added double damage shell
'	// PMM - reordered to handle blending
'	if ( currententity->flags & ( RF_SHELL_RED | RF_SHELL_GREEN | RF_SHELL_BLUE | RF_SHELL_DOUBLE | RF_SHELL_HALF_DAM) )
'	{
'		int		color;
'
'		// PMM - added double
'		color = currententity->flags & ( RF_SHELL_RED | RF_SHELL_GREEN | RF_SHELL_BLUE | RF_SHELL_DOUBLE | RF_SHELL_HALF_DAM);
'		// PMM - reordered, new shells after old shells (so they get overriden)
'
'		if ( color == RF_SHELL_RED )
'			r_aliasblendcolor = SHELL_RED_COLOR;
'		else if ( color == RF_SHELL_GREEN )
'			r_aliasblendcolor = SHELL_GREEN_COLOR;
'		else if ( color == RF_SHELL_BLUE )
'			r_aliasblendcolor = SHELL_BLUE_COLOR;
'		else if ( color == (RF_SHELL_RED | RF_SHELL_GREEN) )
'			r_aliasblendcolor = SHELL_RG_COLOR;
'		else if ( color == (RF_SHELL_RED | RF_SHELL_BLUE) )
'			r_aliasblendcolor = SHELL_RB_COLOR;
'		else if ( color == (RF_SHELL_BLUE | RF_SHELL_GREEN) )
'			r_aliasblendcolor = SHELL_BG_COLOR;
'		// PMM - added this .. it's yellowish
'		else if ( color == (RF_SHELL_DOUBLE) )
'			r_aliasblendcolor = SHELL_DOUBLE_COLOR;
'		else if ( color == (RF_SHELL_HALF_DAM) )
'			r_aliasblendcolor = SHELL_HALF_DAM_COLOR;
'		// pmm
'		else
'			r_aliasblendcolor = SHELL_WHITE_COLOR;
'/*		if ( color & RF_SHELL_RED )
'		{
'			if ( ( color & RF_SHELL_BLUE) && ( color & RF_SHELL_GREEN) )
'				r_aliasblendcolor = SHELL_WHITE_COLOR;
'			else if ( color & (RF_SHELL_BLUE | RF_SHELL_DOUBLE))
'				r_aliasblendcolor = SHELL_RB_COLOR;
'			else
'				r_aliasblendcolor = SHELL_RED_COLOR;
'		}
'		else if ( color & RF_SHELL_BLUE)
'		{
'			if ( color & RF_SHELL_DOUBLE )
'				r_aliasblendcolor = SHELL_CYAN_COLOR;
'			else
'				r_aliasblendcolor = SHELL_BLUE_COLOR;
'		}
'		else if ( color & (RF_SHELL_DOUBLE) )
'			r_aliasblendcolor = SHELL_DOUBLE_COLOR;
'		else if ( color & (RF_SHELL_HALF_DAM) )
'			r_aliasblendcolor = SHELL_HALF_DAM_COLOR;
'		else if ( color & RF_SHELL_GREEN )
'			r_aliasblendcolor = SHELL_GREEN_COLOR;
'		else
'			r_aliasblendcolor = SHELL_WHITE_COLOR;
'*/
'
'		if ( currententity->alpha > 0.33 )
'			d_pdrawspans = R_PolysetDrawSpansConstant8_66;
'		else
'			d_pdrawspans = R_PolysetDrawSpansConstant8_33;
'	}
'	else if ( currententity->flags & RF_TRANSLUCENT )
'	{
'		if ( currententity->alpha > 0.66 )
'			d_pdrawspans = R_PolysetDrawSpans8_Opaque;
'		else if ( currententity->alpha > 0.33 )
'			d_pdrawspans = R_PolysetDrawSpans8_66;
'		else
'			d_pdrawspans = R_PolysetDrawSpans8_33;
'	}
'	else
'	{
'		d_pdrawspans = R_PolysetDrawSpans8_Opaque;
'	}
'
'	/*
'	** compute this_frame and old_frame addresses
'	*/
'	R_AliasSetUpLerpData( s_pmdl, currententity->backlerp );
'
'	if (currententity->flags & RF_DEPTHHACK)
'		s_ziscale = (float)0x8000 * (float)0x10000 * 3.0;
'	else
'		s_ziscale = (float)0x8000 * (float)0x10000;
'
'	R_AliasPreparePoints ();
'
'	if ( ( currententity->flags & RF_WEAPONMODEL ) && ( r_lefthand->value == 1.0F ) )
'	{
'		aliasxscale = -aliasxscale;
'	}
'	
	
End Sub






'''''''''''''''''''''''''

'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''
'/'
'================
'R_AliasTransformFinalVerts
'================
''/
#if id386 'and !defined __linux__
sub R_AliasTransformFinalVerts( numpoints as integer,fv as finalvert_t ptr,oldv as  dtrivertx_t ptr,newv as  dtrivertx_t ptr )
 
	dim as float  lightcos 
	dim as float	lerped_vert(3) 
	dim as integer    byte_to_dword_ptr_var 
	dim as integer    tmpint 

	dim as float  one = 1.0F 
	dim as float  zi 

	static as float  FALIAS_Z_CLIP_PLANE = ALIAS_Z_CLIP_PLANE 
	static as float  PS_SCALE = POWERSUIT_SCALE 
asm
	 mov ecx, numpoints

	/'
	lerped_vert[0] = r_lerp_move[0] + oldv->v[0]*r_lerp_backv[0] + newv->v[0]*r_lerp_frontv[0];
	lerped_vert[1] = r_lerp_move[1] + oldv->v[1]*r_lerp_backv[1] + newv->v[1]*r_lerp_frontv[1];
	lerped_vert[2] = r_lerp_move[2] + oldv->v[2]*r_lerp_backv[2] + newv->v[2]*r_lerp_frontv[2];
	'/
top_of_loop:

	 mov esi, oldv
	 mov edi, newv

	 xor ebx, ebx

	 mov bl, byte ptr [esi+DTRIVERTX_V0]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var      
	 fmul dword ptr [r_lerp_backv+0]                  # oldv[0]*rlb[0]

	 mov bl, byte ptr [esi+DTRIVERTX_V1]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var
	 fmul dword ptr [r_lerp_backv+4]                  # oldv[1]*rlb[1] | oldv[0]*rlb[0]

	 mov bl, byte ptr [esi+DTRIVERTX_V2]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var
	 fmul dword ptr [r_lerp_backv+8]                  # oldv[2]*rlb[2] | oldv[1]*rlb[1] | oldv[0]*rlb[0]

	 mov bl, byte ptr [edi+DTRIVERTX_V0]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var      
	 fmul dword ptr [r_lerp_frontv+0]                 # newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] | oldv[0]*rlb[0]

	 mov bl, byte ptr [edi+DTRIVERTX_V1]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var
	 fmul dword ptr [r_lerp_frontv+4]                 # newv[1]*rlf[1] | newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] | oldv[0]*rlb[0]

	 mov bl, byte ptr [edi+DTRIVERTX_V2]
	 mov byte_to_dword_ptr_var, ebx
	 fild dword ptr byte_to_dword_ptr_var
	 fmul dword ptr [r_lerp_frontv+8]                 # newv[2]*rlf[2] | newv[1]*rlf[1] | newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] | oldv[0]*rlb[0]

	 fxch st(5)                     # oldv[0]*rlb[0] | newv[1]*rlf[1] | newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] | newv[2]*rlf[2]
	 faddp st(2), st                # newv[1]*rlf[1] | oldv[0]*rlb[0] + newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] | newv[2]*rlf[2]
	 faddp st(3), st                # oldv[0]*rlb[0] + newv[0]*rlf[0] | oldv[2]*rlb[2] | oldv[1]*rlb[1] + newv[1]*rlf[1] | newv[2]*rlf[2]
	 fxch st(1)                     # oldv[2]*rlb[2] | oldv[0]*rlb[0] + newv[0]*rlf[0] | oldv[1]*rlb[1] + newv[1]*rlf[1] | newv[2]*rlf[2]
	 faddp st(3), st                # oldv[0]*rlb[0] + newv[0]*rlf[0] | oldv[1]*rlb[1] + newv[1]*rlf[1] | oldv[2]*rlb[2] + newv[2]*rlf[2]
	 fadd dword ptr [r_lerp_move+0] # lv0 | oldv[1]*rlb[1] + newv[1]*rlf[1] | oldv[2]*rlb[2] + newv[2]*rlf[2]
	 fxch st(1)                     # oldv[1]*rlb[1] + newv[1]*rlf[1] | lv0 | oldv[2]*rlb[2] + newv[2]*rlf[2]
	 fadd dword ptr [r_lerp_move+4] # lv1 | lv0 | oldv[2]*rlb[2] + newv[2]*rlf[2]
	 fxch st(2)                     # oldv[2]*rlb[2] + newv[2]*rlf[2] | lv0 | lv1
	 fadd dword ptr [r_lerp_move+8] # lv2 | lv0 | lv1
	 fxch st(1)                     # lv0 | lv2 | lv1
	 fstp dword ptr [lerped_vert+0] # lv2 | lv1
	 fstp dword ptr [lerped_vert+8] # lv2
	 fstp dword ptr [lerped_vert+4] # (empty)

	 mov  eax, currententity
	 mov  eax, dword ptr [eax+ENTITY_FLAGS]
	 mov  ebx, RF_SHELL_RED | RF_SHELL_GREEN | RF_SHELL_BLUE | RF_SHELL_DOUBLE | RF_SHELL_HALF_DAM
	 and  eax, ebx
	 jz   not_powersuit

	/'
	**    lerped_vert[0] += lightnormal[0] * POWERSUIT_SCALE
	**    lerped_vert[1] += lightnormal[1] * POWERSUIT_SCALE
	**    lerped_vert[2] += lightnormal[2] * POWERSUIT_SCALE
	'/

	 xor ebx, ebx
	 mov bl,  byte ptr [edi+DTRIVERTX_LNI]
	 mov eax, 12
	 mul ebx
	 lea eax, [r_avertexnormals+eax]

	 fld  dword ptr [eax+0]				# n[0]
	 fmul PS_SCALE							# n[0] * PS
	 fld  dword ptr [eax+4]				# n[1] | n[0] * PS
	 fmul PS_SCALE							# n[1] * PS | n[0] * PS
	 fld  dword ptr [eax+8]				# n[2] | n[1] * PS | n[0] * PS
	 fmul PS_SCALE							# n[2] * PS | n[1] * PS | n[0] * PS
	 fld  dword ptr [lerped_vert+0]		# lv0 | n[2] * PS | n[1] * PS | n[0] * PS
	 faddp st(3), st						# n[2] * PS | n[1] * PS | n[0] * PS + lv0
	 fld  dword ptr [lerped_vert+4]		# lv1 | n[2] * PS | n[1] * PS | n[0] * PS + lv0
	 faddp st(2), st						# n[2] * PS | n[1] * PS + lv1 | n[0] * PS + lv0
	 fadd dword ptr [lerped_vert+8]		# n[2] * PS + lv2 | n[1] * PS + lv1 | n[0] * PS + lv0
	 fxch st(2)							# LV0 | LV1 | LV2
	 fstp dword ptr [lerped_vert+0]		# LV1 | LV2
	 fstp dword ptr [lerped_vert+4]		# LV2
	 fstp dword ptr [lerped_vert+8]		# (empty)

not_powersuit:

	/'
	fv->flags = 0;

	fv->xyz[0] = DotProduct(lerped_vert, aliastransform[0]) + aliastransform[0][3];
	fv->xyz[1] = DotProduct(lerped_vert, aliastransform[1]) + aliastransform[1][3];
	fv->xyz[2] = DotProduct(lerped_vert, aliastransform[2]) + aliastransform[2][3];
	'/
	 mov  eax, fv
	 mov  dword ptr [eax+FINALVERT_FLAGS], 0

	 fld  dword ptr [lerped_vert+0]           # lv0
	 fmul dword ptr [aliastransform+0]        # lv0*at[0][0]
	 fld  dword ptr [lerped_vert+4]           # lv1 | lv0*at[0][0]
	 fmul dword ptr [aliastransform+4]        # lv1*at[0][1] | lv0*at[0][0]
	 fld  dword ptr [lerped_vert+8]           # lv2 | lv1*at[0][1] | lv0*at[0][0]
	 fmul dword ptr [aliastransform+8]        # lv2*at[0][2] | lv1*at[0][1] | lv0*at[0][0]
	 fxch st(2)                               # lv0*at[0][0] | lv1*at[0][1] | lv2*at[0][2]
	 faddp st(1), st                          # lv0*at[0][0] + lv1*at[0][1] | lv2*at[0][2]
	 faddp st(1), st                          # lv0*at[0][0] + lv1*at[0][1] + lv2*at[0][2]
	 fadd  dword ptr [aliastransform+12]      # FV.X

	 fld  dword ptr [lerped_vert+0]           # lv0
	 fmul dword ptr [aliastransform+16]       # lv0*at[1][0]
	 fld  dword ptr [lerped_vert+4]           # lv1 | lv0*at[1][0]
	 fmul dword ptr [aliastransform+20]       # lv1*at[1][1] | lv0*at[1][0]
	 fld  dword ptr [lerped_vert+8]           # lv2 | lv1*at[1][1] | lv0*at[1][0]
	 fmul dword ptr [aliastransform+24]       # lv2*at[1][2] | lv1*at[1][1] | lv0*at[1][0]
	 fxch st(2)                               # lv0*at[1][0] | lv1*at[1][1] | lv2*at[1][2]
	 faddp st(1), st                          # lv0*at[1][0] + lv1*at[1][1] | lv2*at[1][2]
	 faddp st(1), st                          # lv0*at[1][0] + lv1*at[1][1] + lv2*at[1][2]
	 fadd dword ptr [aliastransform+28]       # FV.Y | FV.X
	 fxch st(1)                               # FV.X | FV.Y
	 fstp  dword ptr [eax+FINALVERT_X]        # FV.Y
	
	 fld  dword ptr [lerped_vert+0]           # lv0
	 fmul dword ptr [aliastransform+32]       # lv0*at[2][0]
	 fld  dword ptr [lerped_vert+4]           # lv1 | lv0*at[2][0]
	 fmul dword ptr [aliastransform+36]       # lv1*at[2][1] | lv0*at[2][0]
	 fld  dword ptr [lerped_vert+8]           # lv2 | lv1*at[2][1] | lv0*at[2][0]
	 fmul dword ptr [aliastransform+40]       # lv2*at[2][2] | lv1*at[2][1] | lv0*at[2][0]
	 fxch st(2)                               # lv0*at[2][0] | lv1*at[2][1] | lv2*at[2][2]
	 faddp st(1), st                          # lv0*at[2][0] + lv1*at[2][1] | lv2*at[2][2]
	 faddp st(1), st                          # lv0*at[2][0] + lv1*at[2][1] + lv2*at[2][2]
	 fadd dword ptr [aliastransform+44]       # FV.Z | FV.Y
	 fxch st(1)                               # FV.Y | FV.Z
	 fstp dword ptr [eax+FINALVERT_Y]         # FV.Z
	 fstp dword ptr [eax+FINALVERT_Z]         # (empty)

	/'
	**  lighting
	**
	**  plightnormal = r_avertexnormals[newv->lightnormalindex];
	**	lightcos = DotProduct (plightnormal, r_plightvec);
	**	temp = r_ambientlight;
	'/
	 xor ebx, ebx
	 mov bl,  byte ptr [edi+DTRIVERTX_LNI]
	 mov eax, 12
	 mul ebx
	 lea eax, [r_avertexnormals+eax]
	 lea ebx, r_plightvec

	 fld  dword ptr [eax+0]
	 fmul dword ptr [ebx+0]
	 fld  dword ptr [eax+4]
	 fmul dword ptr [ebx+4]
	 fld  dword ptr [eax+8]
	 fmul dword ptr [ebx+8]
	 fxch st(2)
	 faddp st(1), st
	 faddp st(1), st
	 fstp dword ptr lightcos
	 mov eax, lightcos
	 mov ebx, r_ambientlight

	/'
	if (lightcos < 0)
	{
		temp += (int)(r_shadelight * lightcos);

		// clamp# because we limited the minimum ambient and shading light, we
		// don't have to clamp low light, just bright
		if (temp < 0)
			temp = 0;
	}

	fv->v[4] = temp;
	'/
	 or  eax, eax
	 jns store_fv4

	 fld   dword ptr r_shadelight
	 fmul  dword ptr lightcos
	 fistp dword ptr tmpint
	 add   ebx, tmpint

	 or    ebx, ebx
	 jns   store_fv4
	 mov   ebx, 0

store_fv4:
	 mov edi, fv
	 mov dword ptr [edi+FINALVERT_V4], ebx

	 mov edx, dword ptr [edi+FINALVERT_FLAGS]

	/'
	** do clip testing and projection here
	'/
	/'
	if ( dest_vert->xyz[2] < ALIAS_Z_CLIP_PLANE )
	{
		dest_vert->flags |= ALIAS_Z_CLIP;
	}
	else
	{
		R_AliasProjectAndClipTestFinalVert( dest_vert );
	}
	'/
	 mov eax, dword ptr [edi+FINALVERT_Z]
	 and eax, eax
	 js  alias_z_clip
	 cmp eax, FALIAS_Z_CLIP_PLANE
	 jl  alias_z_clip

	/'
	This is the code to R_AliasProjectAndClipTestFinalVert

	float	zi;
	float	x, y, z;

	x = fv->xyz[0];
	y = fv->xyz[1];
	z = fv->xyz[2];
	zi = 1.0 / z;

	fv->v[5] = zi * s_ziscale;

	fv->v[0] = (x * aliasxscale * zi) + aliasxcenter;
	fv->v[1] = (y * aliasyscale * zi) + aliasycenter;
	'/
	 fld   one                             # 1
	 fdiv  dword ptr [edi+FINALVERT_Z]     # zi

	 mov   eax, dword ptr [edi+32]
	 mov   eax, dword ptr [edi+64]

	 fst   zi                              # zi
	  fmul  s_ziscale                       # fv5
	 fld   dword ptr [edi+FINALVERT_X]     # x | fv5
	  fmul  aliasxscale                     # x * aliasxscale | fv5
	 fld   dword ptr [edi+FINALVERT_Y]     # y | x * aliasxscale | fv5
	  fmul  aliasyscale                     # y * aliasyscale | x * aliasxscale | fv5
	 fxch  st(1)                           # x * aliasxscale | y * aliasyscale | fv5
	 fmul  zi                              # x * asx * zi | y * asy | fv5
	 fadd  aliasxcenter                    # fv0 | y * asy | fv5
	 fxch  st(1)                           # y * asy | fv0 | fv5
	  fmul  zi                              # y * asy * zi | fv0 | fv5
	 fadd  aliasycenter                    # fv1 | fv0 | fv5
	 fxch  st(2)                           # fv5 | fv0 | fv1
	 fistp dword ptr [edi+FINALVERT_V5]    # fv0 | fv1
	 fistp dword ptr [edi+FINALVERT_V0]    # fv1
	 fistp dword ptr [edi+FINALVERT_V1]    # (empty)

	/'
	if (fv->v[0] < r_refdef.aliasvrect.x)
		fv->flags |= ALIAS_LEFT_CLIP;
	if (fv->v[1] < r_refdef.aliasvrect.y)
		fv->flags |= ALIAS_TOP_CLIP;
	if (fv->v[0] > r_refdef.aliasvrectright)
		fv->flags |= ALIAS_RIGHT_CLIP;
	if (fv->v[1] > r_refdef.aliasvrectbottom)
		fv->flags |= ALIAS_BOTTOM_CLIP;
	'/
	 mov eax, dword ptr [edi+FINALVERT_V0]
	 mov ebx, dword ptr [edi+FINALVERT_V1]


   'FIGURE OUT HOW TO ACCESS TYPE MEMBERS IN INLINE ASSEMBLY'''''''''

	' cmp eax, r_refdef.aliasvrect.x
	  cmp eax, r_refdef_aliasvrect_x
	 jge ct_alias_top
	 or  edx, ALIAS_LEFT_CLIP
ct_alias_top:
	 'cmp ebx, r_refdef.aliasvrect.y
	  cmp ebx, r_refdef_aliasvrect_y
	 jge ct_alias_right
	 or edx, ALIAS_TOP_CLIP
ct_alias_right:
	 'cmp eax, r_refdef.aliasvrectright
	  cmp eax, r_refdef_aliasvrectright
	 
	 jle ct_alias_bottom
	 or edx, ALIAS_RIGHT_CLIP
ct_alias_bottom:
	' cmp ebx, r_refdef.aliasvrectbottom
	  cmp ebx, r_refdef_aliasvrectbottom
	
''''''''''''''''''''''''''''''''''''''''''''''''''''	
	 jle end_of_loop
	 or  edx, ALIAS_BOTTOM_CLIP

	 jmp end_of_loop

alias_z_clip:
	 or  edx, ALIAS_Z_CLIP

end_of_loop:

	 mov dword ptr [edi+FINALVERT_FLAGS], edx
	 add oldv, DTRIVERTX_SIZE
	 add newv, DTRIVERTX_SIZE
	 add fv, FINALVERT_SIZE

	 dec ecx
	 jnz top_of_loop
end asm 
end sub
#endif





