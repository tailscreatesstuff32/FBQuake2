
'FINISHED FOR NOW//////////////////////////////////////////////////////////////////



#Include "FB_Ref_Soft\r_local.bi"

 
#ifndef id386
sub R_SurfacePatch ()
	
End Sub
 
sub R_EdgeCodeStart ()
	
End Sub

sub R_EdgeCodeEnd ()
	
	
	
End Sub



#endif


#if 0
the complex cases add new polys on most lines, so dont optimize for keeping them the same
have multiple free span lists to try to get better coherence?
low depth complexity -- 1 to 3 or so

have a sentinal at both ends?
#endif


 
 
 
dim  shared as edge_t	ptr auxedges 
dim  shared as edge_t	ptr r_edges,  edge_p,  edge_max 
 
 
 
 
dim shared  as surf_t ptr  surfaces,  surface_p,  surf_max 
 
 


dim shared as edge_t	 ptr newedges(MAXHEIGHT) 
dim shared as edge_t	 ptr  removeedges(MAXHEIGHT) 
 
 
dim shared  as  espan_t	ptr span_p,  max_span_p 

dim shared  as integer		r_currentkey 

dim shared current_iv as integer


dim shared  as integer	edge_head_u_shift20, edge_tail_u_shift20 
 
dim shared as sub() pdrawfunc

dim shared edge_head  as edge_t 
dim shared edge_tail  as edge_t
dim shared edge_aftertail as edge_t
dim shared as edge_t	edge_sentinel 
  
dim shared fv as float
 
static shared as  integer	miplevel 

dim as float		   scale_for_mip 
dim as integer			ubasestep, errorterm, erroradjustup, erroradjustdown 

'// FIXME: should go away
'declare sub		R_RotateBmodel ()
'declare sub			R_TransformFrustum () 
extern "c"
declare sub R_GenerateSpans () 

end extern

declare sub R_GenerateSpansBackward () 
declare sub R_LeadingEdge (edge as edge_t ptr) 
declare sub R_LeadingEdgeBackwards (edge as edge_t ptr) 
declare sub R_TrailingEdge (surf as surf_t ptr,edge as  edge_t ptr) 

  
 sub R_BeginEdgeFrame ()
  	dim as integer		v 
 
 	edge_p = r_edges 
 	edge_max = @r_edges[r_numallocatededges] 
 
 	surface_p = @surfaces[2] 	'// background is surface 1,
 								      '//  surface 0 is a dummy
 	surfaces[1].spans = NULL 	'// no background spans yet
 	surfaces[1].flags = SURF_DRAWBACKGROUND 
 
 '// put the background behind everything in the world
 	if (sw_draworder->value) then
 	 	pdrawfunc = @R_GenerateSpansBackward() 
 		surfaces[1].key = 0 
 		r_currentkey = 1 
 
 	else
 
 		 pdrawfunc = @R_GenerateSpans() 
 		surfaces[1].key = &H7FFfFFFF 
 		r_currentkey = 0 
 	end if
 
 '// FIXME: set with memset
 	for  v = r_refdef.vrect.y to r_refdef.vrectbottom -1 
 	removeedges(v) = NULL
 	newedges(v) = removeedges(v) 
 	Next
 
 	
 End Sub
  
#ifndef id386


/'
==============
R_InsertNewEdges

Adds the edges in the linked list edgestoadd, adding them to the edges in the
linked list edgelist.  edgestoadd is assumed to be sorted on u, and non-empty (this is actually newedges[v]).  edgelist is assumed to be sorted on u, with a
sentinel at the end (actually, this is the active edge table starting at
edge_head.next).
==============
'/
sub R_InsertNewEdges (edgestoadd as edge_t ptr,edgelist as  edge_t ptr)
 
	dim as edge_t	ptr next_edge 

	do
	 
		next_edge = edgestoadd->_next 
