'FINISHED FOR NOW////////////////////////////////////////////////////////

#Include "FB_Ref_Soft\r_local.bi"

 '//
'// current entity info
'//
 
dim shared as qboolean		insubmodel 


dim shared as vec3_t			modelorg 		'// modelorg is the viewpoint reletive to
														'// the currently rendering entity
														
dim shared as float			entity_rotation(3,3)
														
dim shared as entity_t   ptr currententity 

 
 



dim shared as vec3_t r_entorigin '// the currently rendering entity in world
                                 '// coordinates

dim shared as integer				r_currentbkey 

enum solidstate_t
touchessolid,
drawnode,
nodrawnode
End Enum


#define MAX_BMODEL_VERTS	500			'// 6K
#define MAX_BMODEL_EDGES	1000		'// 12K

static shared as mvertex_t	 ptr pbverts 
static shared as bedge_t	 ptr pbedges 
static shared as integer			numbverts, numbedges 

static shared as mvertex_t ptr	pfrontenter,  pfrontexit 

static shared as qboolean		makeclippededge 


'//===========================================================================



/'
================
R_EntityRotate
================
'/
sub R_EntityRotate (vec as vec3_t ptr)
	
		dim as vec3_t tvec  	 

	_VectorCopy (@vec, @tvec) 
	vec->v(0) = _DotProduct (@entity_rotation(0,0), @tvec) 
	vec->v(1) = _DotProduct (@entity_rotation(1,0), @tvec) 
	vec->v(2) = _DotProduct (@entity_rotation(2,0), @tvec) 
	
End Sub
 
 




/'
================
R_RotateBmodel
================
'/
sub R_RotateBmodel ()
 
	dim as float	angle, s, c, temp1(3,3), temp2(3,3), temp3(3,3) 

'// TODO: should use a look-up table
'// TODO: should really be stored with the entity instead of being reconstructed
'// TODO: could cache lazily, stored in the entity
'// TODO: share work with R_SetUpAliasTransform

'// yaw
	angle = currententity->angles(YAW) 		
	angle = angle * M_PI*2 / 360 
	s = sin(angle) 
	c = cos(angle) 

	temp1(0,0) = c 
	temp1(0,1) = s 
	temp1(0,2) = 0 
	temp1(1,0) = -s 
	temp1(1,1) = c 
	temp1(1,2) = 0 
	temp1(2,0) = 0 
	temp1(2,1) = 0 
	temp1(2,2) = 1 


'// pitch
	angle = currententity->angles(PITCH) 		
	angle = angle * M_PI*2 / 360 
	s = sin(angle) 
	c = cos(angle) 

	temp2(0,0) = c 
	temp2(0,1) = 0 
	temp2(0,2) = -s 
	temp2(1,0) = 0 
	temp2(1,1) = 1 
	temp2(1,2) = 0 
	temp2(2,0) = s 
	temp2(2,1) = 0 
	temp2(2,2) = c 

	R_ConcatRotations (temp2(), temp1(), temp3()) 

'// roll
 	angle = currententity->angles(ROLL)		
 	angle = angle * M_PI*2 / 360 
 	s = sin(angle) 
 	c = cos(angle) 
 
	temp1(0,0) = 1 
	temp1(0,1) = 0 
	temp1(0,2) = 0 
	temp1(1,0) = 0 
	temp1(1,1) = c 
	temp1(1,2) = s 
	temp1(2,0) = 0 
	temp1(2,1) = -s 
	temp1(2,2) = c 

	 R_ConcatRotations (temp1(), temp3(), entity_rotation()) 

'//
'// rotate modelorg and the transformation matrix
'//
	 R_EntityRotate(@modelorg) 
	 R_EntityRotate (@vpn) 
	 R_EntityRotate (@vright) 
	 R_EntityRotate (@vup) 

	 R_TransformFrustum () 
end sub



/'
================
R_RecursiveClipBPoly

