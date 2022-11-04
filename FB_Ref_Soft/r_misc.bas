'FINISHED/////////////////////////////////////////////////////////


#Include "FB_Ref_Soft\r_local.bi"

#define NUM_MIPS	4

dim shared as cvar_t	ptr sw_mipcap
dim shared as cvar_t	ptr sw_mipscale 

dim shared as surfcache_t		ptr d_initial_rover 
dim shared as qboolean		d_roverwrapped 
dim shared as integer	   d_minmip 
dim shared as float			d_scalemip(NUM_MIPS-1)

extern "C"
extern alias_colormap as ubyte ptr 
end extern

 
 extern as integer			d_aflatcolor
 
 
 static shared as float	basemip(NUM_MIPS-1) => {1.0, 0.5*0.8, 0.25*0.8} 
 
 type _TargaHeader  
 	
   as ubyte 	id_length, colormap_type, image_type 
 	as ushort	colormap_index, colormap_length 
 	as ubyte	colormap_size 
   as ushort	x_origin, y_origin, width, height 
 	as ubyte	pixel_size, attributes 
 
 	
 End type:  type TargaHeader as _TargaHeader
 
dim shared as Integer	d_pix_min, d_pix_max, d_pix_shift 
 
 dim shared as integer	d_scantable(MAXHEIGHT)
 dim shared as short	ptr zspantable(MAXHEIGHT)  
 
 
 
dim shared	as integer d_vrectx, d_vrecty, d_vrectright_particle, d_vrectbottom_particle 


/'
================
D_Patch
================
'/


#if id386

extern "C"
declare sub D_Aff8Patch()
declare sub D_PolysetAff8Start()
end extern

#endif	
	
sub D_Patch ()
 
#if id386
	
	static as qboolean protectset8 = false 


	if ( protectset8 = null) then
 	
		Sys_MakeCodeWriteable (cast(integer,@D_PolysetAff8Start()), _
						     cast(integer,@D_Aff8Patch()) - cast(integer,@D_PolysetAff8Start())) 
		Sys_MakeCodeWriteable (cast(long,@R_Surf8Start()), _
						 cast(long,@R_Surf8End()) - cast(long,@R_Surf8Start())) 
		protectset8 = true 
	end if
	colormap = vid.colormap 

	 R_Surf8Patch () 
	 D_Aff8Patch() 
#endif
end sub

/'
================
D_ViewChanged
================
'/
dim shared as ubyte  ptr alias_colormap 

sub D_ViewChanged ()
	
 
	dim as integer		i 

	 scale_for_mip = xscale 
	 if (yscale > xscale) then
	 	scale_for_mip = yscale
	 EndIf
 

	 d_zrowbytes = vid._width * 2 
	 d_zwidth = vid._width 

  d_pix_min = r_refdef.vrect._width / 32 
	 if (d_pix_min < 1) then
	 	d_pix_min = 1
	 EndIf
	 

	 d_pix_max = cast(integer,(cast(float,r_refdef.vrect._width) / (320.0 / 4.0) + 0.5)) 
	 d_pix_shift = 8 - cast(integer,cast(float,r_refdef.vrect._width) / 320.0 + 0.5) 
	'if (d_pix_max < 1)
	'	d_pix_max = 1;

	 d_vrectx = r_refdef.vrect.x 
	 d_vrecty = r_refdef.vrect.y 
	 d_vrectright_particle = r_refdef.vrectright - d_pix_max 
	 d_vrectbottom_particle = _
	 		r_refdef.vrectbottom - d_pix_max 

	 for  i=0  to vid._height-1 
 
 		d_scantable(i) = i*r_screenwidth 
	 	zspantable(i) = d_pzbuffer + i*d_zwidth 
	next

	/'
	** clear Z-buffer and color-buffers if we're doing the gallery
	'/
	if ( r_newrefdef.rdflags and RDF_NOWORLDMODEL ) then
	memset( d_pzbuffer, &Hff, vid._width * vid._height * sizeof( d_pzbuffer[0] ) ) 
	Draw_Fill( r_newrefdef.x, r_newrefdef.y, r_newrefdef._width, r_newrefdef._height,cast( integer, sw_clearcolor->value ) and &Hff ) 

	EndIf
 
	alias_colormap = vid.colormap 

	D_Patch () 
	
