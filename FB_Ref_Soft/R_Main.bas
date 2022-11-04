'FINISHED FOR NOW////////////////////////////////////////////////////////////////

#Include "FB_Ref_Soft\r_local.bi"

dim shared vid as viddef_t
dim shared	ri as refimport_t

dim shared as  uinteger d_8to24table(256)

dim shared as entity_t	r_worldentity

dim shared as zstring * MAX_QPATH skyname 
dim shared as float skyrotate
dim shared as vec3_t skyaxis
dim shared as image_t ptr sky_images(6)

dim shared  r_newrefdef as refdef_t
dim shared currentmodel as model_t ptr

dim shared  r_worldmodel as model_t	ptr

dim shared as ubyte r_warpbuffer(WARP_WIDTH * WARP_HEIGHT)

dim shared sw_state as swstate_t





dim shared as any ptr   colormap 
dim shared as vec3_t		viewlightvec 
dim shared as alight_t	r_viewlighting: r_viewlighting.ambientlight = 128:r_viewlighting.shadelight = 192:r_viewlighting.plightvec = cast(float ptr,@viewlightvec) 
dim shared as float		r_time1 
dim shared as integer   r_numallocatededges 
dim shared as float		r_aliasuvscale = 1.0
dim shared as integer   r_outofsurfaces 
dim shared as integer   r_outofedges 

dim shared as qboolean	r_dowarp 

dim shared as mvertex_t	ptr r_pcurrentvertbase 

dim shared as integer   c_surf 
dim shared as integer   r_maxsurfsseen, r_maxedgesseen, r_cnumsurfs 
dim shared as qboolean	r_surfsonstack 
dim shared as integer   r_clipflags 


dim shared as vec3_t vup,base_vup
dim shared as vec3_t vpn ,base_vpn
dim shared as vec3_t	vright, base_vright
dim shared r_origin as vec3_t

dim shared as oldrefdef_t	r_refdef
dim shared as float		xcenter, ycenter 
dim shared as float		xscale, yscale 
dim shared as float		xscaleinv, yscaleinv 
dim shared as float		xscaleshrink, yscaleshrink 
dim shared as float		aliasxscale, aliasyscale, aliasxcenter, aliasycenter 

dim shared as integer r_screenwidth

dim shared as float	xOrigin, yOrigin
dim shared as float	verticalFieldOfView

dim shared as mplane_t	screenedge(4)

'//
'// refresh flags
'//
dim shared as integer		r_framecount = 1 	'// so frame counts initialized to 0 don't match
dim shared as integer		r_visframecount 
dim shared as integer	   d_spanpixcount 
dim shared as integer		r_polycount 
dim shared as integer		r_drawnpolycount 
dim shared as integer		r_wholepolycount 

dim shared as integer ptr    pfrustum_indexes(4)  
dim shared as integer 		  r_frustum_indexes(4*6) 

dim shared as mleaf_t ptr r_viewleaf
dim shared as integer	r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2


dim shared as image_t ptr  r_notexture_mip

dim shared as float	da_time1, da_time2, dp_time1, dp_time2, db_time1, db_time2, rw_time1, rw_time2 
dim shared as float	se_time1, se_time2, de_time1, de_time2 


declare sub R_MarkLeaves ()

extern as cvar_t ptr sw_allow_modex
dim shared as cvar_t ptr r_lefthand
dim shared as cvar_t ptr sw_aliasstats
dim shared as cvar_t ptr sw_allow_modex
dim shared as cvar_t ptr sw_clearcolor
dim shared as cvar_t ptr sw_drawflat
dim shared as cvar_t ptr sw_draworder
dim shared as cvar_t ptr sw_maxedges
dim shared as cvar_t ptr sw_maxsurfs
dim shared as cvar_t ptr sw_mode
dim shared as cvar_t ptr sw_reportedgeout
dim shared as cvar_t ptr sw_reportsurfout
dim shared as cvar_t ptr sw_stipplealpha
dim shared as cvar_t ptr sw_surfcacheoverride
dim shared as cvar_t ptr sw_waterwarp

dim shared as cvar_t ptr r_drawworld
dim shared as cvar_t ptr r_drawentities
dim shared as cvar_t ptr r_dspeeds
dim shared as cvar_t ptr r_fullbright
dim shared as cvar_t ptr r_lerpmodels
dim shared as cvar_t ptr r_novis

dim shared as cvar_t ptr r_speeds
dim shared as cvar_t ptr r_lightlevel	'//FIXME HACK

dim shared as cvar_t ptr vid_fullscreen
dim shared as cvar_t ptr vid_gamma


'//PGM
dim shared as cvar_t ptr sw_lockpvs
'//PGM


#define	STRINGER(x) "x"


 
 
 
'#if !id386 
#ifndef id386 
''''''''''''''''''''''''''''''''''''''''''''''''''

 
dim shared as float	d_sdivzstepu, d_tdivzstepu, d_zistepu 
dim shared as float	d_sdivzstepv, d_tdivzstepv, d_zistepv 
dim shared as float	d_sdivzorigin, d_tdivzorigin, d_ziorigin 

dim shared as fixed16_t	sadjust, tadjust, bbextents, bbextentt 

dim shared as pixel_t ptr cacheblock 
dim shared as integer cachewidth 
dim shared as pixel_t ptr d_viewbuffer 
dim shared as short ptr d_pzbuffer 
dim shared as uinteger d_zrowbytes 
dim shared as uinteger d_zwidth 


#endif	'// !id386

dim shared as ubyte	r_notexture_buffer(1024)



sub	R_InitTextures ()

dim as integer		x,y, m
dim as ubyte ptr  dest

'// create a simple checkerboard texture for the default
r_notexture_mip = cast(image_t ptr , @r_notexture_buffer(0) )

