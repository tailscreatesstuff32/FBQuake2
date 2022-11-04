'FINISHED FOR NOW////////////////////////////////////////////////////////////////////

#Include "FB_Ref_Soft\r_local.bi"



extern "C"

extern as medge_t			ptr r_pedge
extern as qboolean		r_leftclipped, r_rightclipped 
extern as mvertex_t	r_leftenter, r_leftexit 
extern as mvertex_t	r_rightenter, r_rightexit 
 
end extern






#define MAXLEFTCLIPEDGES		100

'// !!! if these are changed, they must be changed in asm_draw.h too !!!
#define FULLY_CLIPPED_CACHED	&H80000000
#define FRAMECOUNT_MASK			&H7FFFFFFF

dim shared as uinteger		cacheoffset


dim shared as integer			c_faceclip 				'// number of faces clipped




dim shared  as clipplane_t	 ptr entity_clipplanes 
dim shared  as clipplane_t	view_clipplanes(4) 
dim shared  as clipplane_t	world_clipplanes(16) 


dim shared as medge_t			ptr r_pedge 


dim shared  as qboolean 	r_leftclipped, r_rightclipped
static shared as qboolean	makeleftedge, makerightedge
dim shared as qboolean		r_nearzionly



dim shared as integer      sintable(1280) 
dim shared  as integer      intsintable(1280) 
dim shared  as integer		blanktable(1280) 		'// PGM



dim shared  as mvertex_t	r_leftenter, r_leftexit 
dim shared  as mvertex_t	r_rightenter, r_rightexit 



type evert_t
   as float	u,v 
	as integer		ceilv 
End Type


dim shared  as integer				r_emitted 
dim shared  as float			      r_nearzi 
dim shared as float			r_u1, r_v1, r_lzi1
dim shared as integer	   r_ceilv1

 
dim shared  as qboolean		r_lastvertvalid
 dim shared as integer				r_skyframe

 dim shared as msurface_t	ptr	r_skyfaces 
 dim shared as mplane_t		r_skyplanes(6)
 dim shared as  mtexinfo_t		r_skytexinfo(6)
 dim shared as mvertex_t	ptr	r_skyverts 
 dim shared as medge_t	ptr		r_skyedges 
 dim shared as integer		ptr		r_skysurfedges 

 






 

 dim shared as vec3_t box_vecs(6,2) 
 
  dim shared as integer box_edges(24) 
 

'dim shared as qboolean		r_lastvertvalid 
 
'




dim shared  as integer	 skybox_planes(12) 
dim shared as integer box_faces(6)

dim shared as float box_verts(8,3)


