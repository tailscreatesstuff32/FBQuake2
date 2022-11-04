 'FINISHED FOR NOW
 
'// models.c -- model loading and caching

'// models are the only shared resource between a client and server running
'// on the same machine.

 '#define  Dmodel_t Dim shared as model_t
 '#define  Dint   dim shared as  integer

 
#Include "FB_Ref_Soft\r_local.bi"


extern as model_t ptr loadmodel 
 dim shared as  model_t  ptr loadmodel 



dim shared as zstring ptr loadname(32) 	'// for hunk tags

'void Mod_LoadSpriteModel (model_t *mod, void *buffer);
'void Mod_LoadBrushModel (model_t *mod, void *buffer);
declare sub Mod_LoadAliasModel (_mod as model_t ptr,buffer as any ptr) 
 'model_t *Mod_LoadModel (model_t *mod, qboolean crash) 

dim shared as ubyte 	mod_novis(MAX_MAP_LEAFS/8)

 #define	MAX_MOD_KNOWN	256
 
 dim shared as  model_t mod_known(MAX_MOD_KNOWN)
dim shared as  integer  mod_numknown 
 
'// the inline * models from the current map are kept seperate
dim shared as  model_t	mod_inline(MAX_MOD_KNOWN) 
 
dim shared	as Integer	registration_sequence  
dim shared	as Integer		modfilelen






/'
=================
Mod_SetParent
=================
'/
sub Mod_SetParent (node as mnode_t ptr,parent as  mnode_t ptr)
 
	node->parent = parent 
	if (node->contents <> -1) then
		return
	EndIf
	 
	Mod_SetParent (node->children(0), node) 
end sub



'//===============================================================================


'/*
'=================
'Mod_LoadSpriteModel
'=================
'*/
sub Mod_LoadSpriteModel (_mod as model_t ptr, buffer as any ptr)
 
	dim as dsprite_t ptr	 sprin, sprout 
	dim as  integer			i 

	sprin = cast(dsprite_t ptr,buffer) 
	sprout = Hunk_Alloc (modfilelen) 

	sprout->ident = LittleLong (sprin->ident) 
	sprout->version = LittleLong (sprin->version) 
	sprout->numframes = LittleLong (sprin->numframes) 

	if (sprout->version <> SPRITE_VERSION) then
		ri.Sys_Error (ERR_DROP, "%s has wrong version number (%i should be %i)", _
		 					_mod->_name, sprout->version, SPRITE_VERSION)
	EndIf
				

	if (sprout->numframes > MAX_MD2SKINS) then
		ri.Sys_Error (ERR_DROP, "%s has too many frames (%i > %i)")
	end if	
				_ mod->_name, sprout->numframes, MAX_MD2SKINS) 

	'// byte swap everything
	for  i=0 to sprout->numframes - 1 
	 
		sprout->frames(i)._width = LittleLong (sprin->frames(i)._width)
		sprout->frames(i)._height = LittleLong (sprin->frames(i)._height)
		sprout->frames(i).origin_x = LittleLong (sprin->frames(i).origin_x)
		sprout->frames(i).origin_y = LittleLong (sprin->frames(i).origin_y)
		memcpy (@sprout->frames(i)._name, @sprin->frames(i)._name, MAX_SKINNAME)
		_mod->skins(i) = R_FindImage (sprout->frames(i)._name, it_sprite)
	next

	_mod->_type = mod_sprite 
end sub

'//=============================================================================



 
function Mod_ForName (_name as zstring ptr,crash as qboolean ) as model_t ptr
	dim _mod as model_t	ptr
	dim buf as UInteger ptr
	dim i as integer 
	
	if (_name[0] = NULL) then
 		 ri.Sys_Error (ERR_DROP, "Mod_ForName: NULL name") 
	end if
	
	
	'//
	'// inline models are grabbed only from worldmodel
	'//
	if (_name[0]  = "*") then
		i = atoi(_name+1)
			if (i < 1 or r_worldmodel = NULL or i >= r_worldmodel->numsubmodels) then
			 	ri.Sys_Error (ERR_DROP, "bad inline model number") 
			EndIf
		return @mod_inline(i)
	EndIf
	 
 	'//
	'// search the currently loaded models
	'//
	_mod = @mod_known(0) 
	for  i = 0 to mod_numknown-1
			if ( _mod->_name[0] = NULL) then
			 continue for
			 end if
		if ( strcmp (_mod->_name, _name) = 0  ) then
			return _mod 
		EndIf
		_mod+=1
	Next
		 
 	'//
	'// find a free model slot spot
	'//
	_mod = @mod_known(0) 
	for  i = 0 to mod_numknown-1
		if (_mod->_name[0] = NULL) then
			exit for
			
		EndIf
			
	Next
	 
	 
	if (i  = mod_numknown) then
		if (mod_numknown = MAX_MOD_KNOWN) then
			
			 ri.Sys_Error (ERR_DROP, "mod_numknown == MAX_MOD_KNOWN")
		
		EndIf
	mod_numknown+=1
 
	EndIf
	
	

	strcpy (_mod->_name, _name) 
	
 
	
	modfilelen = ri.FS_LoadFile (_mod->_name, @buf) 
   	if ( buf = NULL) then
    
		if (crash) then
			
			 ri.Sys_Error (ERR_DROP, "Mod_NumForName: %s not found", _mod->_name) 
			'printf(!"Mod_NumForName: %s not found", _mod->_name)
		EndIf		
		memset (@_mod->_name, 0, sizeof(_mod->_name)) 
	 return NULL	
	EndIf
	
	 loadmodel = _mod
	
	'
   '//
	'// fill it in
	'//

	
		'// call the apropriate loader
	 
	
	select case  LittleLong(*cast(uinteger ptr,  buf))
	 
		case IDALIASHEADER 
			
			   print
   printf(!"\n")
   printf(!"IDP2\n")
   print("IDP2")
	'printf("is_bsp")
   'print("is_bsp")
   print
		   loadmodel->extradata = _Hunk_Begin(&H200000) 
		   
		   print "EXTRA DATA: " & loadmodel->extradata
		   
		  Mod_LoadAliasModel (_mod, buf) 
		  
		  
		 ' print loadmodel->numvertexes 
		 
		 'sleep
		 
		 
	 

	case IDSPRITEHEADER 
	    loadmodel->extradata = _Hunk_Begin (&H10000) 
		 Mod_LoadSpriteModel (_mod, buf) 
    print
    printf(!"\n")
   printf("IDS2")
   'print("IDS2")
	
	case IDBSPHEADER 
	 loadmodel->extradata = _Hunk_Begin (&H1000000) 
		'Mod_LoadBrushModel (_mod, buf) 
	 'printf("is_bsp")
   'print("is_bsp")
   print
   printf(!"\n")
   printf("IBSP")
   print("IBSP")
	case else
		 ri.Sys_Error (ERR_DROP,"Mod_NumForName: unknown fileid for %s", _mod->_name) 
	 'printf( "Mod_NumForName: unknown fileid for %s") 
	end select

  loadmodel->extradatasize = _Hunk_End () 
   
	ri.FS_FreeFile (buf) 

	return _mod 
	
	