Clip a bmodel poly down the world bsp tree
================
'/
sub R_RecursiveClipBPoly (pedges as bedge_t ptr,pnode as mnode_t ptr,psurf as msurface_t ptr)
   dim as bedge_t	ptr pnextedge,  ptedge ,	 psideedges(2)
  	dim as integer			i, side, lastside 
 	dim as float		dist, _frac, lastdist 
 	dim as mplane_t tplane 
 	dim as mplane_t ptr	 splitplane
    
 	dim as  mvertex_t	ptr pvert,  plastvert,  ptvert 
 	dim as mnode_t	 ptr pn 
 	dim as integer			area 
 
 
   psideedges(1) = NULL
 	psideedges(0) = psideedges(1)
 
 	makeclippededge = _false 
 
'// transform the BSP plane into model space
'// FIXME: cache these?
 	splitplane = pnode->plane 
 	tplane.dist = splitplane->dist - _
 			_DotProduct(@r_entorigin, @splitplane->normal) 
 	tplane.normal.v(0) = _DotProduct (@entity_rotation(0,0), @splitplane->normal)  
 	tplane.normal.v(1) = _DotProduct (@entity_rotation(1,0), @splitplane->normal) 
 	tplane.normal.v(2) = _DotProduct (@entity_rotation(2,0), @splitplane->normal) 
 
'// clip edges to BSP plane
 
    do while pedges
    	pnextedge = pedges->pnext 
    	
    	'	// set the status for the last point as the previous point
'	// FIXME: cache this stuff somehow?
    	
 		plastvert = pedges->v(0) 
 		lastdist = _DotProduct (@plastvert->position, @tplane.normal) - _
 				   tplane.dist 
    	
 
 		
 

 
 		if (lastdist > 0) then
 		 	lastside = 0 
 		else
 			lastside = 1 	
 		EndIf

 
   	pvert = pedges->v(1)
 
 		dist = _DotProduct (@pvert->position, @tplane.normal) - tplane.dist 
 
 		if (dist > 0) then
 		   side = 0 
 		else
 			side = 1	
 			
 		EndIf
 
 
 		 if (side <> lastside) then
 
'		// clipped
 			if (numbverts >= MAX_BMODEL_VERTS) then
 				return
 			EndIf
 
 
'		// generate the clipped vertex
 			_frac = lastdist / (lastdist - dist) 
 			ptvert = @pbverts[numbverts]:numbverts+=1 
 			
 			ptvert->position.v(0) = plastvert->position.v(0) + _
 					_frac * (pvert->position.v(0) - _
 					plastvert->position.v(0)) 
 			ptvert->position.v(1) = plastvert->position.v(1) + _
 					_frac * (pvert->position.v(1) - _
  					plastvert->position.v(1)) 
 			ptvert->position.v(2) = plastvert->position.v(2) + _
 					_frac * (pvert->position.v(2) - _
 					plastvert->position.v(2)) 
'
'		// split into two edges, one on each side, and remember entering
'		// and exiting points
'		// FIXME: share the clip edge by having a winding direction flag?
 			if (numbedges >= (MAX_BMODEL_EDGES - 1)) then
 
 				ri.Con_Printf (PRINT_ALL,!"Out of edges for bmodel\n") 
 				return 
 			end if
 
 			ptedge = @pbedges[numbedges] 
 			ptedge->pnext = psideedges(lastside) 
 			psideedges(lastside) = ptedge 
 			ptedge->v(0) = plastvert
 			ptedge->v(1) = ptvert 
  
 			ptedge = @pbedges[numbedges + 1] 
 			ptedge->pnext = psideedges(side) 
   		psideedges(side) = ptedge 
 			ptedge->v(0) = ptvert 
 			ptedge->v(1) = pvert 
 
 			numbedges += 2 
 
 			if (side = 0) then
 
'			// entering for front, exiting for back
 				pfrontenter = ptvert 
 				makeclippededge = true 
 
 			else
 
 				pfrontexit = ptvert 
 				makeclippededge = true 
 			end if
 
 		else
 
'		// add the edge to the appropriate side
 			pedges->pnext = psideedges(side)
 			psideedges(side) = pedges 
 		 end if
 		 
 		    	pedges = pnextedge
    	
    	
     
    
 	loop
 
