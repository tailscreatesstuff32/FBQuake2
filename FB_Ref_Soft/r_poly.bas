
'FINISHED FOR NOW//////////////////////////////////////////////////////////
'#include <assert.h>
#Include "FB_Ref_Soft\r_local.bi"

 


 
 
 #define AFFINE_SPANLET_SIZE      16
#define AFFINE_SPANLET_SIZE_BITS 4

type spanletvars_t
	as ubyte  ptr   pbase,  pdest 
	as short	ptr pz 
	as fixed16_t s, t 
	as fixed16_t sstep, tstep 
	as integer       izi, izistep, izistep_times_2 
	as integer       spancount 
	as uinteger  u, v 
End Type
 

   

dim shared as spanletvars_t s_spanletvars 

 

static shared as espan_t	ptr s_polygon_spans 

 

dim as msurface_t ptr r_alpha_surfaces 

extern as integer ptr r_turb_turb 


 static shared as integer r_polyblendcolor 


dim shared as polydesc_t	r_polydesc

 static shared as integer		clip_current 
dim shared as vec5_t	r_clip_verts(2,MAXWORKINGVERTS+2)  

static shared as integer		s_minindex, s_maxindex 

/'
** R_DrawSpanletOpaque
'/
sub R_DrawSpanletOpaque()
 
	dim as uinteger btemp 

	do
	 
		dim as uinteger ts, tt 

		ts = s_spanletvars.s shr 16 
		tt = s_spanletvars.t shr 16 

		btemp = *(s_spanletvars.pbase + (ts) + (tt) * cachewidth) 
		 if (btemp <> 255) then
		 		if (*s_spanletvars.pz <= (s_spanletvars.izi shr 16)) then
	 
		 		*s_spanletvars.pz    = s_spanletvars.izi shr 16 
		 		*s_spanletvars.pdest = btemp 
		 
		 	 EndIf
		 EndIf
	 
		 s_spanletvars.izi += s_spanletvars.izistep 
		 s_spanletvars.pdest+=1
		 s_spanletvars.pz+=1 
		 s_spanletvars.s += s_spanletvars.sstep 
		 s_spanletvars.t += s_spanletvars.tstep 
		 s_spanletvars.spancount-=1
	 loop while (s_spanletvars.spancount > 0) 
end sub


	
sub	R_DrawSpanletTurbulentStipple33	
	dim as uinteger btemp 
	dim as integer	     sturb, tturb 
	dim as ubyte   ptr pdest = s_spanletvars.pdest 
	dim as short  ptr pz    = s_spanletvars.pz 
	dim as integer      izi   = s_spanletvars.izi 
	
	 if (  ( s_spanletvars.v and 1 ) = null ) then
	 
 		s_spanletvars.pdest += s_spanletvars.spancount 
	 	s_spanletvars.pz    += s_spanletvars.spancount 

	 	if ( s_spanletvars.spancount = AFFINE_SPANLET_SIZE ) then
	 		s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS 
	 	else
	 		s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep 
	 	end if
	 	if ( s_spanletvars.u and 1 ) then
	 	 		izi += s_spanletvars.izistep 
	 		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 

	 		pdest+=1
	 		pz+=1
	 		s_spanletvars.spancount-=1
	 		
	 		
	 	EndIf
 

	 	s_spanletvars.sstep   *= 2 
	 	s_spanletvars.tstep   *= 2 

	 	while ( s_spanletvars.spancount > 0 )
 
	 		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16) and (CYCLE-1)])  shr 16) and 63 
	 		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16) and (CYCLE-1)])  shr 16) and 63 
	 		
	 		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 
	 		
	 		if ( *pz <= ( izi shr 16 ) ) then
	 			*pdest = btemp 
	 		EndIf
	 			
	 		
	 		izi               += s_spanletvars.izistep_times_2 
	  		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 
	 		
	 		pdest += 2 
	 		pz    += 2 
	 		
	 		s_spanletvars.spancount -= 2 
	 	wend
	 
	 else
	 
 		s_spanletvars.pdest += s_spanletvars.spancount 
	 	s_spanletvars.pz    += s_spanletvars.spancount 

	 	if ( s_spanletvars.spancount =  AFFINE_SPANLET_SIZE ) then
	 		s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS
	 	else
	 		s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep 
	 	end if
	 
	 	while ( s_spanletvars.spancount > 0 )
	 
	 		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16) and (CYCLE-1)]) shr 16) and 63 
	 		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16) and (CYCLE-1)]) shr 16) and 63 
	 		
	 		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 
	 	
	 		if ( *pz <= ( izi shr 16 ) ) then
	 			*pdest = btemp
	 		EndIf
	 			 
	 	
	 		izi               += s_spanletvars.izistep 
	 		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 
	 		
	 		pdest+=1
	 		pz+=1
	 		
	 		s_spanletvars.spancount-=1
	 	wend
	 end if
End Sub


