'FINISSHED FOR NOW/////////////////////////////////////////////////

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


/'
** R_AliasCheckFrameBBox
**
** Checks a specific alias frame bounding box
'/
function R_AliasCheckFrameBBox( frame as daliasframe_t ptr, worldxf() as float  ) as ulong 
 
	 dim as ulong aggregate_and_clipcode = not(0U),aggregate_or_clipcode = 0   
 	                
	 dim as integer           i 
	 dim as vec3_t        mins, maxs 
	 dim as vec3_t        transformed_min, transformed_max 
	 dim as qboolean      zclipped = false, zfullyclipped = true 
	 dim  as float         minz = 9999.0F 

	'/*
	'** get the exact frame bounding box
	'*/
 
    for i = 0 to 3-1
      mins.v(i) = frame->translate(i) 
	 	maxs.v(i) = mins.v(i) + frame->scale(i)*255
    	
    Next
 

	'/*
	'** transform the min and max values into view space
	'*/
	 R_AliasTransformVector(@mins, @transformed_min, aliastransform() ) 
	 R_AliasTransformVector( @maxs, @transformed_max, aliastransform() ) 

	 if ( transformed_min.v(2) >= ALIAS_Z_CLIP_PLANE ) then
	 	zfullyclipped = false
	 EndIf
 
	 if ( transformed_max.v(2) >= ALIAS_Z_CLIP_PLANE ) then
	 	zfullyclipped = false 
	 EndIf
	 	

	 if ( zfullyclipped ) then
	 	return BBOX_TRIVIAL_REJECT
	 EndIf
 
	 if ( zclipped ) then
 
 		return ( BBOX_MUST_CLIP_XY or BBOX_MUST_CLIP_Z ) 
	end if

	'/*
	'** build a transformed bounding box from the given min and max
	'*/
 
	for i = 0 to 8-1
		
	
 		dim as integer      j 
	 	dim  as vec3_t   tmp, transformed 
	 	dim as ulong clipcode = 0 

	 	if ( i and 1 ) then
	 		tmp.v(0) = mins.v(0) 
	 	else
	 		tmp.v(0) = maxs.v(0)
	 	end if

	 	if ( i and 2 ) then
	 		tmp.v(1) = mins.v(1)
	 		
	 		else
	 tmp.v(1) = maxs.v(1)
	 	EndIf
 

	 	if ( i and 4 ) then 
	      tmp.v(2) = mins.v(2) 
	 	else
	 		tmp.v(2) = maxs.v(2)
	 	EndIf


	 	R_AliasTransformVector( @tmp, @transformed,  worldxf() ) 

 
	 for j = 0 to 4-1
	 	
	   	dim as float dp = _DotProduct( @transformed, @view_clipplanes(j).normal ) 

	 		if ( ( dp - view_clipplanes(j).dist ) < 0.0F ) then
	 			clipcode or= 1 shl j
	 		EndIf
	 next
	 
	   

	 	aggregate_and_clipcode and= clipcode 
	 	aggregate_or_clipcode  or= clipcode 
	Next

	 if ( aggregate_and_clipcode ) then
	  
 		return BBOX_TRIVIAL_REJECT 
	end if
	 if ( aggregate_or_clipcode = NULL) then
	 
 		return BBOX_TRIVIAL_ACCEPT 
	end if

	 return BBOX_MUST_CLIP_XY 
end function

function R_AliasCheckBBox () as qboolean 
 
	dim as ulong ccodes(2) => { 0, 0 } 

	'ccodes(0) = R_AliasCheckFrameBBox( r_thisframe, aliasworldtransform ) 

	/'
	** non-lerping model
	'/
if ( currententity->backlerp =  0 ) then
	   if ( ccodes(0) = BBOX_TRIVIAL_ACCEPT ) then
			return BBOX_TRIVIAL_ACCEPT 
	   elseif ( ccodes(0) and BBOX_TRIVIAL_REJECT ) then
			return BBOX_TRIVIAL_REJECT 
		else
			return ( ccodes(0) and not(BBOX_TRIVIAL_REJECT) ) 
      EndIf