End Function
  
  
  
  
  
  
  
  
  
/'
===================
Mod_DecompressVis
===================
'/
function Mod_DecompressVis (_in as ubyte ptr,model as model_t ptr )as ubyte ptr
	static as ubyte	decompressed(MAX_MAP_LEAFS/8)
	dim as integer		c 
	dim as ubyte	ptr _out 
	dim as integer		row 

	row = (model->vis->numclusters+7) shr 3 	
	_out = @decompressed(0) 

#if 0
	memcpy (_out, _in, row) 
#else
	if (_in = null) then
	'	// no vis info, so make all visible
		while (row)
			*_out+=1 = &Hff 
			row-=1	
		Wend
 
		return @decompressed(0) 		
	end if

	do
	 
		if (*_in) then
		 
			 
			_out = _in
			_out+=1: _in+=1
			
			continue do
		end if
	
		c = _in[1] 
		_in += 2  
		while (c)
		 
			*_out = 0:_out +=1
			c-=1
		wend
	loop while (_out - @decompressed(0) < row) 
#endif
	
	return @decompressed(0) 
End Function


  
'  /*
'==============
'Mod_ClusterPVS
'==============
'*/
function Mod_ClusterPVS ( cluster as integer, model as model_t ptr) as ubyte ptr
	
		if (cluster =  -1 or  model->vis = null) then
			return @mod_novis(0)
		EndIf

 	return Mod_DecompressVis ( cast(ubyte ptr,model->vis) + model->vis->bitofs(cluster,DVIS_PVS), _
	 	model) 
End Function
 

 
  
  
  
  






'/*
'================
'Mod_Modellist_f
'================
'*/
sub Mod_Modellist_f ()
 
	dim i as integer		 
	dim 	_mod  as model_t ptr
	dim  total   as integer		

	total = 0 
	 ri.Con_Printf (PRINT_ALL,!"Loaded models:\n") 
	'printf(!"Loaded models:\n") 
	_mod=@mod_known(0)
 
	 
	
	
	for i=0 to mod_numknown-1
		
		if ( _mod->_name[0] = NULL) then
			continue for
		EndIf
		
				'ri.Con_Printf (PRINT_ALL, "%8i : %s\n",mod->extradatasize, mod->name) 
		Printf (!"%8i : %s\n",_mod->extradatasize, _mod->_name)
		total +=_mod->extradatasize 
		_mod+=1	
		
		
		
	Next
	 
		'sleep

 'printf(!"Total resident: %i\n", total)
 ri.Con_Printf (PRINT_ALL, !"Total resident: %i\n", total) 
 

end sub




 




 sub Mod_Init ()
 	memset (@mod_novis(0), &Hff, ubound(mod_novis))
 end sub
 
 
 
 /'
===============================================================================

					BRUSHMODEL LOADING

===============================================================================
'/

dim shared as ubyte ptr	 mod_base 






 
  /'
=================
Mod_LoadNodes
=================
'/
sub Mod_LoadNodes (l As lump_t ptr)
 
	 dim as integer	i, j, count, p 
	 dim as dnode_t	ptr _in 
	 dim as mnode_t 	ptr _out 

	 _in = cast(any ptr,(mod_base + l->fileofs)) 
	 if (l->_filelen mod sizeof(*_in)) then
	 	ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 
	 EndIf
	 	
	 count = l->_filelen / sizeof(*_in) 
	_out = Hunk_Alloc ( count*sizeof(*_out)) 	

	 loadmodel->nodes = _out 
	 loadmodel->numnodes = count 

	 for   i=0 to count - 1 
	 
 		for  j=0 to 3-1
 		
	 
	 		_out->minmaxs(j) = LittleShort (_in->mins(j)) 
	 		_out->minmaxs(3+j) = LittleShort (_in->maxs(j)) 
	 	next
	 
	 	p = LittleLong(_in->planenum) 
   	_out->plane = loadmodel->planes + p 

	 	_out->firstsurface = LittleShort (_in->firstface) 
	 	_out->numsurfaces = LittleShort (_in->numfaces) 
	 	_out->contents = CONTENTS_NODE 	'// differentiate from leafs
	 	
	 for  j=0 to 2-1
	 
	 		p = LittleLong (_in->children(j)) 
	 		if (p >= 0) then
	 			_out->children(j) = loadmodel->nodes + p 
	 		else
	 			_out->children(j) = cast(mnode_t ptr,(loadmodel->leafs + (-1 - p)))
	 		end if
	_in+=1  
	_out+=1
	next