edgesearch:
		if (edgelist->u >= edgestoadd->u) then
			goto addedge
		EndIf
			 
		edgelist=edgelist->_next 
		if (edgelist->u >= edgestoadd->u) then
			goto addedge 
		EndIf
		edgelist=edgelist->_next 
		if (edgelist->u >= edgestoadd->u) then
			goto addedge 
		EndIf
			
		edgelist=edgelist->_next 
		if (edgelist->u >= edgestoadd->u)
			goto addedge 
		edgelist=edgelist->_next 
		goto edgesearch 

	'// insert edgestoadd before edgelist
addedge:
		edgestoadd->_next = edgelist 
		edgestoadd->_prev = edgelist->_prev 
		edgelist->_prev->_next = edgestoadd 
		edgelist->_prev = edgestoadd 
		
		edgestoadd = next_edge
	loop while ((edgestoadd) <> NULL) 
end sub

#endif	'// !id386
	
/'
=========================================================================

SURFACE FILLING

=========================================================================
'/

dim shared as msurface_t		ptr pface 
dim shared as surfcache_t		ptr pcurrentcache 
dim shared as vec3_t			transformed_modelorg 
dim shared as vec3_t			world_transformed_modelorg 
dim shared as vec3_t			 local_modelorg 


/'
=============
D_MipLevelForScale
=============
'/
function D_MipLevelForScale (scale as float ) as Integer
 
	dim as integer		lmiplevel 

	if (scale >= d_scalemip(0) ) then
		lmiplevel = 0 
	elseif (scale >= d_scalemip(1) ) then
		lmiplevel = 1 
	elseif (scale >= d_scalemip(2) ) then
		lmiplevel = 2 
	else
		lmiplevel = 3 
	end if

	if (lmiplevel < d_minmip) then
		lmiplevel = d_minmip 
	EndIf
		
	return lmiplevel 
end function
















#ifndef d386

/'
==============
R_RemoveEdges
==============
'/

sub R_RemoveEdges (pedge as edge_t ptr)
 

	do
 
		pedge->_next->_prev = pedge->_prev 
		pedge->_prev->_next = pedge->_next 
	loop while ((pedge = pedge->nextremove) <> NULL) 
end sub

#endif	'// !id386



#ifndef	 id386
sub R_StepActiveU (pedge as edge_tptr)
 	dim as 	edge_t	ptr	pnext_edge,  pwedge 
 
 	while (1)
 
 nextedge:
 		pedge->u += pedge->u_step 
 		if (pedge->u < pedge->prev->u) then
 			goto pushback 
 		EndIf
 			
 		pedge = pedge->_next 
 			
 		pedge->u += pedge->u_step 
 		if (pedge->u < pedge->prev->u) then
 			goto pushback
 		EndIf
 			 
 		pedge = pedge->_next 
 			
 		pedge->u += pedge->u_step 
 		if (pedge->u < pedge->prev->u) then
 			goto pushback 
 		EndIf
 			
 		pedge = pedge->_next 
 			
 		pedge->u += pedge->u_step 
 		if (pedge->u < pedge->prev->u) then
 			goto pushback 
 		EndIf
 			
 		pedge = pedge->_next 
 			
 		goto nextedge 		
 		
 pushback:
 		if (pedge = @edge_aftertail) then
 			return
 		EndIf
 
 		
'	// push it back to keep it sorted		
 		pnext_edge = pedge->_next 
 
'	// pull the edge out of the edge list
 		pedge->_next->_prev = pedge->_prev 
 		pedge->_prev->_next = pedge->_next 
 
'	// find out where the edge goes in the edge list
 		pwedge = pedge->_prev->_prev 
 
 		while (pwedge->u > pedge->u)
 	 
 			pwedge = pwedge->_prev 
 		wend
 
'	// put the edge back into the edge list
 		pedge->_next = pwedge->_next 
 		pedge->_prev = pwedge 
 		pedge->_next->_prev = pedge 
 		pwedge->_next = pedge 
'
 		pedge = pnext_edge 
 		if (pedge = @edge_tail) then
 			return 
 		EndIf
 			
 	wend
	
	
End Sub

#endif


/'
==============
R_CleanupSpan
==============
'/
sub R_CleanupSpan ()
 	dim as surf_t ptr surf		 
 	dim as integer		iu 
 	dim as espan_t	ptr span 
 
