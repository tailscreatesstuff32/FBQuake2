
'FINISHED fOR NOW/////////////////////////////////////


#Include "FB_Ref_Soft\r_local.bi"





extern "C"
 extern as ubyte	ptr r_turb_pbase, r_turb_pdest
 extern as fixed16_t		r_turb_s, r_turb_t, r_turb_sstep, r_turb_tstep 
 extern as integer	ptr		   r_turb_turb 
 extern as integer			 	r_turb_spancount
 
 
 declare sub D_DrawTurbulent8Span () 
 
end extern






dim shared as ubyte	ptr r_turb_pbase, r_turb_pdest 
dim shared as fixed16_t		r_turb_s, r_turb_t, r_turb_sstep, r_turb_tstep 
dim shared as integer ptr			   r_turb_turb 
dim shared as integer			 	r_turb_spancount 




 
'/*
'=============
'D_WarpScreen
'
'this performs a slight compression of the screen at the same time as
'the sine warp, to keep the edges from wrapping
'=============
'*/
sub D_WarpScreen ()
 dim  as   integer		w, h 
 dim  as   integer		u,v, u2, v2  
 dim  as   ubyte	   ptr dest 
 dim  as   integer	 ptr turb 
 dim  as   integer	 ptr col 
 dim  as   ubyte	   ptr ptr row 
	
 static as integer	cached_width, cached_height
	
  
 	static as ubyte	ptr rowptr(1200+AMP2*2)
 	static as integer	column(1600+AMP2*2) 
'
'	//
'	// these are constant over resolutions, and can be saved
'	//
 	w = r_newrefdef._width 
 	h = r_newrefdef._height 
 	if (w <> cached_width or h <> cached_height) then
 
 		cached_width = w 
 		cached_height = h 
 		for  v=0 to  (h+AMP2*2)-1 
  
 
         v2 = cast(integer,cast(float,v)/(h + AMP2 * 2) * r_refdef.vrect._height) 
 			rowptr(v) = @r_warpbuffer(0) + (WARP_WIDTH * v2) 
 		next
 
 		for  u=0 to  (h+AMP2*2)-1 
 
   	 u2 = cast(integer,cast(float,u)/(w + AMP2 * 2) * r_refdef.vrect._width) 
 	 	column(u) = u2 
 		next
 	end if
 
 	turb = @intsintable(0) + (cast(integer,(r_newrefdef._time*SPEED))and(CYCLE-1)) 
 	dest = vid.buffer + r_newrefdef.y * vid.rowbytes + r_newrefdef.x 
 
 
 for v = 0 to h-1
 	
 	
 		col = @column(turb[v])
 		row = @rowptr(v) 
 		u= 0
 		 do while u < w 
 		 	dest[u+0] = row[turb[u+0]][col[u+0]] 
			dest[u+1] = row[turb[u+1]][col[u+1]] 
			dest[u+2] = row[turb[u+2]][col[u+2]] 
			dest[u+3] = row[turb[u+3]][col[u+3]] 
 		 	u+=4
 		 Loop
 
 		 dest += vid.rowbytes
 	next
 
End Sub
 




#ifndef	id386

/'
'=============
'D_DrawTurbulent8Span
'=============
'/
sub D_DrawTurbulent8Span ()

	dim as integer		sturb, tturb

	do
 
		sturb = ((r_turb_s + r_turb_turb[(r_turb_t shr 16) and (CYCLE-1)]) shr 16)and 63 
		 tturb = ((r_turb_t + r_turb_turb[(r_turb_s shr 16) and (CYCLE-1)]) shr 16) and 63 
		 *r_turb_pdest = *(r_turb_pbase + (tturb shl 6) + sturb)  
		 r_turb_pdest+=1
		 
		r_turb_s += r_turb_sstep 
		r_turb_t += r_turb_tstep 
		r_turb_spancount -=1
	loop while (r_turb_spancount > 0) 
end sub
#endif


/'
=============
Turbulent8
=============
'/


sub Turbulent8 (pspan as espan_t ptr)
 