EndIf
	 

	'ccodes(1) = R_AliasCheckFrameBBox( r_lastframe, aliasoldworldtransform ) 

	if ( ( ccodes(0) or ccodes(1) ) = BBOX_TRIVIAL_ACCEPT ) then
		return BBOX_TRIVIAL_ACCEPT 
	elseif ( ( ccodes(0) and ccodes(1) ) and BBOX_TRIVIAL_REJECT ) then
		return BBOX_TRIVIAL_REJECT 
	else
		return ( ccodes(0) or ccodes(1) ) and not(BBOX_TRIVIAL_REJECT)
	end if 
end function




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
 

/'
================
R_AliasPreparePoints

General clipped case
================
'/
type aliasbatchedtransformdata_t
 
	as integer          num_points 
	as dtrivertx_t  ptr last_verts    '// verts from the last frame
	as dtrivertx_t  ptr this_verts    '// verts from this frame
	as finalvert_t  ptr dest_verts    '// destination for transformed verts
end type 

dim shared as  aliasbatchedtransformdata_t aliasbatchedtransformdata 

sub R_AliasPreparePoints ()
  dim as integer			i  
  dim as dstvert_t	ptr pstverts 
  dim as dtriangle_t	ptr ptri 
  dim as finalvert_t	ptr pfv(3) 
  dim as finalvert_t	finalverts(MAXALIASVERTS + _
 						((CACHE_SIZE - 1) / sizeof(finalvert_t)) + 3)
  dim as finalvert_t	ptr  pfinalverts 
  
	'//PGM
	  iractive = ((r_newrefdef.rdflags and RDF_IRGOGGLES) and (currententity->flags and RF_IR_VISIBLE)) 
  '  	iractive = 0 
  ' 	if( (r_newrefdef.rdflags and RDF_IRGOGGLES) andalso (currententity->flags and RF_IR_VISIBLE))
   ' 		iractive = 1 
    '	end if	
    '//PGM
    
    
    '	// put work vertexes on stack, cache aligned
 	pfinalverts = cast(finalvert_t ptr, _
 			 ((cast(long,@finalverts(0)) + CACHE_SIZE - 1) and not(CACHE_SIZE - 1))) 
 
 	aliasbatchedtransformdata.num_points = s_pmdl->num_xyz 
 	aliasbatchedtransformdata.last_verts = @r_lastframe->verts(0) 
 	aliasbatchedtransformdata.this_verts = @r_thisframe->verts(0) 
 	aliasbatchedtransformdata.dest_verts = pfinalverts 
 
 
	R_AliasTransformFinalVerts( aliasbatchedtransformdata.num_points, _
		                         aliasbatchedtransformdata.dest_verts, _
								       aliasbatchedtransformdata.last_verts, _
								       aliasbatchedtransformdata.this_verts ) 

    
 '
'// clip and draw all triangles
'//
 	pstverts = cast(dstvert_t ptr,  (cast(byte ptr, s_pmdl) + s_pmdl->ofs_st)) 
 	ptri = cast(dtriangle_t ptr ,(cast(ubyte ptr,s_pmdl) + s_pmdl->ofs_tris))
 	
 	
 		if (  currententity->flags and RF_WEAPONMODEL   andalso  r_lefthand->value =  1.0F   ) then
 			
 		 
 			
 			
 			for i = 0 to s_pmdl->num_tris - 1
 				
    		pfv(0) = @pfinalverts[ptri->index_xyz(0)]
 			pfv(1) = @pfinalverts[ptri->index_xyz(1)] 
 			pfv(2) = @pfinalverts[ptri->index_xyz(2)] 
 
 			if ( pfv(0)->flags and pfv(1)->flags and pfv(2)->flags ) then
 				continue for  '// completely clipped
 			EndIf
 						
 