next
	Mod_SetParent (loadmodel->nodes, NULL) '	// sets nodes and leafs
end sub
 
  











/'
=================
Mod_LoadLeafs
=================
'/
 sub Mod_LoadLeafs (l as lump_t ptr)
 
 	dim as dleaf_t 	ptr _in  
 	dim as mleaf_t 	ptr _out  
 	dim as integer			i, j, count 
 
 	_in = cast(any ptr  ,mod_base + l->fileofs) 
 	if (l->_filelen mod sizeof(*_in)) then
 		 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 

 		
 	EndIf
 	count = l->_filelen / sizeof(*_in) 
 	_out = Hunk_Alloc ( count*sizeof(*_out)) 
 
 	loadmodel->leafs = _out 
 	loadmodel->numleafs = count 
 
 	for   i=0 to count -1  
 
 

 
     for j= 0 to 3-1
     	   _out->minmaxs(j) = LittleShort (_in->mins(j)) 
 			_out->minmaxs(3+j) = LittleShort (_in->maxs(j)) 
     	
     next

 
 
 		_out->contents = LittleLong(_in->contents) 
 		_out->cluster = LittleShort(_in->cluster) 
 		_out->area = LittleShort(_in->area) 
 
 		_out->firstmarksurface = loadmodel->marksurfaces + _
 			LittleShort(_in->firstleafface) 
 		_out->nummarksurfaces = LittleShort(_in->numleaffaces) 
 		
 		 _in+=1
 		 _out +=1
 	next	
end sub
 



















'/*
'=================
'Mod_LoadMarksurfaces
'=================
'*/

sub Mod_LoadMarksurfaces (l as lump_t ptr)
	 
dim as	 integer		i, j, count 
dim as	short	ptr	_in 
dim as	msurface_t ptr ptr _out 
 	
 	_in = cast(any ptr,(mod_base + l->fileofs)) 
 	if (l->_filelen mod sizeof(*_in)) then
 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 
 	EndIf
 		
 	count = l->_filelen / sizeof(*_in) 
 	_out = Hunk_Alloc ( count*sizeof(*_out)) 	
 
 	loadmodel->marksurfaces = _out 
 	loadmodel->nummarksurfaces = count 
 
 	for i=0 to count-1 
 
 		j = LittleShort(_in[i]) 
 		if (j >= loadmodel->numsurfaces) then
 			ri.Sys_Error (ERR_DROP,"Mod_ParseMarksurfaces: bad surface number") 
 		_out[i] = loadmodel->surfaces + j 	
 		EndIf
 		
 	next
End Sub











 
 
 
 
 
 
 
 
' /*
'=================
'Mod_LoadSurfedges
'=================
'*/
sub Mod_LoadSurfedges (l as lump_t ptr)
 
	dim as  integer		i, count 
	dim as integer	ptr _in, _out 
 	
 	_in = cast(any ptr,(mod_base + l->fileofs)) 
 	if (l->_filelen mod sizeof(*_in)) then
 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name)
 	EndIf
 	 
 	count = l->_filelen / sizeof(*_in) 
 	_out = Hunk_Alloc ( (count+24)*sizeof(*_out)) 	'// extra for skybox
 
 	loadmodel->surfedges = _out 
 	loadmodel->numsurfedges = count 
 
 	for   i=0 to  count  -1
 	_out[i] = LittleLong (_in[i])
 	Next
 		
 		
 		
 		
end sub
'
 /'
'=================
'Mod_LoadPlanes
'=================
'/
sub Mod_LoadPlanes (l as lump_t ptr)
 
 	dim as integer			i, j 
 	dim as mplane_t ptr _out 
 	dim as dplane_t ptr _in   	 
 	dim as integer	   count 
 	dim as integer		 bits 
 	
 	_in = cast(any ptr,(mod_base + l->fileofs)) 
 	if (l->_filelen mod sizeof(*_in)) then
 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name)
 		count = l->_filelen / sizeof(*_in)
 		_out = Hunk_Alloc ( (count+6)*sizeof(*_out))
 	EndIf
 
 
 	loadmodel->planes = _out 
 	loadmodel->numplanes = count 
 
 	for i = 0 to count-1
 	
 
 		bits = 0 
 
    for j = 0 to 3-1
    	
			_out->normal.v(j) = LittleFloat (_in->normal(j))
 			if (_out->normal.v(j) < 0) then
 				bits or= 1 shl j	
 			EndIf
 			 
    next
 
 		_out->dist = LittleFloat (_in->dist) 
 		_out->_type = LittleLong (_in->_type) 
 		_out->signbits = bits 
 		
	_in+=1
 	_out+=1
 Next
  
end sub




