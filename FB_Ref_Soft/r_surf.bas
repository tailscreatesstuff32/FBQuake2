'FINISHED FOR NOW///////////////////////////////////////////////


#Include "FB_Ref_Soft\r_local.bi"



dim shared as drawsurf_t	r_drawsurf 

dim shared as surfcache_t	ptr sc_rover,  sc_base 

 dim shared as integer _sc_size
 
 
extern "C"

extern  as integer				lightleft, sourcesstep, blocksize, sourcetstep 
extern  as integer				lightdelta, lightdeltastep 
extern  as integer				lightright, lightleftstep, lightrightstep, blockdivshift 
extern  as integer		      blockdivmask 
extern  as any		        ptr prowdestbase 
extern  as ubyte	        ptr pbasesource 
extern  as integer				surfrowbytes 	' used by ASM files
extern  as integer		  ptr r_lightptr 
extern  as integer				r_stepback 
extern  as integer				r_lightwidth 
extern  as integer				r_numhblocks, r_numvblocks 
extern  as ubyte	ptr r_source, r_sourcemax 
 
 
 
declare sub R_DrawSurfaceBlock8_mip0 ()
declare sub R_DrawSurfaceBlock8_mip1 ()
declare sub R_DrawSurfaceBlock8_mip2 ()
declare sub R_DrawSurfaceBlock8_mip3 ()
 
 
 
 
end extern 


static shared as sub () surfmiptable(4)   => { _
	@R_DrawSurfaceBlock8_mip0, _
	@R_DrawSurfaceBlock8_mip1, _
	@R_DrawSurfaceBlock8_mip2, _
	@R_DrawSurfaceBlock8_mip3  _
} 

 
dim shared as integer				lightleft, sourcesstep, blocksize, sourcetstep 
dim shared as integer				lightdelta, lightdeltastep 
dim shared as integer				lightright, lightleftstep, lightrightstep, blockdivshift 
dim shared as integer		      blockdivmask 
dim shared as any		        ptr prowdestbase 
dim shared as ubyte	        ptr pbasesource 
dim shared as integer				surfrowbytes 	' used by ASM files
dim shared as integer		  ptr r_lightptr 
dim shared as integer				r_stepback 
dim shared as integer				r_lightwidth 
dim shared as integer				r_numhblocks, r_numvblocks 
dim shared as ubyte	ptr r_source, r_sourcemax 

declare sub R_BuildLightMap () 
extern	as uinteger		blocklights(1024) 	'// allow some very large lightmaps

dim shared as float           surfscale 
dim shared as qboolean        r_cache_thrash       '  // set if surface cache is thrashing

'dim shared as integer         sc_size 
'dim shared as surfcache_t	ptr  sc_rover,  sc_base 



/'
===============
R_TextureAnimation

Returns the proper texture for a given time and base texture
===============
'/
function R_TextureAnimation (tex as mtexinfo_t ptr ) as image_t ptr
 
	dim as integer		c 

	if ( tex->_next <> null) then
		return tex->_image
	EndIf
		 

	c = currententity->frame mod tex->numframes 
	while (c)
		tex = tex->_next 
		c-=1	
	Wend
	 
	
	 

	return tex->_image 
end function
 

'/*
'===============
'R_DrawSurface
'===============
'*/
sub R_DrawSurface ()
   dim as ubyte	ptr basetptr 
 	dim as integer				smax, tmax, twidth 
 	dim as integer				u 
 	dim as integer				soffset, basetoffset, texwidth 
 	dim as integer				horzblockstep 
 	dim as ubyte	ptr      pcolumndest 
 	dim as sub() pblockdrawer 


 	dim as image_t	 ptr  mt 
 
 	surfrowbytes = r_drawsurf.rowbytes 
 
 	mt = r_drawsurf._image 
 	
 	r_source = mt->pixels(r_drawsurf.surfmip)
 
'// the fractional light values should range from 0 to (VID_GRADES - 1) << 16
'// from a source range of 0 - 255
'	
 	texwidth = mt->_width shr r_drawsurf.surfmip 
 
 	blocksize = 16 shr r_drawsurf.surfmip 
 	blockdivshift = 4 - r_drawsurf.surfmip 
 	blockdivmask = (1 shl blockdivshift) - 1 
 	
 	r_lightwidth = (r_drawsurf.surf->extents(0) shr 4)+1 
 
 	r_numhblocks = r_drawsurf.surfwidth shr blockdivshift 
 	r_numvblocks = r_drawsurf.surfheight shr blockdivshift 
 
'//==============================
 
 	'
 	'pblockdrawer = surfmiptable(r_drawsurf.surfmip) 
