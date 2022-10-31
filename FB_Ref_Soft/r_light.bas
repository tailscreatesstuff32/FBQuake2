'FINISHED FOR NOW//////////////////////////////////////////////////////////////


#Include "FB_Ref_Soft\r_local.bi"
dim shared as integer	r_dlightframecount

extern	as uinteger		blocklights(1024)


dim shared as uinteger		blocklights(1024)	'// allow some very large lightmaps

sub R_MarkLights (light as dlight_t ptr,_bit as integer ,node as mnode_t ptr)
 	dim as  mplane_t	ptr splitplane 
 	dim as float		dist 
 	dim as msurface_t	ptr surf 
	dim as 	integer			i 
 	
 	if (node->contents <> -1) then
 		return
 	EndIf
 
 
 	splitplane = node->plane 
 	dist = _DotProduct (@light->origin.v(0), @splitplane->normal ) - splitplane->dist 
'	
'//=====
'//PGM
 	i=light->intensity 
 	if(i<0) then
 		i=-i
 	EndIf
 	 
'//PGM
'//=====
'
 	if (dist > i)	 then'// PGM (dist > light->intensity)
 		R_MarkLights (light, _bit, node->children(0))
 		return
 	EndIf
 
 	if (dist < -i) then	'// PGM (dist < -light->intensity)
 		R_MarkLights (light, _bit, node->children(1))
 		return 
 	EndIf
 		
' // mark the polygons
 	surf = r_worldmodel->surfaces + node->firstsurface 
 	for  i =0 to node->numsurfaces -1 
 
 		if (surf->dlightframe <> r_dlightframecount) then
 			surf->dlightbits = 0
 			surf->dlightframe = r_dlightframecount
 		EndIf
 
 		surf->dlightbits or= _bit 
 		surf+=1
  	next
 
 	R_MarkLights (light, _bit, node->children(0)) 
 	R_MarkLights (light, _bit, node->children(1)) 
End Sub





	sub R_PushDlights( model as model_t ptr )
	 dim as integer		i 
	 dim as dlight_t	ptr l 

	 r_dlightframecount = r_framecount 
	 
	 l = r_newrefdef.dlights
	 for  i=0   to r_newrefdef.num_dlights-1
	 	 
 		R_MarkLights ( l, 1 shl i,  _
	 	model->nodes + model->firstnode)
	 
	 l+=1
	 Next
 
	'}
		
	End Sub
'	/*
'=============================================================================
'
'LIGHT SAMPLING
'
'=============================================================================
'*/
'
dim shared as vec3_t	pointcolor 
dim shared as mplane_t	ptr lightplane 		'// used as shadow plane
 dim shared as vec3_t			lightspot 
 
 function RecursiveLightPoint (node as mnode_t ptr,start as vec3_t ptr ,_end as vec3_t ptr ) as Integer
 
dim as	 float		front, back, _frac 
dim as integer			side 
dim as mplane_t	ptr plane 
dim as vec3_t		_mid 
dim as 	msurface_t	ptr surf 
dim as integer			s, t, ds, dt 
dim as integer			i 
dim as 	mtexinfo_t	ptr tex 
dim as ubyte	ptr	lightmap 
dim as	float	ptr	scales 
dim as	integer		maps 
dim as	float		   samp 
dim as integer			r 
 
 	if (node->contents <> -1) then
 				return -1 		'// didn't hit anything
 	EndIf
 
'	
'// calculate mid point
'
'// FIXME: optimize for axial
 	plane = node->plane 
 	front = _DotProduct (start, @plane->normal) - plane->dist 
 	back = DotProduct (_end, @plane->normal) - plane->dist 
 	side = front < 0 
 	
 	if ( (back < 0) = side) then
 		return RecursiveLightPoint (node->children(side), start, _end)
 	EndIf
 
 	
 	_frac = front / (front-back) 
 	_mid.v(0) = start->v(0) + (_end->v(0) - start->v(0))*_frac 
 	_mid.v(1) = start->v(1) + (_end->v(1) - start->v(1))*_frac 
 	_mid.v(2) = start->v(2) + (_end->v(2) - start->v(2))*_frac 
 	if (plane->_type < 3) then	'// axial planes
 		_mid.v(plane->_type) = plane->dist
 	end if 
'
'// go down front side	
 	r = RecursiveLightPoint (node->children(side), start,@_mid) 
 	if (r >= 0) then 
 		return r'		;		// hit something
 	EndIf
