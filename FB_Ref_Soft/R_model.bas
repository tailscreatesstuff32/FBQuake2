 
 
'// models.c -- model loading and caching

'// models are the only shared resource between a client and server running
'// on the same machine.

 '#define  Dmodel_t Dim shared as model_t
 '#define  Dint   dim shared as  integer

 
#Include "FB_Ref_Soft\r_local.bi"


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
	 'loadmodel->extradata = _Hunk_Begin (&H1000000) 
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
 
 
 
 
' /*
'=================
'Mod_LoadLeafs
'=================
'*/
'void Mod_LoadLeafs (lump_t *l)
'{'
'	dleaf_t 	*in;'
'	mleaf_t 	*out;
'	int			i, j, count;
'
'	in = (void *)(mod_base + l->fileofs);
'	if (l->filelen % sizeof(*in))
'		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->name);
'	count = l->filelen / sizeof(*in);
'	out = Hunk_Alloc ( count*sizeof(*out));
'
'	loadmodel->leafs = out;
'	loadmodel->numleafs = count;
'
'	for ( i=0 ; i<count ; i++, in++, out++)
'	{
'		for (j=0 ; j<3 ; j++)
'		{
'			out->minmaxs[j] = LittleShort (in->mins[j]);
'			out->minmaxs[3+j] = LittleShort (in->maxs[j]);
'		}
'
'		out->contents = LittleLong(in->contents);
'		out->cluster = LittleShort(in->cluster);
'		out->area = LittleShort(in->area);
'
'		out->firstmarksurface = loadmodel->marksurfaces +
'			LittleShort(in->firstleafface);
'		out->nummarksurfaces = LittleShort(in->numleaffaces);
'	}	
'}
'




















'/*
'=================
'Mod_LoadMarksurfaces
'=================
'*/

sub Mod_LoadMarksurfaces (l as lump_t ptr)
	'{	'
	'int		i, j, count;'
	'short		*in;
'	msurface_t **out;
'	
'	in = (void *)(mod_base + l->fileofs);
'	if (l->filelen % sizeof(*in))
'		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->name);
'	count = l->filelen / sizeof(*in);
'	out = Hunk_Alloc ( count*sizeof(*out));	
'
'	loadmodel->marksurfaces = out;
'	loadmodel->nummarksurfaces = count;
'
'	for ( i=0 ; i<count ; i++)
'	{
'		j = LittleShort(in[i]);
'		if (j >= loadmodel->numsurfaces)
'			ri.Sys_Error (ERR_DROP,"Mod_ParseMarksurfaces: bad surface number");
'		out[i] = loadmodel->surfaces + j;
'	}
End Sub











 
 
 
 
 
 
 
 
' /*
'=================
'Mod_LoadSurfedges
'=================
'*/
'void Mod_LoadSurfedges (lump_t *l)
'{	'
	'int		i, count;'
	'int		*in, *out;
'	
'	in = (void *)(mod_base + l->fileofs);
'	if (l->filelen % sizeof(*in))
'		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->name);
'	count = l->filelen / sizeof(*in);
'	out = Hunk_Alloc ( (count+24)*sizeof(*out));	// extra for skybox
'
'	loadmodel->surfedges = out;
'	loadmodel->numsurfedges = count;
'
'	for ( i=0 ; i<count ; i++)
'		out[i] = LittleLong (in[i]);
'}
'
'/*
'=================
'Mod_LoadPlanes
'=================
'*/
'void Mod_LoadPlanes (lump_t *l)
'{'
'	int			i, j;'
'	mplane_t	*out;
'	dplane_t 	*in;
'	int			count;
'	int			bits;
'	
'	in = (void *)(mod_base + l->fileofs);
'	if (l->filelen % sizeof(*in))
'		ri.Sys_Error (ERR_DROP,"MOD_LoadBmodel: funny lump size in %s",loadmodel->name);
'	count = l->filelen / sizeof(*in);
'	out = Hunk_Alloc ( (count+6)*sizeof(*out));		// extra for skybox
'	
'	loadmodel->planes = out;
'	loadmodel->numplanes = count;
'
'	for ( i=0 ; i<count ; i++, in++, out++)
'	{
'		bits = 0;
'		for (j=0 ; j<3 ; j++)
'		{
'			out->normal[j] = LittleFloat (in->normal[j]);
'			if (out->normal[j] < 0)
'				bits |= 1<<j;
'		}
'
'		out->dist = LittleFloat (in->dist);
'		out->type = LittleLong (in->type);
'		out->signbits = bits;
'	}
'}
 
' /*
'=================
'Mod_LoadBrushModel
'=================
'*/
'void Mod_LoadBrushModel (model_t *mod, void *buffer)
'{'
	'int			i;'
	'dheader_t	*header;