r_notexture_mip->_height = 16
r_notexture_mip->_width = r_notexture_mip->_height
r_notexture_mip->pixels(0) = @r_notexture_buffer(sizeof(image_t))
r_notexture_mip->pixels(1) = r_notexture_mip->pixels(0) + 16*16
r_notexture_mip->pixels(2) = r_notexture_mip->pixels(1) + 8*8
r_notexture_mip->pixels(3) = r_notexture_mip->pixels(2) + 4*4

for m = 0 to 4-1
	dest = r_notexture_mip->pixels(m)
	for  y=0  to (16 shr m) - 1
		for  x=0 to (16 shr m)-1
			if (  (y < (8 shr m) ) xor (x < (8 shr m) ) ) then


				*dest = 0:dest+=1
			else
				*dest  = &Hff:dest+=1
			EndIf



		Next

	Next
Next

end sub







'/*
'================
'R_InitTurb
'================
'*/
sub R_InitTurb ()
dim as	integer		i

for i = 0 to 1280-1
sintable(i) = AMP + sin(i*3.14159*2/CYCLE)*AMP
intsintable(i) = AMP2 + sin(i*3.14159*2/CYCLE)*AMP2	'// AMP2, not 20
blanktable(i) = 0			'//PGM

Next


End Sub

declare sub R_ImageList_f()

sub R_register

sw_aliasstats = ri.Cvar_Get ("sw_polymodelstats", "0", 0)
sw_allow_modex = ri.Cvar_Get( "sw_allow_modex", "1", CVAR_ARCHIVE )
sw_clearcolor = ri.Cvar_Get ("sw_clearcolor", "2", 0)
sw_drawflat = ri.Cvar_Get ("sw_drawflat", "0", 0)
sw_draworder = ri.Cvar_Get ("sw_draworder", "0", 0)
sw_maxedges = ri.Cvar_Get ("sw_maxedges", STRINGER(MAXSTACKSURFACES), 0)
sw_maxsurfs = ri.Cvar_Get ("sw_maxsurfs", "0", 0)
sw_mipcap = ri.Cvar_Get ("sw_mipcap", "0", 0)
sw_mipscale = ri.Cvar_Get ("sw_mipscale", "1", 0)
sw_reportedgeout = ri.Cvar_Get ("sw_reportedgeout", "0", 0)
sw_reportsurfout = ri.Cvar_Get ("sw_reportsurfout", "0", 0)
sw_stipplealpha = ri.Cvar_Get( "sw_stipplealpha", "0", CVAR_ARCHIVE )
sw_surfcacheoverride = ri.Cvar_Get ("sw_surfcacheoverride", "0", 0)
sw_waterwarp = ri.Cvar_Get ("sw_waterwarp", "1", 0)
sw_mode = ri.Cvar_Get( "sw_mode", "0", CVAR_ARCHIVE )

r_lefthand = ri.Cvar_Get( "hand", "0", _CVAR_USERINFO or CVAR_ARCHIVE )
r_speeds = ri.Cvar_Get ("r_speeds", "0", 0)
r_fullbright = ri.Cvar_Get ("r_fullbright", "0", 0)
r_drawentities = ri.Cvar_Get ("r_drawentities", "1", 0)
r_drawworld = ri.Cvar_Get ("r_drawworld", "1", 0)
r_dspeeds = ri.Cvar_Get ("r_dspeeds", "0", 0)
r_lightlevel = ri.Cvar_Get ("r_lightlevel", "0", 0)
r_lerpmodels = ri.Cvar_Get( "r_lerpmodels", "1", 0 )
r_novis = ri.Cvar_Get( "r_novis", "0", 0 )

vid_fullscreen = ri.Cvar_Get( "vid_fullscreen", "0", CVAR_ARCHIVE )
vid_gamma = ri.Cvar_Get( "vid_gamma", "1.0", CVAR_ARCHIVE )

 ri.Cmd_AddCommand ("modellist", @Mod_Modellist_f)
 
 ri.Cmd_AddCommand( "screenshot", @R_ScreenShot_f )
 ri.Cmd_AddCommand( "imagelist", @R_ImageList_f )

sw_mode->modified = true '// force us to do mode specific stuff later
vid_gamma->modified = true '// force us to rebuild the gamma table later

	sw_lockpvs = ri.Cvar_Get ("sw_lockpvs", "0", 0)


End Sub

sub R_UnRegister ()
	ri.Cmd_RemoveCommand( "screenshot" )
	ri.Cmd_RemoveCommand ("modellist")
	ri.Cmd_RemoveCommand( "imagelist" )
End Sub



'FINISHED FOR NOW''''''''''''''''''''''''''''''''''''''''''''''''''''''
function R_init(hinstance as any ptr,wndproc as any ptr) as qboolean

'COMPLETE ADDED''''''''''''''''''''''''''''''''''''
 


 
R_InitImages ()
Mod_Init ()
Draw_InitLocal ()
R_InitTextures

R_InitTurb ()

view_clipplanes(0).leftedge = true
view_clipplanes(1).rightedge = true
view_clipplanes(1).leftedge = view_clipplanes(2).leftedge = _
	view_clipplanes(3).leftedge = false
view_clipplanes(0).rightedge = view_clipplanes(2).rightedge = _
	view_clipplanes(3).rightedge = false

r_refdef.xOrigin = XCENTERING
r_refdef.yOrigin = YCENTERING

'// TODO: collect 386-specific code in one place
'#if

 #ifdef id386
 
 
    
Sys_MakeCodeWriteable (cast(long,@R_EdgeCodeStart ), _
cast(long,@R_EdgeCodeEnd ) - cast(long,@R_EdgeCodeStart ))
Sys_SetFPCW () 		'// get bit masks for FPCW	(FIXME: is this id386?)
 

#endif	'// id386

r_aliasuvscale = 1.0

R_Register
Draw_GetPalette ()
SWimp_Init( hInstance, wndProc )



'CREATE WINDOW
 R_BeginFrame( 0 )
'''''''''''''''''''''''''''''''''''''''''''''''''

 ri.Con_Printf (PRINT_ALL, !"ref_soft version: " REF_VERSION !"\n")

return _true


End function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'FINISHED'''''''''''''''''''''
sub R_Shutdown ()
'// free z buffer
if (d_pzbuffer) then
	free (d_pzbuffer)
	d_pzbuffer = NULL