'		
  if ( (back < 0) = side ) then
  	return -1'		;		// didn't hit anuthing
  EndIf
 	
'// check for impact on this node
 	_VectorCopy (@_mid, @lightspot) 
 	lightplane = plane 
 
 	surf = r_worldmodel->surfaces + node->firstsurface 
 	for  i=0   to  node->numsurfaces-1  
 
 		if (surf->flags and (SURF_DRAWTURB or SURF_DRAWSKY))  then
 			continue for
 		EndIf
  

 		tex = surf->texinfo 
 		
 		s = _DotProduct (@_mid, @tex->vecs(0,0))  + tex->vecs(0,3) 
 		t = _DotProduct (@_mid, @tex->vecs(1,0))  + tex->vecs(1,3) 
 		if (s < surf->texturemins(0) or _
 		t < surf->texturemins(1)) then
 		 	continue for
 		end if
 		ds = s - surf->texturemins(0) 
 		dt = t - surf->texturemins(1)
 		
 		if ( ds > surf->extents(0) or dt > surf->extents(1) ) then
 		 	continue for
 		EndIf
 
 	if (surf->samples = NULL) then
 			return 0 
 	EndIf
 	
'
 		ds shr= 4 
 		dt shr= 4 
 
 		lightmap = surf->samples 
 		_VectorCopy (@vec3_origin, @pointcolor) 
 		if (lightmap) then
 
 			lightmap += dt * ((surf->extents(0) shr 4)+1) + ds 
 
 		do while maps < MAXLIGHTMAPS and surf->styles(maps) <> 255  
 				
 			 


 				samp = *lightmap * /' 0.5 * '/ (1.0/255) 	'// adjust for gl scale
   		   scales = @r_newrefdef.lightstyles[0]._rgb(0)  
 				VectorMA (@pointcolor, samp, @scales, @pointcolor) 
 				lightmap += ((surf->extents(0) shr 4)+1) * _
 						((surf->extents(1) shr 4)+1) 
 			maps+=1
 		loop
 			
 		end if
 		
   surf+=1
   
   return 1
 next
'// go down back side
 	return RecursiveLightPoint (node->children(iif(side = 0,1,0)), @_mid, @_end) 
end function

sub R_AddDynamicLights ()
  dim as msurface_t ptr surf 
 	dim as integer			lnum 
 	dim as integer			sd, td 
   dim as 	float		dist, rad, minlight 
 	dim as vec3_t		impact, _local 
   dim as integer			s, t 
   dim as integer			i 
   dim as integer			smax, tmax 
	dim as mtexinfo_t ptr	tex 
 	dim as dlight_t	ptr dl 
	dim as integer	   negativeLight 	'//PGM
 
	surf = r_drawsurf.surf 
	smax = (surf->extents(0) shr 4)+1 
	tmax = (surf->extents(1) shr 4)+1 
	tex = surf->texinfo 
 
    for lnum = 0 to r_newrefdef.num_dlights -1
 
 		if (  (surf->dlightbits and (1 shl lnum) ) = null) then
  			continue for '		// not lit by this light			
 		EndIf

 		dl = @r_newrefdef.dlights[lnum] 
 		rad = dl->intensity 
 
'//=====
'//PGM
 		negativeLight = 0 
 		if(rad < 0) then
 
 			negativeLight = 1 
 			rad = -rad 
 		end if
'//PGM
'//=====
' 
 		 dist = _DotProduct (@dl->origin.v(0), @surf->plane->normal)  - _ 
 				  surf->plane->dist 
 		rad -= fabs(dist) 
 		minlight = 32 		'// dl->minlight;
 		if (rad < minlight) then
 			continue for
 		end if
   	minlight = rad - minlight 
 
 		for i=0 to 3-1 
 			  impact.v(i) =  dl->origin.v(i)  - _
		      surf->plane->normal.v(i)*dist 			
 		Next
 
 
 		_local.v(0) = _DotProduct (@impact, @tex->vecs(0,0)) + tex->vecs(0,3) 
 		_local.v(1) = _DotProduct (@impact, @tex->vecs(1,1)) + tex->vecs(1,3) 
 
 		_local.v(0) -= surf->texturemins(0) 
 		_local.v(1) -= surf->texturemins(1)  
 		
 		for  t = 0 to tmax - 1 
 
   		td = _local.v(1) - t*16 
 			if (td < 0) then
 				td = -td
 			EndIf
 
 
 			  for s = 0 to s < smax
 			 	
 		 
 
 				sd = _local.v(0) - s*16 
 				if (sd < 0) then
 					sd = -sd
 				EndIf

 					 
 				if (sd > td) then
 				   dist = sd + (td shr 1) 
 				else
   				dist = td + (sd shr 1) 	
 				EndIf