'// now that we've reached the right edge of the screen, we're done with any
'// unfinished surfaces, so emit a span for whatever's on top
 	surf = surfaces[1]._next 
 	iu = edge_tail_u_shift20 
 	if (iu > surf->last_u) then
 		
 
 
 		span = span_p:span_p+=1 
 		span->u = surf->last_u 
 		span->count = iu - span->u 
 		span->v = current_iv 
 		span->pnext = surf->spans 
 		surf->spans = span 
 	EndIf
'
'// reset spanstate for all surfaces in the surface stack
 	do
 
 		surf->spanstate = 0  
 		surf = surf->_next 
   loop while (surf <> @surfaces[1]) 
End Sub


sub R_LeadingEdgeBackwards (edge as edge_t ptr )
 	dim as	espan_t	ptr		span 
 dim as	surf_t	ptr		surf,  surf2 
 dim as		integer				iu 
 
'// it's adding a new surface in, so find the correct place
 	surf = @surfaces[edge->surfs(1)] 
 
'// don't start a span if this is an inverted span, with the end
'// edge preceding the start edge (that is, we've already seen the
'// end edge)
 	if (surf->spanstate =  1) then
 		
      surf->spanstate +=1
 		surf2 = surfaces[1]._next 

		if (surf->key > surf2->key) then
			goto newtop
		EndIf

'
'	// if it's two surfaces on the same plane, the one that's already
'	// active is in front, so keep going unless it's a bmodel
		if (surf->insubmodel and (surf->key = surf2->key)) then
			'		// must be two bmodels in the same leaf; don't care, because they'll
'		// never be farthest anyway
 			goto newtop

		EndIf


 continue_search:
 
 		do
 		 
 			surf2 = surf2->_next 
 		loop while (surf->key < surf2->key) 

		if (surf->key = surf2->key) then

'		// if it's two surfaces on the same plane, the one that's already
'		// active is in front, so keep going unless it's a bmodel
			if (surf->insubmodel <> null) then
				goto continue_search
			EndIf
				

'		// must be two bmodels in the same leaf; don't care which is really
'		// in front, because they'll never be farthest anyway
		end if
'
 		goto gotposition
 
 newtop:
'	// emit a span (obscures current top)
 		iu = edge->u shr 20

		if (iu > surf2->last_u) then

			span = span_p:span_p+=1
			span->u = surf2->last_u
			span->count = iu - span->u
			span->v = current_iv
			span->pnext = surf2->spans
			surf2->spans = span
		end if

'		// set last_u on the new span
 		surf->last_u = iu 
 				
 gotposition:
'	// insert before surf2
 		surf->_next = surf2 
 		surf->_prev = surf2->_prev 
 		surf2->_prev->_next = surf  
 		surf2->_prev = surf 
 	end if
	
End Sub

/'
==============
R_TrailingEdge
==============
'/
sub R_TrailingEdge (surf as surf_t ptr,edge as edge_t ptr)
	dim as espan_t			ptr span 
	dim as integer				iu 
'
'// don't generate a span if this is an inverted span, with the end
'// edge preceding the start edge (that is, we haven't seen the
'// start edge yet)
	if (surf->spanstate = 0) then
 
 		if (surf =  surfaces[1]._next) then
 
'		// emit a span (current top going away)
 			iu = edge->u shr 20 
 			if (iu > surf->last_u) then
 
 				span = span_p:span_p+=1
 				span->u = surf->last_u 
 				span->count = iu - span->u 
 				span->v = current_iv 
 				span->pnext = surf->spans 
 				surf->spans = span 
 			end if
 
'		// set last_u on the surface below
 			surf->_next->last_u = iu 
        surf->spanstate -=1
 		end if
 
		surf->_prev->_next = surf->_next
		surf->_next->_prev = surf->_prev
 	end if


	
End Sub