'			// insert s/t coordinates
 			pfv(0)->s = pstverts[ptri->index_st(0)].s shl 16 
 			pfv(0)->t = pstverts[ptri->index_st(0)].t shl 16 
 
 			pfv(1)->s = pstverts[ptri->index_st(1)].s shl 16 
 			pfv(1)->t = pstverts[ptri->index_st(1)].t shl 16 
 
 			pfv(2)->s = pstverts[ptri->index_st(2)].s shl 16 
 			pfv(2)->t = pstverts[ptri->index_st(2)].t shl 16 
 				
 				
 				if (  (pfv(0)->flags or pfv(1)->flags or pfv(2)->flags) = NULL) then
 			   aliastriangleparms.a = pfv(2)
  				aliastriangleparms.b = pfv(1)
 				aliastriangleparms.c = pfv(0)
 
 				R_DrawTriangle() 
 			else
 
 				'R_AliasClipTriangle (pfv(2), pfv(1), pfv(0)) 
 				end if
 
 		 		ptri+=1
 				
 			Next
 	 
 	else			
 				
 
	 
	 for i = 0 to s_pmdl->num_tris -1
	 
			pfv(0) = @pfinalverts[ptri->index_xyz(0)] 
			pfv(1) = @pfinalverts[ptri->index_xyz(1)] 
			pfv(2) = @pfinalverts[ptri->index_xyz(2)] 

				
 				if (  (pfv(0)->flags or pfv(1)->flags or pfv(2)->flags) ) then
				continue for 		'// completely clipped
            end if
			'// insert s/t coordinates
			pfv(0)->s = pstverts[ptri->index_st(0)].s shl 16 
			pfv(0)->t = pstverts[ptri->index_st(0)].t shl 16 

			pfv(1)->s = pstverts[ptri->index_st(1)].s shl 16 
			pfv(1)->t = pstverts[ptri->index_st(1)].t shl 16 

			pfv(2)->s = pstverts[ptri->index_st(2)].s shl 16 
			pfv(2)->t = pstverts[ptri->index_st(2)].t shl 16 

			if (  (pfv(0)->flags or pfv(1)->flags or pfv(2)->flags) = NULL) then
			 	'// totally unclipped
				aliastriangleparms.a = pfv(0)
				aliastriangleparms.b = pfv(1)
				aliastriangleparms.c = pfv(2)

				R_DrawTriangle() 
			 
			else		
			 	'// partially clipped
				'R_AliasClipTriangle (pfv[0], pfv[1], pfv[2]);
			end if
		next
	 	
 			 
 			
 EndIf
 	
 	   
	
End Sub
 


/'
================
R_AliasSetUpTransform
================
'/
sub R_AliasSetUpTransform ()
 
	dim as integer				i 
	static as float	viewmatrix(3,4)
	dim as vec3_t			angles 

''// TODO: should really be stored with the entity instead of being reconstructed
''// TODO: should use a look-up table
''// TODO: could cache lazily, stored in the entity
   
 	angles.v(ROLL) = currententity->angles(ROLL)
	angles.v(PITCH) = currententity->angles(PITCH)
	angles.v(YAW) = currententity->angles(YAW)
	AngleVectors( @angles, @s_alias_forward, @s_alias_right, @s_alias_up )