sub	R_DrawSpanletTurbulentStipple66()
	dim as uinteger btemp 
	dim as integer	     sturb, tturb 
	dim as ubyte   ptr pdest = s_spanletvars.pdest 
	dim as short  ptr pz    = s_spanletvars.pz 
	dim as integer      izi   = s_spanletvars.izi 
	
	 if (  ( s_spanletvars.v and 1 ) = null ) then
	 
 		s_spanletvars.pdest += s_spanletvars.spancount 
	 	s_spanletvars.pz    += s_spanletvars.spancount 

	 	if ( s_spanletvars.spancount = AFFINE_SPANLET_SIZE ) then
	 		s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS 
	 	else
	 		s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep 
	 	end if
	 	if ( s_spanletvars.u and 1 ) then
	 	 		izi += s_spanletvars.izistep 
	 		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 

	 		pdest+=1
	 		pz+=1
	 		s_spanletvars.spancount-=1
	 		
	 		
	 	EndIf
 

	 	s_spanletvars.sstep   *= 2 
	 	s_spanletvars.tstep   *= 2 

	 	while ( s_spanletvars.spancount > 0 )
 
	 		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16) and (CYCLE-1)])  shr 16) and 63 
	 		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16) and (CYCLE-1)])  shr 16) and 63 
	 		
	 		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 
	 		
	 		if ( *pz <= ( izi shr 16 ) ) then
	 			*pdest = btemp 
	 		EndIf
	 			
	 		
	 		izi               += s_spanletvars.izistep_times_2 
	  		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 
	 		
	 		pdest += 2 
	 		pz    += 2 
	 		
	 		s_spanletvars.spancount -= 2 
	 	wend
	 
	 else
	 
 		s_spanletvars.pdest += s_spanletvars.spancount 
	 	s_spanletvars.pz    += s_spanletvars.spancount 

	 	if ( s_spanletvars.spancount =  AFFINE_SPANLET_SIZE ) then
	 		s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS
	 	else
	 		s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep 
	 	end if
	 
	 	while ( s_spanletvars.spancount > 0 )
	 
	 		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16) and (CYCLE-1)]) shr 16) and 63 
	 		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16) and (CYCLE-1)]) shr 16) and 63 
	 		
	 		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 
	 	
	 		if ( *pz <= ( izi shr 16 ) ) then
	 			*pdest = btemp
	 		EndIf
	 			 
	 	
	 		izi               += s_spanletvars.izistep 
	 		s_spanletvars.s   += s_spanletvars.sstep 
	 		s_spanletvars.t   += s_spanletvars.tstep 
	 		
	 		pdest+=1
	 		pz+=1
	 		
	 		s_spanletvars.spancount-=1
	 	wend
	 end if
End Sub


sub		R_DrawSpanletTurbulentBlended66 
		dim as  	uinteger btemp 
	dim as integer    sturb, tturb 

	do
 
		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16)and(CYCLE-1)]) shr 16) and 63 
		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16)and(CYCLE-1)]) shr 16) and 63 

		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 

		if ( *s_spanletvars.pz <= ( s_spanletvars.izi shr 16 ) ) then
			*s_spanletvars.pdest = vid.alphamap[btemp*256+*s_spanletvars.pdest] 
		EndIf
			

		s_spanletvars.izi += s_spanletvars.izistep 
		s_spanletvars.pdest+=1
		s_spanletvars.pz+=1
		s_spanletvars.s += s_spanletvars.sstep 
		s_spanletvars.t += s_spanletvars.tstep 
		
	loop while (s_spanletvars.spancount > 0)
End Sub
	
sub		R_DrawSpanletTurbulentBlended33 
	dim as  	uinteger btemp 
	dim as integer    sturb, tturb 

	do
 
		sturb = ((s_spanletvars.s + r_turb_turb[(s_spanletvars.t shr 16)and(CYCLE-1)]) shr 16) and 63 
		tturb = ((s_spanletvars.t + r_turb_turb[(s_spanletvars.s shr 16)and(CYCLE-1)]) shr 16) and 63 

		btemp = *( s_spanletvars.pbase + ( sturb ) + ( tturb shl 6 ) ) 

		if ( *s_spanletvars.pz <= ( s_spanletvars.izi shr 16 ) ) then
			*s_spanletvars.pdest = vid.alphamap[btemp+*s_spanletvars.pdest*256] 
		EndIf
			

		s_spanletvars.izi += s_spanletvars.izistep 
		s_spanletvars.pdest+=1
		s_spanletvars.pz+=1
		s_spanletvars.s += s_spanletvars.sstep 
		s_spanletvars.t += s_spanletvars.tstep 
		
	loop while (s_spanletvars.spancount > 0)
End Sub

/'
** R_DrawSpanlet33
'/
sub R_DrawSpanlet33()
			dim as uinteger btemp 

	do
	 
		dim as uinteger ts, tt 

		ts = s_spanletvars.s shr 16 
		tt = s_spanletvars.t shr 16 

		btemp = *(s_spanletvars.pbase + (ts) + (tt) * cachewidth) 

		 if ( btemp <> 255 ) then
		 
	 		if (*s_spanletvars.pz <= (s_spanletvars.izi shr 16)) then
	 
		 		 *s_spanletvars.pdest = vid.alphamap[btemp*256+*s_spanletvars.pdest] 
	      end if
		end if

		s_spanletvars.izi += s_spanletvars.izistep 
		s_spanletvars.pdest+=1
		s_spanletvars.pz+=1
		s_spanletvars.s += s_spanletvars.sstep 
		s_spanletvars.t += s_spanletvars.tstep 
		 s_spanletvars.spancount -=1
	loop while (s_spanletvars.spancount > 0)
End Sub





sub R_DrawSpanletConstant33
   do
		if (*s_spanletvars.pz <= (s_spanletvars.izi shr 16)) then
		 
			*s_spanletvars.pdest = vid.alphamap[r_polyblendcolor+*s_spanletvars.pdest*256] 
		end if

		s_spanletvars.izi += s_spanletvars.izistep 
		s_spanletvars.pdest+=1
		s_spanletvars.pz+=1
		s_spanletvars.spancount-=1
	  loop while (s_spanletvars.spancount > 0) 