/'
=================
Mod_LoadVisibility
=================
'/
sub Mod_LoadVisibility (l as lump_t ptr)
	 dim as 	integer		i 

	 if (l->_filelen = NULL) then
	 	loadmodel->vis = NULL 
	 	return 

	 EndIf
 
	 loadmodel->vis = Hunk_Alloc ( l->_filelen) 	
	 memcpy (loadmodel->vis, mod_base + l->fileofs, l->_filelen) 

	 loadmodel->vis->numclusters = LittleLong (loadmodel->vis->numclusters) 
	 for  i=0  to loadmodel->vis->numclusters - 1 
	 
	 
	 	loadmodel->vis->bitofs(i,0) = LittleLong (loadmodel->vis->bitofs(i,0)) 
	 	loadmodel->vis->bitofs(i,1) = LittleLong (loadmodel->vis->bitofs(i,1)) 
	  	Next
  
	
	
End Sub
 




/'
=================
Mod_LoadVertexes
=================
'/
sub  Mod_LoadVertexes (l as lump_t ptr )
 
	dim as dvertex_t ptr	 _in 
	dim as mvertex_t	 ptr _out 
	dim as integer			i, count 

	_in = cast(any ptr,(mod_base + l->fileofs)) 
	if (l->_filelen mod sizeof(*_in)) then
		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name)
	EndIf
		 
	count = l->_filelen / sizeof(*_in) 
	_out = Hunk_Alloc ( (count+8)*sizeof(*_out)) 		'// extra for skybox

	loadmodel->vertexes = _out 
	loadmodel->numvertexes = count 

 
for i = 0 to count-1
 		_out->position.v(0) = LittleFloat (_in->_point(0)) 
 		_out->position.v(1) = LittleFloat (_in->_point(1)) 
 		_out->position.v(2) = LittleFloat (_in->_point(2))
 		
 		 
 _in+=1
 _out+=1
next



 
end sub

 
 
 dim shared as integer		r_leaftovis(MAX_MAP_LEAFS) 
 dim shared as integer		r_vistoleaf(MAX_MAP_LEAFS) 
  dim shared as integer		r_numvisleafs 

sub	R_NumberLeafs (node as mnode_t ptr)
 
	dim as mleaf_t	 ptr leaf 
	dim as integer		leafnum 

	if (node->contents <> -1) then
 
		 leaf = cast(mleaf_t ptr, node) 
		 leafnum = leaf - loadmodel->leafs 
		 if (leaf->contents and  CONTENTS_SOLID) then
		 	return
		 EndIf
       
		 r_leaftovis(leafnum) = r_numvisleafs 
		 r_vistoleaf(r_numvisleafs) = leafnum 
		 r_numvisleafs+=1 
		return 
	end if

	R_NumberLeafs (node->children(0)) 
	R_NumberLeafs (node->children(1)) 
end sub

/'
=================
Mod_LoadTexinfo
=================
'/
sub Mod_LoadTexinfo (l as lump_t ptr)
 
 	dim as texinfo_t ptr _in 
	dim as mtexinfo_t ptr _out,  _step 
	dim as integer 	i, j, count 
	dim as float	len1, len2 
	dim as zstring *	MAX_QPATH _name  
	dim as integer		_next 
 
 	_in = cast(any ptr,(mod_base + l->fileofs)) 
 	if (l->_filelen mod sizeof(*_in)) then
 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 
 	end if
 	count = l->_filelen  / sizeof(*_in) 
 	_out = Hunk_Alloc ( (count+6)*sizeof(*_out)) 	'// extra for skybox
'
 	loadmodel->texinfo = _out 
 	loadmodel->numtexinfo = count 
 
 
   for i = 0 to count - 1
      for  j=0 to 8-1
 			_out->vecs(0,j) = LittleFloat (_in->vecs(0,j)) 
      next
  		len1 = VectorLength (@_out->vecs(0,0)) 
 		len2 = VectorLength (@_out->vecs(1,1)) 
 		len1 = (len1 + len2)/2 
 		if (len1 < 0.32) then
 			_out->mipadjust = 4 
 		elseif (len1 < 0.49) then
 			_out->mipadjust = 3 
 		elseif (len1 < 0.99) then
 			_out->mipadjust = 2 
 		else
   		_out->mipadjust = 1
 		end if
 		
 #if 0
 		if (len1 + len2 < 0.001) then
 			_out->mipadjust = 1 	'// don't crash
 		else
 			_out->mipadjust = 1 / floor( (len1+len2)/2 + 0.1 ) 
 #endif
 
 		_out->flags = LittleLong (_in->flags) 
 
 		_next = LittleLong (_in->nexttexinfo) 
 		if (_next > 0) then
 			_out->_next = loadmodel->texinfo + _next
 		EndIf
 
 
 		Com_sprintf (_name, sizeof(_name), "textures/%s.wal",   _in->texture) 
 		_out->_image = R_FindImage (_name, it_wall) 
 		if (_out->_image = null) then
 	 
 			_out->_image = r_notexture_mip  '// texture not found
 			_out->flags = 0 
 		end if
 		
 		 _in+=1 
 		 _out+=1
 	next
 
'	// count animation frames
 	for  i=0 to count-1 
 
 		_out = @loadmodel->texinfo[i]
 		_out->numframes = 1 
 		
 		do while _step andalso _step <> _out
 			
 			_out->numframes+=1
 			_step=_step->_next
 		Loop
 		
  
 	next
end sub