'
''// TODO: can do this with simple matrix rearrangement
'
 	memset( @aliasworldtransform(0,0), 0, sizeof( aliasworldtransform(0,0) ) * ubound(aliasworldtransform) ) 
 	 memset( @aliasoldworldtransform(0,0), 0, sizeof( aliasworldtransform(0,0) ) * ubound(aliasworldtransform) ) 
 
 	for  i=0 to  3  

 		aliasoldworldtransform(i,0) = aliasworldtransform(i,0) =  s_alias_forward.v(i) 
 		aliasoldworldtransform(i,0) = aliasworldtransform(i,1) = -s_alias_right.v(i) 
 		aliasoldworldtransform(i,0) = aliasworldtransform(i,2) =  s_alias_up.v(i) 
 	next
 
	aliasworldtransform(0,3) = currententity->origin(0)-r_origin.v(0) 
	aliasworldtransform(1,3) = currententity->origin(1)-r_origin.v(1) 
	aliasworldtransform(2,3) = currententity->origin(2)-r_origin.v(2) 

	aliasoldworldtransform(0,3) = currententity->origin(0)-r_origin.v(0)
	aliasoldworldtransform(1,3) = currententity->origin(1)-r_origin.v(1)
	aliasoldworldtransform(2,3) = currententity->origin(2)-r_origin.v(2) 
'
''// FIXME: can do more efficiently than full concatenation
''//	memcpy( rotationmatrix, t2matrix, sizeof( rotationmatrix ) );
'
''//	R_ConcatTransforms (t2matrix, tmatrix, rotationmatrix);
'
 '// TODO: should be global, set when vright, etc., set
 	_VectorCopy (@vright, @viewmatrix(0,0)) 
 	_VectorCopy (@vup, @viewmatrix(1,0)) 
 	VectorInverse (@viewmatrix(1,0)) 
 	_VectorCopy (@vpn, @viewmatrix(2,0)) 
 
 	viewmatrix(0,3) = 0 
 	viewmatrix(1,3) = 0 
 	viewmatrix(2,3) = 0 
 
 '//	memcpy( aliasworldtransform, rotationmatrix, sizeof( aliastransform ) ) 
 
 	 R_ConcatTransforms (viewmatrix(), aliasworldtransform(), aliastransform()) 
 
 	aliasworldtransform(0,3) = currententity->origin(0) 
 	aliasworldtransform(1,3) = currententity->origin(1) 
 	aliasworldtransform(2,3) = currententity->origin(2) 
 
 	aliasoldworldtransform(0,3) = currententity->oldorigin(0) 
 	aliasoldworldtransform(1,3) = currententity->oldorigin(1) 
 	aliasoldworldtransform(2,3) = currententity->oldorigin(2)
end sub


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



#else
sub R_AliasTransformFinalVerts( numpoints as integer ,fv as  finalvert_t ptr,oldv as  dtrivertx_t ptr,newv  as  dtrivertx_t ptr)
'{'
	'int i;'

'	for ( i = 0; i < numpoints; i++, fv++, oldv++, newv++ )
'	{
'		int		temp;
'		float	lightcos, *plightnormal;
'		vec3_t  lerped_vert;
'
'		lerped_vert[0] = r_lerp_move[0] + oldv->v[0]*r_lerp_backv[0] + newv->v[0]*r_lerp_frontv[0];
'		lerped_vert[1] = r_lerp_move[1] + oldv->v[1]*r_lerp_backv[1] + newv->v[1]*r_lerp_frontv[1];
'		lerped_vert[2] = r_lerp_move[2] + oldv->v[2]*r_lerp_backv[2] + newv->v[2]*r_lerp_frontv[2];
'
'		plightnormal = r_avertexnormals[newv->lightnormalindex];
'
'		// PMM - added double damage shell
'		if ( currententity->flags & ( RF_SHELL_RED | RF_SHELL_GREEN | RF_SHELL_BLUE | RF_SHELL_DOUBLE | RF_SHELL_HALF_DAM) )
'		{
'			lerped_vert[0] += plightnormal[0] * POWERSUIT_SCALE;
'			lerped_vert[1] += plightnormal[1] * POWERSUIT_SCALE;
'			lerped_vert[2] += plightnormal[2] * POWERSUIT_SCALE;
'		}
'
'		fv->xyz[0] = DotProduct(lerped_vert, aliastransform[0]) + aliastransform[0][3];
'		fv->xyz[1] = DotProduct(lerped_vert, aliastransform[1]) + aliastransform[1][3];
'		fv->xyz[2] = DotProduct(lerped_vert, aliastransform[2]) + aliastransform[2][3];
'
'		fv->flags = 0;
'
'		// lighting
'		lightcos = DotProduct (plightnormal, r_plightvec);
'		temp = r_ambientlight;
'
'		if (lightcos < 0)
'		{
'			temp += (int)(r_shadelight * lightcos);
'
'			// clamp; because we limited the minimum ambient and shading light, we
'			// don't have to clamp low light, just bright
'			if (temp < 0)
'				temp = 0;
'		}
'
'		fv->l = temp;
'
'		if ( fv->xyz[2] < ALIAS_Z_CLIP_PLANE )
'		{
'			fv->flags |= ALIAS_Z_CLIP;
'		}
'		else
'		{
'			R_AliasProjectAndClipTestFinalVert( fv );
'		}
'	}
end sub