'// TODO: only needs to be set when there is a display settings change
 	horzblockstep = blocksize 
 
 	smax = mt->_width shr r_drawsurf.surfmip 
 	twidth = texwidth 
 	tmax = mt->_height shr r_drawsurf.surfmip 
 	sourcetstep = texwidth 
 	r_stepback = tmax * twidth 
 
 	r_sourcemax = r_source + (tmax * smax) 
 
 	soffset = r_drawsurf.surf->texturemins(0)
 	basetoffset = r_drawsurf.surf->texturemins(1)
 
'// << 16 components are to guarantee positive values for %
 	soffset = ((soffset shr r_drawsurf.surfmip) + (smax shl 16)) mod smax 
 	basetptr = @r_source[((((basetoffset shr r_drawsurf.surfmip) _ 
 		+ (tmax shl 16)) mod tmax) * twidth)] 
'
 	pcolumndest = r_drawsurf.surfdat 
'
 	for  u=0 to r_numhblocks 
 
 		r_lightptr = @blocklights(0) + u 
'
 		prowdestbase = pcolumndest 
'
 		pbasesource = basetptr + soffset 
 
 		' pblockdrawer()
 
 		soffset = soffset + blocksize 
 		if (soffset >= smax) then
 			soffset = 0 
 		EndIf
 			
 
 		pcolumndest += horzblockstep 
	 next
End Sub
 
 
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
 
 
 
 
'/*
'=================
'D_SCAlloc
'=================
'*/
 
 
function D_SCAlloc (_width as integer ,_size as integer ) as surfcache_t  ptr
	
 	dim as surfcache_t    ptr         _new  
 	dim as qboolean                wrapped_this_time 
 
 	if ((_width < 0) or (_width > 256)) then
 		ri.Sys_Error (ERR_FATAL,!"D_SCAlloc: bad cache width %d\n", _width)
 	EndIf
 
 	if ((_size <= 0) or (_size > &H10000)) then
 		ri.Sys_Error (ERR_FATAL,!"D_SCAlloc: bad cache size %d\n", _size)
 	EndIf
 
  'MIGHT of did it wrong///////////////////////////////////
  _size = cast(integer,@cast(surfcache_t ptr,0)->_data(_size))
  '////////////////////////////////////////////////////////
 	
 	  _size = (_size + 3) and not 3 
 	
 	if (_size > sc_size) then
 		ri.Sys_Error (ERR_FATAL,"D_SCAlloc: %i > cache size of %i",_size, sc_size) 
 	EndIf
 		
 
'// if there is not size bytes after the rover, reset to the start
 	wrapped_this_time = false 

	if ( sc_rover = null or cast(ubyte ptr,sc_rover) - cast(ubyte ptr,sc_base) > sc_size - _size) then

		if (sc_rover) then
				wrapped_this_time = true 
		EndIf

 		sc_rover = sc_base 
 	end if
		
'// colect and free surfcache_t blocks until the rover block is large enough
 	_new = sc_rover  
 	if (sc_rover->owner) then
 		*sc_rover->owner = NULL
 	EndIf
 
 	
 	while (_new->size < _size)
 	'	// free another
 		sc_rover = sc_rover->_next 
 		if (sc_rover = NULL) then
 			ri.Sys_Error (ERR_FATAL,"D_SCAlloc: hit the end of memory")
 		EndIf
 			 
 	Wend
 

 		
   	if (sc_rover->owner) then
   		*sc_rover->owner = NULL
   	EndIf
 
 		
 		_new->size += sc_rover->size 
 		_new->_next = sc_rover->_next 

'// create a fragment out of any leftovers
 	if (_new->size - _size > 256) then
 
 		sc_rover = cast(surfcache_t ptr, cast(ubyte ptr,_new) + _size) 
 		sc_rover->size = _new->size - _size 
 		sc_rover->_next = _new->_next 
 		sc_rover->_width = 0 
 		sc_rover->owner = NULL 
 		_new->_next = sc_rover 
 		_new->size = _size 
 
 	else
 		sc_rover = _new->_next 
 	end if
'	
 	_new->_width = _width 
'// DEBUG
 	if (_width > 0)then
 		_new->_height = (_size - sizeof(*_new) + sizeof(_new->_data)) / _width
 	EndIf
 
 
 	_new->owner = NULL               '// should be set properly after return
 
 	if (d_roverwrapped) then
 
 		if (wrapped_this_time or (sc_rover >= d_initial_rover)) then
 			r_cache_thrash = true
 		EndIf
 			 
 
 	elseif (wrapped_this_time) then
       
 		d_roverwrapped = true 
 	end if
'
 	return _new 
	
End Function
 
 

 
 
 '// if the num is not a power of 2, assume it will not repeat