'// if anything was clipped, reconstitute and add the edges along the clip
'// plane to both sides (but in opposite directions)
 	if (makeclippededge) then
  
 		if (numbedges >= (MAX_BMODEL_EDGES - 2)) then
 
   		ri.Con_Printf (PRINT_ALL,!"Out of edges for bmodel\n") 
 			return  
 		end if
 
 		ptedge = @pbedges[numbedges] 
 		ptedge->pnext = psideedges(0)
 		psideedges(0) = ptedge 
 		ptedge->v(0) = pfrontexit 
 		ptedge->v(1) = pfrontenter 
 
 		ptedge = @pbedges[numbedges + 1] 
 		ptedge->pnext = psideedges(1) 
 		psideedges(1) = ptedge 
 		ptedge->v(0) = pfrontenter 
 		ptedge->v(1) = pfrontexit 
'
 		numbedges += 2 
 	end if
'
'// draw or recurse further
 	for   i=0 to 2-1 
 
 		 if (psideedges(i)) then
 
		'// draw if we've reached a non-solid leaf, done if all that's left is a
		'// solid leaf, and continue down the tree if it's not a leaf
			pn = pnode->children(i)

 		'// we're done with this branch if the node or leaf isn't in the PVS
 			 if (pn->visframe = r_visframecount) then
 
 			 	if (pn->contents <> CONTENTS_NODE) then
 
 			 		if (pn->contents <> CONTENTS_SOLID) then
 
 			 			if (r_newrefdef.areabits) then
 		 			 
			 			area = (cast(mleaf_t ptr,pn))->area 
			 			   if (  (r_newrefdef.areabits[area shr 3] and (1 shl (area and 7)) ) = null ) then
 			 			 		continue for		'// not visible
 
                      end if
         			end if
			 			 r_currentbkey = (cast(mleaf_t ptr,pn))->key 
			 		  '  R_RenderBmodelFace (psideedges(i), psurf) 
						
 			 		end if
 			  
 			 	else
 
 					R_RecursiveClipBPoly (@psideedges(i), @pnode->children(i), _
 									  psurf) 
 			  end if
 		 	
 		  end if
 	
	 end if
	
	next
	
End Sub


sub  R_DrawSolidClippedSubmodelPolygons(pmodel as model_t ptr,topnode as mnode_t ptr)	
	dim as integer			i, j, lindex 
	dim as vec_t		dot 
	dim as msurface_t	ptr psurf 
	dim as integer		numsurfaces 
	dim as mplane_t	ptr pplane 
	dim as mvertex_t	bverts(MAX_BMODEL_VERTS) 
	dim as bedge_t		bedges(MAX_BMODEL_EDGES)
	dim as bedge_t ptr pbedge 
	dim as medge_t	ptr	 pedge,  pedges 
  
'// FIXME: use bounding-box-based frustum clipping info?
 
 	psurf = @pmodel->surfaces[pmodel->firstmodelsurface] 
 	numsurfaces = pmodel->nummodelsurfaces 
 	pedges = pmodel->edges 
'
'	for (i=0 ; i<numsurfaces ; i++, psurf++)
 for i = 0 to numsurfaces-1
 		'// find which side of the node we are on
 		pplane = psurf->plane 
 	
 	
 	dot = DotProduct (@modelorg, @pplane->normal) - pplane->dist
 	
 	
 	'	// draw the polygon
 		if ((  (psurf->flags and SURF_PLANEBACK) = null andalso (dot < -BACKFACE_EPSILON)) orelse _
 			((psurf->flags and SURF_PLANEBACK) andalso (dot > BACKFACE_EPSILON))) then
 			
 			
 			continue for
 
 		end if
 	'	// FIXME: use bounding-box-based frustum clipping info?