sub Mod_LoadSubmodels(l as lump_t ptr)
    dim as dmodel_t	ptr _in 
	 dim as dmodel_t	ptr _out 
	 dim as integer			i, j, count 

	_in = cast(any ptr,(mod_base + l->fileofs)) 
	 if (l->_filelen mod sizeof(*_in)) then
	 	
	 	ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 

	 EndIf
	 count = l->_filelen / sizeof(*_in) 
	_out = Hunk_Alloc ( count*sizeof(*_out)) 	

	 loadmodel->submodels = _out 
	 loadmodel->numsubmodels = count 

	 for i = 0 to count-1
	 
 		for j = 0 to 3-1
 			'// spread the mins / maxs by a pixel
	 		_out->mins(j) = LittleFloat (_in->mins(j)) - 1 
	  		_out->maxs(j) = LittleFloat (_in->maxs(j)) + 1 
	 		_out->origin(j) = LittleFloat (_in->origin(j)) 
	 	next
	 	_out->headnode = LittleLong (_in->headnode) 
	 	_out->firstface = LittleLong (_in->firstface) 
	 	_out->numfaces = LittleLong (_in->numfaces) 
	 	
	 	_in+=1 
	 	_out+=1
	 next
 
	
End Sub

sub Mod_LoadEdges(l as lump_t ptr)
	dim as dedge_t ptr _in 
	dim as medge_t ptr _out 
	dim as integer 	i, count 

	_in = cast(any ptr,(mod_base + l->fileofs)) 
	if (l->_filelen mod sizeof(*_in)) then
		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name)
	EndIf
 
	count = l->_filelen / sizeof(*_in) 
	_out = Hunk_Alloc ( (count + 13) * sizeof(*_out)) 	'// extra for skybox

	loadmodel->edges = _out 
	loadmodel->numedges = count 
 
	 
	 for i =0 to count-1
	 	_out->v(0) = cast(ushort,LittleShort(_in->v(0))) 
	   _out->v(1) = cast(ushort,LittleShort(_in->v(1))) 
			 	
	 	_in+=1
	 	_out+=1
	 Next
 
End Sub
 


sub Mod_LoadLighting(l as lump_t ptr)
dim as	integer		i, size 
dim as	ubyte	ptr _in 
'
 	if (l->_filelen = null) then
 
 		loadmodel->lightdata = NULL 
 		return 
 	end if
 	size = l->_filelen/3 
 	loadmodel->lightdata = Hunk_Alloc (size) 
 	_in = cast(any ptr,(mod_base + l->fileofs)) 
 	for  i=0 to size-1

 
 		if (_in[0] > _in[1] andalso _in[0] > _in[2]) then
 			loadmodel->lightdata[i] = _in[0] 
 		elseif (_in[1] > _in[0] andalso _in[1] > _in[2]) then
 			loadmodel->lightdata[i] = _in[1] 
 		else
 			loadmodel->lightdata[i] = _in[2] 
 		end if
 
_in+=3
next
'

	
End Sub

 

sub Mod_Loadfaces(l as lump_t ptr)
   dim as dmodel_t	ptr _in 
	 dim as dmodel_t	ptr _out 
	dim as integer			i, j, count 

	_in = cast(any ptr,(mod_base + l->fileofs)) 
	 if (l->_filelen mod sizeof(*_in)) then
	 		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->_name) 
	 EndIf
	 	 	
	 count = l->_filelen / sizeof(*_in) 
	 _out = Hunk_Alloc ( count*sizeof(*_out)) 	

	 loadmodel->submodels = _out 
	 loadmodel->numsubmodels = count 

    for i = 0 to count-1
	 
      for j =0  to 3-1
	 	 	'// spread the mins / maxs by a pixel
	 		_out->mins(j) = LittleFloat (_in->mins(j)) - 1 
	 		_out->maxs(j) = LittleFloat (_in->maxs(j)) + 1 
	 		_out->origin(j) = LittleFloat (_in->origin(j)) 
	 	next
	 	_out->headnode = LittleLong (_in->headnode) 
	 	_out->firstface = LittleLong (_in->firstface) 
	 	_out->numfaces = LittleLong (_in->numfaces) 
	 	
	 	_in+=1
	   _out+=1
	 next
	
	
End Sub




  /'
'=================
'Mod_LoadBrushModel
'=================
 '/
 sub Mod_LoadBrushModel (_mod as model_t ptr,buffer as any ptr)
 
	dim as integer			i 
	dim as dheader_t	ptr header 
 	dim as dmodel_t 	ptr  bm 
 
 	loadmodel->_type = mod_brush 
 	if (loadmodel <> @mod_known(0)) then
 		ri.Sys_Error (ERR_DROP, "Loaded a brush model after the world")
 	End If
 		 
 
 	header = cast(dheader_t ptr, buffer) 
 
 	i = LittleLong (header->version) 
 	if (i <> BSPVERSION) then
 				ri.Sys_Error (ERR_DROP,"Mod_LoadBrushModel: %s has wrong version number (%i should be %i)", _mod->_name, i, BSPVERSION) 
 	End If
 '
'// swap all the lumps
 	mod_base = cast(ubyte ptr,header) 
 
 	for  i=0 to (sizeof(dheader_t)/4)-1 
 	
 	 cast(integer ptr,header)[i]  = LittleLong ( (cast(integer ptr,header))[i]) 
 	
 	Next
 		