'//====
'//PGM
 				if(negativeLight <> null) then
 
 					if (dist < minlight) then
 						blocklights(t*smax + s) += (rad - dist)*256 
 					end if
 				 
 				else
 			 
 					if (dist < minlight) then
   					blocklights(t*smax + s) -= (rad - dist)*256 
   				end if
 					if(blocklights(t*smax + s) < minlight) then
 						blocklights(t*smax + s) = minlight
 					end if	
 				end if 
'				
'//PGM
'//====
 			next
 		next
   next
End Sub


sub R_BuildLightMap ()
   dim as   integer			smax, tmax 
 	dim as   integer			t 
   dim as   integer			i, size 
 	dim as ubyte		ptr lightmap 
 	dim as   integer	scale 
   dim as   integer		maps 
 	dim as  msurface_t ptr   surf 	
 
 	surf = r_drawsurf.surf 
 
 	smax = (surf->extents(0) shr 4) + 1 
 	tmax = (surf->extents(1) shr  4) + 1 
 	size = smax*tmax 
 
 	if (r_fullbright->value or  r_worldmodel->lightdata = NULL) then
 		 		for i = 0 to size-1
 		 		
 		 		blocklights(i) = 0
 		 		
 		 		Next
 
 		return 
 
 
 	EndIf
 

'// clear to no light
 	for  i=0 to size -1
 		blocklights(i) = 0
 	Next
 		 
 
'// add all the lightmaps
 	lightmap = surf->samples 
 	if (lightmap) then
 		
 	EndIf
 
 	 do while maps < MAXLIGHTMAPS and surf->styles(maps) <> 255 
 	 	 	 	 			scale = r_drawsurf.lightadj(maps)	'// 8.8 fraction		
 			for  i=0 to size -1
 				blocklights(i) += lightmap[i] * scale
 			Next
 			lightmap += size 	'// skip to next lightmap	
 	 Loop
 

 	 
 
'// add all the dynamic lights
 	if (surf->dlightframe = r_framecount) then
 		R_AddDynamicLights ()
 	EndIf
 
 
'// bound, invert, and shift
 	for  i=0  to size - 1 
 
 		t = cast(integer,blocklights(i)) 
   	if (t < 0) then
   		t = 0
   	EndIf
 
  		t = (255*256 - t) shr  (8 - VID_CBITS) 
 
 		if (t < (1 shl 6)) then
 			 t = (1 shl 6) 
 		EndIf
 			
 
  		blocklights(i) = t 
 	next
End Sub



sub R_LightPoint (p as vec3_t ptr ,_color as vec3_t ptr )
	 dim as	vec3_t		_end 
	 dim as	float		r 
	 dim as	integer			lnum  
	 dim as	dlight_t	ptr dl 
	 dim as	float		light 
	 dim as vec3_t ptr		dist 
	 dim as float		_add 
	 
	 if ( r_worldmodel->lightdata = NULL)  then
	 	_color->v(2) = 1.0
	 	_color->v(1) = _color->v(2)
	 	_color->v(0) = _color->v(1)
	 	
	 	return
	 EndIf
 
 
	 _end.v(0) = p->v(0) 
	 _end.v(1) = p->v(1)
	 _end.v(2)  =p->v(2) - 2048 
  
	 r = RecursiveLightPoint (r_worldmodel->nodes, p, @_end) 
 
	 if (r = -1) then
	 	_VectorCopy (@vec3_origin, _color) 
	 else
	 	_VectorCopy (@pointcolor, _color)
	 EndIf
 
 

	'//
	'// add dynamic lights
	'//
	 light = 0 
	 for lnum=0 to  r_newrefdef.num_dlights -1 
	 
   	dl =  @r_newrefdef.dlights[lnum] 
	 	_VectorSubtract (@currententity->origin(0), _
	 					@dl->origin.v(0), _
	 					@dist) 
	 	_add = dl->intensity - VectorLength(dist) 
	 	_add *= (1.0/256) 
	 	if (_add > 0) then
	 		VectorMA (@_color, _add, @dl->_color.v(0), @_color) 
	 	EndIf
 
	next
	
End Sub