'	dmodel_t 	*bm;
'	
'	loadmodel->type = mod_brush;
'	if (loadmodel != mod_known)
'		ri.Sys_Error (ERR_DROP, "Loaded a brush model after the world");
'	
'	header = (dheader_t *)buffer;
'
'	i = LittleLong (header->version);
'	if (i != BSPVERSION)
'		ri.Sys_Error (ERR_DROP,"Mod_LoadBrushModel: %s has wrong version number (%i should be %i)", mod->name, i, BSPVERSION);
'
'// swap all the lumps
'	mod_base = (byte *)header;
'
'	for (i=0 ; i<sizeof(dheader_t)/4 ; i++)
'		((int *)header)[i] = LittleLong ( ((int *)header)[i]);
'
'// load into heap
'	
'	Mod_LoadVertexes (&header->lumps[LUMP_VERTEXES]);
'	Mod_LoadEdges (&header->lumps[LUMP_EDGES]);
'	Mod_LoadSurfedges (&header->lumps[LUMP_SURFEDGES]);
'	Mod_LoadLighting (&header->lumps[LUMP_LIGHTING]);
'	Mod_LoadPlanes (&header->lumps[LUMP_PLANES]);
'	Mod_LoadTexinfo (&header->lumps[LUMP_TEXINFO]);
'	Mod_LoadFaces (&header->lumps[LUMP_FACES]);
'	Mod_LoadMarksurfaces (&header->lumps[LUMP_LEAFFACES]);
'	Mod_LoadVisibility (&header->lumps[LUMP_VISIBILITY]);
'	Mod_LoadLeafs (&header->lumps[LUMP_LEAFS]);
'	Mod_LoadNodes (&header->lumps[LUMP_NODES]);
'	Mod_LoadSubmodels (&header->lumps[LUMP_MODELS]);
'	r_numvisleafs = 0;
'	R_NumberLeafs (loadmodel->nodes);
'	
'//
'// set up the submodels
'//
'	for (i=0 ; i<mod->numsubmodels ; i++)
'	{
'		model_t	*starmod;
'
'		bm = &mod->submodels[i];
'		starmod = &mod_inline[i];
'
'		*starmod = *loadmodel;
'		
'		starmod->firstmodelsurface = bm->firstface;
'		starmod->nummodelsurfaces = bm->numfaces;
'		starmod->firstnode = bm->headnode;
'		if (starmod->firstnode >= loadmodel->numnodes)
'			ri.Sys_Error (ERR_DROP, "Inline model %i has bad firstnode", i);
'
'		VectorCopy (bm->maxs, starmod->maxs);
'		VectorCopy (bm->mins, starmod->mins);
'	
'		if (i == 0)
'			*loadmodel = *starmod;
'	}
'
'	R_InitSkyBox ();
'}
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
'	for (i=0 ; i<pheader->num_glcmds ; i++)
'		poutcmd[i] = LittleLong (pincmd[i]);
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
 
 
 'need to figure out how to add vec3_t in freebasic still''''''''''''''''''''''''''
	'_mod->mins(0) = -32 
	'_mod->mins(1) = -32 
	'_mod->mins(2) = -32 
	'_mod->maxs(0) = 32 
	'_mod->maxs(1) = 32 
	'_mod->maxs(2) = 32 
end sub



'/*
'==============================================================================
'
'SPRITE MODELS
'
'==============================================================================
'*/
'
'/*
'=================
'Mod_LoadSpriteModel
'=================
'*/
'void Mod_LoadSpriteModel (model_t *mod, void *buffer)
'{'
	'dsprite_t	*sprin, *sprout;'
	'int			i;
'
'	sprin = (dsprite_t *)buffer;
'	sprout = Hunk_Alloc (modfilelen);
'
'	sprout->ident = LittleLong (sprin->ident);
'	sprout->version = LittleLong (sprin->version);
'	sprout->numframes = LittleLong (sprin->numframes);
'
'	if (sprout->version != SPRITE_VERSION)
'		ri.Sys_Error (ERR_DROP, "%s has wrong version number (%i should be %i)",
'				 mod->name, sprout->version, SPRITE_VERSION);
'
'	if (sprout->numframes > MAX_MD2SKINS)
'		ri.Sys_Error (ERR_DROP, "%s has too many frames (%i > %i)",
'				 mod->name, sprout->numframes, MAX_MD2SKINS);
'
'	// byte swap everything
'	for (i=0 ; i<sprout->numframes ; i++)
'	{
'		sprout->frames[i].width = LittleLong (sprin->frames[i].width);
'		sprout->frames[i].height = LittleLong (sprin->frames[i].height);
'		sprout->frames[i].origin_x = LittleLong (sprin->frames[i].origin_x);
'		sprout->frames[i].origin_y = LittleLong (sprin->frames[i].origin_y);
'		memcpy (sprout->frames[i].name, sprin->frames[i].name, MAX_SKINNAME);
'		mod->skins[i] = R_FindImage (sprout->frames[i].name, it_sprite);
'	}
'
'	mod->type = mod_sprite;
'}
'
'//=============================================================================
 
 
 
 
 
   sub R_BeginRegistration (model as ZString ptr)
	  dim fullname as zstring * MAX_QPATH 
	 	 dim flushmap as cvar_t	ptr
	 	 registration_sequence+=1
	 	 r_oldviewcluster = -1 
	'	 Com_sprintf (fullname, sizeof(fullname), "maps/%s.bsp", model) 
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
	'
	'	int		i;
	'model_t	*mod;

	'for (i=0, mod=mod_known ; i<mod_numknown ; i++, mod++)
	'{
'		if (!mod->name[0])
	'		continue;
	'	if (mod->registration_sequence != registration_sequence)
	'	{	// don't need this model
	'		Hunk_Free (mod->extradata);
	'		memset (mod, 0, sizeof(*mod));
	'	}
	'	else
	'	{	// make sure it is paged in
	'		Com_PageInMemory (mod->extradata, mod->extradatasize);
	'	}
	'}

	'R_FreeUnusedImages ();
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