dim as 	integer				count 
dim as 	fixed16_t		snext, tnext 
dim as 	float			sdivz, tdivz, zi, z, du, dv, spancountminus1 
dim as 	float			sdivz16stepu, tdivz16stepu, zi16stepu 
 	
  	r_turb_turb = @sintable(0) + (cast(integer,(r_newrefdef._time*SPEED)) and (CYCLE-1)) 
 
 	r_turb_sstep = 0 	'// keep compiler happy
 	r_turb_tstep = 0 	'// ditto
 
	r_turb_pbase = cast(ubyte ptr,cacheblock) 
 
 	sdivz16stepu = d_sdivzstepu * 16 
 	tdivz16stepu = d_tdivzstepu * 16 
 	zi16stepu = d_zistepu * 16 
  
 	do
 
 		r_turb_pdest = cast(ubyte ptr,(cast(ubyte ptr,d_viewbuffer) + _
 				(r_screenwidth * pspan->v) + pspan->u)) 
 
 		count = pspan->count 
 
'	// calculate the initial s/z, t/z, 1/z, s, and t and clamp
 		du = cast(float,pspan->u) 
 		dv = cast(float,pspan->v)  
 
 		sdivz = d_sdivzorigin + dv*d_sdivzstepv + du*d_sdivzstepu 
 		tdivz = d_tdivzorigin + dv*d_tdivzstepv + du*d_tdivzstepu 
 		zi = d_ziorigin + dv*d_zistepv + du*d_zistepu 
 		z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point
 
 		r_turb_s = cast(integer,sdivz * z) + sadjust 
 		if (r_turb_s > bbextents) then
 			r_turb_s = bbextents 
 		elseif (r_turb_s < 0) then
 			r_turb_s = 0 
 		end if
 			
 
 		r_turb_t = cast(integer,tdivz * z) + tadjust 
 		if (r_turb_t > bbextentt) then
 			r_turb_t = bbextentt 
 		elseif (r_turb_t < 0) then
 			r_turb_t = 0
 		end if 
 
 		do
 
'		// calculate s and t at the far end of the span
 			if (count >= 16) then
 				r_turb_spancount = 16 
 			else
 				r_turb_spancount = count 
			endif
 '
 			count -= r_turb_spancount 
 
 			if (count) then
 
'			// calculate s/z, t/z, zi->fixed s and t at far end of span,
'			// calculate s and t steps across span by shifting
 				sdivz += sdivz16stepu 
 				tdivz += tdivz16stepu 
 				zi += zi16stepu 
 				z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point
 
 				snext = cast(integer,sdivz * z)  + sadjust 
 				if (snext > bbextents) then
 					snext = bbextents 
 				elseif (snext < 16) then
 					snext = 16
 				end if
 					             '// prevent round-off error on <0 steps from
 								    '//  from causing overstepping & running off the
 								    '//  edge of the texture
 
 				tnext = cast(integer,tdivz * z) + tadjust 
   			if (tnext > bbextentt) then
 					tnext = bbextentt 
   			elseif (tnext < 16) then
 					tnext = 16 	'// guard against round-off error on <0 steps
 				end if
 				r_turb_sstep = (snext - r_turb_s) shr 4 
 				r_turb_tstep = (tnext - r_turb_t) shr 4 
 			 
 			else
 			 
'			// calculate s/z, t/z, zi->fixed s and t at last pixel in span (so
'			// can't step off polygon), clamp, calculate s and t steps across
'			// span by division, biasing steps low so we don't run off the
'			// texture
 				spancountminus1 = cast(float,r_turb_spancount - 1) 
  				sdivz += d_sdivzstepu * spancountminus1 
 				tdivz += d_tdivzstepu * spancountminus1 
 				zi += d_zistepu * spancountminus1 
 				z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
 				snext = cast(integer,sdivz * z) + sadjust 
 				if (snext > bbextents) then
   				snext = bbextents 
 				elseif (snext < 16) then
 					snext = 16 	'// prevent round-off error on <0 steps from
				end if				  '//  from causing overstepping & running off the
								  '//  edge of the texture
 
 				tnext = cast(integer,tdivz * z) + tadjust 
 				if (tnext > bbextentt) then
 					tnext = bbextentt 
 				elseif (tnext < 16) then
 					tnext = 16 	'// guard against round-off error on <0 steps
            end if
 				if (r_turb_spancount > 1) then
 
 					r_turb_sstep = (snext - r_turb_s) / (r_turb_spancount - 1) 
 					r_turb_tstep = (tnext - r_turb_t) / (r_turb_spancount - 1) 
 				end if
 			end if
 
 			r_turb_s = r_turb_s and ((CYCLE shl 16)-1) 
 			r_turb_t = r_turb_t and ((CYCLE shl 16)-1) 
 
 			D_DrawTurbulent8Span () 
 
 			r_turb_s = snext 
 			r_turb_t = tnext 
 
 		loop while (count > 0) 
     pspan = pspan->pnext
 	loop while (pspan  <> NULL) 