/'
==============
D_CalcGradients
==============
'/
sub D_CalcGradients (pface as msurface_t ptr)
 
	dim as mplane_t	ptr pplane 
	dim as float		mipscale 
	dim as vec3_t		p_temp1 
	dim as vec3_t		p_saxis, p_taxis 
	dim as float		t 

	pplane = pface->plane 

	mipscale = 1.0 / cast(float,(1 shl miplevel)) 

	TransformVector (@pface->texinfo->vecs(0,0), @p_saxis) 
	TransformVector (@pface->texinfo->vecs(1,0), @p_taxis) 

	t = xscaleinv * mipscale 
	d_sdivzstepu = p_saxis.v(0) * t 
	d_tdivzstepu = p_taxis.v(0) * t 

	t = yscaleinv * mipscale 
	d_sdivzstepv = -p_saxis.v(1) * t 
	d_tdivzstepv = -p_taxis.v(1) * t 

	d_sdivzorigin = p_saxis.v(2) * mipscale - xcenter * d_sdivzstepu - _
			ycenter * d_sdivzstepv
	d_tdivzorigin = p_taxis.v(2) * mipscale - xcenter * d_tdivzstepu - _
			ycenter * d_tdivzstepv 

	VectorScale (@transformed_modelorg, mipscale, @p_temp1) 

	t = &H10000*mipscale 
	 sadjust = (cast(fixed16_t, _DotProduct (@p_temp1, @p_saxis ) * &H10000 + 0.5))   - _
	   	((pface->texturemins(0) shl 16) shr miplevel) _
	 		+ pface->texinfo->vecs(0,3)*t 
	 tadjust = (cast (fixed16_t, _DotProduct  (@p_temp1, @p_taxis) * &H10000 + 0.5))   - _
	 		((pface->texturemins(1) shl 16) shr miplevel) _
	 		+ pface->texinfo->vecs(1,3)*t 

	'// PGM - changing flow speed for non-warping textures.
	if (pface->texinfo->flags and SURF_FLOWING) then
	 
		if(pface->texinfo->flags and SURF_WARP) then
			sadjust += &H10000 * (-128 * ( (r_newrefdef._time * 0.25) - cast(integer,(r_newrefdef._time * 0.25)) )) 
		else
			sadjust += &H10000 * (-128 * ( (r_newrefdef._time * 0.77) - cast(integer,(r_newrefdef._time * 0.77)) )) 
		end if
	end if
	'// PGM

'//
'// -1 (-epsilon) so we never wander off the edge of the texture
'//
	bbextents = ((pface->extents(0) shl 16) shr miplevel) - 1 
	bbextentt = ((pface->extents(1) shl 16) shr miplevel) - 1 
end sub

/'
==============
R_LeadingEdge
==============
'/
sub R_LeadingEdge (edge as edge_t ptr)
   dim as espan_t	ptr		span 
 	dim as surf_t	ptr		surf,  surf2 
  	dim as integer				iu 
 	dim as float			fu, newzi, testzi, newzitop, newzibottom 
 
 	if (edge->surfs(1)) then
 
'	// it's adding a new surface in, so find the correct place
 		surf = @surfaces[edge->surfs(1)] 
'
'	// don't start a span if this is an inverted span, with the end
'	// edge preceding the start edge (that is, we've already seen the
'	// end edge)
 		if (surf->spanstate = 1) then
 
        surf->spanstate+=1
 			surf2 = surfaces[1]._next 
 
 			if (surf->key < surf2->key) then
 				goto newtop
 			EndIf
 
 
'		// if it's two surfaces on the same plane, the one that's already
'		// active is in front, so keep going unless it's a bmodel
 			if (surf->insubmodel and (surf->key = surf2->key)) then
 
'			// must be two bmodels in the same leaf; sort on 1/z
 				fu = cast(float,(edge->u - &HFFFFF)) * (1.0 / &H100000) 
 				newzi = surf->d_ziorigin + fv*surf->d_zistepv + _
 						fu*surf->d_zistepu 
 				newzibottom = newzi * 0.99 
 
 				testzi = surf2->d_ziorigin + fv*surf2->d_zistepv + _
 						fu*surf2->d_zistepu 
 
 				if (newzibottom >= testzi) then
 					goto newtop 
 				EndIf
 
 
 				newzitop = newzi * 1.01 
 				if (newzitop >= testzi) then
 
 					if (surf->d_zistepu >= surf2->d_zistepu) then
 				 
 						goto newtop 
 					end if
 				end if
 			end if
 
 continue_search:
 
 			do
 
 				surf2 = surf2->_next 
 			loop while (surf->key > surf2->key) 
 
 			if (surf->key = surf2->key) then
  