EndIf
'// free surface cache
if (sc_base) then
	D_FlushCaches ()
	free (sc_base)
	sc_base = NULL
EndIf


'// free colormap
if (vid.colormap) then
	free (vid.colormap)
	vid.colormap = NULL
EndIf



R_UnRegister () 'FINISHED
Mod_FreeAll () 'FINISHED
R_ShutdownImages () 'FINISHED



SWimp_Shutdown() 'FINISHED


End Sub
''''''''''''''''''''''''''''''''''''''''

 

/'
===============
R_NewMap
===============
'/
sub R_NewMap ()
 
	r_viewcluster = -1 

	r_cnumsurfs = sw_maxsurfs->value 

	if (r_cnumsurfs <= MINSURFACES) then
		r_cnumsurfs = MINSURFACES 
	EndIf
		

 if (r_cnumsurfs > NUMSTACKSURFACES) then
 
 		surfaces = malloc (r_cnumsurfs * sizeof(surf_t)) 
	 	surface_p = surfaces 
	 	surf_max =  @surfaces[r_cnumsurfs] 
	 	r_surfsonstack = false 
	'// surface 0 doesn't really exist; it's just a dummy because index 0
	'// is used to indicate no edge attached to surface
	 	surfaces-=1
	  R_SurfacePatch () 
 
 	else
 
   	r_surfsonstack = true 
	endif

	 r_maxedgesseen = 0 
	 r_maxsurfsseen = 0 

	 r_numallocatededges = sw_maxedges->value 

	 if (r_numallocatededges < MINEDGES) then
	 	r_numallocatededges = MINEDGES
	 	
	 	
	 EndIf
 
 if (r_numallocatededges <= NUMSTACKEDGES) then
 
 		auxedges = NULL 
	 
	 else
	 
   	auxedges = malloc (r_numallocatededges * sizeof(edge_t)) 
	end if
end sub






sub R_MarkLeaves()
 	dim as ubyte ptr vis 
 	dim as mnode_t	 ptr node 
 	dim as integer		i 
 	dim as mleaf_t ptr leaf 
 	dim as integer 	 cluster 
 
 	if (r_oldviewcluster =  r_viewcluster and  r_novis->value = NULL and r_viewcluster <> -1) then
 		return 
 	end if
'	
'	// development aid to let you run around and see exactly where
'	// the pvs ends
 	if (sw_lockpvs->value) then
 		return 
 	EndIf
 		
 
 	r_visframecount+=1
 	r_oldviewcluster = r_viewcluster 
 
 	if (r_novis->value or r_viewcluster = -1 or  r_worldmodel->vis = NULL) then
  
'		// mark everything
 		for  i=0  to r_worldmodel->numleafs -1 
 			r_worldmodel->leafs[i].visframe = r_visframecount 
 		next
     for  i=0  to r_worldmodel->numnodes -1 
 			r_worldmodel->nodes[i].visframe = r_visframecount 
     next
 		return 
 
 		
 	EndIf

 
 	vis = Mod_ClusterPVS (r_viewcluster, r_worldmodel) 
 	
 
leaf=r_worldmodel->leafs
  for i = 0 to r_worldmodel->numleafs-1
  	
  	

 
 		cluster = leaf->cluster 
 		if (cluster =  -1) then
 			 continue for
 		end if
 		
 		if (vis[cluster shr 3] and (1 shl (cluster and 7))) then
 
 	   	node = cast(mnode_t ptr,leaf) 
 			do
 			 
 				if (node->visframe =  r_visframecount) then
 					exit do
 				EndIf
 			 
 				node->visframe = r_visframecount 
 				node = node->parent 
 		  loop while (node) 
 		end if
 		leaf+=1
next
'
 #if 0
 	for (i=0  =r_worldmodel->vis->numclusters -1 
 
 		if (vis[cluster shr 3] and (1 shl (cluster and 7))) then
 
 			node = cast(mnode_t ptr,@r_wo rldmodel->leafs(i)) 	'// FIXME: cluster
   		do
 
 				if (node->visframe =  r_visframecount) then
   				exit do 
 				node->visframe = r_visframecount 
 				node = node->parent 
 		  while (node) 
    end if
 next
 #endif
End Sub




 /'
** R_DrawNullModel
**
** IMPLEMENT THIS!
'/
sub R_DrawNullModel()
End Sub
''''''''''''''''''''''''''''''''''''''''''''''''''''