End Sub




/'
** R_DrawSpanlet66
'/
sub R_DrawSpanlet66()
		dim as uinteger btemp 

	do
	 
		dim as uinteger ts, tt 

		ts = s_spanletvars.s shr 16 
		tt = s_spanletvars.t shr 16 

		btemp = *(s_spanletvars.pbase + (ts) + (tt) * cachewidth) 

		 if ( btemp <> 255 ) then
		 
	 		if (*s_spanletvars.pz <= (s_spanletvars.izi shr 16)) then
	 
		 		 *s_spanletvars.pdest = vid.alphamap[btemp*256+*s_spanletvars.pdest] 
	      end if
		end if

		s_spanletvars.izi += s_spanletvars.izistep 
		s_spanletvars.pdest+=1
		s_spanletvars.pz+=1
		s_spanletvars.s += s_spanletvars.sstep 
		s_spanletvars.t += s_spanletvars.tstep 
		 s_spanletvars.spancount -=1
	loop while (s_spanletvars.spancount > 0)
End Sub





sub R_DrawSpanlet33Stipple()
	dim as uinteger btemp 
	dim as ubyte    ptr pdest = s_spanletvars.pdest 
	dim as short   ptr pz    = s_spanletvars.pz 
	dim as integer      izi   = s_spanletvars.izi 
	
	if ( r_polydesc.stipple_parity xor ( s_spanletvars.v and 1 ) ) then
 
		s_spanletvars.pdest += s_spanletvars.spancount 
		s_spanletvars.pz    += s_spanletvars.spancount 

		if ( s_spanletvars.spancount = AFFINE_SPANLET_SIZE ) then
			s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS 
		else
			s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep
		end if 
		
		if ( r_polydesc.stipple_parity xor ( s_spanletvars.u and 1 ) ) then
	 
			izi += s_spanletvars.izistep 
			s_spanletvars.s   += s_spanletvars.sstep 
			s_spanletvars.t   += s_spanletvars.tstep 

			pdest+=1
			pz+=1
			s_spanletvars.spancount-=1
		end if

		s_spanletvars.sstep *= 2 
		s_spanletvars.tstep *= 2 

		while ( s_spanletvars.spancount > 0 )
		 
			dim as uinteger s = s_spanletvars.s shr 16 
			dim as uinteger t = s_spanletvars.t shr 16 

			btemp = *( s_spanletvars.pbase + ( s ) + ( t * cachewidth ) ) 
			
			if ( btemp <> 255 ) then
						if ( *pz <= ( izi shr 16 ) ) then
					*pdest = btemp
				EndIf
			 
	 EndIf
			
			izi               += s_spanletvars.izistep_times_2 
			s_spanletvars.s   += s_spanletvars.sstep 
			s_spanletvars.t   += s_spanletvars.tstep 
			
			pdest += 2 
			pz    += 2 
			
			s_spanletvars.spancount -= 2 
		wend
 	 EndIf
End Sub	

	
/'
** R_DrawSpanlet66Stipple
'/
sub R_DrawSpanlet66Stipple()
	dim as uinteger btemp 
	dim as ubyte    ptr pdest = s_spanletvars.pdest 
	dim as short   ptr pz    = s_spanletvars.pz 
	dim as integer      izi   = s_spanletvars.izi 
	
	if ( r_polydesc.stipple_parity xor ( s_spanletvars.v and 1 ) ) then
 
		s_spanletvars.pdest += s_spanletvars.spancount 
		s_spanletvars.pz    += s_spanletvars.spancount 

		if ( s_spanletvars.spancount = AFFINE_SPANLET_SIZE ) then
			s_spanletvars.izi += s_spanletvars.izistep shl AFFINE_SPANLET_SIZE_BITS 
		else
			s_spanletvars.izi += s_spanletvars.izistep * s_spanletvars.izistep
		end if 
		
		if ( r_polydesc.stipple_parity xor ( s_spanletvars.u and 1 ) ) then
	 
			izi += s_spanletvars.izistep 
			s_spanletvars.s   += s_spanletvars.sstep 
			s_spanletvars.t   += s_spanletvars.tstep 

			pdest+=1
			pz+=1
			s_spanletvars.spancount-=1
		end if

		s_spanletvars.sstep *= 2 
		s_spanletvars.tstep *= 2 

		while ( s_spanletvars.spancount > 0 )
		 
			dim as uinteger s = s_spanletvars.s shr 16 
			dim as uinteger t = s_spanletvars.t shr 16 

			btemp = *( s_spanletvars.pbase + ( s ) + ( t * cachewidth ) ) 
			
			if ( btemp <> 255 ) then
						if ( *pz <= ( izi shr 16 ) ) then
					*pdest = btemp
				EndIf
			 
	 EndIf
			
			izi               += s_spanletvars.izistep_times_2 
			s_spanletvars.s   += s_spanletvars.sstep 
			s_spanletvars.t   += s_spanletvars.tstep 
			
			pdest += 2 
			pz    += 2 
			
			s_spanletvars.spancount -= 2 
		wend
 	 EndIf