End Sub























 
 
sub R_PrintTimes  ()
	dim as integer		r_time2 
	dim  as integer		ms 

	r_time2 = Sys_Milliseconds () 

	ms = r_time2 - r_time1 
	
	ri.Con_Printf (PRINT_ALL,!"%5i ms %3i/%3i/%3i poly %3i surf\n", _
				ms, c_faceclip, r_polycount, r_drawnpolycount, c_surf) 
	c_surf = 0 
End Sub

sub R_PrintDSpeeds
		dim as integer	ms, dp_time, r_time2, rw_time, db_time, se_time, de_time, da_time 

	r_time2 = Sys_Milliseconds () 

	da_time = (da_time2 - da_time1) 
	dp_time = (dp_time2 - dp_time1) 
	rw_time = (rw_time2 - rw_time1) 
	db_time = (db_time2 - db_time1) 
	se_time = (se_time2 - se_time1) 
	de_time = (de_time2 - de_time1) 
	ms = (r_time2 - r_time1) 

	ri.Con_Printf (PRINT_ALL,"%3i %2ip %2iw %2ib %2is %2ie %2ia\n", _
				ms, dp_time, rw_time, db_time, se_time, de_time, da_time) 
End Sub



/'
=============
R_PrintAliasStats
=============
'/
sub R_PrintAliasStats ()
 
	ri.Con_Printf (PRINT_ALL,!"%3i polygon model drawn\n", r_amodels_drawn) 
end sub


 sub R_TransformFrustum ()
   dim as integer		i 
	dim as vec3_t	v, v2 
	
	for  i=0 to  4 -1
	
	   v.v(0) = screenedge(i).normal.v(2) 
		v.v(1) = -screenedge(i).normal.v(0) 
		v.v(2) = screenedge(i).normal.v(1) 

		v2.v(0) = v.v(1)*vright.v(0) + v.v(2)*vup.v(0) + v.v(0)*vpn.v(0) 
		v2.v(1) = v.v(1)*vright.v(1) + v.v(2)*vup.v(1) + v.v(0)*vpn.v(1) 
		v2.v(2) = v.v(1)*vright.v(2) + v.v(2)*vup.v(2) + v.v(0)*vpn.v(2) 
		_VectorCopy (@v2, @view_clipplanes(i).normal) 

		view_clipplanes(i).dist = _DotProduct (@modelorg, @v2) 
	
	Next
 

	 
 End Sub







'#if !(defined __linux__ && defined __i386__)
 #ifndef  id386
'
 /'
'================
'TransformVector
'================
'/
 sub TransformVector (_in as vec3_t ptr ,  _out as vec3_t ptr)
 	
 	 _out->v(0) = DotProduct(_in,@vright) 
	 _out->v(1) = DotProduct(_in,@vup) 
    _out->v(2) = DotProduct(_in,@vpn) 	
 End Sub
  
	
 
'
 #else
 
 
'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''
sub TransformVector naked (vin as  vec3_t ptr ,vout as vec3_t ptr)
 asm
 	
 	   .intel_syntax noprefix
 	   
	 mov eax, dword ptr [esp+4]
	 mov edx, dword ptr [esp+8]

	 fld  dword ptr [eax+0]
	 fmul dword ptr [vright+0]
	 fld  dword ptr [eax+0]
	 fmul dword ptr [vup+0]
	 fld  dword ptr [eax+0]
	 fmul dword ptr [vpn+0]

	 fld  dword ptr [eax+4]
	 fmul dword ptr [vright+4]
	 fld  dword ptr [eax+4]
	 fmul dword ptr [vup+4]
	 fld  dword ptr [eax+4]
	 fmul dword ptr [vpn+4]

	 fxch st(2)

	 faddp st(5), st(0)
	 faddp st(3), st(0)
	 faddp st(1), st(0)

	 fld  dword ptr [eax+8]
	 fmul dword ptr [vright+8]
	 fld  dword ptr [eax+8]
	 fmul dword ptr [vup+8]
	 fld  dword ptr [eax+8]
	 fmul dword ptr [vpn+8]

	 fxch st(2)

	 faddp st(5), st(0)
	 faddp st(3), st(0)
	 faddp st(1), st(0)

	 fstp dword ptr [edx+8]
	 fstp dword ptr [edx+4]
	 fstp dword ptr [edx+0]

	 ret
 end asm
