
'WORK IN PROGRESS'''''''''''''''''''''''''

#include "gl_local.bi"


dim shared  as integer 		r_viewcluster, r_viewcluster2, r_oldviewcluster, r_oldviewcluster2
dim shared  r_worldmodel as model_t ptr 	 


dim shared loadmodel as model_t ptr	
dim shared  modfilelen  as integer	


declare sub Mod_LoadSpriteModel (_mod as model_t ptr ,buffer as any ptr) 
declare sub Mod_LoadBrushModel (_mod as model_t ptr , buffer as any ptr)  
declare sub Mod_LoadAliasModel (_mod as model_t ptr , buffer as any ptr) 
declare function Mod_LoadModel (_mod as model_t ptr , crash as qboolean ) as model_t ptr

dim shared mod_novis(MAX_MAP_LEAFS/8) as ubyte	

#define	MAX_MOD_KNOWN	512
dim shared mod_known(MAX_MOD_KNOWN) as model_t	
dim shared mod_numknown as integer		

 
dim shared  mod_inline(MAX_MOD_KNOWN) as model_t	

dim shared registration_sequence  as integer = 1		

dim shared hunkcount as Integer



'function Mod_PointInLeaf (p as vec3_t, model as model_t ptr) as mleaf_t ptr
'	
'	 dim node as mnode_t ptr		
'	 dim d as float	 
'	 dim plane as cplane_t ptr 
'	'
'	 if ((model <> NULL) or  (model->nodes  <> NULL)) then
'	 	ri.Sys_Error (ERR_DROP, "Mod_PointInLeaf: bad model")	
'	 endIf
'	 
'
'	node = model->nodes 
'	while (1)
'		if (node->contents <> -1) then
'			return cast(mleaf_t ptr,  node) 
'		plane = node->plane 
'	 	d = DotProduct (p,plane->_normal) - plane->dist 
'	'd = _dotproduct(p,plane->_normal)
'		if (d > 0) then
'			node = node->children(0) 
'		else
'			node = node->children(1)
'		end if
'		end if	
'	Wend
'
'	
'	return NULL 
'	
'	
'End function
' 
'
'
' function Mod_DecompressVis (_in as ubyte ptr, model as model_t ptr ) as ubyte ptr
' 	static 	decompressed(MAX_MAP_LEAFS/8)  as ubyte
'	dim c as integer 
'	dim _out as ubyte ptr
'	dim  row as integer		
'
'	row = (model->vis->numclusters+7) shr 3 	
' 	_out = @decompressed(0) 
'
'	if (_in <> null) then
'
'		while (row)
'		 
'			*_out = &Hff:_out+=1
'			row-=1 
'		wend
'		return @decompressed(0) 	
'		
'	end if
'
'	do
'	 
'		if (*_in) then
'		 
'			*_out = *_in:_out+=1:_in+=1
'			continue do
'		end if
'	
'		c = _in[1] 
'		_in += 2 
'		while (c)
'		 
'			*_out = 0:_out+=1
'			
'			c-=1
'		 wend
'	loop  while (_out - decompressed(0) < row) 
'	
'	return @decompressed(0) 
'
' 	
' 	
' End Function
' 
'	

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
	'ri.Con_Printf (PRINT_ALL,"Loaded models:\n");
	printf(!"Loaded models:\n") 
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

 printf(!"Total resident: %i\n", total)
	'ri.Con_Printf (PRINT_ALL, "Total resident: %i\n", total) 
 

end sub


 sub Mod_Init ()
 	memset (@mod_novis(0), &Hff, ubound(mod_novis))
 end sub
' 
'


'/*
'==================
'Mod_ForName
'
'Loads in a model for the given name
'==================
'*/
function Mod_ForName (_name as zstring ptr,crash as qboolean ) as model_t ptr
	dim _mod as model_t	ptr
	dim buf as UInteger ptr
	dim i as integer 
	
	if (_name[0] = NULL) then
 		 ri.Sys_Error (ERR_DROP, "Mod_ForName: NULL name");
	end if
	
	
	'//
	'// inline models are grabbed only from worldmodel
	'//
	if (_name[0]  = "*") then
			if (i < 1 or r_worldmodel = NULL or i >= r_worldmodel->numsubmodels) then
			  		ri.Sys_Error (ERR_DROP, "bad inline model number") 
			EndIf
	
		i = atoi(_name+1)
		
		return @mod_inline(i)
	EndIf
	 
 
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
			
			 ri.Sys_Error (ERR_DROP, "Mod_NumForName: %s not found", mod->name) 
			printf(!"Mod_NumForName: %s not found", _mod->_name)
		EndIf		
		memset (@_mod->_name, 0, sizeof(_mod->_name)) 
	 return NULL	
	EndIf
	
	 loadmodel = _mod
	
	
		'// call the apropriate loader
	
	
	
 'cls
	 
	'print mod_known(0)._name
	' sleep
	
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
   print("IDS2")
	
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
		'ri.Sys_Error (ERR_DROP,"Mod_NumForName: unknown fileid for %s", mod->name);
	 printf( "Mod_NumForName: unknown fileid for %s") 
	end select

  loadmodel->extradatasize = _Hunk_End () 
   
	ri.FS_FreeFile (buf) 

	return _mod 
	
	