End Sub


 
	function R_ClipPolyFace (nump as integer ,pclipplane as clipplane_t ptr) as Integer
		
	dim as integer		i, outcount 
	dim as float	dists(MAXWORKINGVERTS+3) 
	dim as float	_frac, clipdist    
	dim as float ptr pclipnormal 
	dim as float ptr	 _in,  instep,  outstep,  vert2 

	clipdist = pclipplane->dist 
	pclipnormal = @pclipplane->normal 
	
'// calc dists
	if (clip_current) then
	    _in = @r_clip_verts(1,0) 
		outstep = @r_clip_verts(0,0) 
		clip_current = 0 
	 
	else
 
		_in = @r_clip_verts(0,0)  
		outstep = @r_clip_verts(1,0) 
		clip_current = 1 
	 
	EndIf
	 
 	
 	
 	instep = _in 
 	for  i=0 to nump=1
 	 	
 	dists(i) = _DotProduct (instep, pclipnormal) - clipdist 
 		
 	instep += sizeof (vec5_t) \ sizeof (float)
 	Next
 
' // handle wraparound case
 	dists(nump) = dists(0) 
 	memcpy (instep, _in, sizeof (vec5_t)) 
'
'
''// clip the winding
 	instep = _in 
 	outcount = 0 
 
 
 for i=0 to nump -1 
 		if (dists(i) >= 0) then
 		   memcpy (outstep, instep, sizeof (vec5_t)) 
 			 outstep += sizeof (vec5_t) \ sizeof (float) 
 			outcount+=1
 			
 		EndIf
 
 		if (dists(i) = 0 or dists(i+1) = 0) then
 		 	continue for
 		EndIf
 
 
 		if ( (dists(i) > 0) = (dists(i+1) > 0) ) then
 		 			continue for
 		EndIf
 		
'	// split it into a new vertex
 		_frac = dists(i) / (dists(i) - dists(i+1)) 
 			
 		vert2 = instep + sizeof (vec5_t) \ sizeof (float) 
 		
  		outstep[0] = instep[0] + _frac*(vert2[0] - instep[0]) 
 		outstep[1] = instep[1] + _frac*(vert2[1] - instep[1])  
 		outstep[2] = instep[2] + _frac*(vert2[2] - instep[2]) 
 		outstep[3] = instep[3] + _frac*(vert2[3] - instep[3]) 
  		outstep[4] = instep[4] + _frac*(vert2[4] - instep[4]) 
 
 		 outstep += sizeof (vec5_t) \ sizeof (float) 
 		outcount+=1
   next	
	
	return outcount 
	End function
	
	
	
/'
** R_PolygonDrawSpans
'/
'// PGM - iswater was qboolean. changed to allow passing more flags
sub R_PolygonDrawSpans(pspan as espan_t ptr, iswater as integer  )
   dim as integer			count 
	dim as fixed16_t	snext, tnext 
	dim as float		sdivz, tdivz, zi, z, du, dv, spancountminus1 
	dim as float		sdivzspanletstepu, tdivzspanletstepu, zispanletstepu 

	s_spanletvars.pbase = cacheblock 

'//PGM
	if ( iswater and SURF_WARP) then
		r_turb_turb = @sintable(0) + cast(integer,(r_newrefdef._time*SPEED) and (CYCLE-1)) 
	elseif (iswater and SURF_FLOWING) then
		r_turb_turb = @blanktable(0)
	end if
'//PGM

	sdivzspanletstepu = d_sdivzstepu * AFFINE_SPANLET_SIZE 
	tdivzspanletstepu = d_tdivzstepu * AFFINE_SPANLET_SIZE 
	zispanletstepu = d_zistepu * AFFINE_SPANLET_SIZE 

'// we count on FP exceptions being turned off to avoid range problems
 	s_spanletvars.izistep = cast(integer,(d_zistepu * &H8000 * &H10000)) 
 	s_spanletvars.izistep_times_2 = s_spanletvars.izistep * 2 
 
 	s_spanletvars.pz = 0 
 
 	do
 
 		s_spanletvars.pdest   = cast(ubyte ptr,d_viewbuffer) + ( d_scantable(pspan->v) /'r_screenwidth * pspan->v'/) + pspan->u 
 		s_spanletvars.pz      = d_pzbuffer + (d_zwidth * pspan->v) + pspan->u 
 		s_spanletvars.u       = pspan->u 
 		s_spanletvars.v       = pspan->v 
 
 		count = pspan->count 
 
 		if (count <= 0) then
 			goto NextSpan
 		EndIf
 
 	'// calculate the initial s/z, t/z, 1/z, s, and t and clamp
 		dv = cast(float,pspan->v) 
  
 		sdivz = d_sdivzorigin + dv*d_sdivzstepv + du*d_sdivzstepu 
 		tdivz = d_tdivzorigin + dv*d_tdivzstepv + du*d_tdivzstepu 
 
 		zi = d_ziorigin + dv*d_zistepv + du*d_zistepu 
  		z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point
   	'// we count on FP exceptions being turned off to avoid range problems
 		s_spanletvars.izi = cast(integer,zi * &H8000 * &H10000) 
 
 		s_spanletvars.s = cast(integer,sdivz * z) + sadjust 
 		s_spanletvars.t = cast(integer,tdivz * z) + tadjust 
 
    	if (  iswater = NULL ) then
 
 			if (s_spanletvars.s > bbextents) then
 				s_spanletvars.s = bbextents 
 			elseif (s_spanletvars.s < 0) then
 				s_spanletvars.s = 0
 			end if
 
 			if (s_spanletvars.t > bbextentt) then
 				s_spanletvars.t = bbextentt 
 			elseif (s_spanletvars.t < 0) then
 				
 				s_spanletvars.t = 0 
 			end if	
 	   end if
