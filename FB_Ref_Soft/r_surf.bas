#Include "FB_Ref_Soft\r_local.bi"





dim shared as surfcache_t	ptr sc_rover,  sc_base 

 dim shared as integer _sc_size
'/*
'================
'R_InitCaches
'
'================
'*/
sub R_InitCaches ()
 
	dim as integer		_size 
	dim as integer		pix 

	'// calculate size to allocate
	if (sw_surfcacheoverride->value) then
 
		_size = sw_surfcacheoverride->value 
	 
	else
	 
		_size = SURFCACHE_SIZE_AT_320X240 

		pix = vid._width*vid._height 
		if (pix > 64000) then
			_size += (pix-64000)*3 
	end if		
	end if	
	'// round up to page size
	 _size = (_size + 8191) and not(8191) 

    
	 ri.Con_Printf (PRINT_ALL,!"%ik surface cache\n", _size\1024  ) 
	
	_sc_size = _size 
	sc_base = cast(surfcache_t ptr,malloc(_size)) 
	sc_rover = sc_base 
	
	sc_base->_next = NULL 
	sc_base->owner = NULL 
	sc_base->size = sc_size 
end sub



sub D_FlushCaches()
	 	dim as surfcache_t ptr c 
	
	 if ( sc_base = NULL) then
	 	return
	 EndIf

	c = sc_base
	do while c
		
	 if (c->owner) then
	 		*c->owner = NULL 
	 EndIf
	 	

		
	c = c->_next
	Loop
	
	
	
	 sc_rover = sc_base 
	 sc_base->_next = NULL 
	 sc_base->owner = NULL 
	 sc_base->size = sc_size 
 
End Sub

	 


 
	
 