end sub

#endif
'#endif



/'
================
R_TransformPlane
================
'/
sub R_TransformPlane (p as mplane_t ptr,normal as float ptr,dist as float ptr)
 
	dim as float	d 
	
	d = _DotProduct (@r_origin, @p->normal) 
	*dist = p->dist - d 
'// TODO: when we have rotating entities, this will need to use the view matrix
	TransformVector (@p->normal, @normal) 
end sub


/'
===============
R_SetUpFrustumIndexes
===============
'/
sub R_SetUpFrustumIndexes ()
 
	dim as integer		i, j  
   dim as integer ptr pindex  
   
	pindex = @r_frustum_indexes(0) 
 
	 for i = 0 to 4-1
	 	
	 	
	 	
	 
		for j=0 to 3-1 
 
			if  view_clipplanes(i).normal.v(j) < 0  then
		 
				pindex[j] = j 
				pindex[j+3] = j+3 
			 
			else
			 
				pindex[j] = j+3 
				pindex[j+3] = j 
			end if
	 Next

	'// FIXME: do just once at start
		pfrustum_indexes(i) = pindex 
		pindex += 6 
	next
end sub








/'
===============
R_ViewChanged

Called every time the vid structure or r_refdef changes.
Guaranteed to be called before the first refresh
===============
'/
sub R_ViewChanged (vr as vrect_t ptr)
 
	dim as integer		i 

	r_refdef.vrect = *vr 

	r_refdef.horizontalFieldOfView = 2*tan(cast(float,r_newrefdef.fov_x)/360*M_PI) 
	verticalFieldOfView = 2*tan(cast(float,r_newrefdef.fov_y)/360*M_PI) 

	r_refdef.fvrectx = cast(float,r_refdef.vrect.x) 
	r_refdef.fvrectx_adj = cast(float,r_refdef.vrect.x) - 0.5 
	r_refdef.vrect_x_adj_shift20 = (r_refdef.vrect.x shl 20) + (1 shl 19) - 1 
	r_refdef.fvrecty = cast(float,r_refdef.vrect.y) 
	r_refdef.fvrecty_adj = cast(float,r_refdef.vrect.y - 0.5) 
	r_refdef.vrectright = r_refdef.vrect.x + r_refdef.vrect._width 
 	r_refdef.vrectright_adj_shift20 = (r_refdef.vrectright shl 20) + (1 shl 19) - 1 
 	r_refdef.fvrectright = cast(float,r_refdef.vrectright)
 	r_refdef.fvrectright_adj = cast(float,r_refdef.vrectright) - 0.5 
 	r_refdef.vrectrightedge =  cast(float,r_refdef.vrectright) - 0.99 
 	r_refdef.vrectbottom = r_refdef.vrect.y + r_refdef.vrect._height 
 	r_refdef.fvrectbottom = cast(float,r_refdef.vrectbottom) 
 	r_refdef.fvrectbottom_adj = cast(float,r_refdef.vrectbottom) - 0.5 
 
 	r_refdef.aliasvrect.x = cast(integer,(r_refdef.vrect.x * r_aliasuvscale)) 
 	r_refdef.aliasvrect.y = cast(integer,(r_refdef.vrect.y * r_aliasuvscale)) 
 	r_refdef.aliasvrect._width = cast(integer,(r_refdef.vrect._width * r_aliasuvscale)) 
 	r_refdef.aliasvrect._height = cast(integer,(r_refdef.vrect._height * r_aliasuvscale)) 
 	r_refdef.aliasvrectright = r_refdef.aliasvrect.x + _ _
 			r_refdef.aliasvrect._width 
 	r_refdef.aliasvrectbottom = r_refdef.aliasvrect.y + _
 			r_refdef.aliasvrect._height 
 
 	xOrigin = r_refdef.xOrigin 
 	yOrigin = r_refdef.yOrigin 