function   MaskForNum (num as integer ) as integer
	if (num = 128) then
		return 127
	EndIf
		 
	if (num = 64) then
		return 63 
	EndIf
		
	if (num = 32) then
		return 31 
	EndIf
		
	if (num = 16) then
		return 15
	EndIf
	 
	return 255 
End Function
 

 

function  D_log2 (num as integer ) as Integer
  dim as integer   c 
	
	c = 0 
	
	while (num)
		num shr= 1
		c+=1
	Wend
		
	return c 
	
End Function
 




 
/'
=================
D_SCDump
=================
'/
sub D_SCDump ()
		dim as surfcache_t ptr test

 	 test = sc_base
	do while test
			if (test = sc_rover) then
		      ri.Con_Printf (PRINT_ALL,"ROVER:\n")
   EndIf

		      ri.Con_Printf (PRINT_ALL,!"%p : %i bytes     %i width\n",test, test->size, test->_width) 
		test = test->_next
	Loop
  
			
 
 
 
 
End Sub
	













 
 
 
/'
================
D_CacheSurface
================
'/
function D_CacheSurface (surface as msurface_t ptr,miplevel as integer ) as surfcache_t ptr
	dim as	surfcache_t     ptr  cache  

'//
'// if the surface is animating or flashing, flush the cache
'//
	r_drawsurf._image = R_TextureAnimation (surface->texinfo) 
	r_drawsurf.lightadj(0) = r_newrefdef.lightstyles[surface->styles(0)].white*128 
	r_drawsurf.lightadj(1) = r_newrefdef.lightstyles[surface->styles(1)].white*128 
	r_drawsurf.lightadj(2) = r_newrefdef.lightstyles[surface->styles(2)].white*128 
	r_drawsurf.lightadj(3) = r_newrefdef.lightstyles[surface->styles(3)].white*128 
	
'//
'// see if the cache holds apropriate data
'//
	cache = surface->cachespots(miplevel) 

	if (cache <> null and  cache->dlight = null and surface->dlightframe <> r_framecount _
			and cache->_image  = r_drawsurf._image _
			and cache->lightadj(0) = r_drawsurf.lightadj(0) _ 
			and cache->lightadj(1) = r_drawsurf.lightadj(1) _
			and cache->lightadj(2) = r_drawsurf.lightadj(2) _
			and cache->lightadj(3) = r_drawsurf.lightadj(3) ) then
			
		return cache 	
		end if	
		

'//
'// determine shape of surface
'//
	surfscale = 1.0 / (1 shl miplevel) 
	r_drawsurf.surfmip = miplevel 
	r_drawsurf.surfwidth = surface->extents(0) shr miplevel 
	r_drawsurf.rowbytes = r_drawsurf.surfwidth 
	r_drawsurf.surfheight = surface->extents(1) shr miplevel 
	
'//
'// allocate memory if needed
'//
	if (cache = null) then    '// if a texture just animated, don't reallocate it
	   cache = D_SCAlloc (r_drawsurf.surfwidth, _
	   r_drawsurf.surfwidth * r_drawsurf.surfheight) 
		surface->cachespots(miplevel) = cache 
		cache->owner = @surface->cachespots(miplevel)
		cache->mipscale = surfscale 
	EndIf
 

 
	if (surface->dlightframe  = r_framecount) then
			cache->dlight = 1 
	else
		cache->dlight = 0 	
	EndIf


	r_drawsurf.surfdat = cast(pixel_t ptr, @cache->_data(0) )
	
	cache->_image = r_drawsurf._image 
	cache->lightadj(0) = r_drawsurf.lightadj(0) 
	cache->lightadj(1) = r_drawsurf.lightadj(1) 
	cache->lightadj(2) = r_drawsurf.lightadj(2) 
	cache->lightadj(3) = r_drawsurf.lightadj(3) 

'//
'// draw and light the surface texture
'//
	r_drawsurf.surf = surface 

	c_surf+=1

	'// calculate the lightings
	R_BuildLightMap () 
	
	'// rasterize the surface into the cache
	R_DrawSurface () 

	return cache 
	
	
	
End Function

 
 
 
 
 
 'NOT REALLY NEEDED FOR nOW
 
 #ifndef id386