extern as model_t ptr loadmodel
sub R_InitSkyBox()
 
	dim as	integer		i 


	r_skyfaces = loadmodel->surfaces + loadmodel->numsurfaces 
	 loadmodel->numsurfaces += 6 
	 r_skyverts = loadmodel->vertexes + loadmodel->numvertexes 
	 loadmodel->numvertexes += 8 
	 r_skyedges = loadmodel->edges + loadmodel->numedges 
	 loadmodel->numedges += 12 
	 r_skysurfedges = loadmodel->surfedges + loadmodel->numsurfedges 
	 loadmodel->numsurfedges += 24 
	 if (loadmodel->numsurfaces > MAX_MAP_FACES _
	 	or loadmodel->numvertexes > MAX_MAP_VERTS _
	 	or loadmodel->numedges > MAX_MAP_EDGES) then
	 	ri.Sys_Error (ERR_DROP, "InitSkyBox: map overflow")
	 	end if
	 	 

	 memset (r_skyfaces, 0, 6*sizeof(*r_skyfaces)) 
	 for i = 0 to 6-1
	 	
	 	
	 	
	 Next
 
 		r_skyplanes(i).normal.v(skybox_planes(i*2)) = 1 
	 	r_skyplanes(i).dist = skybox_planes(i*2+1) 

	 	_VectorCopy (@box_vecs(i,0), @r_skytexinfo(i).vecs(0,0)) 
	 	_VectorCopy (@box_vecs(i,1), @r_skytexinfo(i).vecs(1,0)) 

	 	r_skyfaces[i].plane = @r_skyplanes(i) 
	 	r_skyfaces[i].numedges = 4 
	 	r_skyfaces[i].flags = box_faces(i) or SURF_DRAWSKYBOX 
	 	r_skyfaces[i].firstedge = loadmodel->numsurfedges-24+i*4 
	 	r_skyfaces[i].texinfo = @r_skytexinfo(i) 
	 	r_skyfaces[i].texturemins(0) = -128 
	 	r_skyfaces[i].texturemins(1) = -128 
	 	r_skyfaces[i].extents(0) = 256 
	 	r_skyfaces[i].extents(1) = 256 
	'}

	'for (i=0 ; i<24 ; i++)
	'	if (box_surfedges[i] > 0)
	'		r_skysurfedges[i] = loadmodel->numedges-13 + box_surfedges[i];
	'	else
	'		r_skysurfedges[i] = - (loadmodel->numedges-13 + -box_surfedges[i]);

	 for i=0 to  12-1 
	' 
	 	r_skyedges[i].v(0) = loadmodel->numvertexes-9+box_edges(i*2+0)
	 	r_skyedges[i].v(1) = loadmodel->numvertexes-9+box_edges(i*2+1) 
	 	r_skyedges[i].cachededgeoffset = 0 
	 next
End Sub








/'
================
R_EmitSkyBox
================
'/
sub R_EmitSkyBox ()
	dim as integer		i, j 
	dim as integer		oldkey 

	if (insubmodel) then
		return '// submodels should never have skies
	end if
			
	if (r_skyframe = r_framecount) then
		return '// already set this frame
	EndIf
				

	r_skyframe = r_framecount 

	''// set the eight fake vertexes
	 for i = 0 to 8 - 1
	 	for j = 0 to 3-1
	 	r_skyverts[i].position.v(j) = r_origin.v(j) + box_verts(i,j)*128 	
	 	Next
	 Next
	 		

	'// set the six fake planes
	 for i =0 to 6 -1
	 	if (skybox_planes(i*2+1) > 0) then
	 		r_skyplanes(i).dist = r_origin.v(skybox_planes(i*2))+128 
	 	else
	 		r_skyplanes(i).dist = r_origin.v(skybox_planes(i*2))-128 
	 	EndIf
	next

	'// fix texture offseets
	for i = 0 to 6-1
	  
		r_skytexinfo(i).vecs(0,3) = -_DotProduct (@r_origin, @r_skytexinfo(i).vecs(0,0)) 
		r_skytexinfo(i).vecs(1,3) = -_DotProduct (@r_origin, @r_skytexinfo(i).vecs(1,0)) 
	next

	'// emit the six faces
	oldkey = r_currentkey 
	r_currentkey = &H7ffffff0 
 	for i = 0 to 6-1
	 
		R_RenderFace (r_skyfaces + i, 15) 
	next
	r_currentkey = oldkey 		'// bsp sorting order
	
	
	
End Sub


#ifndef id386



/'
================
R_EmitEdge
================
'/
sub R_EmitEdge (pv0 as mvertex_t ptr,pv1 as mvertex_t ptr)
	
End Sub

/'
================
R_ClipEdge
================
'/
sub R_ClipEdge (pv0 as mvertex_t ptr,pv1 as mvertex_t ptr,clip as clipplane_t ptr)
	
End Sub



#endif






/'
================
R_EmitCachedEdge
================
'/
sub R_EmitCachedEdge ()
		dim as edge_t	ptr	pedge_t 

	'pedge_t = (edge_t *)((unsigned long)r_edges + r_pedge->cachededgeoffset);

	if ( pedge_t->surfs(0) = NULL) then 
				pedge_t->surfs(0) = surface_p - surfaces 
	else
		pedge_t->surfs(1) = surface_p - surfaces 
	EndIf


	if (pedge_t->nearzi > r_nearzi) then
		'// for mipmap finding
		r_nearzi = pedge_t->nearzi
	EndIf
	 

	r_emitted = 1 
