 
 
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
'void Mod_LoadAliasModel (model_t *mod, void *buffer);
'model_t *Mod_LoadModel (model_t *mod, qboolean crash);

dim shared as ubyte 	mod_novis(MAX_MAP_LEAFS/8)

 #define	MAX_MOD_KNOWN	256
 
 dim shared as  model_t mod_known(MAX_MOD_KNOWN)
dim shared as  integer  mod_numknown 
 
'// the inline * models from the current map are kept seperate
dim shared as  model_t	mod_inline(MAX_MOD_KNOWN) 
 
dim shared	as Integer	registration_sequence  
dim shared	as Integer		modfilelen

'//===============================================================================

 


function R_RegisterModel (_name as ZString ptr) as model_s ptr
 
'	dim _mod  as model_t	ptr
'	dim  i  as integer		
'	dim  sprout  as dsprite_t	ptr
'	dim  pheader as dmdl_t ptr
'
'	_mod = Mod_ForName (_name, _false) 
'	if (_mod) then
'	 
'		_mod->registration_sequence = registration_sequence 
'
'		'// register any images used by the models
'		if (_mod->_type = mod_sprite) then
'		 
'			sprout = cast(dsprite_t ptr, _mod->extradata) 
'			for  i=0  to sprout->numframes - 1 
'				_mod->skins(i) = GL_FindImage (sprout->frames(i)._name, it_sprite) 
'			Next
'				
'		 
'		elseif (_mod->_type = mod_alias) then
'		 
'			pheader = cast(dmdl_t ptr,_mod->extradata )
'			for  i=0 to  pheader->num_skins - 1
'				
'			 _mod->skins(i) = GL_FindImage (cast(zstring ptr,pheader) + pheader->ofs_skins + i*MAX_SKINNAME, it_skin) 
'
'			Next 
'		'//PGM
'			_mod->numframes = pheader->num_frames 
''//PGM
'		 
'		elseif (_mod->_type = mod_brush) then
'		 
'			 for  i=0  to _mod->numtexinfo  
'			 	_mod->texinfo[i]._image->registration_sequence = registration_sequence 
'			 Next
'			 	
'		 
'	end if
'end if	
'	return _mod 

 
end function





sub R_BeginRegistration (model as ZString ptr)
	'	 dim fullname as zstring * MAX_QPATH 
	'	 dim flushmap as cvar_t	ptr
	'	 registration_sequence+=1
	'	 r_oldviewcluster = -1 
	'	 Com_sprintf (fullname, sizeof(fullname), "maps/%s.bsp", model) 
	'	 ' flushmap = ri.Cvar_Get ("flushmap", "0", 0)
	'	  ' or flushmap->value
	'if ( strcmp(mod_known(0)._name, fullname) ) then
	'	Mod_Free (@mod_known(0))
	'EndIf
 	'r_worldmodel = Mod_ForName(fullname, _true)
	'	 r_viewcluster = -1
	
End Sub
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
 sub Mod_Init ()
 	memset (@mod_novis(0), &Hff, ubound(mod_novis))
 end sub
 
sub	R_EndRegistration ()
	
	
End Sub