'
'// load into heap
'	
 	Mod_LoadVertexes (@header->lumps(LUMP_VERTEXES)) 
 	Mod_LoadEdges (@header->lumps(LUMP_EDGES)) 
 	Mod_LoadSurfedges (@header->lumps(LUMP_SURFEDGES)) 
 	Mod_LoadLighting (@header->lumps(LUMP_LIGHTING)) 
 	Mod_LoadPlanes (@header->lumps(LUMP_PLANES)) 
 	Mod_LoadTexinfo (@header->lumps(LUMP_TEXINFO)) 
 	Mod_LoadFaces (@header->lumps(LUMP_FACES)) 
 	Mod_LoadMarksurfaces (@header->lumps(LUMP_LEAFFACES))
 	
 	Mod_LoadVisibility (@header->lumps(LUMP_VISIBILITY))
 	Mod_LoadLeafs (@header->lumps(LUMP_LEAFS)) 
 	Mod_LoadNodes (@header->lumps(LUMP_NODES)) 
 	Mod_LoadSubmodels (@header->lumps(LUMP_MODELS)) 
 	r_numvisleafs = 0 
 	R_NumberLeafs (loadmodel->nodes) 
 	
'//
'// set up the submodels
'//
 for i = 0 to _mod->numsubmodels - 1
 	
 
 		dim as model_t	ptr starmod 
 
 		bm =  @_mod->submodels[i]
 		starmod = @mod_inline(i) 
 
 		*starmod = *loadmodel 
 		
 		starmod->firstmodelsurface = bm->firstface 
 		starmod->nummodelsurfaces = bm->numfaces 
 		starmod->firstnode = bm->headnode 
 		if (starmod->firstnode >= loadmodel->numnodes) then
 				ri.Sys_Error (ERR_DROP, "Inline model %i has bad firstnode", i)
 		EndIf
 
 
 		_VectorCopy (@bm->maxs(0), @starmod->maxs) 
 		_VectorCopy (@bm->mins(0), @starmod->mins) 
 	
 		if (i = 0) then
 			*loadmodel = *starmod 
 		End If
 			
 	 next
 
 	 R_InitSkyBox () 
end sub
' 
'/*
'==============================================================================
'
'ALIAS MODELS
'
'==============================================================================
'*/
'
'/*
'=================
'Mod_LoadAliasModel
'====== 
 sub  Mod_LoadAliasModel (_mod as model_t ptr ,buffer as  any ptr)
 
   dim as integer					i, j 
   dim as dmdl_t ptr	 pinmodel,  pheader 
  	dim as dstvert_t ptr	 pinst,  poutst 
 	dim as dtriangle_t	ptr  pintri,  pouttri 
 	dim as daliasframe_t ptr  pinframe,  poutframe 
   dim as integer ptr pincmd,  poutcmd 
   dim as integer					version 
'
 	pinmodel =  cast(dmdl_t ptr,buffer) 
'
 	version = LittleLong (pinmodel->version) 
 
 	
 	if (version <> ALIAS_VERSION) then
 		'		ri.Sys_Error (ERR_DROP, "%s has wrong version number (%i should be %i)",
 				printf(!"%s has wrong version number (%i should be %i)", _mod->_name, version, ALIAS_VERSION) 

  	EndIf

 'print  pheader
 pheader = _Hunk_Alloc (LittleLong(pinmodel->ofs_end)) 
 if pheader = null then
 print "NULL"
 return
 endif
 
 
 

 
 
 'print LittleLong (pinmodel->ident)
 'print LittleLong (version)
 'print sizeof( *pheader )

 'print pinmodel->skinwidth
 'print pinmodel->skinheight
 'print pinmodel->framesize
 'print pinmodel->num_skins
 'print pinmodel->num_xyz
 'print pinmodel->num_st
 'print pinmodel->num_tris
 'print pinmodel->num_glcmds
 'print pinmodel->num_frames
 'print pinmodel->ofs_skins
 'print pinmodel->ofs_st
 'print pinmodel->ofs_tris
 'print pinmodel->ofs_frames
 'print pinmodel->ofs_glcmds
 'print pinmodel->ofs_end
 '
 '
 
 'sleep
 
'	
	'// byte swap the header fields and sanity check
 
 	'	
 	 for i = 0 to (sizeof(dmdl_t)/4)-1
 		
 		cast(Integer ptr,pheader)[i] = LittleLong (cast(Integer ptr,buffer)[i]) 
 		
 	Next
 	
 	
 	
 	 
  print
  print "PHEADER: " & pheader 
  print "SKIN WIDTH: " & pheader->skinwidth
  print "SKIN HEIGHT: " & pheader->skinheight
  print "FRAME SIZE: " & pheader->framesize
  print "NUM SKINS: " & pheader->num_skins
  print "NUM XYZ: " & pheader->num_xyz 
  print "NUM ST: " & pheader->num_st
  print "NUM TRIS: " & pheader->num_tris
  print "NUM GLCMDS: " & pheader->num_glcmds
  print "NUM FRAMES: " & pheader->num_frames
  print "OFS ST: " & pheader->ofs_st
  print "OFS TRIS: " & pheader->ofs_tris
  print "OFS FRAMES: " & pheader->ofs_frames
  print "OFS GLCMDS: " & pheader->ofs_glcmds
  print "OFS END: " & pheader->ofs_end
 
  
'//
'// load base s and t vertices (not used in gl version)
'//
	pinst = cast(dstvert_t ptr , (cast (ubyte ptr,pinmodel) + pheader->ofs_st)) 
	poutst = cast(dstvert_t ptr,  (cast (ubyte ptr,pheader) + pheader->ofs_st))
  
  
  	for  i = 0 to pheader->num_st -1
  	 	poutst[i].s = LittleShort (pinst[i].s) 
	 	poutst[i].t = LittleShort (pinst[i].t) 	
  	Next
	 