#endif





/'
================
R_AliasProjectAndClipTestFinalVert
================
'/
sub R_AliasProjectAndClipTestFinalVert( fv as finalvert_t ptr )
 
	dim as float	zi 
	dim as float	x, y, z
	
	'// project points
	x = fv->xyz(0) 
	y = fv->xyz(1) 
	z = fv->xyz(2) 
	zi = 1.0 / z 

	fv->zi = zi * s_ziscale 

	fv->u = (x * aliasxscale * zi) + aliasxcenter 
	fv->v = (y * aliasyscale * zi) + aliasycenter 

	if (fv->u < r_refdef.aliasvrect.x) then
		fv->flags or= ALIAS_LEFT_CLIP 	
	EndIf
	
	if (fv->v < r_refdef.aliasvrect.y) then
		fv->flags or= ALIAS_TOP_CLIP 
	EndIf
		
	if (fv->u > r_refdef.aliasvrectright) then
		fv->flags or= ALIAS_RIGHT_CLIP 
	EndIf
		
	if (fv->v > r_refdef.aliasvrectbottom ) then
				fv->flags or= ALIAS_BOTTOM_CLIP 
	EndIf
	
end sub

 
/'
===============
R_AliasSetupSkin
===============
'/
 function R_AliasSetupSkin () as qboolean static
 
	dim as integer				skinnum 
	dim as image_t		ptr	pskindesc 

	if (currententity->skin) then
		pskindesc = currententity->skin 
	else
 
		skinnum = currententity->skinnum 
		if ((skinnum >= s_pmdl->num_skins) or (skinnum < 0)) then
			
	 
			ri.Con_Printf (PRINT_ALL, !"R_AliasSetupSkin %s: no such skin # %d\n", _
				currentmodel->_name, skinnum) 
			skinnum = 0 
		end if

		pskindesc = currentmodel->skins(skinnum) 
	end if

	if (  pskindesc = NULL ) then
		return false 
	EndIf
		

	r_affinetridesc.pskin = pskindesc->pixels(0) 
	r_affinetridesc.skinwidth = pskindesc->_width 
	r_affinetridesc.skinheight = pskindesc->_height 

	R_PolysetUpdateTables () 		'// FIXME: precalc edge lookups

	return true 
end function




/'
================
R_AliasSetupLighting

  FIXME: put lighting into tables
================
'/
sub R_AliasSetupLighting ()
 
   dim as  alight_t		lighting 
 	dim as float			lightvec(3) = {-1, 0, 0} 
 	dim as vec3_t			light 
 	dim as integer				i, j 
 
'	// all components of light should be identical in software
 	if ( currententity->flags and RF_FULLBRIGHT ) then
 
 		for  i=0 to 3-1
 		
 		light.v(i) = 1.0 
 		Next
 			
 
 	else
 
 		R_LightPoint (@currententity->origin(0), @light) 
 	end if