'
 		do
     
 		'// calculate s and t at the far end of the span
  			if (count >= AFFINE_SPANLET_SIZE ) then
  				s_spanletvars.spancount = AFFINE_SPANLET_SIZE 
  			else
  				s_spanletvars.spancount = count
  			end if 
 
  			count -= s_spanletvars.spancount 
  
  			if (count) then
  
 '			// calculate s/z, t/z, zi->fixed s and t at far end of span,
 '			// calculate s and t steps across span by shifting
 				sdivz += sdivzspanletstepu 
  				tdivz += tdivzspanletstepu 
 				zi += zispanletstepu 
  				z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
 
  				snext = cast(integer, sdivz * z) + sadjust 
  				tnext = cast(integer,tdivz * z) + tadjust 
  
 				 if ( iswater ) then
 
  					if (snext > bbextents) then
  						snext = bbextents 
  					elseif (snext < AFFINE_SPANLET_SIZE) then
 						snext = AFFINE_SPANLET_SIZE 	'// prevent round-off error on <0 steps from
 					end if
 '									//  from causing overstepping & running off the
 '									//  edge of the texture
 
   				if (tnext > bbextentt) then
  						tnext = bbextentt 
 					elseif (tnext < AFFINE_SPANLET_SIZE) then
  						tnext = AFFINE_SPANLET_SIZE 	'// guard against round-off error on <0 steps
  				   end if
  
 				s_spanletvars.sstep = (snext - s_spanletvars.s) shr AFFINE_SPANLET_SIZE_BITS 
 				s_spanletvars.tstep = (tnext - s_spanletvars.t) shr AFFINE_SPANLET_SIZE_BITS 
          end if
    		else
 
' 			// calculate s/z, t/z, zi->fixed s and t at last pixel in span (so
' 			// can't step off polygon), clamp, calculate s and t steps across
' 			// span by division, biasing steps low so we don't run off the
'  		// texture
 				spancountminus1 = cast(float,s_spanletvars.spancount - 1) 
 				sdivz += d_sdivzstepu * spancountminus1 
 		   	tdivz += d_tdivzstepu * spancountminus1 
 				zi += d_zistepu * spancountminus1 
 				z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
 				snext = cast(integer,sdivz * z) + sadjust 
 				tnext = cast(integer,tdivz * z) + tadjust 
 
 				if ( iswater = NULL) then
 
 					if (snext > bbextents) then
 						snext = bbextents 
 					elseif (snext < AFFINE_SPANLET_SIZE) then
 						snext = AFFINE_SPANLET_SIZE 	'// prevent round-off error on <0 steps from
					end if		 									'//  from causing overstepping & running off the
 									                     '//  edge of the texture
 
 					if (tnext > bbextentt) then
 						tnext = bbextentt 
 					elseif (tnext < AFFINE_SPANLET_SIZE) then
 						tnext = AFFINE_SPANLET_SIZE 	'// guard against round-off error on <0 steps
 				   EndIf
            end if
            
   			if (s_spanletvars.spancount > 1) then
  
 				s_spanletvars.sstep = (snext - s_spanletvars.s) / (s_spanletvars.spancount - 1) 
 				s_spanletvars.tstep = (tnext - s_spanletvars.t) / (s_spanletvars.spancount - 1) 
   			end if
         end if
         
  			if ( iswater ) then
  
  				s_spanletvars.s = s_spanletvars.s and ((CYCLE shl 16)-1) 
  				s_spanletvars.t = s_spanletvars.t and ((CYCLE shl 16)-1) 
  			end if
  
  			r_polydesc.drawspanlet() 
  
 			s_spanletvars.s = snext 
  			s_spanletvars.t = tnext  
 
 		loop while (count > 0) 
 
 NextSpan:
 		pspan+=1

		loop  while (pspan->count <> DS_SPAN_LIST_END) 
	
End Sub
	
/'
**
** R_PolygonScanLeftEdge
**
** Goes through the polygon and scans the left edge, filling in 
** screen coordinate data for the spans
'/
sub R_PolygonScanLeftEdge ()
   dim as integer			i, v, itop, ibottom, lmaxindex 
	dim as emitpoint_t	ptr pvert,  pnext 
	dim as espan_t	ptr	pspan 
	dim as float		du, dv, vtop, vbottom, slope 
	dim as fixed16_t	u, u_step 

	pspan = s_polygon_spans 
	i = s_minindex 
	 if (i = 0) then
	 	i = r_polydesc.nump
	 EndIf
 

	 lmaxindex = s_maxindex 
	 if (lmaxindex =  0) then
	 	lmaxindex = r_polydesc.nump 
	 EndIf
	 	

	 vtop = ceil (r_polydesc.pverts[i].v) 

	 do
	 
 		pvert = @r_polydesc.pverts[i] 
	 	pnext = pvert - 1 

	 	vbottom = ceil (pnext->v) 

	 	if (vtop < vbottom) then
	 		
	 	   du = pnext->u - pvert->u 
	 	 	dv = pnext->v - pvert->v 
	 		
	 		
	 	EndIf
	 


	 		slope = du / dv 
	 		u_step = cast(integer,(slope * &H10000))
	'	// adjust u to ceil the integer portion
	 		u = cast(integer,((pvert->u + (slope * (vtop - pvert->v)))) * &H10000) + _
	 				(&H10000 - 1) 
	 		itop = cast(integer,vtop) 
	 		ibottom = cast(integer,vbottom) 

 
	   for v = itop to ibottom -1 
	   	   pspan->u = u shr 16 
	 			pspan->v = v 
	 			u += u_step 
	 			pspan+=1
	   Next
 

	 	vtop = vbottom 

	  i-=1
	 	if (i = 0) then
	 		i = r_polydesc.nump 
	 	EndIf
	 	

	loop while (i <> lmaxindex) 
 
	