sub R_DrawEntitiesOnList()
	 
	 dim as integer			i  
	 dim as qboolean	translucent_entities = false 

	 if ( r_drawentities->value = NULL) then
	 	return
	 EndIf
 

	'// all bmodels have already been drawn by the edge list
 
	for i = 0 to r_newrefdef.num_entities -1
 
 		currententity = @r_newrefdef.entities[i] 

	 	if ( currententity->flags and RF_TRANSLUCENT ) then
	 		translucent_entities = true
	 		continue for
	 	EndIf
	 

	 	if ( currententity->flags and RF_BEAM ) then
	 
	 		modelorg.v(0) = -r_origin.v(0) 
	 		modelorg.v(1) = -r_origin.v(1) 
	 		modelorg.v(2) = -r_origin.v(2) 
	 		_VectorCopy( @vec3_origin, @r_entorigin ) 
	 		R_DrawBeam( currententity ) 
	 
	 	else
	 
	 		currentmodel = currententity->model 
	 		if ( currentmodel = NULL) then
	 			R_DrawNullModel() 
	 			 continue for	
	 		EndIf
 
	 		
          
	 		_VectorCopy(@currententity->origin(0), @r_entorigin) 
	 		_VectorSubtract (@r_origin, @r_entorigin, @modelorg) 

	 select case  (currentmodel->_type)
	 
	 		case mod_sprite 
	 			 R_DrawSprite () 
 

	 		case mod_alias 
	 			 R_AliasDrawModel () 
	  

	 		 case else
	 end select
 
	  end if
	next

	 if (  translucent_entities <> null) then
	 	return
	 EndIf
	 
	 for  i=0  to r_newrefdef.num_entities - 1
	 
	 		currententity = @r_newrefdef.entities[i] 

	 	if ( ( currententity->flags and RF_TRANSLUCENT ) ) then
	 			continue for
	 	EndIf
	 	

   	if ( currententity->flags and RF_BEAM ) then
 
	 		modelorg.v(0) = -r_origin.v(0) 
	 		modelorg.v(1) = -r_origin.v(1) 
	 		modelorg.v(2) = -r_origin.v(2) 
	 		_VectorCopy( @vec3_origin, @r_entorigin ) 
	 		R_DrawBeam( currententity ) 
	 
	 	else
	 
	 		currentmodel = currententity->model 
	 		if ( currentmodel = NULL) then
   			R_DrawNullModel() 
	   		continue for
	 		EndIf
 
 
	 		_VectorCopy (@currententity->origin(0), @r_entorigin) 
	   	_VectorSubtract (@r_origin, @r_entorigin,@modelorg) 

   		select case (currentmodel->_type)
 
	  		case mod_sprite:
	 			R_DrawSprite () 
 

	 		case mod_alias 
	 			R_AliasDrawModel () 
 

	   	case else
 
	 end select
   	end if
   	
   next	
   	
End Sub


function R_BmodelCheckBBox (minmaxs as float ptr) as Integer
	
  dim as integer	ptr  pindex
  dim as integer clipflags
  dim as integer i
	dim as vec3_t		acceptpt, rejectpt 
	dim as  float		d 

	clipflags = 0 

	for  i=0 to 4-1
		

 
	'// generate accept and reject points
	'// FIXME: do with fast look-ups or integer tests based on the sign bit
	'// of the floating point values

		pindex = pfrustum_indexes(i)

		rejectpt.v(0) = minmaxs[pindex[0]] 
		rejectpt.v(1) = minmaxs[pindex[1]] 
		rejectpt.v(2) = minmaxs[pindex[2]] 
		
		d = DotProduct (@rejectpt, @view_clipplanes(i).normal) 
		d -= view_clipplanes(i).dist 

		if (d <= 0) then
			return BMODEL_FULLY_CLIPPED 
		EndIf
			

		acceptpt.v(0) = minmaxs[pindex[3+0]] 
		acceptpt.v(1) = minmaxs[pindex[3+1]] 
		acceptpt.v(2) = minmaxs[pindex[3+2]] 

		d = DotProduct (@acceptpt, @view_clipplanes(i).normal) 
		d -= view_clipplanes(i).dist 

		if (d <= 0) then
			clipflags or= (1 shl (i)) 
		EndIf
			
 	Next

	return clipflags 
End function

 
/'
===================
R_FindTopnode

Find the first node that splits the given box
===================
'/
function R_FindTopnode (mins as vec3_t ptr ,maxs as vec3_t ptr ) as mnode_t ptr
 	dim as mplane_t	ptr splitplane 
	dim as integer			sides
	dim as mnode_t ptr node 

	 node = r_worldmodel->nodes 

	 while (1)
	 
 		if (node->visframe <> r_visframecount) then
 			return NULL
 		EndIf
 
	 
   	if (node->contents <> CONTENTS_NODE) then
   		if (node->contents <> CONTENTS_SOLID) then
   			return	node '//  visible and not BSP clipped
   			
   		EndIf
   		return NULL 	'// in solid, so not visible
   	EndIf
 
	'						
	'		
 
	'	
	 	splitplane = node->plane 
	 	sides = BOX_ON_PLANE_SIDE(mins, maxs, cast(cplane_t ptr,splitplane)) 
	'	
	 	if (sides = 3) then
	 		return node '	// this is the splitter
	 	EndIf
	 
	 	
	'// not split yet; recurse down the contacted side
	 	if (sides and 1) then
		  		node = node->children(0) 
	 	else
	 		node = node->children(1)  		
	 	EndIf

	wend
 	
	
End function
 
 
 /'
=============
RotatedBBox