'
'	// save off light value for server to look at (BIG HACK!)
 	if ( currententity->flags and RF_WEAPONMODEL ) then
 		r_lightlevel->value = 150.0 * light.v(0)
 	EndIf
 
 	if ( currententity->flags and RF_MINLIGHT ) then
 		for  i=0  to 3-1
 			if (light.v(i) < 0.1) then
 				light.v(i) = 0.1
 			
 			end if 
 			next	
 	EndIf
 
 
 	if ( currententity->flags and RF_GLOW ) then
'	 	// bonus items will pulse with time
 		dim as float	scale 
 		dim as float	min 
 
 		scale = 0.1 * sin(r_newrefdef._time*7) 
 		for i = 0 to 3-1
 		    min = light.v(i) * 0.8 
 		   light.v(i) += scale 
 			if (light.v(i) < min) then
 				light.v(i) = min 
 			EndIf
 				
 			
 		Next
   end if
 
 	j = (light.v(0) + light.v(1) + light.v(2))*0.3333*255 
 
 	lighting.ambientlight = j 
 	lighting.shadelight = j 
 
 	lighting.plightvec = @lightvec(0)  
 
'// clamp lighting so it doesn't overbright as much
 	if (lighting.ambientlight > 128) then
 		lighting.ambientlight = 128 
 	EndIf
 

  	if (lighting.ambientlight + lighting.shadelight > 192) then
  		lighting.shadelight = 192 - lighting.ambientlight
  	EndIf
 
'// guarantee that no vertex will ever be lit below LIGHT_MIN, so we don't have
'// to clamp off the bottom
 	r_ambientlight = lighting.ambientlight 
 
 	if (r_ambientlight < LIGHT_MIN) then
 		r_ambientlight = LIGHT_MIN 
 	EndIf

 	r_ambientlight = (255 - r_ambientlight) shl VID_CBITS 
'
 	if (r_ambientlight < LIGHT_MIN) then
 		r_ambientlight = LIGHT_MIN 
 	EndIf

  
 	r_shadelight = lighting.shadelight 
 
 	if (r_shadelight < 0) then
 		r_shadelight = 0
 	EndIf
 
 	r_shadelight *= VID_GRADES 
'
'// rotate the lighting vector into the model's frame of reference
 	r_plightvec.v(0) =  _DotProduct( lighting.plightvec, @s_alias_forward ) 
 	r_plightvec.v(1) = -_DotProduct( lighting.plightvec, @s_alias_right ) 
 	r_plightvec.v(2) =  _DotProduct( lighting.plightvec, @s_alias_up ) 
end sub








/'
=================
R_AliasSetupFrames

=================
'/
sub R_AliasSetupFrames( pmdl as dmdl_t ptr )
	
		dim as integer thisframe = currententity->frame 
	dim as integer lastframe = currententity->oldframe 

	if ( ( thisframe >= pmdl->num_frames ) or ( thisframe < 0 ) ) then
	 
		ri.Con_Printf (PRINT_ALL, !"R_AliasSetupFrames %s: no such thisframe %d\n", _  
			currentmodel->_name, thisframe) 
		thisframe = 0 
	end if
	if ( ( lastframe >= pmdl->num_frames ) or ( lastframe < 0 ) ) then
		ri.Con_Printf (PRINT_ALL, !"R_AliasSetupFrames %s: no such lastframe %d\n",  _
 			currentmodel->_name, lastframe) 
 		lastframe = 0 
	EndIf
 
 
 	r_thisframe = cast(daliasframe_t ptr, (cast(ubyte ptr, pmdl)  + pmdl->ofs_frames _
 		+ thisframe * pmdl->framesize)) 
 
  	r_thisframe = cast(daliasframe_t ptr, (cast(ubyte ptr, pmdl)  + pmdl->ofs_frames _
 		+ thisframe * pmdl->framesize)) 
 


	
End Sub