End Sub
	
	
	/'
** R_PolygonScanRightEdge
**
** Goes through the polygon and scans the right edge, filling in
** count values.
'/
sub R_PolygonScanRightEdge ()
	dim as integer			i, v, itop, ibottom 
	dim as emitpoint_t ptr pvert,  pnext 
	dim as espan_t		ptr pspan 
	dim as float		du, dv, vtop, vbottom, slope, uvert, unext, vvert, vnext 
	dim as fixed16_t	u, u_step 

	 pspan = s_polygon_spans 
	 i = s_minindex 

	 vvert = r_polydesc.pverts[i].v 
	 if (vvert < r_refdef.fvrecty_adj) then
	 	vvert = r_refdef.fvrecty_adj
	 EndIf
 
	 if (vvert > r_refdef.fvrectbottom_adj) then
	 	vvert = r_refdef.fvrectbottom_adj
	 EndIf
	
 

	 vtop = ceil (vvert) 

	 do
 
 		pvert = @r_polydesc.pverts[i] 
	 	pnext = pvert + 1 

	 	vnext = pnext->v 
	 	if (vnext < r_refdef.fvrecty_adj) then
	 		vnext = r_refdef.fvrecty_adj 
	 	EndIf
	 		
	 	if (vnext > r_refdef.fvrectbottom_adj) then
	 		vnext = r_refdef.fvrectbottom_adj 
	 	EndIf
	 		

	 	vbottom = ceil (vnext) 

	 	if (vtop < vbottom) then
	 
	 		uvert = pvert->u 
	 		if (uvert < r_refdef.fvrectx_adj) then
	 			uvert = r_refdef.fvrectx_adj 
	 		EndIf
	 			
	 		if (uvert > r_refdef.fvrectright_adj) then
	 			uvert = r_refdef.fvrectright_adj 
	 		EndIf
	 			

	 		unext = pnext->u 
	 		if (unext < r_refdef.fvrectx_adj) then
	 			unext = r_refdef.fvrectx_adj
	 		EndIf
	  
	 		if (unext > r_refdef.fvrectright_adj) then
	 			unext = r_refdef.fvrectright_adj
	 		EndIf
	 
	 		du = unext - uvert 
	 		dv = vnext - vvert 
	 		slope = du / dv 
	 		u_step = cast(integer,(slope * &H10000)) 
	'	// adjust u to ceil the integer portion
	 		u = cast(integer,((uvert + (slope * (vtop - vvert)))   * &H10000)) + _
	 				(&H10000 - 1) 
	 		itop = cast(integer,vtop) 
	 		ibottom = cast(integer,vbottom) 

	 		for  v=itop to v<ibottom -1 
	 			pspan->count = (u shr 16) - pspan->u
	 			u += u_step
	 			pspan+=1
	 		Next
 
	  end if

	 	vtop = vbottom 
	 	vvert = vnext 

	 	i+=1
	 	if (i = r_polydesc.nump) then
	 		i = 0 
	 	EndIf
	 	

	 loop while (i <> s_maxindex) 

	pspan->count = DS_SPAN_LIST_END 	'// mark the end of the span list 
	
End Sub

'FINISHED FOR NBOW///////////////////////////////////////////////////////	
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
 
 		 r_polydesc.drawspanlet = @R_DrawSpanletConstant33() 
 	 
 	else
 

		/'
		** choose the correct spanlet routine based on alpha
		'/
 		if ( alpha_ =  1 ) then
 		 
 			'// isturbulent is ignored because we know that turbulent surfaces
 			'// can't be opaque
  			r_polydesc.drawspanlet = @R_DrawSpanletOpaque() 
 
 		else
 
 			if ( sw_stipplealpha->value ) then
 		 
 			   if ( isturbulent ) then
 			  	
 			 
 			 
 			   if ( alpha_ > 0.33 ) then
 						r_polydesc.drawspanlet = @R_DrawSpanletTurbulentStipple66() 
 					else 
 						r_polydesc.drawspanlet = @R_DrawSpanletTurbulentStipple33() 
 					end if
 
 				else
 
 					if ( alpha_ > 0.33 ) then
      					r_polydesc.drawspanlet = @R_DrawSpanlet66Stipple()
 					else 
 					 	r_polydesc.drawspanlet = @R_DrawSpanlet33Stipple()
 			      end if
 				end if
 
 			else
 
   			if ( isturbulent ) then
 				 
 					if ( alpha_ > 0.33 ) then
 					r_polydesc.drawspanlet = @R_DrawSpanletTurbulentBlended66()
 					else
 						r_polydesc.drawspanlet = @R_DrawSpanletTurbulentBlended33()
					end if
 			 
 				else
				 
 					if ( alpha_ > 0.33 ) then
 						r_polydesc.drawspanlet = @R_DrawSpanlet66() 
 					else 
  						r_polydesc.drawspanlet = @R_DrawSpanlet33()
 					end if
 				end if
 			end if
 		end if
 	end if
 	
 	
 	'// clip to the frustum in worldspace
	nump = r_polydesc.nump 
	clip_current = 0 
 
 	 for i = 0 to 4-1
 
 		nump = R_ClipPolyFace (nump, @view_clipplanes(i)) 
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
 
 	R_DrawPoly( isturbulent ) 	
  	