'	
''// values for perspective projection
''// if math were exact, the values would range from 0.5 to to range+0.5
''// hopefully they wll be in the 0.000001 to range+.999999 and truncate
''// the polygon rasterization will never render in the first row or column
''// but will definately render in the [range) row and column, so adjust the
''// buffer origin to get an exact edge to edge fill
 	xcenter = (cast(float,r_refdef.vrect._width) * XCENTERING) + _
 			r_refdef.vrect.x - 0.5 
 	aliasxcenter = xcenter * r_aliasuvscale 
 	ycenter = (cast(float,r_refdef.vrect._height) * YCENTERING) + _
 			r_refdef.vrect.y - 0.5 
 	aliasycenter = ycenter * r_aliasuvscale 
 
 	xscale = r_refdef.vrect._width / r_refdef.horizontalFieldOfView 
 	aliasxscale = xscale * r_aliasuvscale 
 	xscaleinv = 1.0 / xscale 
 
 	yscale = xscale 
 	aliasyscale = yscale * r_aliasuvscale 
 	yscaleinv = 1.0 / yscale 
 	xscaleshrink = (r_refdef.vrect._width-6)/r_refdef.horizontalFieldOfView 
 	yscaleshrink = xscaleshrink 
'
''// left side clip
 	screenedge (0).normal.v (0) = -1.0 / (xOrigin*r_refdef.horizontalFieldOfView) 
 	screenedge (0).normal.v (1) = 0 
 	screenedge (0).normal.v (2) = 1 
 	screenedge (0)._type = PLANE_ANYZ 
'	
''// right side clip
	screenedge (1).normal.v(0) = _
			1.0 / ((1.0-xOrigin)*r_refdef.horizontalFieldOfView) 
	screenedge (1).normal.v(1) = 0 
	screenedge (1).normal.v(2) = 1  
	screenedge (1)._type = PLANE_ANYZ 
'	
''// top side clip
	screenedge (2).normal.v(0) = 0 
	screenedge (2).normal.v(1) = -1.0 / (yOrigin*verticalFieldOfView) 
	screenedge (2).normal.v(2) = 1 
	screenedge (2)._type = PLANE_ANYZ 
	
''// bottom side clip
 	screenedge (3).normal.v(0) = 0 
 	screenedge (3).normal.v(1) = 1.0 / ((1.0-yOrigin)*verticalFieldOfView) 
 	screenedge (3).normal.v(2) = 1 	
 	screenedge (3)._type = PLANE_ANYZ 
	
	for  i=0 to 4-1
		VectorNormalize (@screenedge(i).normal) 
	next

	D_ViewChanged () 
end sub





sub R_SetupFrame ()
   dim as integer			i 
	dim as vrect_t		vrect 

	if (r_fullbright->modified) then
	 
		r_fullbright->modified = false 
		D_FlushCaches () 	'// so all lighting changes
	end if
	
	r_framecount+=1


'// build the transformation matrix for the given view angles
 	_VectorCopy (@r_refdef.vieworg, @modelorg) 
 	_VectorCopy (@r_refdef.vieworg, @r_origin) 
 
 	AngleVectors (@r_refdef.viewangles, @vpn, @vright, @vup) 
 
'// current viewleaf
 	if ( ( r_newrefdef.rdflags and RDF_NOWORLDMODEL ) = NULL) then
  		r_viewleaf = Mod_PointInLeaf (@r_origin, r_worldmodel) 
 		r_viewcluster = r_viewleaf->cluster 	
 	EndIf
 

 
 
'	if (sw_waterwarp->value && (r_newrefdef.rdflags & RDF_UNDERWATER) )
'		r_dowarp = true;
'	else
'		r_dowarp = false;
'
  	if (r_dowarp) then
    	 '// warp into off screen buffer
 		vrect.x = 0 
 		vrect.y = 0 
 		vrect._width = iif(r_newrefdef._width < WARP_WIDTH, r_newrefdef._width , WARP_WIDTH) 
 		vrect._height = iif(r_newrefdef._height < WARP_HEIGHT , r_newrefdef._height , WARP_HEIGHT) 
 
 		d_viewbuffer = @r_warpbuffer(0) 
 		r_screenwidth = WARP_WIDTH 
 
 	else
 
 		vrect.x = r_newrefdef.x 
 		vrect.y = r_newrefdef.y 
 		vrect._width = r_newrefdef._width 
 		vrect._height = r_newrefdef._height 