End Function
  


sub R_BeginRegistration (model as ZString ptr)
		 dim fullname as zstring * MAX_QPATH 
		 dim flushmap as cvar_t	ptr
		 registration_sequence+=1
		 r_oldviewcluster = -1 
		 Com_sprintf (fullname, sizeof(fullname), "maps/%s.bsp", model) 
		 ' flushmap = ri.Cvar_Get ("flushmap", "0", 0)
		  ' or flushmap->value
	if ( strcmp(mod_known(0)._name, fullname) ) then
		Mod_Free (@mod_known(0))
	EndIf
 	r_worldmodel = Mod_ForName(fullname, _true)
		 r_viewcluster = -1
	
End Sub


'/*
'@@@@@@@@@@@@@@@@@@@@@
'R_EndRegistration
'
'@@@@@@@@@@@@@@@@@@@@@
'*/
sub R_EndRegistration ()
'		int		i;
'	model_t	*mod;
'
'
'   mod=mod_known
'	for (i=0, mod=mod_known ; i<mod_numknown ; i++, mod++)
'	{
'		if (!mod->name[0])
'			continue;
'		if (mod->registration_sequence != registration_sequence)
'		{	// don't need this model
'			Mod_Free (mod);
'		}
'	}
'
'	GL_FreeUnusedImages ();
'}

	
	
End Sub
 




' 
'
'	
'
'' 
''	if ( strcmp(mod_known[0].name, fullname) || flushmap->value)
''		;
''	r_worldmodel = Mod_ForName(fullname, _true);
''
'' 
''}
'
'
'
'
'
'
'
'
'
'sub R_EndRegistration ()
'	
'	
'	'	dim i as integer
'	'dim _mod as model_t	
'
'	'for (i=0, mod=mod_known ; i<mod_numknown ; i++, mod++)
'	'
'	'		if ( _mod->_name(0)) then
'	'		continue for
'	'	if (mod->registration_sequence <> registration_sequence) then
'	'		Mod_Free (_mod) 
'	'	EndIf
'	'	
'	'	EndIf
'	'	
'	'
'	'Next
' 
'
'		 
'			
'		 
' 
''	GL_FreeUnusedImages () 
' 
'
'	
'End Sub
' 
 
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
 		_mod->skins(i) = GL_FindImage (cast(zstring ptr,pheader) + pheader->ofs_skins + i*MAX_SKINNAME,it_skin) 

 	
 	Next
 
 
 'need to figure out how to add vec3_t in freebasic still''''''''''''''''''''''''''
	'_mod->mins(0) = -32 
	'_mod->mins(1) = -32 
	'_mod->mins(2) = -32 
	'_mod->maxs(0) = 32 
	'_mod->maxs(1) = 32 
	'_mod->maxs(2) = 32 
end sub




 
sub  Mod_Free (_mod as model_t ptr )
	
	
 
 if _mod then
	 _Hunk_Free (_mod->extradata) 
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



'/*
'@@@@@@@@@@@@@@@@@@@@@
'R_RegisterModel
'
'@@@@@@@@@@@@@@@@@@@@@
'*/
function R_RegisterModel (_name as ZString ptr) as model_s ptr
 
	dim _mod  as model_t	ptr
	dim  i  as integer		
	dim  sprout  as dsprite_t	ptr
	dim  pheader as dmdl_t ptr

	_mod = Mod_ForName (_name, _false) 
	if (_mod) then
	 
		_mod->registration_sequence = registration_sequence 

		'// register any images used by the models
		if (_mod->_type = mod_sprite) then
		 
			sprout = cast(dsprite_t ptr, _mod->extradata) 
			for  i=0  to sprout->numframes - 1 
				_mod->skins(i) = GL_FindImage (sprout->frames(i)._name, it_sprite) 
			Next
				
		 
		elseif (_mod->_type = mod_alias) then
		 
			pheader = cast(dmdl_t ptr,_mod->extradata )
			for  i=0 to  pheader->num_skins - 1
				
			 _mod->skins(i) = GL_FindImage (cast(zstring ptr,pheader) + pheader->ofs_skins + i*MAX_SKINNAME, it_skin) 

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