Returns an axially aligned box that contains the input box at the given rotation
=============
'/
sub RotatedBBox (mins as vec3_t ptr ,maxs as vec3_t ptr,angles as vec3_t ptr,  tmins as vec3_t ptr, tmaxs as vec3_t ptr)
 
	 dim as vec3_t	tmp, _v 
	 dim as integer		i, j 
	 dim as vec3_t	forward, _right, up 

	 if ( angles->v(0) = null and angles->v(1) = null and angles->v(2) = null) then
	 	_VectorCopy (mins, tmins)
	 	_VectorCopy (maxs, tmaxs)
	 	return
	 EndIf
 
	 for i=0 to 3-1
	 	tmins->v(i) = 99999 
	 	tmaxs->v(i) = -99999 
	 
	 Next
 
	 AngleVectors (angles, @forward, @_right,@up) 

	  
	 for   i = 0 to 8-1 
	 	
	 if ( i and 1 ) then
	 	tmp.v(0) = mins->v(0)
	 else
	 	tmp.v(0) = maxs->v(0)	
	 EndIf
	 	if ( i and 2 ) then
	 		tmp.v(1) = mins->v(1)
	 	else
	   	tmp.v(1) = maxs->v(1)
	 	end if
    	if ( i and 4 ) then
    	   tmp.v(2) = mins->v(2)
	 	else
	   	tmp.v(2) = maxs->v(2)
    	EndIf
    	
	 Next
 
  
	   VectorScale (@forward, tmp.v(0), @_v) 
	 	VectorMA (@_v, -tmp.v(1), @_right, @_v) 
	 	VectorMA (@_v, tmp.v(2), @up, @_v) 

	 	for j = 0 to 3-1
	 	 	if (_v.v(j) < tmins->v(j)) then
	 	 		tmins->v(j) = _v.v(j)
	 	 	EndIf
	 	 	if (_v.v(j) > tmaxs->v(j)) then
	 	 	   tmaxs->v(j) = _v.v(j)
	 	 	EndIf
 
	 	Next
 
end sub
 
 
sub R_DrawBEntitiesOnList()
 	 dim as integer   i, clipflags 
	 dim as vec3_t		oldorigin 
	 dim as vec3_t		mins, maxs 
	 dim as float		minmaxs(6) 
	 dim as mnode_t	ptr	 topnode 

  if ( r_drawentities->value = NULL) then
  	return
  EndIf
 

	 _VectorCopy (@modelorg, @oldorigin) 
	  insubmodel = true 
	 r_dlightframecount = r_framecount 

 
  for i = 0 to r_newrefdef.num_entities -1
 		currententity = @r_newrefdef.entities[i]
	 	currentmodel = currententity->model 
	 	if ( currentmodel = NULL) then
	 		 continue for
	 	EndIf
	 
	 	if (currentmodel->nummodelsurfaces =  0) then
	 	 	continue for ' // clip brush only
	 	EndIf
	 		
	 	if ( currententity->flags and RF_BEAM ) then
	 		 continue for 
	 	EndIf
	
	 	if (currentmodel->_type <> mod_brush) then
	 		 continue for 
	 	EndIf
	 		
	'// see if the bounding box lets us trivially reject, also sets
	'// trivial accept status
	 	RotatedBBox (@currentmodel->mins, @currentmodel->maxs, _
	 		@currententity->angles(0), @mins, @maxs) 
	 	_VectorAdd (@mins, @currententity->origin(0), @minmaxs(0)) 
	 	_VectorAdd (@maxs, @currententity->origin(0), @minmaxs(0)+3) 

	 	clipflags = R_BmodelCheckBBox (@minmaxs(0)) 
	 	if (clipflags =  BMODEL_FULLY_CLIPPED) then
	 	 		continue for	'// off the edge of the screen
	 	EndIf
	

	 	topnode = R_FindTopnode (@minmaxs(0), @minmaxs(0)+3 ) 
	 	if ( topnode = NULL) then
	 	 	 	continue for	'// no part in a visible leaf	
	 	EndIf
	

	 	_VectorCopy (@currententity->origin(0), @r_entorigin) 
	 	_VectorSubtract (@r_origin, @r_entorigin, @modelorg) 

	 	r_pcurrentvertbase = currentmodel->vertexes 

	'// FIXME: stop transforming twice
	 	R_RotateBmodel () 

	'// calculate dynamic lighting for bmodel
	 	R_PushDlights (currentmodel) 

	 	if (topnode->contents = CONTENTS_NODE) then
	 		'	// not a leaf; has to be clipped to the world BSP
	 		r_clipflags = clipflags
	 		 R_DrawSolidClippedSubmodelPolygons (currentmodel, topnode)
	 	EndIf
 
	'	}
	'	else
	'	{
	'	// falls entirely in one leaf, so we just put all the
	'	// edges in the edge list and let 1/z sorting handle
	'	// drawing order
	 		R_DrawSubmodelPolygons (currentmodel, clipflags, topnode) 
	'	}

	'// put back world rotation and frustum clipping		
	'// FIXME: R_RotateBmodel should just work off base_vxx
	 	_VectorCopy (@base_vpn, @vpn) 
	   _VectorCopy (@base_vup, @vup) 
	 	_VectorCopy (@base_vright, @vright) 
	 	_VectorCopy (@oldorigin, @modelorg) 
	 	R_TransformFrustum () 
	next

 	insubmodel = false 
End Sub
	

sub R_EdgeDrawing 
	 dim as 	edge_t	ledges(NUMSTACKEDGES + ((CACHE_SIZE - 1) / sizeof(edge_t)) + 1) 
	 			
	 dim as 	surf_t	lsurfs(NUMSTACKSURFACES + ((CACHE_SIZE - 1) / sizeof(surf_t)) + 1)  
	 		

	 if ( r_newrefdef.rdflags and RDF_NOWORLDMODEL ) then
	 	return
	 EndIf
 

	 if (auxedges) then
	 
 		r_edges = auxedges 
 
	 else
 
 		r_edges =  cast(edge_t ptr,  ((cast(long,@ledges(0)) + CACHE_SIZE - 1)  and not(CACHE_SIZE - 1))) 
	 			
	end if

 if (r_surfsonstack) then
 	
 	
 	surfaces =  cast(surf_t ptr,((cast(long,@lsurfs(0)) + CACHE_SIZE - 1) and not(CACHE_SIZE - 1)))
	surf_max = @surfaces[r_cnumsurfs] 
		'// surface 0 doesn't really exist; it's just a dummy because index 0
	   '// is used to indicate no edge attached to surface
 	surfaces-=1
 	R_SurfacePatch ()
 EndIf

 	R_BeginEdgeFrame () 

	 if (r_dspeeds->value) then
	 	rw_time1 = Sys_Milliseconds () 
	 EndIf
 
 	 R_RenderWorld () 

	 if (r_dspeeds->value) then
	  rw_time2 = Sys_Milliseconds () 
   	db_time1 = rw_time2 
	 EndIf
 
	 R_DrawBEntitiesOnList () 

	 if (r_dspeeds->value) then
 		db_time2 = Sys_Milliseconds () 
	 	se_time1 = db_time2 
	end if

	 R_ScanEdges () 
	