end sub
'
'

'//====================
'//PGM
'/'
'=============
'NonTurbulent8 - this is for drawing scrolling textures. they're warping water textures
'	but the turbulence is automatically 0.
'=============
'/
sub NonTurbulent8 (pspan as espan_t ptr)
 
	dim as integer		   count 
	dim as fixed16_t		snext, tnext 
	dim as float			sdivz, tdivz, zi, z, du, dv, spancountminus1 
	dim as float			sdivz16stepu, tdivz16stepu, zi16stepu 
	
'//	r_turb_turb = sintable + ((int)(r_newrefdef.time*SPEED)&(CYCLE-1));
	r_turb_turb = @blanktable(0) 

	r_turb_sstep = 0 '	// keep compiler happy
	r_turb_tstep = 0 	'// ditto

	r_turb_pbase = cast(ubyte ptr,cacheblock) 

	sdivz16stepu = d_sdivzstepu * 16 
	tdivz16stepu = d_tdivzstepu * 16 
	zi16stepu = d_zistepu * 16 

	 do
 
 		r_turb_pdest = cast(ubyte ptr,(cast(ubyte ptr,d_viewbuffer) + _
	 			(r_screenwidth * pspan->v) + pspan->u)) 

	 	count = pspan->count 

	'// calculate the initial s/z, t/z, 1/z, s, and t and clamp
	 	du = cast(float,pspan->u) 
	 	dv = cast(float,pspan->v) 

	 	sdivz = d_sdivzorigin + dv*d_sdivzstepv + du*d_sdivzstepu 
	 	tdivz = d_tdivzorigin + dv*d_tdivzstepv + du*d_tdivzstepu 
	 	zi = d_ziorigin + dv*d_zistepv + du*d_zistepu 
	 	z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point

	 	r_turb_s = cast(integer,sdivz * z) + sadjust 
	 	if (r_turb_s > bbextents) then
	 		r_turb_s = bbextents
	   elseif (r_turb_s < 0) then
	 		r_turb_s = 0
	 	end if

	   	r_turb_t = cast(integer,tdivz * z) + tadjust 
	 	if (r_turb_t > bbextentt) then
	    	r_turb_t = bbextentt 
	 	elseif (r_turb_t < 0) then
	 		r_turb_t = 0 
	 	end if

	 	do
	 
	'	// calculate s and t at the far end of the span
	 		if (count >= 16) then
	 			r_turb_spancount = 16 
	 		else
	 			r_turb_spancount = count 
	 		EndIf
	 

	 		count -= r_turb_spancount 

	 		if (count) then
	 
	'		// calculate s/z, t/z, zi->fixed s and t at far end of span,
	'		// calculate s and t steps across span by shifting
	 			sdivz += sdivz16stepu 
	 			tdivz += tdivz16stepu 
	 			zi += zi16stepu 
	 			z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point

	 			snext = cast(integer,sdivz * z) + sadjust 
	  			if (snext > bbextents) then 
	 				snext = bbextents 
	  			elseif (snext < 16) then
	  				snext = 16				 	' // prevent round-off error on <0 steps from
								                '//  from causing overstepping & running off the	 
	 												'//  edge of the texture
	  			end if
	



	 			tnext = cast(integer,tdivz * z) + tadjust 
	 			if (tnext > bbextentt) then
	 				tnext = bbextentt 
	 			elseif (tnext < 16) then
				  tnext = 16 	'	// guard against round-off error on <0 steps
	 			end if
	 			
	 			r_turb_sstep = (snext - r_turb_s) shr 4 
	 			r_turb_tstep = (tnext - r_turb_t) shr 4 
	 
	 		else
 
	'		// calculate s/z, t/z, zi->fixed s and t at last pixel in span (so
	'		// can't step off polygon), clamp, calculate s and t steps across
	'		// span by division, biasing steps low so we don't run off the
	'		// texture
	 			spancountminus1 = cast(float,r_turb_spancount - 1) 
	 			sdivz += d_sdivzstepu * spancountminus1   
	 			tdivz += d_tdivzstepu * spancountminus1 
	 			zi += d_zistepu * spancountminus1 
	 			z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
	 			snext = cast(integer,sdivz * z) + sadjust 
	 			if (snext > bbextents) then
	 				snext = bbextents 
	 			elseif (snext < 16) then
	 				snext = 16  	'// prevent round-off error on <0 steps from
				end if				'//  from causing overstepping & running off the
	 							      '//  edge of the texture

	 			tnext = cast(integer,tdivz * z) + tadjust 
	 			if (tnext > bbextentt) then
	 				tnext = bbextentt 
	 			elseif (tnext < 16) then
	 				tnext = 16
	 			EndIf
	 				
	 			
	'				;	// guard against round-off error on <0 steps

	 			if (r_turb_spancount > 1) then
 
	 				r_turb_sstep = (snext - r_turb_s) / (r_turb_spancount - 1) 
	 				r_turb_tstep = (tnext - r_turb_t) / (r_turb_spancount - 1) 
	   		end if
	   	end if

	 		r_turb_s = r_turb_s and ((CYCLE shl 16)-1) 
	 		r_turb_t = r_turb_t and ((CYCLE shl 16)-1) 

	 		D_DrawTurbulent8Span () 

	 		r_turb_s = snext 
	 		r_turb_t = tnext 

	 	loop while (count > 0) 

	loop while ((pspan = pspan->pnext)<> NULL) 