/'
** R_AliasSetUpLerpData
**
** Precomputes lerp coefficients used for the whole frame.
'/
sub R_AliasSetUpLerpData(pmdl as  dmdl_t ptr,backlerp as float  )
 
	dim as float	frontlerp 
	dim as vec3_t	translation, vectors(3) 
	dim as integer		i 

	frontlerp = 1.0F - backlerp 

	/'
	** convert entity's angles into discrete vectors for R, U, and F
	'/
	AngleVectors (@currententity->angles(0), @vectors(0), @vectors(1), @vectors(2)) 

	/'
	** translation is the vector from last position to this position
	'/
	_VectorSubtract (@currententity->oldorigin(0), @currententity->origin(0), @translation) 

	/'
	** move should be the delta back to the previous frame * backlerp
	'/
	r_lerp_move.v(0) =  _DotProduct(@translation, @vectors(0))	'// forward
	r_lerp_move.v(1) = -_DotProduct(@translation, @vectors(1))	'// left
	r_lerp_move.v(2) =  _DotProduct(@translation, @vectors(2))	'// up

	_VectorAdd(@r_lerp_move, @r_lastframe->translate(0), @r_lerp_move ) 

 for i =0 to 3-1
 r_lerp_move.v(i) = backlerp*r_lerp_move.v(i) + frontlerp * r_thisframe->translate(i)
 next
		
 

	 for i =0 to 3-1
	 
		r_lerp_frontv.v(i)  = frontlerp * r_thisframe->scale(i) 
		r_lerp_backv.v(i)  = backlerp  * r_lastframe->scale(i)
	 next
end sub















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
 	s_pmdl = cast(dmdl_t ptr ,currentmodel->extradata) 
 
 	if ( r_lerpmodels->value = 0 ) then
 		currententity->backlerp = 0
 	EndIf
 
 
 	if ( currententity->flags and RF_WEAPONMODEL ) then
 		if ( r_lefthand->value = 1.0F ) then
 			aliasxscale = -aliasxscale
 		EndIf
 	elseif ( r_lefthand->value = 2.0F ) then
 			return 
 	EndIf
 
'
'	/*
'	** we have to set our frame pointers and transformations before
'	** doing any real work
'	*/
 	R_AliasSetupFrames( s_pmdl ) 
 	R_AliasSetUpTransform() 
'
'	// see if the bounding box lets us trivially reject, also sets
'	// trivial accept status
 	if ( R_AliasCheckBBox() = BBOX_TRIVIAL_REJECT ) then
 
 		if ( ( currententity->flags and RF_WEAPONMODEL ) andalso ( r_lefthand->value =  1.0F ) ) then
 
 			aliasxscale = -aliasxscale 
 
 			return 
 		end if
 	end if
 	
'	// set up the skin and verify it exists
 	if (  R_AliasSetupSkin () = NULL ) then
 		ri.Con_Printf( PRINT_ALL, !"R_AliasDrawModel %s: NULL skin found\n", _
 			currentmodel->_name)
 			return
 	EndIf
 
 
 
 	r_amodels_drawn+=1
 	R_AliasSetupLighting () 
 
'	/*
'	** select the proper span routine based on translucency
'	*/
'	// PMM - added double damage shell
'	// PMM - reordered to handle blending
 if ( currententity->flags and ( RF_SHELL_RED or RF_SHELL_GREEN or RF_SHELL_BLUE or RF_SHELL_DOUBLE or RF_SHELL_HALF_DAM) ) then
 
 		 dim as integer		_color 
'
'		// PMM - added double
 		_color = currententity->flags and ( RF_SHELL_RED or RF_SHELL_GREEN or RF_SHELL_BLUE or RF_SHELL_DOUBLE or RF_SHELL_HALF_DAM) 