'
'	// copy the edges to bedges, flipping if necessary so always
'	// clockwise winding
'	// FIXME: if edges and vertices get caches, these assignments must move
'	// outside the loop, and overflow checking must be done here
		pbverts = @bverts(0) 
		pbedges = @bedges(0) 
		numbedges = 0 
		numbverts = numbedges 
		pbedge = @bedges(numbedges) 
		numbedges += psurf->numedges 
 	
 	 		for  j=0 to psurf->numedges-1 
 
 		   lindex = pmodel->surfedges[psurf->firstedge+j] 
 
 			if (lindex > 0) then
 
 				pedge = @pedges[lindex] 
 				pbedge[j].v(0) = @r_pcurrentvertbase[pedge->v(0)] 
 				pbedge[j].v(1) = @r_pcurrentvertbase[pedge->v(1)] 
 
 			else
 
 				lindex = -lindex 
 				pedge = @pedges[lindex] 
 				pbedge[j].v(0) = @r_pcurrentvertbase[pedge->v(1)] 
 				pbedge[j].v(1) = @r_pcurrentvertbase[pedge->v(0)] 
 		   end if
 
 			pbedge[j].pnext = @pbedge[j+1] 
 		next
 

  		pbedge[j-1].pnext = NULL 	'// mark end of edges
 
 		if (  ( psurf->texinfo->flags and ( SURF_TRANS66 or SURF_TRANS33 ) ) ) then
 			' R_RecursiveClipBPoly (pbedge, topnode, psurf) 
 		else
 		'	 R_RenderBmodelFace( pbedge, psurf) 
 		EndIf
 
 	
 Next
 


 

 
 
	
End Sub
 








/'
================
R_DrawSubmodelPolygons

All in one leaf
================
'/
sub R_DrawSubmodelPolygons (pmodel as model_t ptr,clipflags as integer ,topnode as mnode_t ptr)
   dim as integer			i 
	dim as vec_t		dot 
	dim as msurface_t	ptr psurf 
	dim as integer			numsurfaces 
	dim as mplane_t	ptr  pplane 

'// FIXME: use bounding-box-based frustum clipping info?

	psurf = @pmodel->surfaces[pmodel->firstmodelsurface]
	numsurfaces = pmodel->nummodelsurfaces  

	 for  i=0 to numsurfaces-1  
	 pplane = psurf->plane
	 
	 
	 	'// find which side of the node we are on
		pplane = psurf->plane
	 dot = _DotProduct (@modelorg, @pplane->normal) - pplane->dist
	 
	 

	 
	'// draw the polygon
	 	if (((psurf->flags and SURF_PLANEBACK) andalso (dot < -BACKFACE_EPSILON)) or _
	 		( (psurf->flags and SURF_PLANEBACK) = NULL andalso (dot > BACKFACE_EPSILON))) then
	  
	 		r_currentkey = (cast(mleaf_t ptr,topnode))->key 

	'	// FIXME: use bounding-box-based frustum clipping info?
	 		'R_RenderFace (psurf, clipflags) 
	  
	 end if
	 
	 psurf+=1
	 Next
 

End Sub



dim shared as integer c_drawnode 

sub R_RecursiveWorldNode (node as mnode_t ptr,clipflags as integer   ) 
 	dim as integer			i, c, side  
 	dim as integer ptr pindex 
 	dim as vec3_t		acceptpt, rejectpt 
   dim as mplane_t ptr	 plane 
   
   dim as msurface_t ptr ptr mark 
   dim as msurface_t ptr surf
 	dim as float		d, dot 
 	dim as mleaf_t	ptr	 pleaf 
 
 	if (node->contents = CONTENTS_SOLID) then
 		return 		'// solid
 	EndIf
 
 
 	if (node->visframe <> r_visframecount) then
 		return
 	EndIf
 
'// cull the clipping planes if not trivial accept
'// FIXME: the compiler is doing a lousy job of optimizing here; it could be
'//  twice as fast in ASM
 	if (clipflags) then
 
 
      for i = 0 to 4-1 
 			if (  (clipflags and (1 shl i)) = NULL) then
 				 continue for
 			EndIf