end sub
'//PGM'
'//====================

 #ifndef id386
 
'/'
'=============
'D_DrawSpans16
'
'  FIXME: actually make this subdivide by 16 instead of 8!!!
'=============
'/
sub D_DrawSpans16 (pspan as espan_t ptr)
 
	 dim as integer				count, spancount 
	dim as ubyte ptr	 pbase,  pdest 
 	dim fixed16_t		s, t, snext, tnext, sstep, tstep 
 	dim as float			sdivz, tdivz, zi, z, du, dv, spancountminus1 
 	dim as float			sdivz8stepu, tdivz8stepu, zi8stepu 
 
 	sstep = 0 	'// keep compiler happy
 	tstep = 0 	'// ditto
 
 	pbase = cast(ubyte ptr,cacheblock) 
 
 	sdivz8stepu = d_sdivzstepu * 8 
 	tdivz8stepu = d_tdivzstepu * 8 
 	zi8stepu = d_zistepu * 8 
 
 	do
 
 		pdest = cast(ubyte ptr,(cast(ubyte ptr,d_viewbuffer) + _
 				(r_screenwidth * pspan->v) + pspan->u)) 
 
 		count = pspan->count 
 
'	// calculate the initial s/z, t/z, 1/z, s, and t and clamp
 		du = cast(float,pspan->u) 
 		dv = cast(float,pspan->v) 
 
 		sdivz = d_sdivzorigin + dv*d_sdivzstepv + du*d_sdivzstepu 
 		tdivz = d_tdivzorigin + dv*d_tdivzstepv + du*d_tdivzstepu 
 		zi = d_ziorigin + dv*d_zistepv + du*d_zistepu 
 		z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
 
 		s = cast(integer,(sdivz * z)) + sadjust 
 		if (s > bbextents) then
 			s = bbextents 
 		elseif (s < 0) then
 			s = 0
 		rnf if 
   
 	   t = cast(integer,tdivz * z) + tadjust 
 		if (t > bbextentt) then
 			t = bbextentt 
 		else if (t < 0) then
 			t = 0 
     end if
   	do
 
'		// calculate s and t at the far end of the span
 			if (count >= 8) then
 				spancount = 8 
 			else
 				spancount = count
 			end if 
 
 			count -= spancount 
 
 			if (count) then
 