'//
'// load triangle lists
'//
	pintri = cast(dtriangle_t  ptr , (cast (ubyte ptr,pinmodel) + pheader->ofs_tris)) 
	pouttri = cast(dtriangle_t  ptr,  (cast (ubyte ptr,pheader) + pheader->ofs_tris))
  
  
  	for  i = 0 to pheader->num_tris - 1
  			for  j = 0 to 3 - 1
  	 	pouttri[i].index_xyz(j) = LittleShort (pintri[i].index_xyz(j)) 
	 	pouttri[i].index_st(j) = LittleShort (pintri[i].index_st(j)) 	
  	Next
Next	 


'//
'// load the frames
'//
	for  i=0  to  pheader->num_frames -1
		 		pinframe = cast(ubyte ptr, (cast(ubyte ptr,pinmodel)  + pheader->ofs_frames + i * pheader->framesize))
		      poutframe = cast(daliasframe_t ptr,  (cast(ubyte ptr,pheader) + pheader->ofs_frames + i * pheader->framesize)) 
		 
		 memcpy (@poutframe->_name, @pinframe->_name, sizeof(poutframe->_name))
		 
		  
		 for  j=0 to  3 - 1 
	 
	 		poutframe->scale(j) = LittleFloat (pinframe->scale(j)) 
		 	poutframe->translate(j) = LittleFloat (pinframe->translate(j)) 
	 
		'// verts are all 8 bit, so no swapping needed
		 memcpy (@poutframe->verts(0), @pinframe->verts(0), pheader->num_xyz*sizeof(dtrivertx_t)) 
	 	
     next
 
		
	Next
 


 	_mod->_type = mod_alias 





  'sleep
  
  
  
 '		ri.Sys_Error (ERR_DROP, "model %s has a skin taller than %d", mod->name,
'				   MAX_LBM_HEIGHT);
 	print
 if (pheader->skinheight > MAX_LBM_HEIGHT) then
 print "SKIN HEIGHT: " & "NOT OK"
 return
 else
 	
 	print "SKIN HEIGHT: " & "OK"
 EndIf
 
 
 
 

 '		ri.Sys_Error (ERR_DROP, "model %s has no vertices", mod->name);
 	if (pheader->num_xyz <= 0) then
 		
 		 print "NUM XYZ: " & "NOT OK"
 		 return
 else
 	
 	print "NUM XYZ: " & "OK"
 	EndIf


 
'		ri.Sys_Error (ERR_DROP, "model %s has too many vertices", mod->name);
 	if (pheader->num_xyz > MAX_VERTS) then
 		
 		 print "NUM XYZ: " & "NOT OK"
 		 return
 else
 	
 	print "NUM XYZ: " & "OK"
 	EndIf




	'ri.Sys_Error (ERR_DROP, "model %s has no st vertices", mod->name);
 	if (pheader->num_st <= 0) then
 		
 		 print "NUM ST: " & "NOT OK"
 		 return
 else
 	
 	print "NUM ST: " & "OK"
 	EndIf


   'ri.Sys_Error (ERR_DROP, "model %s has no triangles", mod->name);
    	if (pheader->num_tris <= 0) then
 		
 		 print "NUM TRIS: " & "NOT OK"
 		 return
 else
 	
 	print "NUM TRIS: " & "OK"
 	EndIf

   
'   	ri.Sys_Error (ERR_DROP, "model %s has no frames", mod->name);
       	if (pheader->num_frames  <= 0) then
 		
 		 print "NUM FRAMES: " & "NOT OK"
 		 return
 else
 	
 	print "NUM FRAMES: " & "OK"
 	EndIf

 
'	//
'	// load the glcmds
'	//
	pincmd = cast(integer ptr, (cast(ubyte ptr,pinmodel) + pheader->ofs_glcmds))
  poutcmd = cast(integer ptr, (cast(ubyte ptr,pheader) + pheader->ofs_glcmds))

	for i = 0 to pheader->num_glcmds-1
		
		poutcmd[i] = LittleLong (pincmd[i])
		
	Next

'
'
'	// register all skins
 	memcpy ( cast(zstring ptr,pheader) + pheader->ofs_skins, cast(zstring ptr,pinmodel) + pheader->ofs_skins,	pheader->num_skins*MAX_SKINNAME )
 	for  i=0 to pheader->num_skins-1 
 		_mod->skins(i) = R_FindImage (cast(zstring ptr,pheader) + pheader->ofs_skins + i*MAX_SKINNAME,it_skin) 

 	
 	Next
 
 
 
end sub


 
 
 
 
 
   sub R_BeginRegistration (model as ZString ptr)
	  dim fullname as zstring * MAX_QPATH 
	 	 dim flushmap as cvar_t	ptr
	 	 registration_sequence+=1
	 	 r_oldviewcluster = -1 
	    	 Com_sprintf (fullname, sizeof(fullname), "maps/%s.bsp", model) 
	       flushmap = ri.Cvar_Get ("flushmap", "0", 0)
	 	  ' or flushmap->value
	 if ( strcmp(mod_known(0)._name, fullname) ) then
	 	Mod_Free (@mod_known(0))
	 EndIf
 	 r_worldmodel = Mod_ForName(fullname, _true)
	 	 r_viewcluster = -1
	
   End Sub
   
function R_RegisterModel (_name as ZString ptr) as model_s ptr
 
 	dim _mod  as model_t	ptr
 	dim  i  as integer		
 	dim  sprout  as dsprite_t	ptr
 	dim  pheader as dmdl_t ptr
'
 	_mod = Mod_ForName (_name, _false) 
 	if (_mod) then
 	 
 		_mod->registration_sequence = registration_sequence 