End Sub



sub R_CalcPalette
	static as qboolean modified 
	static as ubyte ptr	_palette(256,4) ,  _in,  _out 
	dim as integer		i, j 
	dim as float	alpha_, one_minus_alpha 
	dim as vec3_t	premult 
	dim as integer		v 

 	alpha_ = r_newrefdef.blend(3)
 	if (alpha_ <= 0) then
 		if (modified) then
 			'// set back to default
 			modified = false
 			R_GammaCorrectAndSetPalette(cast( const ubyte ptr, @d_8to24table(0) ))
	      return
 		EndIf
 		return
 	EndIf
 modified = true
  if (alpha_ > 1)  then
  	alpha_ = 1 
  EndIf
  
 
 
 	premult.v(0) = r_newrefdef.blend(0)*alpha_*255 
 	premult.v(1) = r_newrefdef.blend(1)*alpha_*255 
 	premult.v(2) = r_newrefdef.blend(2)*alpha_*255 
 
 	one_minus_alpha = (1.0 - alpha_) 
 
 	_in = cast(ubyte ptr,@d_8to24table(0) )
 	_out = _palette(0,0) 
 	for i = 0 to 256-1
 		for j = 0 to 3-1
 	      v = premult.v(j) + one_minus_alpha * _in[j]
 			if (v > 255) then
 				v = 255 
 			end if
 			_out[j] = v 
 		Next
 		 
 		_out[3] = 255
 		
 		_in +=4
 		_out +=4
 	Next
 	
 
 	R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @_palette(0,0)) ) 

'//	SWimp_SetPalette( palette[0] );
	
End Sub

 sub  R_SetLightLevel()
		dim light as vec3_t		 

	if ((r_newrefdef.rdflags and RDF_NOWORLDMODEL) or ( r_drawentities->value = NULL) or ( currententity = NULL)) then
	   r_lightlevel->value = 150.0 
		return 
	EndIf
 
	'// save off light value for server to look at (BIG HACK!)
	R_LightPoint (@r_newrefdef.vieworg(0), @light) 
	r_lightlevel->value = 150.0 * light.v(0) 
	
 End Sub


/'
@@@@@@@@@@@@@@@@
R_RenderFrame

@@@@@@@@@@@@@@@@
'/
	
sub R_RenderFrame (fd as refdef_t ptr)
	r_newrefdef = *fd 

	if ( r_worldmodel = 0 and  ( r_newrefdef.rdflags and RDF_NOWORLDMODEL ) = 0 ) then
		ri.Sys_Error (ERR_FATAL,"R_RenderView: NULL worldmodel")
	EndIf
		

	 'VectorCopy (@fd->vieworg, @r_refdef.vieworg) 
	  _VectorCopy (@fd->vieworg(0), @r_refdef.vieworg) 
	 
	  'VectorCopy (@fd->viewangles(0), @r_refdef.viewangles ) 
     _VectorCopy (@fd->viewangles(0), @r_refdef.viewangles ) 
    
    
	if (r_speeds->value or r_dspeeds->value) then
		r_time1 = Sys_Milliseconds () 
	EndIf
		

	 R_SetupFrame () 

	  R_MarkLeaves () 	'// done here so we know if we're in water

	  R_PushDlights (r_worldmodel) 

	 R_EdgeDrawing ()  

	 if (r_dspeeds->value) then
	   se_time2 = Sys_Milliseconds () 
	 	de_time1 = se_time2 
	 EndIf
 

	  R_DrawEntitiesOnList () 

	 if (r_dspeeds->value) then
	 	 		de_time2 = Sys_Milliseconds () 
	 	dp_time1 = Sys_Milliseconds () 
	 EndIf
 

	 R_DrawParticles () 

	 if (r_dspeeds->value) then
	 	dp_time2 = Sys_Milliseconds ()
	 EndIf
 

	 R_DrawAlphaSurfaces()

	 R_SetLightLevel () 

	 if (r_dowarp) then
	 	D_WarpScreen ()
	 EndIf
 
	 if (r_dspeeds->value) then
	 	da_time1 = Sys_Milliseconds ()
	 EndIf
	    

	 if (r_dspeeds->value) then
	 	da_time2 = Sys_Milliseconds ()
	 EndIf
 
	 R_CalcPalette () 

	 if (sw_aliasstats->value) then
	 	R_PrintAliasStats ()
	 EndIf
	 
	 if (r_speeds->value) then
	 	R_PrintTimes () 
	 EndIf
	 
	 if (r_dspeeds->value) then
	  R_PrintDSpeeds ()
	 EndIf
 

	 if (sw_reportsurfout->value and r_outofsurfaces) then
	 	ri.Con_Printf (PRINT_ALL,!"Short %d surfaces\n", r_outofsurfaces)
	 EndIf
	 	 

	 if (sw_reportedgeout->value and r_outofedges) then
	 	ri.Con_Printf (PRINT_ALL,!"Short roughly %d edges\n", r_outofedges * 2 / 3)
	 EndIf
 

