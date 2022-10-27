'#include <assert.h>
#Include "FB_Ref_Soft\r_local.bi"

 

static shared as integer r_polyblendcolor 

dim shared as polydesc_t	r_polydesc

static shared as integer		clip_current 
dim shared as vec5_t	r_clip_verts(2,MAXWORKINGVERTS+2) 
 


sub R_DrawSpanletConstant33
	
End Sub


	sub R_DrawAlphaSurfaces()
		
		
	End Sub
	
/'
** R_ClipAndDrawPoly
'/
'// PGM - isturbulent was qboolean. changed to int to allow passing more flags
sub R_ClipAndDrawPoly ( alpha_ as float , isturbulent as integer , textured as qboolean )
 
   dim as emitpoint_t	outverts(MAXWORKINGVERTS+3)
   dim as emitpoint_t ptr pout 
   dim as	float		ptr pv 
 	dim as integer			i, nump 
 	dim as float		scale 
   dim as	vec3_t		transformed, _local 
 
 	if (  textured = _false) then
 
 		'r_polydesc.drawspanlet = @R_DrawSpanletConstant33() 
 	 
 	else
 

		/'
		** choose the correct spanlet routine based on alpha
		'/
 		if ( alpha_ =  1 ) then
 		 
 			'// isturbulent is ignored because we know that turbulent surfaces
 			'// can't be opaque
 '			r_polydesc.drawspanlet = R_DrawSpanletOpaque;
 
 		else
 
 			if ( sw_stipplealpha->value ) then
 		 
 			   if ( isturbulent ) then
 			  	
 			 
 			 
 					if ( alpha_ > 0.33 ) then
'						r_polydesc.drawspanlet = R_DrawSpanletTurbulentStipple66;
 					else 
'						r_polydesc.drawspanlet = R_DrawSpanletTurbulentStipple33;
 					end if
 
 				else
 
 					if ( alpha_ > 0.33 ) then
'						r_polydesc.drawspanlet = R_DrawSpanlet66Stipple;
 					else 
'						r_polydesc.drawspanlet = R_DrawSpanlet33Stipple;
 			      end if
 				end if
 
 			else
 
   			if ( isturbulent ) then
 				 
 					if ( alpha_ > 0.33 ) then
'						r_polydesc.drawspanlet = R_DrawSpanletTurbulentBlended66;
 					else
'						r_polydesc.drawspanlet = R_DrawSpanletTurbulentBlended33;
					end if
 			 
 				else
				 
 					if ( alpha_ > 0.33 ) then
'						r_polydesc.drawspanlet = R_DrawSpanlet66;
 					else 
 '						r_polydesc.drawspanlet = R_DrawSpanlet33;
 					end if
 				end if
 			end if
 		end if
 	end if
 	
 	
 	'// clip to the frustum in worldspace
	nump = r_polydesc.nump 
	clip_current = 0 
'
 	 for i = 0 to 4-1
 
'		nump = R_ClipPolyFace (nump, &view_clipplanes[i]);
 		if (nump < 3) then
 			return
 		EndIf
    	if (nump > MAXWORKINGVERTS) then
    		ri.Sys_Error(ERR_DROP, "R_ClipAndDrawPoly: too many points: %d", nump )
    	EndIf
 			 
	 next
 
 '// transform vertices into viewspace and project
 	pv = @r_clip_verts(clip_current,0).v(0) 
 
  	for  i=0 to nump -1
  		_VectorSubtract (pv, @r_origin, @_local)
  		 TransformVector (@_local, @transformed)
 		if (transformed.v(2) < NEAR_CLIP) then
 		transformed.v(2) = NEAR_CLIP	
 		EndIf
 		 
  		pout = @outverts(i) 
  		pout->zi = 1.0 / transformed.v(2)
  		pout->s = pv[3] 
		pout->t = pv[4] 

  	Next
 
 	
 		scale = xscale * pout->zi 
 		pout->u = (xcenter + scale * transformed.v(0)) 
 
 		scale = yscale * pout->zi 
 		pout->v = (ycenter - scale * transformed.v(1)) 
 
   	pv +=  sizeof (vec5_t) \ sizeof ((pv))  
 
'
'// draw it
 	r_polydesc.nump = nump 
 	r_polydesc.pverts = @outverts(0) 
'
'	R_DrawPoly( isturbulent );	
' 	
 	
 	
 	
 	
 	
 	
 	
 	
end sub
	
	
/'
** R_IMFlatShadedQuad
'/
sub R_IMFlatShadedQuad(  a as vec3_t ptr, b as vec3_t ptr,c as  vec3_t ptr ,d as vec3_t ptr , _color as  integer ,alpha_ as  float  ) 

	 	dim as vec3_t s0, s1 
	'
	'
	'
	'VectorNormalize( r_polydesc.vpn )
	'
	 r_polyblendcolor = _color
	'
	  R_ClipAndDrawPoly( alpha_,  _false,  _false ) 
End Sub
 


'	r_polydesc.nump = 4;
'	VectorCopy( r_origin, r_polydesc.viewer_position );
'
'	VectorCopy( a, r_clip_verts[0][0] );
'	VectorCopy( b, r_clip_verts[0][1] );
'	VectorCopy( c, r_clip_verts[0][2] );
'	VectorCopy( d, r_clip_verts[0][3] );
'
'	r_clip_verts[0][0][3] = 0;
'	r_clip_verts[0][1][3] = 0;
'	r_clip_verts[0][2][3] = 0;
'	r_clip_verts[0][3][3] = 0;
'
'	r_clip_verts[0][0][4] = 0;
'	r_clip_verts[0][1][4] = 0;
'	r_clip_verts[0][2][4] = 0;
'	r_clip_verts[0][3][4] = 0;
'
'	VectorSubtract( d, c, s0 );
'	VectorSubtract( c, b, s1 );
'	CrossProduct( s0, s1, r_polydesc.vpn );
'	;
'
'	r_polydesc.dist = DotProduct( r_polydesc.vpn, r_clip_verts[0][0] );
'
'	;
'
 