End Sub


/'
================
R_RenderFace
================
'/
sub R_RenderFace (fa as msurface_t ptr,clipflags as integer )
   dim as integer			i, lindex  
	 dim as uinteger	mask 
	 dim as mplane_t	ptr pplane 
	 dim as float		distinv 
	 dim as vec3_t		p_normal 
	 dim as medge_t	ptr	pedges, tedge 
	 dim as clipplane_t	ptr pclip 

	'// translucent surfaces are not drawn by the edge renderer
	if (fa->texinfo->flags and (SURF_TRANS33 or SURF_TRANS66)) then
	 
		fa->nextalphasurface = r_alpha_surfaces 
		r_alpha_surfaces = fa 
		return 
	end if

	'// sky surfaces encountered in the world will cause the
	'// environment box surfaces to be emited
	if ( fa->texinfo->flags and SURF_SKY ) then
	 
		R_EmitSkyBox () 	
		return 
	end if

'// skip out if no more surfs
	if ((surface_p) >= surf_max) then
 
		r_outofsurfaces+=1
		return 
	end if

'// ditto if not enough edges left, or switch to auxedges if possible
	if ((edge_p + fa->numedges + 4) >= edge_max) then
	 
		r_outofedges += fa->numedges 
		return 
	end if

	c_faceclip+=1

'// set up clip planes
	pclip = NULL 

 

   i = 0
   mask = &H08
   do while i >=0
   	
   	
    if (clipflags and mask) then
    		view_clipplanes(i)._next = pclip 
	 		pclip = @view_clipplanes(i) 
    EndIf

	' 
   	mask shr=1
   	i-=1
   Loop






'// push the edges through
	r_emitted = 0 
	r_nearzi = 0 
	r_nearzionly = false 
	makerightedge = false 
	makeleftedge = makerightedge
	pedges = currentmodel->edges 
	r_lastvertvalid = false 

 
	 for i = 0 to fa->numedges-1
 		lindex = currentmodel->surfedges[fa->firstedge + i] 

	 	if (lindex > 0) then
	'	 
	 		r_pedge = @pedges[lindex] 

	'	'// if the edge is cached, we can just reuse the edge
	 		if ( insubmodel = NULL) then
	 		 
	 			if (r_pedge->cachededgeoffset and FULLY_CLIPPED_CACHED) then
 
	 				if ((r_pedge->cachededgeoffset and FRAMECOUNT_MASK) = _
	 					r_framecount) then
	 				 
	 					r_lastvertvalid = false 
	 					continue for
	 				end if
	 
	 			else
	 
   				if  ((cast(ulong, edge_p) - cast(ulong,r_edges)) > _
	 					 r_pedge->cachededgeoffset) andalso _
	 					 (cast(edge_t ptr, cast(ulong,r_edges    + _
	 					 r_pedge->cachededgeoffset))->owner = r_pedge)  then
	 
	 					R_EmitCachedEdge () 
	 					r_lastvertvalid = false  
	 					continue for
	 					
	 				end if
	 			end if
	 		end if

	 	'// assume it's cacheable
	 		cacheoffset = cast(ubyte ptr, edge_p) - cast(ubyte ptr, r_edges) 
	 		r_rightclipped = false 
	 		r_leftclipped = r_rightclipped
	 		
	 		
	 		R_ClipEdge (@r_pcurrentvertbase[r_pedge->v(0)], _
	 					@r_pcurrentvertbase[r_pedge->v(1)], _
	   				pclip) 
	 		r_pedge->cachededgeoffset = cacheoffset 

	 		if (r_leftclipped) then
	 			makeleftedge = true
	 		EndIf
	 
 		if (r_rightclipped) then
 			makerightedge = true
 		EndIf
	 		r_lastvertvalid = true 
	  
	  else
	 
	 		lindex = -lindex 
	 		r_pedge = @pedges[lindex] 
	 	'// if the edge is cached, we can just reuse the edge
	 		if (insubmodel = null) then
	 			
	 	 
 
	 			if (r_pedge->cachededgeoffset and FULLY_CLIPPED_CACHED) then
	 				
	 		 
	 
	 				if ((r_pedge->cachededgeoffset and FRAMECOUNT_MASK) = _
	 					r_framecount) then
 
	   				r_lastvertvalid = false 
	 					  continue for
	 				end if
	  
	 
	 			else
	 
	 			'// it's cached if the cached edge is valid and is owned
	 			'// by this medge_t
	 				if  ((cast(ulong, edge_p) - cast(ulong,r_edges)) > _
	 					 r_pedge->cachededgeoffset) andalso _
	 					     (cast(edge_t ptr, cast(ulong,r_edges    + _
	 					 r_pedge->cachededgeoffset))->owner = r_pedge)  then
	 
	 					R_EmitCachedEdge () 
	 					r_lastvertvalid = false 
	 				continue for
	 			 
	 			end if
	 		 end if
      end if
	'	'// assume it's cacheable
	 		cacheoffset = cast(ubyte ptr,edge_p) - cast(ubyte ptr,r_edges) 
	      r_rightclipped   = false   
	 		r_leftclipped = r_rightclipped
	 		R_ClipEdge (@r_pcurrentvertbase[r_pedge->v(1)], _
	 					@r_pcurrentvertbase[r_pedge->v(0)], _
	 					pclip) 
	 		r_pedge->cachededgeoffset = cacheoffset 

	 		if (r_leftclipped) then
	 			makeleftedge = true 
	 		EndIf
	 			
	 		if (r_rightclipped) then
	 			makerightedge = true 
	 		EndIf
	 		r_lastvertvalid = true 
	  end if
  next