'			// if it's two surfaces on the same plane, the one that's already
'			// active is in front, so keep going unless it's a bmodel
 				if (surf->insubmodel = NULL) then
 					goto continue_search 
 				EndIf
 					
 
'			// must be two bmodels in the same leaf; sort on 1/z
 				fu = cast(float,(edge->u - &HFFFFF)) * (1.0 / &H100000) 
 				newzi = surf->d_ziorigin + fv*surf->d_zistepv + _
 						fu*surf->d_zistepu 
 				newzibottom = newzi * 0.99 
 
 				testzi = surf2->d_ziorigin + fv*surf2->d_zistepv + _
 						fu*surf2->d_zistepu 
 
 				if (newzibottom >= testzi) then
 					goto gotposition 
 				EndIf
 
 
 
 				newzitop = newzi * 1.01 
 				if (newzitop >= testzi) then
 
 					if (surf->d_zistepu >= surf2->d_zistepu) then
 					 
 						goto gotposition 
 					end if
 				end if
 
 				goto continue_search 
 			end if
'
 			goto gotposition 
 
 newtop:
'		// emit a span (obscures current top)
 			iu = edge->u shr 20 
 
 			if (iu > surf2->last_u) then
 
 				span = span_p:span_p+=1
 				span->u = surf2->last_u 
 				span->count = iu - span->u 
 				span->v = current_iv 
 				span->pnext = surf2->spans 
 				surf2->spans = span 
 			end if
'
'			// set last_u on the new span
 			surf->last_u = iu 
 			
 gotposition:
'		// insert before surf2
 			surf->_next = surf2 
 			surf->_prev = surf2->_prev 
 			surf2->_prev->_next = surf 
 			surf2->_prev = surf 
 		end if
 	end if
 	
	
	
End Sub



#ifndef id386



/'
==============
R_GenerateSpans
==============
'/
sub R_GenerateSpans ()
 
 	dim as edge_t	ptr		edge 
 	dim as surf_t	ptr		surf 
 
'// clear active surfaces to just the background surface
 	surfaces[1]._next = surfaces[1]._prev = @surfaces[1] 
 	surfaces[1].last_u = edge_head_u_shift20 
 
 
 		edge=edge_head._next
    do while edge <> @edge_tail
    	
 

 		if (edge->surfs(0)) then
 			'// it has a left surface, so a surface is going away for this span
 			surf = @surfaces[edge->surfs(0)] 
 
 			R_TrailingEdge (surf, edge) 
 
 			if ( edge->surfs[1] = NULL) then
 				continue for
 			
 		   EndIf
' 
 		R_LeadingEdge (edge) 
 	next
    Loop
 	R_CleanupSpan () 
end sub


#endif



/'
==============
R_GenerateSpansBackward
==============
'/
sub R_GenerateSpansBackward ()
 
	dim as edge_t		ptr edge 

'// clear active surfaces to just the background surface
   surfaces[1]._prev=  @surfaces[1] 
	surfaces[1]._next = surfaces[1]._prev
	surfaces[1].last_u = edge_head_u_shift20 

'// generate spans

edge=edge_head._next
do while edge <> @edge_tail

 
 			
 		if (edge->surfs(0)) then
 			R_TrailingEdge (@surfaces[edge->surfs(0)], edge)
 		EndIf
 

	 	if (edge->surfs(1)) then
	 		R_LeadingEdgeBackwards (edge)
	 	EndIf
 
	edge=edge->_next
	loop

	R_CleanupSpan () 