'
 		d_viewbuffer = cast(any ptr,vid.buffer) 
 		r_screenwidth = vid.rowbytes 
 	end if
 	
 	R_ViewChanged (@vrect) 
 
'// start off with just the four screen edge clip planes
 	R_TransformFrustum () 
 	R_SetUpFrustumIndexes () 
 
'// save base values
 	_VectorCopy (@vpn, @base_vpn) 
 	_VectorCopy (@vright, @base_vright) 
 	_VectorCopy (@vup, @base_vup) 
 
'// clear frame counts
 	c_faceclip = 0 
 	d_spanpixcount = 0 
 	r_polycount = 0 
 	r_drawnpolycount = 0 
 	r_wholepolycount = 0 
 	r_amodels_drawn = 0 
 	r_outofsurfaces = 0 
 	r_outofedges = 0 
 
'// d_setup
 	d_roverwrapped = _false 
 	d_initial_rover = sc_rover 
 
 	d_minmip = sw_mipcap->value 
 	if (d_minmip > 3) then
 		d_minmip = 3 
 	elseif (d_minmip < 0) then
 		d_minmip = 0 
   end if
 
   for i = 0 to (NUM_MIPS-1)-1
 
   	d_scalemip(i) = basemip(i) * sw_mipscale->value
   Next


 	d_aflatcolor = 0 
	
End Sub




#if	 id386

/'
================
R_SurfacePatch
================
'/
sub R_SurfacePatch ()
	'// we only patch code on Intel
End Sub
 
#endif	'// !id386





/' 
============================================================================== 
 
						SCREEN SHOTS 
 
============================================================================== 
'/ 


/' 
============== 
WritePCXfile 
============== 
'/ 
sub WritePCXfile (filename as zstring ptr,_data as ubyte ptr,_width as integer ,_height as integer , _
	rowbytes as integer , _palette as ubyte ptr ) 

 '// pack the image
 
	dim as integer			i, j, length 
	dim as pcx_t	ptr	 pcx 
	dim as ubyte	ptr	 pack 
	dim as FILE	ptr f 

	pcx = cast(pcx_t ptr,malloc (_width*_height*2+1000) )
	if ( pcx = null) then
		return
	EndIf
	

	pcx->manufacturer = &H0a 	'// PCX id
	pcx->version = 5 			'// 256 color
 	pcx->_encoding = 1 		'// uncompressed
	pcx->bits_per_pixel = 8 		'// 256 color
	pcx->xmin = 0 
	pcx->ymin = 0 
	pcx->xmax = LittleShort(cast(short,_width-1)) 
	pcx->ymax = LittleShort(cast(short,_height-1)) 
	pcx->hres = LittleShort(cast(short,_width))
	pcx->vres = LittleShort(cast(short,_height)) 
	memset (@pcx->_palette(0),0,sizeof(pcx->_palette(0))*ubound(pcx->_palette))
	pcx->color_planes = 1 		'// chunky image
	pcx->bytes_per_line = LittleShort(cast(short,_width))
	pcx->palette_type = LittleShort(2) 		'// not a grey scale
	memset (@pcx->filler(0),0,sizeof(pcx->filler)) 

	pack = @pcx->_data 
	
 	for  i=0 to _height-1 
 			for  j=0  to _width -1
 	    if ( (*_data and &Hc0) <> &Hc0) then
 				*pack  = *_data 
 				pack +=1
 			_data+=1 
 			else
 
 				*pack  = &Hc1 
 				pack+=1
 				*pack = *_data 
 				_data+=1 
 				pack+=1
 	 
 		 
 			end if
 				
 				
 			Next
 			_data += rowbytes - _width
 	Next
 
 
 			
'// write the palette
 	*pack  = &H0c 	'// palette ID byte
 	pack+=1
 	for  i=0 to  768 - 1 
 		
 		*pack  = *_palette 
 		pack+=1  
 	  _palette+=1
 		
 	Next
 		
 		 
 		