End Sub


'/*
'** R_InitGraphics
'*/
sub R_InitGraphics(_width as integer , _height as integer )
vid._width  = _width
vid._height = _height

 
'// free z buffer
if ( d_pzbuffer ) then
	free( d_pzbuffer )
	d_pzbuffer = NULL
EndIf


'// free surface cache
if ( sc_base ) then
	D_FlushCaches ()
	free( sc_base )
	sc_base = NULL
EndIf


 d_pzbuffer = malloc(vid._width*vid._height*2)

R_InitCaches ()

 R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @d_8to24table(0) ) )
 
End Sub

'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''

'extern declare sub Draw_BuildGammaTable()
 declare sub Draw_BuildGammaTable()
sub R_BeginFrame(camera_separation as float )
 

'/*
'** rebuild the gamma correction palette if necessary
'*/
if ( vid_gamma->modified ) then
 
	 Draw_BuildGammaTable()
	 R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  @d_8to24table(0) ))

	vid_gamma->modified = false

EndIf

 

while ( sw_mode->modified or vid_fullscreen->modified )

dim as rserr_t _err

'/*
'** if this returns rserr_invalid_fullscreen then it set the mode but not as a
'	** fullscreen mode, e.g. 320x200 on a system that doesn't support that res
'	*/

_err = SWimp_SetMode(@vid._width,@vid._height,sw_mode->value,vid_fullscreen->value)

 

if (  _err = rserr_ok ) then

R_InitGraphics( vid._width, vid._height )

sw_state.prev_mode = sw_mode->value
vid_fullscreen->modified = false
sw_mode->modified = false

else

if ( _err = rserr_invalid_mode ) then

ri.Cvar_SetValue( "sw_mode", sw_state.prev_mode )
ri.Con_Printf( PRINT_ALL, !"ref_soft::R_BeginFrame() - could not set mode\n" )

elseif ( _err = rserr_invalid_fullscreen ) then

R_InitGraphics( vid._width, vid._height )

ri.Cvar_SetValue( "vid_fullscreen", 0)
ri.Con_Printf( PRINT_ALL, !"ref_soft::R_BeginFrame() - fullscreen unavailable in this mode\n" )
sw_state.prev_mode = sw_mode->value
'//				vid_fullscreen->modified = false;
'//				sw_mode->modified = false;

else

ri.Sys_Error( ERR_FATAL, !"ref_soft::R_BeginFrame() - catastrophic mode change failure\n" )
end if
end if
wend

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'/*
'** R_GammaCorrectAndSetPalette
'*/
sub R_GammaCorrectAndSetPalette( _palette as const ubyte ptr)
	dim as integer i
   
 
	for  i = 0 to 256-1
		

		
		sw_state.currentpalette(i*4+0) =  sw_state.gammatable(_palette[i*4+0])
		sw_state.currentpalette(i*4+1) =  sw_state.gammatable(_palette[i*4+1])
		sw_state.currentpalette(i*4+2) =  sw_state.gammatable(_palette[i*4+2])

	Next


	 SWimp_SetPalette( @sw_state.currentpalette(0) )

End Sub

 


/'
** R_CinematicSetPalette
'/
sub R_CinematicSetPalette( _palette as const zstring ptr  )
	dim as ubyte palette32(1024) 
	dim as integer			i, j, w 
	dim as integer	ptr	d 

	'// clear screen to black to avoid any palette flash
	w = abs(vid.rowbytes) shr 2 	'// stupid negative pitch win32 stuff...
 
	for i = 0 to vid._height - 1
		
		d = cast(integer ptr,  (vid.buffer + i*vid.rowbytes) ) 
			for  j= 0 to w-1  
				d[j] = 0
	   	Next
	
			d+=w
	next
	'// flush it to the screen
	SWimp_EndFrame () 

	if ( _palette ) then
	 
		for  i = 0 to 256-1 
					 
			palette32(i*4+0) = _palette[i*3+0] 
			palette32(i*4+1) = _palette[i*3+1] 
			palette32(i*4+2) = _palette[i*3+2] 
			palette32(i*4+3) = &HFF 
		Next
 
		' //R_GammaCorrectAndSetPalette( palette32 ) 
	 
	else
	 
'	 //R_GammaCorrectAndSetPalette( cast( const ubyte ptr,  d_8to24table))  
	end if
End Sub


'/*
'================
'Draw_BuildGammaTable
'================
'*/
sub Draw_BuildGammaTable ()



	dim as integer		i, inf
	dim as float	g

	g = vid_gamma->value

	if (g = 1.0) then

		for i = 0 to 256-1
			sw_state.gammatable(i) = i
		next
		return
	end if

	for i = 0 to 256-1
		inf = 255 * pow ( (i+0.5)/255.5 , g ) + 0.5
		if (inf < 0) then
			inf = 0
		EndIf

		if (inf > 255) then
			inf = 255
		EndIf

		sw_state.gammatable(i) = inf
	next
	End Sub