end sub





 sub R_ScanEdges
   dim as integer		iv, bottom 
	dim as ubyte	basespans(MAXSPANS*sizeof(espan_t)+CACHE_SIZE) 
	dim as espan_t	ptr basespan_p 
	dim as surf_t	ptr s 

 	basespan_p = cast(espan_t ptr ,(cast(long,(@basespans(0) + CACHE_SIZE - 1)) and not(CACHE_SIZE - 1))) 
 		
 	max_span_p = @basespan_p[MAXSPANS - r_refdef.vrect._width]
 
 	span_p = basespan_p 
 
'// clear active edges to just the background edges around the whole screen
'// FIXME: most of this only needs to be set up once
 	edge_head.u = r_refdef.vrect.x shl 2 
 	edge_head_u_shift20 = edge_head.u shr 20 
  	edge_head.u_step = 0 
 	edge_head._prev = NULL 
 	edge_head._next = @edge_tail 
 	edge_head.surfs(0) = 0 
 	edge_head.surfs(1) = 1 
'	
	edge_tail.u = (r_refdef.vrectright shl 20) + &HFFFFF 
	edge_tail_u_shift20 = edge_tail.u shr 20 
	edge_tail.u_step = 0 
	edge_tail._prev = @edge_head 
	edge_tail._next = @edge_aftertail 
	edge_tail.surfs(0) = 1 
	edge_tail.surfs(1) = 0 
'	
	edge_aftertail.u = -1 		'// force a move
	edge_aftertail.u_step = 0 
	edge_aftertail._next = @edge_sentinel 
	edge_aftertail._prev = @edge_tail 

'// FIXME: do we need this now that we clamp x in r_draw.c?
 	edge_sentinel.u = 2000 shl 24 		'// make sure nothing sorts past this
 	edge_sentinel._prev = @edge_aftertail 
 
'//	
'// process all scan lines
'//
 	bottom = r_refdef.vrectbottom - 1 
'
 

    for iv=r_refdef.vrect.y to bottom -1
    	
    	
    	
    	



 
 		current_iv = iv 
 		fv = cast(float,iv)
'
'	// mark that the head (background start) span is pre-included
 		surfaces[1].spanstate = 1 
'
 		if (newedges(iv)) then
 		 		R_InsertNewEdges (newedges(iv), edge_head._next) 	
 		EndIf
 
 
 		pdrawfunc()
     

'	// flush the span list if we can't be sure we have enough spans left for
'	// the next scan
 		if (span_p > max_span_p) then
 			D_DrawSurfaces () 
 		
 
 			
 



'		// clear the surface span pointers
 			for s = @surfaces[1] to surface_p-1 
   			s->spans = NULL 
 
 			span_p = basespan_p 
 			next
 		EndIf
 		if (removeedges(iv)) then
 				R_RemoveEdges (removeedges(iv))
 		EndIf
 		 
 
 		if (edge_head._next <> @edge_tail) then
 			 R_StepActiveU (edge_head._next) 
 		EndIf
 			
 	next
'
'// do the last scan (no need to step or sort or remove on the last scan)
 
 	current_iv = iv 
 	fv = cast(float,iv) 
'
'// mark that the head (background start) span is pre-included
 	surfaces[1].spanstate = 1 
'
 	if (newedges(iv)) then
 	   R_InsertNewEdges(@newedges(iv), edge_head._next)
 	EndIf
 
      pdrawfunc()
'  list
	D_DrawSurfaces () 
 	
 	
 End Sub
 
/'
==============
D_FlatFillSurface

Simple single color fill with no texture mapping
==============
'/
sub D_FlatFillSurface (surf as surf_t ptr,_color as integer )
	
  dim as espan_t	ptr span 
	dim as ubyte	ptr pdest 
	dim as integer		u, u2 
	span=surf->spans 
	 do while span 
	 
		pdest = cast(ubyte ptr, d_viewbuffer) + r_screenwidth*span-> u = span->u 
		 
		u2 = span->u + span->count - 1 
		do while u <= u2
 
			pdest[u] = _color
			u+=1 
		loop
		
		span=span->pnext	
	loop
End Sub
 
 
/'
==============
D_BackgroundSurf