'		// PMM - reordered, new shells after old shells (so they get overriden)
'
 		if ( color =  RF_SHELL_RED ) then
 			r_aliasblendcolor = SHELL_RED_COLOR 
 		elseif ( color = RF_SHELL_GREEN ) then
 			r_aliasblendcolor = SHELL_GREEN_COLOR 
 		elseif ( color = RF_SHELL_BLUE ) then
 			r_aliasblendcolor = SHELL_BLUE_COLOR 
 		elseif ( color = (RF_SHELL_RED or RF_SHELL_GREEN) ) then
 			r_aliasblendcolor = SHELL_RG_COLOR 
 		elseif ( color = (RF_SHELL_RED or RF_SHELL_BLUE) ) then
 			r_aliasblendcolor = SHELL_RB_COLOR 
 		elseif ( color = (RF_SHELL_BLUE or RF_SHELL_GREEN) ) then
 			r_aliasblendcolor = SHELL_BG_COLOR 
'		// PMM - added this .. it's yellowish
 		elseif ( color = (RF_SHELL_DOUBLE) ) then
 			r_aliasblendcolor = SHELL_DOUBLE_COLOR 
 		elseif ( color = (RF_SHELL_HALF_DAM) ) then
 			r_aliasblendcolor = SHELL_HALF_DAM_COLOR 
'		// pmm
   	else
   		r_aliasblendcolor = SHELL_WHITE_COLOR
   	end if
 /'		if ( color & RF_SHELL_RED )
 		{
 			if ( ( color & RF_SHELL_BLUE) && ( color & RF_SHELL_GREEN) )
 				r_aliasblendcolor = SHELL_WHITE_COLOR;
 			else if ( color & (RF_SHELL_BLUE | RF_SHELL_DOUBLE))
 				r_aliasblendcolor = SHELL_RB_COLOR;
 			else
 				r_aliasblendcolor = SHELL_RED_COLOR;
 		}
 		else if ( color & RF_SHELL_BLUE)
 		{
 			if ( color & RF_SHELL_DOUBLE )
 				r_aliasblendcolor = SHELL_CYAN_COLOR;
 			else
 				r_aliasblendcolor = SHELL_BLUE_COLOR;
 		}
 		else if ( color & (RF_SHELL_DOUBLE) )
 			r_aliasblendcolor = SHELL_DOUBLE_COLOR;
 		else if ( color & (RF_SHELL_HALF_DAM) )
 			r_aliasblendcolor = SHELL_HALF_DAM_COLOR;
 		else if ( color & RF_SHELL_GREEN )
 			r_aliasblendcolor = SHELL_GREEN_COLOR;
 		else
 			r_aliasblendcolor = SHELL_WHITE_COLOR;
 '/
 
 		if ( currententity->alpha_ > 0.33 ) then
 			'd_pdrawspans = @R_PolysetDrawSpansConstant8_66()
 		else
 			'd_pdrawspans = @R_PolysetDrawSpansConstant8_33()
 		end if
 
   elseif ( currententity->flags and RF_TRANSLUCENT ) then
 
 		if ( currententity->alpha_ > 0.66 ) then 
 		'	d_pdrawspans = @R_PolysetDrawSpans8_Opaque 
 		elseif ( currententity->alpha_ > 0.33 ) then
 			'd_pdrawspans = @R_PolysetDrawSpans8_66() 
 		else
 		'	d_pdrawspans = @R_PolysetDrawSpans8_33()
 		end if
 
 	else
 
 		'd_pdrawspans = @R_PolysetDrawSpans8_Opaque()
 	end if
 
 	/'
 	** compute this_frame and old_frame addresses
 	'/
 	R_AliasSetUpLerpData( s_pmdl, currententity->backlerp ) 
 
 	if (currententity->flags and RF_DEPTHHACK) then
 		s_ziscale = cast(float,&H8000) * cast(float,&H10000) * 3.0 
 	else
 		s_ziscale = cast(float,&H8000) * cast(float,&H10000)
 	end if
 
 	R_AliasPreparePoints () 
 
 	if ( ( currententity->flags and RF_WEAPONMODEL ) andalso ( r_lefthand->value  = 1.0F ) ) then
 
 		aliasxscale = -aliasxscale 
 	end if
 	
	
End Sub