/'
================
R_DrawSurfaceBlock8_mip0
================
'/
sub R_DrawSurfaceBlock8_mip0 ()
 
	dim as integer				v, i, b, lightstep, lighttemp, light 
	dim as ubyte	ptr psource,  prowdest  
   dim as ubyte pix
	psource = pbasesource  
	prowdest = prowdestbase 

	for (v=0 ; v<r_numvblocks ; v++)
	{
	// FIXME: make these locals?
	// FIXME: use delta rather than both right and left, like ASM?
		lightleft = r_lightptr[0];
		lightright = r_lightptr[1];
		r_lightptr += r_lightwidth;
		lightleftstep = (r_lightptr[0] - lightleft) >> 4;
		lightrightstep = (r_lightptr[1] - lightright) >> 4;

		for (i=0 ; i<16 ; i++)
		{
			lighttemp = lightleft - lightright;
			lightstep = lighttemp >> 4;

			light = lightright;

			for (b=15; b>=0; b--)
			{
				pix = psource[b];
				prowdest[b] = ((unsigned char *)vid.colormap)
						[(light & 0xFF00) + pix];
				light += lightstep;
			}
	
			psource += sourcetstep;
			lightright += lightrightstep;
			lightleft += lightleftstep;
			prowdest += surfrowbytes;
		}

		if (psource >= r_sourcemax)
			psource -= r_stepback;
	}
}


/*
================
R_DrawSurfaceBlock8_mip1
================
*/
void R_DrawSurfaceBlock8_mip1 (void)
{
	int				v, i, b, lightstep, lighttemp, light;
	unsigned char	pix, *psource, *prowdest;

	psource = pbasesource;
	prowdest = prowdestbase;

	for (v=0 ; v<r_numvblocks ; v++)
	{
	// FIXME: make these locals?
	// FIXME: use delta rather than both right and left, like ASM?
		lightleft = r_lightptr[0];
		lightright = r_lightptr[1];
		r_lightptr += r_lightwidth;
		lightleftstep = (r_lightptr[0] - lightleft) >> 3;
		lightrightstep = (r_lightptr[1] - lightright) >> 3;

		for (i=0 ; i<8 ; i++)
		{
			lighttemp = lightleft - lightright;
			lightstep = lighttemp >> 3;

			light = lightright;

			for (b=7; b>=0; b--)
			{
				pix = psource[b];
				prowdest[b] = ((unsigned char *)vid.colormap)
						[(light & 0xFF00) + pix];
				light += lightstep;
			}
	
			psource += sourcetstep;
			lightright += lightrightstep;
			lightleft += lightleftstep;
			prowdest += surfrowbytes;
		}

		if (psource >= r_sourcemax)
			psource -= r_stepback;
	}
}


/*
================
R_DrawSurfaceBlock8_mip2
================
*/
void R_DrawSurfaceBlock8_mip2 (void)
{
	int				v, i, b, lightstep, lighttemp, light;
	unsigned char	pix, *psource, *prowdest;

	psource = pbasesource;
	prowdest = prowdestbase;

	for (v=0 ; v<r_numvblocks ; v++)
	{
	// FIXME: make these locals?
	// FIXME: use delta rather than both right and left, like ASM?
		lightleft = r_lightptr[0];
		lightright = r_lightptr[1];
		r_lightptr += r_lightwidth;
		lightleftstep = (r_lightptr[0] - lightleft) >> 2;
		lightrightstep = (r_lightptr[1] - lightright) >> 2;

		for (i=0 ; i<4 ; i++)
		{
			lighttemp = lightleft - lightright;
			lightstep = lighttemp >> 2;

			light = lightright;

			for (b=3; b>=0; b--)
			{
				pix = psource[b];
				prowdest[b] = ((unsigned char *)vid.colormap)
						[(light & 0xFF00) + pix];
				light += lightstep;
			}
	
			psource += sourcetstep;
			lightright += lightrightstep;
			lightleft += lightleftstep;
			prowdest += surfrowbytes;
		}

		if (psource >= r_sourcemax)
			psource -= r_stepback;
	}
}


/*
================
R_DrawSurfaceBlock8_mip3
================
*/
void R_DrawSurfaceBlock8_mip3 (void)
{
	int				v, i, b, lightstep, lighttemp, light;
	unsigned char	pix, *psource, *prowdest;

	psource = pbasesource;
	prowdest = prowdestbase;

	for (v=0 ; v<r_numvblocks ; v++)
	{
	// FIXME: make these locals?
	// FIXME: use delta rather than both right and left, like ASM?
		lightleft = r_lightptr[0];
		lightright = r_lightptr[1];
		r_lightptr += r_lightwidth;
		lightleftstep = (r_lightptr[0] - lightleft) >> 1;
		lightrightstep = (r_lightptr[1] - lightright) >> 1;

		for (i=0 ; i<2 ; i++)
		{
			lighttemp = lightleft - lightright;
			lightstep = lighttemp >> 1;

			light = lightright;

			for (b=1; b>=0; b--)
			{
				pix = psource[b];
				prowdest[b] = ((unsigned char *)vid.colormap)
						[(light & 0xFF00) + pix];
				light += lightstep;
			}
	
			psource += sourcetstep;
			lightright += lightrightstep;
			lightleft += lightleftstep;
			prowdest += surfrowbytes;
		}

		if (psource >= r_sourcemax)
			psource -= r_stepback;
	}
}

#endif

 