''// if there was a clip off the left edge, add that edge too
''// FIXME: faster to do in screen space?
''// FIXME: share clipped edges?
 	if (makeleftedge) then
 
 		r_pedge = @tedge 
 		r_lastvertvalid = false 
 		R_ClipEdge (@r_leftexit,@r_leftenter, pclip->_next) 
 	end if
'
''// if there was a clip off the right edge, get the right r_nearzi
 	if (makerightedge) then
 	 
 		r_pedge = @tedge 
 		r_lastvertvalid = false 
 		r_nearzionly = true 
 		R_ClipEdge (@r_rightexit, @r_rightenter, view_clipplanes(1)._next) 
 	end if

'// if no edges made it out, return without posting the surface
	if (r_emitted = NULL) then
		return
	EndIf
		 

	r_polycount+=1

	surface_p->msurf = fa 
	surface_p->nearzi = r_nearzi 
	surface_p->flags = fa->flags 
	surface_p->insubmodel = insubmodel 
	surface_p->spanstate = 0 
	surface_p->entity = currententity 
	surface_p->key = r_currentkey:r_currentkey+=1
	surface_p->spans = NULL 

	pplane = fa->plane 
'// FIXME: cache this?
	TransformVector (@pplane->normal, @p_normal) 
'// FIXME: cache this?
	distinv = 1.0 / (pplane->dist - _DotProduct (@modelorg, @pplane->normal)) 

	surface_p->d_zistepu = p_normal.v(0) * xscaleinv * distinv 
	surface_p->d_zistepv = -p_normal.v(1) * yscaleinv * distinv 
	surface_p->d_ziorigin = p_normal.v(2) * distinv  - _
			xcenter * surface_p->d_zistepu - _
			ycenter * surface_p->d_zistepv 

	surface_p+=1
End Sub
 