'// write output file 
 	length = pack - cast(ubyte ptr, pcx) 
 	f = fopen (filename, "wb") 
 	if (f = null) then
  		ri.Con_Printf (PRINT_ALL, !"Failed to open to %s\n", filename) 
 	else
 		fwrite (cast(any ptr,pcx), 1, length, f) 
 		fclose (f) 
 	end if

	free (pcx) 
end sub  
 






sub R_ScreenShot_f()
	dim as integer			i  
	dim as zstring * 80		pcxname  
	dim as zstring * MAX_OSPATH 	checkname  
	dim as FILE	ptr f 
	dim as ubyte		_palette(768) 

	'// create the scrnshots directory if it doesn't exist
	Com_sprintf (checkname, sizeof(checkname), "%s/scrnshot", ri.FS_Gamedir()) 
	Sys_Mkdir (checkname) 

'// 
'// find a file name to save it to 
'// 

	strcpy(pcxname,"FB_quake2_00.pcx") 
		
	for i = 0 to 99 
	 
		pcxname[10] = floor(i/10) + asc("0")
		pcxname[11] = i mod 10 + asc("0") 
		Com_sprintf (checkname, sizeof(checkname), "%s/scrnshot/%s", ri.FS_Gamedir(), pcxname) 
		f = fopen (checkname, "r") 
		if (f = null) then
			exit for 	'// file doesn't exist
		end if
		fclose (f) 
	next
	if (i = 100) then 
 
		ri.Con_Printf (PRINT_ALL, "R_ScreenShot_f: Couldn't create a PCX") 
		return 
	end if

	'// turn the current 32 bit palette into a 24 bit palette
	for i=0 to 256 -1
		_palette(i*3+0) = sw_state.currentpalette(i*4+0)
		_palette(i*3+1) = sw_state.currentpalette(i*4+1)
		_palette(i*3+2) = sw_state.currentpalette(i*4+2) 
	next
'// 
'// save the pcx file 

	 WritePCXfile (checkname, vid.buffer, vid._width, vid._height, vid.rowbytes, _
	 			 @_palette(0)) 
 
	ri.Con_Printf (PRINT_ALL, !"Wrote %s\n", checkname) 
	
	
End Sub





''sub	GL_ImageList_f ()
'	'dim i  as integer		
'	'dim _image as	image_t	ptr  
'	'dim texels  as integer		
'	'dim  palstrings(2) as const zstring ptr => _
'	'{ _
''		@"RGB", _
'	'	@"PAL" _
'	'} 
'	'
'		'ri.Con_Printf (PRINT_ALL, "------------------\n") 
''	texels = 0 
'
'	
'	'for (i=0, image=gltextures ; i<numgltextures ; i++, image++)
' 
'   ' for i = 0 to numgltextures-1
'   ' 	
'   ' 	
' 
'   '  
'	'	if (_image->texnum <= 0) then
'	'		continue for
'	'	end if	
'	'		
'	'	texels += _image->upload_width*_image->upload_height 
'	'	select case (_image->_type)
'	'				case it_skin 
'	'		'ri.Con_Printf (PRINT_ALL, "M") 
'	'	 
'	'	case it_sprite 
'	'		'ri.Con_Printf (PRINT_ALL, "S") 
'	'	 
'	'	case it_wall 
'	'		'ri.Con_Printf (PRINT_ALL, "W") 
'	'		 
'	'	case it_pic 
'	'		'ri.Con_Printf (PRINT_ALL, "P") 
'	'	 
'	'	default:
'	'		'ri.Con_Printf (PRINT_ALL, " ") 
'	'	 
'	'		
'	'		
'	'	End Select
'	' 'ri.Con_Printf (PRINT_ALL,  " %3i %3i %s: %s\n", _
'	''		_image->upload_width, _image->upload_height, palstrings(_image->paletted), _image->_name)
'	'
'	'_image+=1
'   ' next
'	' 
'
'		 
'	 
'	'ri.Con_Printf (PRINT_ALL, "Total texel count (not counting mipmaps): %i\n", texels) 
'	
'	
'	 
'	 
'	
'End Sub