The grey background filler seen when there is a hole in the map
==============
'/
sub D_BackgroundSurf (s as surf_t ptr)
 
'// set up a gradient for the background surface that places it
'// effectively at infinity distance from the viewpoint
	d_zistepu = 0 
	d_zistepv = 0 
	d_ziorigin = -0.9 

	D_FlatFillSurface (s, cast(integer,sw_clearcolor->value) and &HFF) 
	D_DrawZSpans (s->spans) 
end sub

/'
=================
D_TurbulentSurf
=================
'/
sub D_TurbulentSurf (s as surf_t ptr)
 
	d_zistepu = s->d_zistepu 
	d_zistepv = s->d_zistepv 
	d_ziorigin = s->d_ziorigin 

	pface = s->msurf 
	miplevel = 0 
	cacheblock = pface->texinfo->_image->pixels(0) 
	cachewidth = 64 

	if (s->insubmodel) then
	 
	'// FIXME: we don't want to do all this for every polygon!
	'// TODO: store once at start of frame
		currententity = s->entity 	'//FIXME: make this passed in to
									'// R_RotateBmodel ()
		_VectorSubtract (@r_origin, @currententity->origin(0), _
				@local_modelorg) 
		TransformVector (@local_modelorg, @transformed_modelorg) 

		R_RotateBmodel () 	'// FIXME: don't mess with the frustum,
							'// make entity passed in
	end if

	 D_CalcGradients (pface) 

'//============
'//PGM
	'// textures that aren't warping are just flowing. Use NonTurbulent8 instead
	if( (pface->texinfo->flags and SURF_WARP) = null) then
		NonTurbulent8 (s->spans) 
	else
		Turbulent8 (s->spans)
	end if	
		
'//PGM
'//============

	 D_DrawZSpans (s->spans) 

	if (s->insubmodel) then
	 
	'//
	'// restore the old drawing state
	'// FIXME: we don't want to do this every time!
	'// TODO: speed up
	'//
		currententity = NULL 	'// &r_worldentity;
		_VectorCopy (@world_transformed_modelorg, _
					@transformed_modelorg) 
		_VectorCopy (@base_vpn, @vpn) 
		_VectorCopy (@base_vup, @vup) 
		_VectorCopy (@base_vright, @vright) 
		R_TransformFrustum () 
	end if
end sub


/'
==============
D_SkySurf
==============
'/
sub D_SkySurf (s as surf_t ptr)

 	pface = s->msurf 
	miplevel = 0 
	if ( pface->texinfo->_image = null) then
		return 
	EndIf
		
	cacheblock = pface->texinfo->_image->pixels(0) 
	cachewidth = 256 

	d_zistepu = s->d_zistepu 
	d_zistepv = s->d_zistepv 
	d_ziorigin = s->d_ziorigin 

	 D_CalcGradients (pface) 

    D_DrawSpans16 (s->spans) 

'// set up a gradient for the background surface that places it
'// effectively at infinity distance from the viewpoint
	d_zistepu = 0 
	d_zistepv = 0 
	d_ziorigin = -0.9 

	 D_DrawZSpans (s->spans) 
end sub





sub  D_SolidSurf(s as surf_t ptr)
	d_zistepu = s->d_zistepu 
	d_zistepv = s->d_zistepv 
	d_ziorigin = s->d_ziorigin 

	if (s->insubmodel) then
	 
	'// FIXME: we don't want to do all this for every polygon!
	'// TODO: store once at start of frame
		currententity = s->entity 	'//FIXME: make this passed in to
									      ' // R_RotateBmodel ()
		_VectorSubtract (@r_origin, @currententity->origin(0), @local_modelorg) 
		TransformVector (@local_modelorg, @transformed_modelorg) 

		R_RotateBmodel () 	'// FIXME: don't mess with the frustum,
							      '// make entity passed in
 
	else
		currententity = @r_worldentity
	end if 

	pface = s->msurf 
#if 1
	miplevel = D_MipLevelForScale(s->nearzi * scale_for_mip * pface->texinfo->mipadjust) 