/'
** R_DrawBeam
'/
sub R_DrawBeam(e as entity_t ptr )
	#define NUM_BEAM_SEGS 6
	
		dim as integer	i 

	dim as vec3_t perpvec 
	dim as vec3_t direction, normalized_direction  
	dim as vec3_t start_points(NUM_BEAM_SEGS), end_points(NUM_BEAM_SEGS) 
	dim as vec3_t oldorigin, origin 
	
	
	if ( VectorNormalize( @normalized_direction ) = 0 ) then
			return 
	EndIf
	
	oldorigin.v(0) = e->oldorigin(0) 
	oldorigin.v(1) = e->oldorigin(1) 
	oldorigin.v(2) = e->oldorigin(2)
	
	direction.v(0) = oldorigin.v(0) - origin.v(0)
	direction.v(1) = oldorigin.v(1) - origin.v(1) 
	direction.v(2) = oldorigin.v(2) - origin.v(2) 
	
	
	normalized_direction.v(0) = direction.v(0)  
	normalized_direction.v(1) = direction.v(1)  
	normalized_direction.v(2) = direction.v(2) 

	if ( VectorNormalize( @normalized_direction ) = 0 ) then
		return
	EndIf
	 

	PerpendicularVector( @perpvec, @normalized_direction ) 
	VectorScale(@perpvec, e->frame / 2, @perpvec ) 

   for   i = 0 to NUM_BEAM_SEGS - 1 
   	
     _VectorAdd( @start_points(i), @origin, @start_points(i) ) 
     _VectorAdd( @start_points(i), @direction, @end_points(i) ) 
   Next
 
 		RotatePointAroundVector( @start_points(i), @normalized_direction,@ perpvec, (360.0/NUM_BEAM_SEGS)*i ) 

 
 
 for   i = 0 to NUM_BEAM_SEGS - 1
 		R_IMFlatShadedQuad( @start_points(i), _
		                    @end_points(i), _
							@end_points((i+1) mod NUM_BEAM_SEGS), _
							@start_points((i+1) mod NUM_BEAM_SEGS), _
							e->skinnum and &HFF, _
							e->alpha_ ) 

 Next

 
	
	
End Sub






/'
============
R_SetSky
============
'/
'// 3dstudio environment map names
dim shared as zstring ptr suf(6) => {@"rt", @"bk", @"lf", @"ft", @"up", @"dn"}
dim shared as integer	r_skysideimage(6) => {5, 2, 4, 1, 0, 3}
extern	as mtexinfo_t		r_skytexinfo(6)
sub R_setSky(_name as zstring ptr,rotate as float, axis as vec3_t ptr)
	dim as integer		i 
	dim as zstring * MAX_QPATH	pathname  

	strncpy (skyname, _name, sizeof(skyname)-1) 
	skyrotate = rotate 
	_VectorCopy (axis, @skyaxis) 

 
		
	for i = 0 to 6-1
		Com_sprintf (pathname, sizeof(pathname), "env/%s%s.pcx", skyname, suf(r_skysideimage(i)))
		r_skytexinfo(i)._image = R_FindImage (pathname, it_sky)
	Next
	


End Sub


function Draw_GetPalette () as integer
	dim as ubyte ptr 	 _out,  _pal
	dim i  as integer
	dim as integer 	r, g, b

 
	LoadPCX ("pics/colormap.pcx", @vid.colormap, @_pal, NULL, NULL)
	if (vid.colormap = NULL) then
		'ri.Sys_Error (ERR_FATAL, "Couldn't load pics/colormap.pcx")
		print "Couldn't load pics/colormap.pcx"
		return 0
	EndIf
	vid.alphamap = vid.colormap + 64*256

  _out = cast(ubyte ptr,@d_8to24table(0))
	for i = 0 to 256-1

		r = _pal[i*3+0]
		g = _pal[i*3+1]
		b = _pal[i*3+2]
		
        _out[0] = r
        _out[1] = g
        _out[2] = b 
        _out+=4
	Next
 


	free (_pal)

	return 0

End Function

 declare function R_RegisterSkin (_name as ZString) as image_s

'/*
'@@@@@@@@@@@@@@@@@@@@@
'GetRefAPI
'
'@@@@@@@@@@@@@@@@@@@@@
'*/

extern "C"

function GetRefAPI alias "GetRefAPI" (rimp as refimport_t ) as refexport_t export

	dim re  as refexport_t


	ri = rimp

	re._api_version = API_VERSION
	re.BeginRegistration = @R_BeginRegistration
	re.RegisterModel = @R_RegisterModel
	re.RegisterSkin = @R_RegisterSkin
	re.RegisterPic = @Draw_FindPic
	re.SetSky = @R_SetSky
	re.EndRegistration = @R_EndRegistration

	re.RenderFrame = @R_RenderFrame

	re.DrawGetPicSize = @Draw_GetPicSize
	re.DrawPic = @Draw_Pic
	re.DrawStretchPic = @Draw_StretchPic
	re.DrawChar = @Draw_Char
	re.DrawTileClear = @Draw_TileClear
	re.DrawFill = @Draw_Fill
	re.DrawFadeScreen= @Draw_FadeScreen

	re.DrawStretchRaw = @Draw_StretchRaw

	re.Init = @R_Init
	re.Shutdown = @R_Shutdown

	re.CinematicSetPalette = @R_CinematicSetPalette
	re.BeginFrame = @R_BeginFrame
	re.EndFrame = @SWimp_EndFrame

	re.AppActivate = @SWimp_AppActivate

	Swap_Init ()
	return re




End Function

end extern


#ifndef REF_HARD_LINKED





'
''FINISHED
sub sys_error CDecl (_error as zstring ptr,...)
	dim argptr as cva_list
	
	dim text as zstring * 1024
	
	 
	 cva_start(argptr,_error)
	 vsprintf (text, _error, argptr)
	 cva_end(argptr)
	 
	
	 ri.Sys_Error (ERR_FATAL, "%s", text) 
	 
End Sub

'FINISHED
sub Com_Printf CDecl (fmt as zstring ptr,...)
	dim argptr as cva_list
	
	dim text as zstring * 1024
	
	 
	 cva_start(argptr,fmt)
	 vsprintf (text, fmt, argptr)
	 cva_end(argptr)
	 
	 ri.Con_Printf (PRINT_ALL, "%s", text)
	 
End Sub

 #endif

 

 