'			// calculate s/z, t/z, zi->fixed s and t at far end of span,
'			// calculate s and t steps across span by shifting
 				sdivz += sdivz8stepu 
 				tdivz += tdivz8stepu 
 				zi += zi8stepu 
 				z = cast(float,&H10000 / zi) 	'// prescale to 16.16 fixed-point
 
 				snext = cast(integer,sdivz * z) + sadjust 
 				if (snext > bbextents)
 					snext = bbextents 
 				elseif (snext < 8) then
 				   snext = 8 
 				end if
 						'// prevent round-off error on <0 steps from
'								//  from causing overstepping & running off the
'								//  edge of the texture
'
 				tnext = cast(integer,tdivz * z) + tadjust 
    			if (tnext > bbextentt) then
 					tnext = bbextentt 
 				elseif (tnext < 8) then
 					tnext = 8 	'// guard against round-off error on <0 steps
 				end if
 				sstep = (snext - s) shr 3 
 				tstep = (tnext - t) shr 3 
 
 			else
 
'			// calculate s/z, t/z, zi->fixed s and t at last pixel in span (so
'			// can't step off polygon), clamp, calculate s and t steps across
'			// span by division, biasing steps low so we don't run off the
'			// texture
 				spancountminus1 = cast(float,spancount - 1) 
 				sdivz += d_sdivzstepu * spancountminus1 
 				tdivz += d_tdivzstepu * spancountminus1 
   			zi += d_zistepu * spancountminus1 
 				z = cast(float,&H10000) / zi 	'// prescale to 16.16 fixed-point
 				snext = cast(integer,sdivz * z) + sadjust 
 				if (snext > bbextents)then
 					snext = bbextents 
 				elseif (snext < 8) then
 					snext = 8 	'// prevent round-off error on <0 steps from
				end if			'//  from causing overstepping & running off the
								   '//  edge of the texture
 
 				tnext = cast(integer,(tdivz * z)) + tadjust 
      		if (tnext > bbextentt) then
 					tnext = bbextentt 
 				else if (tnext < 8) then
 					tnext = 8 	'// guard against round-off error on <0 steps
 				end if
 
 				if (spancount > 1) then
 
 					sstep = (snext - s) / (spancount - 1) 
 					tstep = (tnext - t) / (spancount - 1) 
 			   end if
        
 
 			do
 
   			*pdest  = *(pbase + (s shr 16) + (t shr 16) * cachewidth) 
   			pdest+=1
 			   s += sstep 
 				t += tstep 
          spancount-=1
 			loop while (spancount > 0) 
 
 			s = snext 
 			t = tnext 
 
 	loop  while (count > 0) 
 
 loop while ((pspan = pspan->pnext) <> NULL) 
end sub

 #endif

#ifndef id386

/'
=============
D_DrawZSpans
=============
'/
sub D_DrawZSpans (pspan as espan_t ptr)
 
	dim as integer				count, doublecount, izistep 
	dim as integer				izi 
	dim as short			*pdest 
	dim as uinteger		ltemp 
	dim as float			zi 
	dim as float			du, dv 

'// FIXME: check for clamping/range problems
'// we count on FP exceptions being turned off to avoid range problems
	izistep = cast(int,d_zistepu) * &H8000 * &H10000 

	do
 
		pdest = d_pzbuffer + (d_zwidth * pspan->v) + pspan->u 

		count = pspan->count 

	'// calculate the initial 1/z
		du = cast(float,pspan->u) 
		dv = cast(float,pspan->v) 

		zi = d_ziorigin + dv*d_zistepv + du*d_zistepu 
	'// we count on FP exceptions being turned off to avoid range problems
		izi = cast(integer,zi * &H8000 * &H10000) 

		if (cast(long,pdest) and &H02))
	 
			*pdest  = cast(short,izi shr 16) 
			pdest+=1
			izi += izistep 
			count-=1
		end if

		if ((doublecount = count shr 1) > 0) then
		 
			do
			 
				ltemp = izi shr 16 
				izi += izistep 
				ltemp |= izi and 0xFFFF0000 
				izi += izistep 
				*cast(int ptr,pdest) = ltemp 
				pdest += 2 
				doublecount-=1
			loop  while (doublecount > 0) 
		end if

		if (count and 1) then
			*pdest = cast(short,izi shr 16)
		EndIf
		 

	loop while ((pspan = pspan->pnext) <> NULL) 
end sub

#endif