'
 		'// register any images used by the models
 		if (_mod->_type = mod_sprite) then
 		 
 			sprout = cast(dsprite_t ptr, _mod->extradata) 
 			for  i=0  to sprout->numframes - 1 
 				_mod->skins(i) = R_FindImage (sprout->frames(i)._name, it_sprite) 
 			Next
 		 
 		elseif (_mod->_type = mod_alias) then
 		 
 			pheader = cast(dmdl_t ptr,_mod->extradata )
 			for  i=0 to  pheader->num_skins - 1
 				
   		 _mod->skins(i) = R_FindImage (cast(zstring ptr,pheader) + pheader->ofs_skins + i*MAX_SKINNAME, it_skin) 
 
 			Next 
 		'//PGM
 			_mod->numframes = pheader->num_frames 
 		'//PGM
 		 
 		elseif (_mod->_type = mod_brush) then
  		 
 			 for  i=0  to _mod->numtexinfo  
 			 	_mod->texinfo[i]._image->registration_sequence = registration_sequence 
 			 Next
 			 	
 		 
 	end if
 end if	
 return _mod 

 
end function

 
sub	R_EndRegistration ()
	 
	 dim as integer		i 
	dim as model_t	ptr _mod
	
_mod=@mod_known(0)


	 for  i=0 to mod_numknown-1 
	 
 		if (_mod->_name[0] = null) then
	 		continue for
 		end if 
 		
	 	if (_mod->registration_sequence <> registration_sequence) then
	 	         	'// don't need this model
	   	Hunk_Free (_mod->extradata) 
	 		memset (_mod, 0, sizeof(*_mod)) 
	 	 

 
	 	else
	   '	// make sure it is paged in
	 		Com_PageInMemory (_mod->extradata, _mod->extradatasize) 
	 	end if
	_mod+=1
	next

	 R_FreeUnusedImages () 
End Sub





sub  Mod_Free (_mod as model_t ptr )
	
	
 
 if _mod then
	 Hunk_Free (_mod->extradata) 
    memset (_mod, 0, sizeof(*_mod))  
 end if

End Sub


 


sub Mod_FreeAll() 
 
	dim i  as integer		

	for i=0   to mod_numknown -1
		 
		 if (mod_known(i).extradatasize) then
		 	
		 		Mod_Free (@mod_known(i)) 
	 
		 EndIf
		
		
	Next
 
End Sub


/'
===============
Mod_PointInLeaf
===============
'/
 function Mod_PointInLeaf ( p as vec3_t ptr ,model as model_t ptr) as mleaf_t ptr
    dim as mnode_t	ptr node 
	 dim as  float		d 
	 dim as mplane_t ptr plane  	   
	 
	 if ( model = NULL orelse  model->nodes = NULL) then
	 	ri.Sys_Error (ERR_DROP, "Mod_PointInLeaf: bad model") 
	 EndIf
	 	

	 node = model->nodes 
	 while (1)
 
 		if (node->contents <> -1) then
	 		return cast(mleaf_t ptr,node )
	 	end if
	 	 'plane = node->plane 
	 	d = _DotProduct (p,@plane->normal) - plane->dist 
	 	if (d > 0) then
	 		node = node->children(0) 
	 	else
	 		node = node->children(1)
	   end  if
	 wend
	 return NULL 	'// never reached
 	
 End Function
 
 
 
'/'
'================
'CalcSurfaceExtents
'
'Fills in s->texturemins[] and s->extents[]
'================
''/
sub CalcSurfaceExtents (s as msurface_t ptr)
 
	dim as float	mins(2), maxs(2), _val 
	dim as integer		i,j, e 
	dim as mvertex_t	ptr v 
	dim as  mtexinfo_t	ptr tex 
	dim as integer		bmins(2), bmaxs(2) 


    mins(1)  = 999999
	 mins(0) = mins(1)
	 maxs(0) = maxs(1) = -99999 

	 tex = s->texinfo 
	 
	 for  i=0  to s->numedges-1 
	 
	 	e = loadmodel->surfedges[s->firstedge+i] 
	 	if (e >= 0) then
	 	 	v = @loadmodel->vertexes[loadmodel->edges[e].v(0)] 
	 	else
	 	 	v = @loadmodel->vertexes[loadmodel->edges[-e].v(1)] 
	   end if	
	 for j = 0 to 2-1
	 
	 		_val = v->position.v(0) * tex->vecs(j,0) + _
	 			v->position.v(1) * tex->vecs(j,1) + _
	 			v->position.v(2) * tex->vecs(j,2) + _
	 			tex->vecs(j,3)
	 		if (_val < mins(j)) then
	 			mins(j) = _val 
	 			end if
	 		if (_val > maxs(j)) then
	 			maxs(j) = _val
	 			end if
 
	 next
next
	 
	for i = 0 to 2-1
		
	
	 
 		bmins(i) = floor(mins(i)/16) 
   	bmaxs(i) = ceil(maxs(i)/16) 

	 	s->texturemins(i) = bmins(i) * 16 
	 	s->extents(i) = (bmaxs(i) - bmins(i)) * 16 
	 	if (s->extents(i) < 16) then
	 		s->extents(i) = 16 	'// take at least one cache block
	 	EndIf
	 	if (  (tex->flags and (SURF_WARP or SURF_SKY)) = NULL andalso s->extents(i) > 256) then
	 		ri.Sys_Error (ERR_DROP,"Bad surface extents") 
	 	EndIf
	   	
	 
	Next
	
end sub