end sub
	
	
	
	
	
	
	
/'
** R_BuildPolygonFromSurface
'/
sub R_BuildPolygonFromSurface(fa as msurface_t ptr)
	
	dim as integer			i, lindex, lnumverts 
	dim as medge_t	ptr	 pedges,  r_pedge 
	dim as integer			vertpage 
	dim as float		ptr vec 
	dim as vec5_t  ptr    pverts 
	dim as float       tmins(2) = { 0, 0 } 

	r_polydesc.nump = 0 

'	// reconstruct the polygon
 	pedges = currentmodel->edges 
 	lnumverts = fa->numedges 
 	vertpage = 0 
 
 	pverts = @r_clip_verts(0,0)
 
 	for  i=0  to lnumverts 
 
 		lindex = currentmodel->surfedges[fa->firstedge + i] 
 
 		if (lindex > 0) then
 
 			r_pedge = @pedges[lindex] 
 			vec = @currentmodel->vertexes[r_pedge->v(0)].position 
 
 		else
 
 			r_pedge = @pedges[-lindex] 
 			vec = @currentmodel->vertexes[r_pedge->v(1)].position 
 		end if
 
 		_VectorCopy (vec, @pverts[i] ) 
 	next
 
 	_VectorCopy( @fa->texinfo->vecs(0,0), @r_polydesc.vright ) 
 	_VectorCopy( @fa->texinfo->vecs(1,0), @r_polydesc.vup ) 
 	_VectorCopy( @fa->plane->normal, @r_polydesc.vpn ) 
 	_VectorCopy( @r_origin, @r_polydesc.viewer_position(0) ) 
 
 	if ( fa->flags and SURF_PLANEBACK ) then
 		_VectorSubtract( @vec3_origin, @r_polydesc.vpn, @r_polydesc.vpn )
 	EndIf
 
'
'// PGM 09/16/98
 	if ( fa->texinfo->flags and (SURF_WARP or SURF_FLOWING) ) then
 		
 		r_polydesc.pixels       = fa->texinfo->_image->pixels(0) 
 		r_polydesc.pixel_width  = fa->texinfo->_image->_width 
   	r_polydesc.pixel_height = fa->texinfo->_image->_height 

 
 
'// PGM 09/16/98
 	else
 
 		dim scache  as surfcache_t ptr
 
 		scache = D_CacheSurface( fa, 0 ) 
 
 		r_polydesc.pixels       = @scache->_data(0) 
   	r_polydesc.pixel_width  = scache->_width 
 		r_polydesc.pixel_height = scache->_height  
 
 		tmins(0) = fa->texturemins(0) 
 		tmins(1) = fa->texturemins(1) 
	end if
 
 	r_polydesc.dist = _DotProduct( @r_polydesc.vpn, @pverts[0] ) 
 
 	r_polydesc.s_offset = fa->texinfo->vecs(0,3) - tmins(0) 
 	r_polydesc.t_offset = fa->texinfo->vecs(1,3) - tmins(1) 
 
'	// scrolling texture addition
 	if (fa->texinfo->flags and SURF_FLOWING) then
   r_polydesc.s_offset += -128 * ( (r_newrefdef._time*0.25) - cast(integer,(r_newrefdef._time*0.25)) ) 

 	EndIf
 
 
 
 	r_polydesc.nump = lnumverts 
	
End Sub
	
	
	
sub R_PolygonCalculateGradients ()
		
	dim as vec3_t		p_normal, p_saxis, p_taxis 
	dim as float		distinv 

	TransformVector (@r_polydesc.vpn, @p_normal) 
	TransformVector (@r_polydesc.vright, @p_saxis) 
	TransformVector (@r_polydesc.vup, @p_taxis) 

 	distinv = 1.0 / (-(_DotProduct (@r_polydesc.viewer_position(0), @r_polydesc.vpn)) + r_polydesc.dist ) 
 
 	d_sdivzstepu  =  p_saxis.v(0) * xscaleinv 
 	d_sdivzstepv  = -p_saxis.v(1) * yscaleinv 
 	d_sdivzorigin =  p_saxis.v(2) - xcenter * d_sdivzstepu - ycenter * d_sdivzstepv 
 
 	d_sdivzstepu  =  p_saxis.v(0) * xscaleinv 
 	d_sdivzstepv  = -p_saxis.v(1) * yscaleinv 
 	d_sdivzorigin =  p_saxis.v(2) - xcenter * d_sdivzstepu - ycenter * d_sdivzstepv 

	d_zistepu =   p_normal.v(0) * xscaleinv * distinv 
	d_zistepv =  -p_normal.v(1) * yscaleinv * distinv 
	d_ziorigin =  p_normal.v(2) * distinv - xcenter * d_zistepu - ycenter * d_zistepv 
 
 
 	sadjust = cast(fixed16_t, ( _DotProduct( @r_polydesc.viewer_position(0), @r_polydesc.vright) + r_polydesc.s_offset ) * &H10000 ) 
 	tadjust = cast(fixed16_t, ( _DotProduct( @r_polydesc.viewer_position(0), @r_polydesc.vup   ) + r_polydesc.t_offset ) * &H10000 ) 