'				;	// don't need to clip against it
'
'		// generate accept and reject points
'		// FIXME: do with fast look-ups or integer tests based on the sign bit
'		// of the floating point values
'
 			pindex = pfrustum_indexes(i) 
 
 			rejectpt.v(0) = cast(float,node->minmaxs(pindex[0])) 
 			rejectpt.v(1) = cast(float,node->minmaxs(pindex[1]))
 			rejectpt.v(2) = cast(float,node->minmaxs(pindex[2])) 
 			
 			d = DotProduct (@rejectpt, @view_clipplanes(i).normal) 
 			d -= view_clipplanes(i).dist 
 			if (d <= 0) then
 				return 
 			EndIf
 				
 			acceptpt.v(0) = cast(float,node->minmaxs(pindex[3+0])) 
 			acceptpt.v(1) = cast(float,node->minmaxs(pindex[3+1])) 
 			acceptpt.v(2) = cast(float,node->minmaxs(pindex[3+2])) 
 
 			d = _DotProduct (@acceptpt, @view_clipplanes(i).normal) 
 			d -= view_clipplanes(i).dist 
 
 			if (d >= 0) then
 				clipflags and= not(1 shl i) 	'// node is entirely on screen
 			EndIf
 				
 				
 		 next
 	end if
 
 c_drawnode+=1
 
'// if a leaf node, draw stuff
 	 if (node->contents <> -1) then
 
 		pleaf = cast(mleaf_t ptr ,node )
 
'		// check for door connected areas
 	 if (r_newrefdef.areabits) then
 
 		if   (r_newrefdef.areabits[pleaf->area shr 3] and (1 shl (pleaf->area and 7)  ) = null ) then
 			return 		'// not visible
 		end if
     end if
  		mark = pleaf->firstmarksurface 
 		c = pleaf->nummarksurfaces 
 
 		if (c) then
 
 			do
 
 				(*mark)->visframe = r_framecount 
 				mark+=1
          c-=1
 			loop while (c) 
 		end if
 
 		pleaf->key = r_currentkey 
 		r_currentkey+=1 		'// all bmodels in a leaf share the same key
 
 	else
 
'	// node is just a decision point, so go down the apropriate sides
 
'	// find which side of the node we are on
 		plane = node->plane 
 
 		select case (plane->_type)
 
 		case PLANE_X 
   		dot = modelorg.v(0) - plane->dist 
 
 		case PLANE_Y 
 			dot = modelorg.v(1) - plane->dist 
 
 		case PLANE_Z 
 			dot = modelorg.v(2) - plane->dist 
 
   	case else
 			dot = _DotProduct (@modelorg, @plane->normal) - plane->dist 
 			 
 		end select
 	
 		if (dot >= 0) then
 			side = 0 
 		else
 			side = 1
 		end if
'
'	// recurse down the children, front side first
 		R_RecursiveWorldNode (@node->children(side), clipflags) 
 
'	// draw stuff
 		c = node->numsurfaces 
 
 		if (c) then
 
 			surf = @r_worldmodel->surfaces[0] + node->firstsurface 
 
 			if (dot < -BACKFACE_EPSILON) then
 
 				do
 			 
 			   	if ((surf->flags and SURF_PLANEBACK) andalso _
 						(surf->visframe =  r_framecount)) then
 			 
 						'R_RenderFace (surf, clipflags) 
 					end if
 
 					surf+=1
					c-=1
 				loop while (c)
 
 			elseif (dot > BACKFACE_EPSILON) then
 
 				do
 
 					if ((surf->flags and  SURF_PLANEBACK) = null  andalso _
 						(surf->visframe = r_framecount)) then
 
 '						R_RenderFace (surf, clipflags);
 				end if

 					surf+=1
					c-=1
 				loop while (c)
 				
 		  end if
 		
 		
'
'		// all surfaces on the same node share the same sequence number
 			r_currentkey+=1
 		end if
 
'	// recurse down the back side
 		R_RecursiveWorldNode (node->children((side = NULL)), clipflags) 
 	 
end if	
	
	
	
End sub





 sub R_RenderWorld ()
   if ( r_drawworld->value = NULL) then
   	return 
   EndIf
		
	if ( r_newrefdef.rdflags and RDF_NOWORLDMODEL ) then
		return 
	EndIf
		

	c_drawnode=0 

	'// auto cycle the world frame for texture animation
	r_worldentity.frame = cast(integer,(r_newrefdef._time*2)) 
	currententity = @r_worldentity 

	_VectorCopy (@r_origin, @modelorg) 
	currentmodel = r_worldmodel 
	 r_pcurrentvertbase = currentmodel->vertexes 

	 R_RecursiveWorldNode (currentmodel->nodes, 15) 
 End Sub


 