#else
	 scope
		dim as float dot 
		dim as float normal(3) 

		if ( s->insubmodel ) then
		 
			_VectorCopy( @pface->plane->normal, @normal(0) ) 
			'//TransformVector( pface->plane->normal, normal);
			dot = _DotProduct( @normal, @vpn ) 
		 
		else
		 
			_VectorCopy( pface->plane->normal, @normal(0) ) 
			dot = DotProduct( @normal(0), @vpn ) 
		end if

		if ( pface->flags and SURF_PLANEBACK ) then
			dot = -dot 
		EndIf
			

		if ( dot > 0 ) then
			printf( "blah" ) 
		EndIf
			

		miplevel = D_MipLevelForScale(s->nearzi * scale_for_mip * pface->texinfo->mipadjust) 
	end scope
#endif

'// FIXME: make this passed in to D_CacheSurface
	 pcurrentcache = D_CacheSurface (pface, miplevel) 

	 cacheblock = cast(pixel_t ptr,@pcurrentcache->_data(0)) 
	 cachewidth = pcurrentcache->_width 

	 D_CalcGradients (pface) 

	 D_DrawSpans16 (s->spans) 

	 D_DrawZSpans (s->spans) 

	if (s->insubmodel) then
	 
	'//
	'// restore the old drawing state
	'// FIXME: we don't want to do this every time!
	'// TODO: speed up
	'//
	 	_VectorCopy (@world_transformed_modelorg, _
					@transformed_modelorg) 
		_VectorCopy (@base_vpn, @vpn) 
		_VectorCopy (@base_vup, @vup) 
		_VectorCopy (@base_vright, @vright) 
		 R_TransformFrustum () 
		currententity = NULL 	'//&r_worldentity;
	end if
	
	
End Sub








/'
=============
D_DrawflatSurfaces

To allow developers to see the polygon carving of the world
=============
'/
sub D_DrawflatSurfaces ()
 
	dim as surf_t		ptr  s 
	
   s = @surfaces[1]
	for   s = 0 to surface_p -1 
		

	 
		if (s->spans = NULL) then
			continue for
		EndIf
			

		d_zistepu = s->d_zistepu 
		d_zistepv = s->d_zistepv 
		d_ziorigin = s->d_ziorigin 

		'// make a stable color for each surface by taking the low
		'// bits of the msurface pointer
		 D_FlatFillSurface (s, cast(integer,s->msurf) and &HFF) 
		 D_DrawZSpans (s->spans) 
	 	Next
end sub

/'
==============
D_DrawSurfaces

Rasterize all the span lists.  Guaranteed zero overdraw.
May be called more than once a frame if the surf list overflows (higher res)
==============
'/
sub D_DrawSurfaces ()
 
	dim as surf_t			ptr s 

'//	currententity = NULL 	'//&r_worldentity;
	_VectorSubtract (@r_origin, @vec3_origin, @modelorg) 
	TransformVector (@modelorg, @transformed_modelorg) 
	_VectorCopy (@transformed_modelorg, @world_transformed_modelorg) 
	 
	if ( sw_drawflat->value = null) then
 
 
	   s = @surfaces[1]
	   
	 do while s<surface_p 
	 
	 		if (s->spans = null) then
	 			continue do
	 		EndIf
		 		

		 	r_drawnpolycount+=1

		 	if ( (s->flags and (SURF_DRAWSKYBOX or SURF_DRAWBACKGROUND or SURF_DRAWTURB) ) = null ) then
		   	 D_SolidSurf (s) 
		 	elseif (s->flags and SURF_DRAWSKYBOX) then
		 	 	D_SkySurf (s) 
		 	elseif (s->flags and SURF_DRAWBACKGROUND) then
		 		 D_BackgroundSurf (s) 
		 	elseif (s->flags and SURF_DRAWTURB) then
				 D_TurbulentSurf (s) 
		 	end if
		s+=1
	 loop
	else
		 D_DrawflatSurfaces () 
	end if

		
 
	 

	currententity = NULL 	'//&r_worldentity;
	_VectorSubtract (@r_origin, @vec3_origin, @modelorg) 
	R_TransformFrustum () 
end sub



 