/'
================
R_RenderBmodelFace
================
'/
sub R_RenderBmodelFace (pedges as bedge_t ptr,psurf as msurface_t ptr)
	dim as integer			i  
	 dim as uinteger	mask 
	 dim as mplane_t	ptr pplane 
	 dim as float		distinv 
	 dim as vec3_t		p_normal 
	 dim as medge_t	ptr  tedge 
	 dim as clipplane_t	ptr pclip 

	'// translucent surfaces are not drawn by the edge renderer
	if (psurf->texinfo->flags and (SURF_TRANS33 or SURF_TRANS66)) then
	 
		psurf->nextalphasurface = r_alpha_surfaces 
		r_alpha_surfaces = psurf 
		return 
	end if






	''// sky surfaces encountered in the world will cause the
	''// environment box surfaces to be emited
	'if ( psurf->texinfo->flags and SURF_SKY ) then
	' 
	'	R_EmitSkyBox () 	
	'	return 
	'end if

'// skip out if no more surfs
	if ( surface_p  >= surf_max) then
 
		r_outofsurfaces+=1
		return 
	end if

'// ditto if not enough edges left, or switch to auxedges if possible
	if ((edge_p + psurf->numedges + 4) >= edge_max) then
	 
		r_outofedges += psurf->numedges 
		return 
	end if

	c_faceclip+=1

   r_pedge = @tedge 

'// set up clip planes
	pclip = NULL 

 

   i = 3
   mask = &H08
   do while i >=0
   	
   	
    if (r_clipflags and mask) then
    		view_clipplanes(i)._next = pclip 
	 		pclip = @view_clipplanes(i) 
    EndIf

	' 
   	mask shr=1
   	i-=1
   Loop






'// push the edges through
	r_emitted = 0 
	r_nearzi = 0 
	r_nearzionly = _false 
	makerightedge = _false 
	makeleftedge = makerightedge
	pedges = currentmodel->edges 
	'// FIXME: keep clipped bmodel edges in clockwise order so last vertex caching
   '// can be used?
	r_lastvertvalid = false 




	do while (pedges)  
	   r_rightclipped = false
		r_leftclipped = r_rightclipped 
		R_ClipEdge (pedges->v(0), pedges->v(1), pclip) 

		if (r_leftclipped) then
			makeleftedge = true
		EndIf
	 	if (r_rightclipped) then
	 		makerightedge = true
	 	EndIf
			 
			
	 pedges = pedges->pnext
  loop



'// if there was a clip off the left edge, add that edge too
'// FIXME: faster to do in screen space?
'// FIXME: share clipped edges?
	if (makeleftedge) then
	 
		r_pedge = @tedge 
		R_ClipEdge (@r_leftexit, @r_leftenter, pclip->_next) 
	end if

'// if there was a clip off the right edge, get the right r_nearzi
	if (makerightedge) then
	 
		r_pedge = @tedge 
		r_nearzionly = true 
		R_ClipEdge (@r_rightexit, @r_rightenter, view_clipplanes(1)._next) 
	end if
  

'// if no edges made it out, return without posting the surface
	if (r_emitted = null) then
		return
	EndIf
	
	r_polycount+=1
 
	surface_p->msurf = psurf 
	surface_p->nearzi = r_nearzi 
	surface_p->flags = psurf->flags 
	surface_p->insubmodel = insubmodel 
	surface_p->spanstate = 0 
	surface_p->entity = currententity 
	surface_p->key = r_currentkey:r_currentkey+=1
	surface_p->spans = NULL 
 
 	pplane = psurf->plane 
'// FIXME: cache this?
	TransformVector (@pplane->normal, @p_normal) 
'// FIXME: cache this?
	distinv = 1.0 / (pplane->dist - _DotProduct (@modelorg, @pplane->normal)) 

	surface_p->d_zistepu = p_normal.v(0) * xscaleinv * distinv 
	surface_p->d_zistepv = -p_normal.v(1) * yscaleinv * distinv 
	surface_p->d_ziorigin = p_normal.v(2) * distinv  - _
			xcenter * surface_p->d_zistepu - _
			ycenter * surface_p->d_zistepv 

	surface_p+=1
 
 


	
End Sub