'// -1 (-epsilon) so we never wander off the edge of the texture
 	bbextents = (r_polydesc.pixel_width shl 16) - 1 
 	bbextentt = (r_polydesc.pixel_height shl 16) - 1 
 
		
End Sub
	

	
/'
** R_DrawPoly
**
** Polygon drawing function.  Uses the polygon described in r_polydesc
** to calculate edges and gradients, then renders the resultant spans.
**
** This should NOT be called externally since it doesn't do clipping!
'/
'// PGM - iswater was qboolean. changed to support passing more flags
sub R_DrawPoly( iswater as integer  )	static
	dim as integer			i, nump 
	dim as float		ymin, ymax 
	dim as emitpoint_t ptr pverts 
	dim as espan_t	spans(MAXHEIGHT+1) 

	s_polygon_spans = @spans(0) 

'// find the top and bottom vertices, and make sure there's at least one scan to
'// draw
	ymin = 999999.9 
	ymax = -999999.9 
	pverts = r_polydesc.pverts 

 
   for i = 0 to r_polydesc.nump-1
   	
   	if (pverts->v < ymin) then
	 
	  		ymin = pverts->v 
	 		s_minindex = i 
   	end if
   	
      if (pverts->v > ymax) then
	 		ymax = pverts->v
	 		s_maxindex = i
	 	EndIf
 
	 	pverts+=1
   	
   Next

	ymin = ceil (ymin) 
	ymax = ceil (ymax) 

	if (ymin >= ymax) then
		return '// doesn't cross any scans at all
	EndIf
 		

	cachewidth = r_polydesc.pixel_width 
	cacheblock = r_polydesc.pixels 

'// copy the first vertex to the last vertex, so we don't have to deal with
'// wrapping
	nump = r_polydesc.nump 
	pverts = r_polydesc.pverts 
	pverts[nump] = pverts[0] 

	R_PolygonCalculateGradients () 
	R_PolygonScanLeftEdge () 
	R_PolygonScanRightEdge () 

	R_PolygonDrawSpans( s_polygon_spans, iswater ) 
	
	
	
End Sub
	


sub R_DrawAlphaSurfaces()
			dim as msurface_t ptr s = r_alpha_surfaces 

	currentmodel = r_worldmodel 

	modelorg.v(0) = -r_origin.v(0) 
	modelorg.v(1) = -r_origin.v(1)
	modelorg.v(2) = -r_origin.v(2) 

	while ( s )
 
		R_BuildPolygonFromSurface( s ) 

'//=======
'//PGM
'//		if (s->texinfo->flags & SURF_TRANS66)
'//			R_ClipAndDrawPoly( 0.60f, ( s->texinfo->flags & SURF_WARP) != 0, true );
'//		else
'//			R_ClipAndDrawPoly( 0.30f, ( s->texinfo->flags & SURF_WARP) != 0, true );

		'// PGM - pass down all the texinfo flags, not just SURF_WARP.
		if (s->texinfo->flags and SURF_TRANS66) then
 			R_ClipAndDrawPoly( 0.60f, (s->texinfo->flags and SURF_WARP or SURF_FLOWING), true ) 
		else
			R_ClipAndDrawPoly( 0.30f, (s->texinfo->flags and SURF_WARP or SURF_FLOWING), true ) 
		EndIf	
			
'//PGM
'//=======

		s = s->nextalphasurface 
	wend
	
	r_alpha_surfaces = NULL 
		
	End Sub
		
	
	
	
	
/'
** R_IMFlatShadedQuad
'/
sub R_IMFlatShadedQuad(  a as vec3_t ptr, b as vec3_t ptr,c as  vec3_t ptr ,d as vec3_t ptr , _color as  integer ,alpha_ as  float  ) 

	 	dim as vec3_t s0, s1 
 
	 
	 
	 VectorNormalize( @r_polydesc.vpn )
	 
	 r_polyblendcolor = _color
	 
	  R_ClipAndDrawPoly( alpha_,  _false,  _false ) 
	  
	  r_polydesc.nump = 4
	  _VectorCopy( @r_origin,  @r_polydesc.viewer_position(0) )
	  
	  r_polydesc.dist = _DotProduct( @r_polydesc.vpn,@r_clip_verts(0,0)  )
	  
	  
	  
	   
   	_VectorSubtract( d, c, @s0 ) 
   	_VectorSubtract( c, b, @s1 ) 

	  CrossProduct( @s0, @s1, @r_polydesc.vpn )
	  
   _VectorCopy( a, @r_clip_verts(0,0)  ) 
 	_VectorCopy( b, @r_clip_verts(0,1) ) 
   _VectorCopy( c, @r_clip_verts(0,2) ) 
 	_VectorCopy( d, @r_clip_verts(0,3) ) 
 
 	r_clip_verts(0,0).v(3) = 0 
 	r_clip_verts(0,1).v(3) = 0 
 	r_clip_verts(0,2).v(3) = 0 
 	r_clip_verts(0,3).v(3) = 0 
 
 	r_clip_verts(0,0).v(4) = 0 
  	r_clip_verts(0,1).v(4) = 0 
 	r_clip_verts(0,2).v(4) = 0 
 	r_clip_verts(0,3).v(4) = 0 
	  
	  
	  
End Sub
 

 
 
