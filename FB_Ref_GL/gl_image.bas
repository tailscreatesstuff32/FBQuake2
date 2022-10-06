 


' WORK IN PROGRESS''''''''''''''''''''''''''''''''''''

#Include "gl_local.bi"

dim shared ri as refimport_t

 dim shared gl_config as glconfig_t
 dim shared gl_state as  glstate_t  
 
dim shared gl_nobind as cvar_t	ptr

dim shared gltextures(MAX_GLTEXTURES) as image_t

dim shared numgltextures as integer
dim shared base_textureid as integer

 dim shared r_notexture as image_t ptr	
 dim shared r_particletexture as image_t ptr	
dim as integer GL_TEXTURE0, GL_TEXTURE1

 dim shared  intensity  as cvar_t ptr		

static shared intensitytable(256) as ubyte	
static shared gammatable(256) as ubyte

 
 extern _screenwidth as Integer
extern _screenheight as Integer


#define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CUInt( c )        And 255 )
#define RGBA_A( c ) ( CUInt( c ) Shr 24         )


dim shared d_8to24table(256) as uinteger 


declare function GL_Upload8 (_data as ubyte ptr,_width as integer ,_height as integer , mipmap as qboolean ,is_sky as qboolean  ) as qboolean 'WORKS FINE FOR NOW''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


declare function GL_Upload32 (_data as uinteger ptr,_width as integer, _height as integer,  mipmap as qboolean) as qboolean 



 dim shared    gl_solid_format as integer = 3 
 dim shared 	gl_alpha_format as integer = 4 

 dim shared 	   gl_tex_solid_format as integer = 3 
 dim shared 		gl_tex_alpha_format as integer = 4 

 dim shared 		gl_filter_min as integer = GL_LINEAR_MIPMAP_NEAREST 
 dim shared 		gl_filter_max  as integer = GL_LINEAR 

dim shared r_norefresh as cvar_t ptr
dim shared r_drawentities as cvar_t ptr
dim shared r_drawworld as cvar_t ptr
dim shared r_speeds as cvar_t ptr
dim shared r_fullbright as cvar_t ptr
dim shared r_novis as cvar_t ptr
dim shared r_nocull as cvar_t ptr
dim shared r_lerpmodels as cvar_t ptr
dim shared  r_lefthand as cvar_t ptr

dim shared  r_lightlevel as cvar_t ptr

dim shared  gl_nosubimage as cvar_t ptr
dim shared  gl_allow_software as cvar_t ptr

dim shared  gl_vertex_arrays as cvar_t ptr

dim shared  gl_partiprintcle_min_size as cvar_t ptr
dim shared  gl_particle_max_size as cvar_t ptr
dim shared  gl_particle_size as cvar_t ptr
dim shared  gl_particle_att_a as cvar_t ptr
dim shared  gl_particle_att_b as cvar_t ptr
dim shared  gl_particle_att_c as cvar_t ptr

dim shared gl_ext_swapinterval as cvar_t ptr
dim shared gl_ext_palettedtexture as cvar_t ptr
dim shared gl_ext_multitexture as cvar_t ptr
dim shared gl_ext_pointparameters as cvar_t ptr
dim shared gl_ext_compiled_vertex_array as cvar_t ptr

dim shared gl_log as cvar_t ptr
dim shared gl_bitdepth as cvar_t ptr
dim shared gl_drawbuffer as cvar_t ptr
dim shared gl_driver as cvar_t ptr
dim shared gl_lightmap as cvar_t ptr
dim shared gl_shadows as cvar_t ptr
dim shared gl_mode as cvar_t ptr
dim shared gl_dynamic as cvar_t ptr
dim shared gl_monolightmap as cvar_t ptr
dim shared _gl_modulate as cvar_t ptr
dim shared gl_round_down as cvar_t ptr
dim shared gl_picmip as cvar_t ptr	
dim shared gl_skymip as cvar_t ptr
dim shared gl_showtris as cvar_t ptr	
dim shared gl_ztrick as cvar_t ptr	
dim shared gl_finish as cvar_t ptr	
dim shared _gl_clear as cvar_t ptr
dim shared gl_cull as cvar_t ptr
dim shared gl_polyblend as cvar_t ptr
dim shared gl_flashblend as cvar_t ptr
dim shared gl_playermip as cvar_t ptr

dim shared gl_saturatelighting as cvar_t ptr
dim shared gl_swapinterval as cvar_t ptr
dim shared _gl_texturemode as cvar_t ptr
dim shared _gl_texturealphamode as cvar_t ptr
dim shared _gl_texturesolidmode as cvar_t ptr
dim shared gl_lockpvs as cvar_t ptr


dim shared gl_3dlabs_broken as cvar_t ptr

dim shared vid_fullscreen as cvar_t ptr
dim shared vid_gamma as cvar_t ptr
dim shared vid_ref as cvar_t ptr

sub _test( t1 as integer,  t2 as Integer,  t3 as Integer,  t4 as Integer, t5 as Integer, t6 as const any ptr)
	
End Sub
 
dim shared   qglColorTableEXT as sub(as integer,as integer,as integer,as integer,as integer,as  const any ptr ) 


qglColorTableEXT =  (cast(sub( as integer,  as Integer,  as Integer,  as Integer,  as Integer, as const any ptr ),@_test) )


sub GL_SetTexturePalette( _palette() as uinteger )
	
	dim i as integer  
   dim temptable(768) as integer 

	'if ( qglColorTableEXT and gl_ext_palettedtexture->value ) then
	'		 
	'	for ( i = 0 to 256-1 )
	'	
	'	   temptable(i*3+0) = ( _palette(i) shr 0 ) and &Hff 
	'		temptable(i*3+1) = ( _palette(i) shr 8 ) and &Hff 
	'		
	'	Next
	'	 
	'		
	'	 

	'	qglColorTableEXT( GL_SHARED_TEXTURE_PALETTE_EXT, _
	'					   GL_RGB, _
	'					   256, _
	'					   GL_RGB, _
	'					   GL_UNSIGNED_BYTE, _
	'					   temptable ) 
	'
	'	
	'	
	'	
	'EndIf

	
End Sub
 

	 
 
sub GL_EnableMultitexture(  enable As qboolean )
	'	if (  qglSelectTextureSGIS = null and  qglActiveTextureARB = null ) then
	'	return 
	'EndIf
	'	

	'if ( enable )then
	'	GL_SelectTexture( GL_TEXTURE1  
	'	qglEnable( GL_TEXTURE_2D ) 
	'	GL_TexEnv( GL_REPLACE ) 
	' 
	'else
	' 
	'	GL_SelectTexture( GL_TEXTURE1 ) 
	'	qglDisable( GL_TEXTURE_2D ) 
	'	GL_TexEnv( GL_REPLACE ) 
	'EndIf
	'
	'GL_SelectTexture( GL_TEXTURE0 ) 
	'GL_TexEnv( GL_REPLACE ) 
 
	
End Sub
 




sub GL_SelectTexture(texture as GLenum  )
 
	dim tmu as integer  

	'if (  qglSelectTextureSGIS = NULL and  qglActiveTextureARB = NULL )
	'	return 
  ' end if
  
	if ( texture = GL_TEXTURE0 ) then
		
				tmu = 0 
 
	else
		
		tmu = 1 
	EndIf
	 

 
  
	 if ( tmu = gl_state.currenttmu ) then
	 
	 	return 
	 end if
	 gl_state.currenttmu = tmu 

	'if ( qglSelectTextureSGIS ) then
 
	'	qglSelectTextureSGIS( texture ) 
 
  
	'else if ( qglActiveTextureARB )
	' 
	'	qglActiveTextureARB( texture ) 
	'	qglClientActiveTextureARB( texture ) 
	'end if
end sub


sub GL_TexEnv( _mode as Glenum)
	static  lastmodes(2) as integer => { -1, -1 } 
	if ( _mode <> lastmodes(gl_state.currenttmu) ) then
'		 qglTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, mode ) 
		lastmodes(gl_state.currenttmu) = _mode 
		
		
	EndIf
 
End Sub



    extern draw_chars  as	image_t	ptr
 
 
 	 ' GL_FindImage ("pics/conchars.pcx", it_pic)
 
 
sub GL_Bind ( texnum as integer)
	 
 'gl_nobind->value and
 'if   draw_chars  then
	  '  texnum = draw_chars->texnum 
	 '  end if
 '
	 if ( gl_state.currenttextures(gl_state.currenttmu) = texnum) then
	 	'print"here2"
	 	return 
	 EndIf
	 	
	  'print"here"
	 gl_state.currenttextures(gl_state.currenttmu) = texnum
 
	  'sleep
	 'qglBindTexture (GL_TEXTURE_2D, texnum) 
	
End Sub
 
 sub GL_MBind(_target as GLenum , texnum as integer )
 
 GL_SelectTexture( _target ) 
 if ( _target = GL_TEXTURE0 ) then
 
 		if ( gl_state.currenttextures(0) = texnum ) then
 		  return 
      EndIf
 	else
 
 		if ( gl_state.currenttextures(1) = texnum ) then
 		return 	
 			
 		EndIf
 		EndIf
 			
 		
 		
   	GL_Bind( texnum ) 
 
 	
 	
 End Sub



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

type glmode_t
	_name as zstring ptr
	as integer	minimize, maximize 
 
	
	
End Type
 	
 	
 dim shared _modes(6) as glmode_t=> {_  
	(@"GL_NEAREST", GL_NEAREST, GL_NEAREST), _
	 (@"GL_LINEAR", GL_LINEAR, GL_LINEAR) , _
	 (@"GL_NEAREST_MIPMAP_NEAREST", GL_NEAREST_MIPMAP_NEAREST, GL_NEAREST) , _
	 (@"GL_LINEAR_MIPMAP_NEAREST", GL_LINEAR_MIPMAP_NEAREST, GL_LINEAR) , _
	 (@"GL_NEAREST_MIPMAP_LINEAR", GL_NEAREST_MIPMAP_LINEAR, GL_NEAREST) , _
	 (@"GL_LINEAR_MIPMAP_LINEAR", GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR) _
} 


#define NUM_GL_MODES ((ubound(_modes)*sizeof(glmode_t)  / sizeof (glmode_t)))
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

type gltmode_t
	
	  _name as  zstring ptr
	_mode as integer
	
End Type  
 


  dim shared gl_alpha_modes(6) as gltmode_t=> {_  
	(@"default", 4), _
	 (@"GL_RGBA", GL_RGBA) , _
	 (@"GL_RGBA8", GL_RGBA) , _
	 (@"GL_RGB5_A1", GL_RGB5_A1) , _
	 (@"GL_RGBA4", GL_RGBA4) , _
	 (@"GL_RGBA2", GL_RGBA2) _
} 

#define NUM_GL_ALPHA_MODES ((ubound(gl_alpha_modes)*sizeof(gltmode_t)  / sizeof (gltmode_t)))
 	



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
#ifdef GL_RGB2_EXT

dim shared  gl_solid_modes(7) as gltmode_t => { _
		(@"default , 3) , _
	   (@"GL_RGB", GL_RGB), __
	   (@"GL_RGB8", GL_RGB8), _
	   (@"GL_RGB5", GL_RGB5), _
	   (@"GL_RGB4", GL_RGB4), _
	   (@"GL_R3_G3_B2", GL_R3_G3_B2),  _
	   (@"GL_RGB2" , GL_RGB2_EXT)  _
 
}  

#else

dim shared  gl_solid_modes(6) as gltmode_t => { _
		(@"GL_RGB" , 3) , _
	   (@"GL_RGB", GL_RGB), _
	   (@"GL_RGB8", GL_RGB8), _
	   (@"GL_RGB5", GL_RGB5), _
	   (@"GL_RGB4", GL_RGB4), _
	   (@"GL_R3_G3_B2", GL_R3_G3_B2)   _ 	   
}  

#endif



#define NUM_GL_SOLID_MODES ((ubound(gl_solid_modes)*sizeof(gltmode_t)  / sizeof (gltmode_t)))
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

sub GL_TextureMode(  _string as ZString ptr )
	dim i as	integer
	dim glt  as image_t	ptr

	
	
	
		for  i=0  to NUM_GL_MODES -1
 
		if ( Q_stricmp( _modes(i)._name,_string ) = 0 ) then 
						exit for
			
		EndIf
		
		
		Next
			
			
	if (i = NUM_GL_MODES) then
			 'ri.Con_Printf (PRINT_ALL, "bad filter name\n");
			 
			 Printf (!"bad filter name\n")
			 
		return 
	 
	EndIf
	 
	
   'printf(!"%s",  _modes(i)._name)
   
	gl_filter_min = _modes(i).minimize 
	gl_filter_max = _modes(i).maximize 
	'// change all the existing mipmap texture objects
	
	
	'for (i=0, glt=gltextures ; i<numgltextures ; i++, glt++)
	'{
'		if (glt->type != it_pic && glt->type != it_sky )
	'	{
	'		GL_Bind (glt->texnum);
	'		qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_min);
	'		qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max);
	'	}
	'}
	
End Sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 

sub GL_TextureAlphaMode(  _string as ZString ptr )
	
		dim i as Integer
		
		
			
			
		for  i=0  to NUM_GL_ALPHA_MODES-1
 
		if ( Q_stricmp( gl_alpha_modes(i)._name, _string )  = 0 )then 
						exit for
			
		EndIf
		
		
		Next
				
			
				if (i = NUM_GL_ALPHA_MODES) then
			   'ri.Con_Printf (PRINT_ALL, "bad alpha texture mode name\n") 
			 
			 Printf (!"bad alpha texture mode name\n")
			 
		return 
	 
	EndIf
	 
   printf(!"%s", *gl_alpha_modes(i)._name)
	gl_tex_alpha_format = gl_alpha_modes(i)._mode 
	
	
End Sub


 

 sub GL_TextureSolidMode(  _string as ZString ptr )
	
 
 
	
	
	dim i as Integer
		
 	
		for  i=0  to NUM_GL_SOLID_MODES-1
 
		if ( Q_stricmp( gl_solid_modes(i)._name, _string )  = 0 )then 
						exit for
			
		EndIf
		
		
		Next
			
	if (i =  NUM_GL_SOLID_MODES) then
		'ri.Con_Printf (PRINT_ALL, "bad solid texture mode name\n") 
		
		Printf (!"bad solid texture mode name\n")
		return 
 
	EndIf
	
	
	' printf(!"%s",  gl_solid_modes(i)._name)
   
 
end sub		



sub	GL_ImageList_f ()
	dim i  as integer		
	dim _image as	image_t	ptr  
	dim texels  as integer		
	dim  palstrings(2) as const zstring ptr => _
	{ _
		@"RGB", _
		@"PAL" _
	} 
	
		'ri.Con_Printf (PRINT_ALL, "------------------\n") 
	texels = 0 

	
	'for (i=0, image=gltextures ; i<numgltextures ; i++, image++)
 
    for i = 0 to numgltextures-1
    	
    	
 
     
		if (_image->texnum <= 0) then
			continue for
		end if	
			
		texels += _image->upload_width*_image->upload_height 
		select case (_image->_type)
					case it_skin 
			'ri.Con_Printf (PRINT_ALL, "M") 
		 
		case it_sprite 
			'ri.Con_Printf (PRINT_ALL, "S") 
		 
		case it_wall 
			'ri.Con_Printf (PRINT_ALL, "W") 
			 
		case it_pic 
			'ri.Con_Printf (PRINT_ALL, "P") 
		 
		default:
			'ri.Con_Printf (PRINT_ALL, " ") 
		 
			
			
		End Select
	 'ri.Con_Printf (PRINT_ALL,  " %3i %3i %s: %s\n", _
	'		_image->upload_width, _image->upload_height, palstrings(_image->paletted), _image->_name)
	
	_image+=1
    next
	 

		 
	 
	'ri.Con_Printf (PRINT_ALL, "Total texel count (not counting mipmaps): %i\n", texels) 
	
	
	 
	 
	
End Sub


	
dim shared scrap_uploads as integer




'
'/*
'=============================================================================
'
'  scrap allocation
'
'  Allocate all the little status bar obejcts into a single texture
'  to crutch up inefficient hardware / drivers
'
'=============================================================================
'*/

#define	MAX_SCRAPS		1
#define	BLOCK_WIDTH		256
#define	BLOCK_HEIGHT	256





dim shared scrap_allocated(MAX_SCRAPS,BLOCK_WIDTH) as integer	
dim shared scrap_texels(MAX_SCRAPS,BLOCK_WIDTH*BLOCK_HEIGHT) as ubyte
dim shared scrap_dirty as qboolean


'// returns a texture number and the position inside it
function  Scrap_AllocBlock ( w as integer,   h as integer,  x as integer ptr, y as integer ptr) as integer
dim	as integer		i, j 
dim	as integer 		best, best2 
dim texnum  as integer	

	for  texnum=0 to MAX_SCRAPS-1 
	 
		best = BLOCK_HEIGHT 

		for  i = 0 to(BLOCK_WIDTH-w)-1 
 
			 best2 = 0 

			 for  j=0 to w-1  
			 
			 	if (scrap_allocated(texnum,i+j) >= best) then
			    exit for 
			 	end if
			 if (scrap_allocated(texnum,i+j) > best2) then
			 	best2 = scrap_allocated(texnum,i+j)
			 	end if
			 next
			 if (j  = w) then
			 	'	// this is a valid spot
			 	*x = i 
			 	*y = best = best2 
			  
			 EndIf
		next	 


		if (best + h > BLOCK_HEIGHT) then
			continue for
		EndIf
			

		for i=0 to  w - 1 
			scrap_allocated(texnum,*x + i) = best + h 

		return texnum 
	  next
next
	return -1 
'//	Sys_Error ("Scrap_AllocBlock: full") 
end function


sub Scrap_Upload ()
	scrap_uploads+=1 
	GL_Bind(TEXNUM_SCRAPS) 
'	GL_Upload8 (scrap_texels(0), BLOCK_WIDTH, BLOCK_HEIGHT, _false, _false ) 
	scrap_dirty = _false 
	
End Sub





'/*
'=================================================================
'
'PCX LOADING
'
'=================================================================
'*/
'
'
'/*
'==============
'LoadPCX
'==============
'*/

'WORKING SO FAR


sub	LoadPCX (filename as ZString ptr, _pic as ubyte ptr ptr, _palette as ubyte ptr ptr ,_width as integer ptr, _height as integer ptr)
	

	
   dim raw as ubyte ptr
    
	 dim  pcx  as pcx_t ptr
	 dim as Integer x, y 
	 dim _len as integer		
	 dim as integer		dataByte, runLength 
	 dim as ubyte ptr	 _out,  pix 

	*_pic = NULL 
	*_palette = NULL 
	
	
	

	
	'//
	'// load the file
	'//
	_len = ri.FS_LoadFile (filename, cast(any ptr ptr,@raw))
		 
  
	 'print _len 
	 if ( raw = NULL) then
			'ri.Con_Printf (PRINT_DEVELOPER, "Bad pcx file %s\n", filename) 
			'printf("Bad pcx file %s\n", filename)
			'print "Bad pcx file " + *filename
			 printf (!"Bad pcx file %s\n", filename)
			 print    "Bad pcx file " & filename
		return 
		
	 EndIf
	' sleep
	    'printf ("Characters: %c %c \n", 'a', 65);

	 
	 
	 pcx = cast(pcx_t ptr,raw )
	 ''	// parse the PCX file
'	'//
' 	
'
     pcx->xmin = LittleShort(pcx->xmin) 
     pcx->ymin = LittleShort(pcx->ymin) 
     pcx->xmax = LittleShort(pcx->xmax)  
     pcx->ymax = LittleShort(pcx->ymax) 
     pcx->hres = LittleShort(pcx->hres) 
     pcx->vres = LittleShort(pcx->vres) 
     pcx->bytes_per_line = LittleShort(pcx->bytes_per_line) 
     pcx->palette_type = LittleShort(pcx->palette_type) 

	'  print pcx->manufacturer
	'  print pcx->Version
	'  print pcx->_encoding
	'  print pcx->bits_per_pixel
   'print pcx->xmin 
   'print  pcx->ymin 
   'print pcx->xmax
   'print pcx->ymax
   'print pcx->hres
   'print pcx->vres
   'print "16 color palette 48 bytes"
   'print pcx->reserved
   'print pcx->color_planes
   'print pcx->bytes_per_line
   'print pcx->palette_type
 
   
 

	raw = @pcx->_data 
' 
 	if (pcx->manufacturer <> &H0a _
 		or pcx->version <> 5 _
 		or pcx->_encoding <> 1 _
 		or pcx->bits_per_pixel <> 8 _
 		or pcx->xmax >= 640 _
 		or pcx->ymax >= 480) _
 	 then  
'		ri.Con_Printf (PRINT_ALL, "Bad pcx file %s\n", filename) 


print "Bad pcx file " + *filename
 
 		return 
 	
 	end if  
 	
 	
 
 	
 
  	_out = malloc ( (pcx->ymax+1) * (pcx->xmax+1) ) 
 
  *_pic = _out
 
 	pix = _out
 
  	if (_palette <> NULL) then
 		 
 	    *_palette = malloc(768) 
   	 memcpy (*_palette, cast(ubyte ptr,pcx) + _len - 768, 768) 
 	 
 		
 	EndIf
 
 
 'sleep
 
   'if _width is NOT null
 	 if (_width) then
 	 	*_width = pcx->xmax+1:end if 
 	 	
 
 	 	
 	 	
  'if _height is NOT null	 
  if (_height) then
  	 	*_height = pcx->ymax+1:end if 
 	
 	'print pcx->ymax
 	'sleep 	
   
  y=0:do while y <= pcx->ymax
  	
 
   
  x=0:do while x <= pcx->xmax
  	
  	
  		dataByte = *raw:raw+=1
  		
  		if (databyte and &HC0) = &HC0 then
  			runlength = databyte and &H3F
  			databyte = *raw:raw+=1
 
  	     else
  	     		runlength = 1
  	     EndIf
  	     
  	     
  	     
  	     while runlength > 0
  	     	runlength-=1
  	     	 	pix[x] = databyte: x+=1
  	  
  	     Wend
  	
  	
  	
  	
   loop
     y+=1
  	pix += pcx->xmax+1
  Loop
    
 
	 if ( raw - cast(ubyte ptr,pcx) > _len) then
		
 
		ri.Con_Printf (PRINT_DEVELOPER, "PCX file %s was malformed", filename) 
		print "PCX file " & filename & " was malformed" 
		free (*_pic) 
		*_pic = NULL	   

		
	EndIf
 
	ri.FS_FreeFile (pcx) 
 

 
	
End Sub 

'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'=========================================================
'
'TARGA LOADING
'
'=========================================================
'*/

type _TargaHeader 
	as ubyte 	id_length, colormap_type, image_type 
	as ushort	colormap_index, colormap_length 
	as ubyte 	colormap_size 
	as ushort	x_origin, y_origin, _width, _height 
	as ubyte	pixel_size, attributes 
end type:type TargaHeader  as _TargaHeader 


'/*
'=============
'LoadTGA
'=============
'*/
sub LoadTGA (_name as zstring ptr, _pic as ubyte ptr ptr,_width as  integer ptr ,  _height as  integer ptr)
 
	dim as integer		columns, rows, numPixels 
	dim as ubyte ptr pixbuf 
	dim as integer		row, column 
	dim as ubyte ptr buf_p 
	dim as ubyte ptr buffer 
	dim as integer		length 
	dim as TargaHeader targa_header 
	dim as ubyte ptr targa_rgba 
	dim as ubyte tmp(2) 

	*_pic = NULL 

	'//
	'// load the file
	'//
	length = ri.FS_LoadFile (_name,  cast(any ptr  ptr, @buffer)) 
	if (buffer = NULL) then
		'ri.Con_Printf (PRINT_DEVELOPER, "Bad tga file %s\n", name);
		printf(!"Bad tga file %s\n", _name)
		return 
 
		
	EndIf
	 


	buf_p = buffer 

	targa_header.id_length = *buf_p:buf_p+=1 
	targa_header.colormap_type = *buf_p:buf_p+=1
	targa_header.image_type = *buf_p:buf_p+=1 
	
	tmp(0) = buf_p[0] 
	tmp(1) = buf_p[1] 
	 targa_header.colormap_index = LittleShort ( *(cast (short ptr,@tmp(0))) ) 
	 buf_p+=2 
	tmp(0) = buf_p[0] 
	tmp(1) = buf_p[1] 
	 targa_header.colormap_length = LittleShort ( *(cast (short ptr,@tmp(0))) ) 
	 buf_p+=2 
	 targa_header.colormap_size = *buf_p:buf_p+=1
	 targa_header.x_origin = LittleShort ( *(cast (short ptr,buf_p)) )
	  buf_p+=2 
	 targa_header.y_origin = LittleShort ( *(cast (short ptr,buf_p)) )
	 buf_p+=2 
	 targa_header._width = LittleShort ( *(cast (short ptr,buf_p)) )
	 buf_p+=2 
	 targa_header._height = LittleShort ( *(cast (short ptr,buf_p)) )
	 buf_p+=2 
	 targa_header.pixel_size = *buf_p:buf_p+=1 
	 targa_header.attributes = *buf_p:buf_p+=1 
	 

	 if (targa_header.image_type <> 2 and targa_header.image_type <> 10) then 
	 	
	'	ri.Sys_Error (ERR_DROP, "LoadTGA: Only type 2 and 10 targa RGB images supported\n");
	printf( !"LoadTGA: Only type 2 and 10 targa RGB images supported\n")
	return
    end if
   

	 if (targa_header.colormap_type <> 0 _
	 	or (targa_header.pixel_size <> 32 and targa_header.pixel_size<>24)) then
	 	'	ri.Sys_Error (ERR_DROP, "LoadTGA: Only 32 or 24 bit images supported (no colormaps)\n");
	 	printf( !"LoadTGA: Only 32 or 24 bit images supported (no colormaps)\n")
	 	return
	 end if
	
	
	
	
  'print targa_header.image_type
  'print targa_header.colormap_type
  'print targa_header.pixel_size
  'print targa_header._width
  ' print targa_header._height



	 columns = targa_header._width 
	 rows = targa_header._height 
	 numPixels = columns * rows 

    'print numPixels 
 
	 if (_width) then
	 	*_width = columns
	 end if 
	 if (_height) then
	 	*_height = rows 
	 EndIf
	 
	 
	 
	 ' print *_width
    'print *_height


	 targa_rgba = malloc (numPixels*4) 
	 *_pic = targa_rgba 
   
	 if (targa_header.id_length <> 0) then
	 	buf_p += targa_header.id_length '  // skip TARGA image comment
	 	beep
	 EndIf
	  
	
	 if (targa_header.image_type=2)  then  '// Uncompressed, RGB images
	' print "uncompressed"
	    dim as  ubyte red,green,blue,alphabyte    

    
    
 'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''   
       row = rows-1
 
    do while row >=0 ':
    
 
     
    	pixbuf = targa_rgba+ row*columns*4
    	 column = 0
    	 do while column < columns
        
    
    select case (targa_header.pixel_size)
    	
    	case 24
    	 				   blue = *buf_p: buf_p+=1 
	 						green = *buf_p: buf_p+=1
	 						red = *buf_p: buf_p+=1
	 				      *pixbuf  = red: pixbuf+=1 
	 						*pixbuf  = green : pixbuf+=1 
	 						*pixbuf  = blue: pixbuf+=1  
	 						*pixbuf  = 255: pixbuf+=1 
    	
    	case 32
    		
		                blue = *buf_p: buf_p+=1 
	 						 green = *buf_p: buf_p+=1
	 						 red = *buf_p: buf_p+=1
	 						 alphabyte  = *buf_p: buf_p+=1
	 				       *pixbuf  = red: pixbuf+=1 
	 						 *pixbuf  = green : pixbuf+=1 
	 						 *pixbuf  = blue: pixbuf+=1  
	 						 *pixbuf  = alphabyte: pixbuf+=1 

    End Select
    
    
    
     column+=1
    	 loop
    	 row-=1
    
   loop
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''    
	 elseif (targa_header.image_type=10)  then
	  'print "RLE compressed"
 
   
	  	 dim as ubyte red,green,blue,alphabyte,packetHeader,packetSize,j
	  row = rows-1
    do while row >=0
	 pixbuf = targa_rgba+ row*columns*4
	 
     	 column = 0
   	 do while column < columns
   	 
    	 	packetHeader= *buf_p:buf_p+=1
     	 	packetSize = 1 + (packetHeader and &H7f)
     	 	
   
     
   	 if (packetHeader and &H80) then   '// run-length packet
   	 	
   	 	
    
         	select case (targa_header.pixel_size)  
    	 					case 24 
								blue = *buf_p:buf_p+=1
								green = *buf_p:buf_p+=1
								red = *buf_p:buf_p+=1
								alphabyte = 255 
							 
						case 32 
			               blue = *buf_p:buf_p+=1
								green = *buf_p:buf_p+=1
								red = *buf_p:buf_p+=1
								alphabyte = *buf_p:buf_p+=1
 	 		
         	End Select
         	
 
	 		  for j = 0 to packetSize -1

	 					*pixbuf=red:pixbuf+=1 
	 					*pixbuf=green :pixbuf+=1
	 					*pixbuf=blue :pixbuf+=1
	 					*pixbuf=alphabyte :pixbuf+=1
	 					column+=1
	 					if (column= columns) then ' // run spans across rows
	 						column=0
	 				
	 						if (row>0) then
	 							row-=1
	 							
	 						else
	 							goto breakOut 
	 						
	 						end if
	 						pixbuf = targa_rgba + row*columns*4 
	 				end if	
	 						
	 						
	 		  next
  		
    	 	else	                                          '// non run-length packet
     	 	  	 	 
 
     	 	
     	 		for j = 0 to packetSize -1
	 			 select case (targa_header.pixel_size) 
	 				
						
							case 24 
	  	 				   blue = *buf_p: buf_p+=1 
	 						green = *buf_p: buf_p+=1
	 						red = *buf_p: buf_p+=1
	 				      *pixbuf  = red: pixbuf+=1 
	 						*pixbuf  = green : pixbuf+=1 
	 						*pixbuf  = blue: pixbuf+=1  
	 						*pixbuf  = 255: pixbuf+=1 
								 
							case 32 
							 blue = *buf_p: buf_p+=1 
	 						 green = *buf_p: buf_p+=1
	 						 red = *buf_p: buf_p+=1
	 						 alphabyte  = *buf_p: buf_p+=1
	 				       *pixbuf  = red: pixbuf+=1 
	 						 *pixbuf  = green : pixbuf+=1 
	 						 *pixbuf  = blue: pixbuf+=1  
	 						 *pixbuf  = alphabyte: pixbuf+=1 
									 
	 					End Select
    		 		
	 				column+=1
            if (column=columns) then   '// pixel packet run spans across rows
	 						column=0 
 					if (row>0) then
	 							row-=1
 					   else
	 							goto breakOut 
 						end if		
	 					pixbuf = targa_rgba + row*columns*4 
	 									
	  			end if 
	
	
	    
     	 		next
     end if 
     
 
       loop
       
      
	 breakOut: 	
	   row-=1
 
       
	 	loop 
	  
end if	 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''      
	

	ri.FS_FreeFile (buffer) 
 end sub


'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''
 function Draw_GetPalette () as integer 
	dim i  as integer	
	dim as integer 	r, g, b 
	dim v as uinteger
	dim as ubyte ptr 	 _pic,  _pal
	dim as integer		_width,_height 

    LoadPCX ("pics/colormap.pcx", @_pic, @_pal, @_width, @_height)
	 if (_pal = NULL) then
		    ri.Sys_Error (ERR_FATAL, "Couldn't load pics/colormap.pcx") 
 
	 EndIf
	 
	 for i = 0 to 256-1
	 	
	 	r = _pal[i*3+0] 
		g = _pal[i*3+1] 
		b = _pal[i*3+2] 
	 	
	 	  v= (255 shl 24) + (r shl 0) + (g shl 8) + (b shl 16) 
		d_8to24table(i) = LittleLong(v) 
		
	 Next
	 
	 d_8to24table(255) and= LittleLong(&Hffffff)
		
		
	free (_pic) 
	free (_pal) 

	return 0
	
End Function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	





















'sub GL_TextureSolidMode( _string as zstrring ptr )
' 
'	i as integer	 
'
'	for  i=0  to NUM_GL_SOLID_MODES 
'		if ( Q_stricmp(gl_solid_modes(i)._name, _string ) = 0 ) then
'					exit for
'			
'		EndIf
'	
'		
'		
'	Next
' 
'	if (i = NUM_GL_SOLID_MODES) then
'		
'			'ri.Con_Printf (PRINT_ALL, "bad solid texture mode name\n");
'			printf(!"bad solid texture mode name\n")		
'		return 
'		
'	EndIf
'	 
'	
	 

'	gl_tex_solid_format = gl_solid_modes(i)._mode 
'end sub











'/*
'================
'GL_LoadWal
'================
'*/


'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''''''	
function GL_LoadWal(_name as ZString ptr) as image_t ptr
  
	dim mt as  miptex_t ptr   	 
	dim as integer			_width, _height, ofs 
    dim   _image  as 	image_t	ptr	

	ri.FS_LoadFile (_name, cast(any ptr ptr,@mt)) 
	
 
	' sleep
	
	if ( mt = null) then
		
	
		'ri.Con_Printf (PRINT_ALL, "GL_FindImage: can't load %s\n", _name)
			 printf (!"GL_FindImage: can't load %s\n", _name)  
		    print "GL_FindImage: can't load " & *_name
	
		
		return r_notexture 
	 
	EndIf
	
	print "name: " & mt->_name
   print "width: " & mt->_width
   print "height: " & mt->_height
   print "anim name: " & mt->animname
   print "flags: " & mt->flags
   print "contents: " & mt->contents
   print "values: " & mt->value
   print "offsets(0): "& LittleLong (mt->offsets(0))
   print "offsets(1): "& LittleLong (mt->offsets(1))
   print "offsets(2): "& LittleLong (mt->offsets(2))
   print "offsets(3): "& LittleLong (mt->offsets(3))
   
   
   
	 'sleep

	_width = LittleLong (mt->_width) 
	_height = LittleLong (mt->_height) 
	ofs = LittleLong (mt->offsets(0)) 
   
 
  
   
   
   
   
  ' sleep
     _image = GL_LoadPic (_name, cast(ubyte ptr,mt) + ofs, _width, _height, it_wall, 8) 
 _image->pic_d(0) = cast(ubyte ptr,mt) + ofs
 ofs = LittleLong (mt->offsets(1)) 
 _image->pic_d(1) = cast(ubyte ptr,mt) + ofs
  ofs = LittleLong (mt->offsets(2)) 
 _image->pic_d(2) = cast(ubyte ptr,mt) + ofs
   ofs = LittleLong (mt->offsets(3)) 
 _image->pic_d(3) = cast(ubyte ptr,mt) + ofs
 
 
 
	ri.FS_FreeFile (cast(any ptr, mt)) 
 
	return _image



 End Function
'''''''''''''''''''''''''''''''''''''''''''''''''

dim shared as integer		upload_width, upload_height 
dim shared uploaded_paletted as qboolean 

function GL_Upload32 (_data as uinteger ptr,_width as integer, _height as integer,  mipmap as qboolean) as qboolean 
	dim samples  as integer			
	dim scaled(256*256) as integer	
	dim paletted_texture(256*256) as ubyte
	dim as integer			scaled_width, scaled_height 
	dim as integer			i, c 
	dim scan as ubyte ptr 
	dim comp as integer 

	 uploaded_paletted = _false 

    scaled_width = 1:do while scaled_width < _width 
     scaled_width shl= 1
    loop
 

 
 
 
   ' 'if (gl_round_down->value and scaled_width > _width and mipmap) then
	'  'scaled_width shr= 1 
   ' 'end if
   
   ' 'gl_round_down->value and 
    if (scaled_width > _width and mipmap) then
	  scaled_width shr= 1 
    end if
 
  
    scaled_height = 1:do while scaled_height < _height 
     scaled_height shl= 1
    loop
   
   'gl_round_down->value and 
    if (scaled_height > _height and mipmap) then
	  	scaled_height shr= 1 
    EndIf
  
   '' if (gl_round_down->value and scaled_height > _height and mipmap) then
	' ' 	scaled_height shr= 1 
   '' EndIf
   
   ' 'gl_round_down->value and 
    if (scaled_height > _height and mipmap) then
	  	scaled_height shr= 1 
    EndIf
    
    '    print"test"
 	 'sleep
   

 'print mipmap
 'sleep
	'// let people sample down the world textures for speed
	 if (mipmap) then
	 
 		'scaled_width shr= cast(integer, gl_picmip->value) 
	' 	scaled_height shr= cast(integer,gl_picmip->value)
	 endif

	'// don't ever bother with >256 textures
	 if (scaled_width > 256) then
	 	scaled_width = 256 
	 EndIf
	 if (scaled_height > 256) then
	 	 scaled_height = 256 
	 EndIf
	 if (scaled_width < 1) then
	    scaled_width = 1 
	 EndIf
	 if (scaled_height < 1) then
	 	scaled_height = 1 
	 end if

	 upload_width = scaled_width 
	 upload_height = scaled_height 

	 if (scaled_width * scaled_height > (sizeof(scaled)*ubound(scaled))/4)  then
	  '	ri.Sys_Error (ERR_DROP, "GL_Upload32: too big");
    printf(!"GL_Upload32: too big",samples)
    end if
	'// scan the texture for any non-255 alpha
	 c = _width*_height 
	 scan = cast(ubyte ptr, _data) + 3 
	 samples = gl_solid_format 


   for i = 0 to c-1 step 4
   	
    	if ( *scan <> 255 ) then
    			 	samples = gl_alpha_format 
    	EndIf
   
   Next

	 if (samples  = gl_solid_format) then
	     comp = gl_tex_solid_format 
	 elseif (samples =  gl_alpha_format) then
	    comp = gl_tex_alpha_format 
	 else  
	'    ri.Con_Printf (PRINT_ALL,
	'		   "Unknown number of texture components %i\n",
	'		   samples);
	  printf(!"Unknown number of texture components %i\n",samples)
     comp = samples 
	 end if
 	

#if 0
	'if (mipmap) then
	'	'gluBuild2DMipmaps (GL_TEXTURE_2D, samples, width, height, GL_RGBA, GL_UNSIGNED_BYTE, trans);
	'else if (scaled_width  = _width and scaled_height = _height) then
	'	'qglTexImage2D (GL_TEXTURE_2D, 0, comp, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, trans);
	'else
	' 	'gluScaleImage (GL_RGBA, width, height, GL_UNSIGNED_BYTE, trans,
	'	'	scaled_width, scaled_height, GL_UNSIGNED_BYTE, scaled);
	'	'qglTexImage2D (GL_TEXTURE_2D, 0, comp, scaled_width, scaled_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, scaled);
	'end if
	'end if

#else
'	print "here"
	'sleep
	
	
 	if (scaled_width = _width and scaled_height  = _height) then
 
 		if (mipmap) then
 		' and gl_ext_palettedtexture->value 
 			if ( qglColorTableEXT <> NULL and samples = gl_solid_format ) then
     ' beep
 				uploaded_paletted = _true 
 				
 			 'GL_BuildPalettedTexture( paletted_texture, ( unsigned char * ) data, scaled_width, scaled_height );

            
'				qglTexImage2D( GL_TEXTURE_2D,
'							  0,
'							  GL_COLOR_INDEX8_EXT,
'							  scaled_width,
'							  scaled_height,
'							  0,
'							  GL_COLOR_INDEX,
'							  GL_UNSIGNED_BYTE,
'							  paletted_texture );
 'beep
 			else
 		 
'				qglTexImage2D (GL_TEXTURE_2D, 0, comp, scaled_width, scaled_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
'		 
 		   goto _done 
 			end if
 		 end if
 		memcpy (@scaled(0), _data, _width*_height*4) 
 
 
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
 	else
 		
'		GL_ResampleTexture (data, width, height, scaled, scaled_width, scaled_height);
'
'	GL_LightScaleTexture (scaled, scaled_width, scaled_height, !mipmap );

'gl_ext_palettedtexture->value and 
 	if ( qglColorTableEXT <> NULL and ( samples = gl_solid_format ) ) then
' 
 	   uploaded_paletted = _true 
'		GL_BuildPalettedTexture( paletted_texture, ( unsigned char * ) scaled, scaled_width, scaled_height );
'		qglTexImage2D( GL_TEXTURE_2D,
'					  0,
'					  GL_COLOR_INDEX8_EXT,
'					  scaled_width,
'					  scaled_height,
'					  0,
'					  GL_COLOR_INDEX,
'					  GL_UNSIGNED_BYTE,
'					  paletted_texture );
' 
 	else
'	 
'		qglTexImage2D( GL_TEXTURE_2D, 0, comp, scaled_width, scaled_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, scaled );
 	end if
 	
 	
 
 	
 	if (mipmap) then
 	 
 	dim	miplevel  as integer		
 
 		miplevel = 0 
   	while (scaled_width > 1 or scaled_height > 1)
 
'			GL_MipMap ((byte *)scaled, scaled_width, scaled_height);
 		   scaled_width shr= 1 
 			scaled_height shr= 1 
 			if (scaled_width < 1) then
    			scaled_width = 1 
 			end if
 			if (scaled_height < 1) then
 				scaled_height = 1 
			end if
 			miplevel+=1
 			' gl_ext_palettedtexture->value and  
 				if ( qglColorTableEXT <> NULL and samples = gl_solid_format   ) then
 
 				uploaded_paletted = _true 
'				GL_BuildPalettedTexture( paletted_texture, ( unsigned char * ) scaled, scaled_width, scaled_height );
'				qglTexImage2D( GL_TEXTURE_2D,
'							  miplevel,
'							  GL_COLOR_INDEX8_EXT,
'							  scaled_width,
'							  scaled_height,
'							  0,
'							  GL_COLOR_INDEX,
'							  GL_UNSIGNED_BYTE,
'							  paletted_texture );
'			 
 			else
'		 
'				qglTexImage2D (GL_TEXTURE_2D, miplevel, comp, scaled_width, scaled_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, scaled);
'		 
  end if

 wend	
 	end if
 	

 	end if
  
  
 	
_done:  
#endif


	if (mipmap) then
 
	'	qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_min) 
	'	qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
      glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_min) 
      glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max)
 
	else
	 
		'qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_max) 
		'qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_max) 
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
	end if

	return  iif(samples  = gl_alpha_format,qboolean._true,qboolean._false) 
 
	
 
End Function


function GL_Upload8 (_data as ubyte ptr,_width as integer ,_height as integer , mipmap as qboolean ,is_sky as qboolean  ) as qboolean 

 
 	dim	_trans(512*256) as uinteger
 	dim as integer			i, s 
  dim as integer			p 
 
 	s = _width*_height 
 
 	if (s > ((sizeof(_trans)*ubound(_trans))/4)) then
 	'		ri.Sys_Error (ERR_DROP, "GL_Upload8: too large");	
 	EndIf
' 
 
' print is_sky
 
 
 
' gl_ext_palettedtexture->value and _
 	if ( qglColorTableEXT <> NULL and _
 		 is_sky ) then 
 
'		qglTexImage2D( GL_TEXTURE_2D,
'					  0,
'					  GL_COLOR_INDEX8_EXT,
'					  width,
'					  height,
'					  0,
'					  GL_COLOR_INDEX,
'					  GL_UNSIGNED_BYTE,
'					  data );
'
 		'qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_max) 
    '	qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_max) 
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
    
'beep
 	else
 	
 	
 
    
  
 		for  i=0  to s-1
 
 	   	p = _data[i] 
 			_trans(i) = d_8to24table(p) 
'
 			if (p = 255) then
' 			 	'// transparent, so scan around for another color
''				// to avoid alpha fringes
''				// FIXME: do a full flood fill so mips work...
 				if (i > _width and _data[i-_width] <> 255) then
            			p = _data[i-_width] 
 				elseif (i > s-_width and _data[i+_width] <> 255) then
 					p = _data[i+_width] 
 				elseif (i > 0 and _data[i-1] <> 255) then
     				p = _data[i-1] 
 				elseif (i < s-1 and _data[i+1] <> 255) then
 					p = _data[i+1] 
 				else
 				p = 0 
''				// copy rgb components
   			  cast(ubyte ptr,@_trans(i))[0] = cast(ubyte ptr,@d_8to24table(p))[0]
   			  cast(ubyte ptr,@_trans(i))[1] = cast(ubyte ptr,@d_8to24table(p))[1]
   			  cast(ubyte ptr,@_trans(i))[2] = cast(ubyte ptr,@d_8to24table(p))[2]
   			 
 	        end if
 		
 	end if
 next
 'sleep
 
 	return   GL_Upload32(@_trans(0), _width, _height, mipmap) 
  
end if 				
 				
 				
end function




function GL_LoadPic ( _name as zstring ptr, pic as ubyte ptr,_width as integer ,_height  as integer , _type as  imagetype_t, _bits as Integer) as image_t ptr
	
 	
  dim _image  as	image_t ptr		
  dim	i	as  integer

 '	// find a free image_t
    _image = @gltextures(0) 
    
 	 for i = 0 to numgltextures'-1
 
 	 	if ( _image->texnum = NULL) then
  
 	 	 	exit for	
 	 	EndIf
 	 _image+=1
 		
 	 next
 	 
 

 	if (i  = numgltextures) then
 		'	{
 	if (numgltextures  = MAX_GLTEXTURES) then
 		'			ri.Sys_Error (ERR_DROP, "MAX_GLTEXTURES") 
 		printf(!"MAX_GLTEXTURES")
 		print "MAX_GLTEXTURES" 
 	EndIf
 numgltextures+=1
 		
 	EndIf

 	_image = @gltextures(i) 
'
 	if (strlen(_name) >= sizeof(_image->_name)) then
'		ri.Sys_Error (ERR_DROP, "Draw_LoadPic: \"%s\" is too long", name)
   printf(!"Draw_LoadPic: \"%s\" is too long", _name)
 	end if
 	
 	strcpy (_image->_name, _name)
  _image->registration_sequence = registration_sequence  
 
 	_image->_width = _width 
 	_image->_height = _height 
 	_image->_type = _type 
 	
  	'print _image->_name
  	'print _image->_width
 	'print _image->_height
   'print _image->_type
 	
 
 	
 	if (_type =  it_skin and _bits  = 8) then
''		R_FloodFillSkin(pic, width, height);
 	end if
'	// load little pics into the scrap


 	if (_image->_type =  it_pic and _bits  = 8  _
 		and _image->_width < 64 and _image->_height < 64) then
 beep
dim  as		integer		x, y 
dim as		integer		i, j, k 
dim  as  	integer		texnum 
'
 	texnum = Scrap_AllocBlock (_image->_width, _image->_height, @x, @y) 
 		if (texnum = -1) then
 			goto nonscrap 
 			scrap_dirty = _true 
 		EndIf

 
'		// copy the texels into the scrap block
 		k = 0 
 		for i=0 to  _image->_height -1
 			for  j=0  to  _image->_width -1
 			
 				Next
      Next
 		
 			
 		scrap_texels(texnum,(y+i)*BLOCK_WIDTH + x + j) = pic[k] 
 		_image->texnum = TEXNUM_SCRAPS + texnum 
 		_image->scrap = _true 
 		_image->has_alpha = _true 
    	_image->_sl = (x+0.01)/cast(float, BLOCK_WIDTH)  
 		_image->_sh = (x+_image->_width-0.01)/(cast(float, BLOCK_WIDTH) ) 
 		_image->_tl = (y+0.01)/ cast(float, BLOCK_WIDTH) 
 		_image->_th = (y+_image->_height-0.01)/cast(float, BLOCK_WIDTH)  
 
 	else
 
nonscrap:

   	_image->scrap = _false 
   	
   	'could be wrong'''''''''''''''''''''''''''''''''''''''''
 		 _image->texnum = TEXNUM_IMAGES + (_image -  @gltextures(0)) 
 		 '''''''''''''''''''''''''''''''''''''''''''''''''''''''
 		  'cls
 		 'print _image '-  @gltextures(0)
 		 ' print  @gltextures(0)
 		  'print  _image->texnum 
 		 'sleep
 		    'print _type
 		    'sleep
	 	 GL_Bind(_image->texnum)
 		if (_bits = 8) then
 		  '  print _image->_type
 		' sleep
		  _image->has_alpha =  GL_Upload8 (pic, _width, _height, iif((_image->_type <> it_pic and _image->_type <> it_sky),qboolean._true,qboolean._false), iif((_image->_type = it_sky),qboolean._true,qboolean._false) ) 
       
 		else
   	'_image->has_alpha = GL_Upload32 ((unsigned *)pic, width, height, (image->type != it_pic && image->type != it_sky) );
      end if
  		_image->upload_width = upload_width 		'// after power of 2 and scales
 		_image->upload_height = upload_height 
 		_image->paletted = uploaded_paletted 
 		_image->_sl = 0 
    	_image->_sh = 1 
 		_image->_tl = 0 
 		_image->_th = 1 

 end if
 
 'printf(!"%d", TEXNUM_IMAGES)
 
 
 	return _image 
 	
	
	
End Function

'draw_chars = GL_FindImage ("pics/conchars.pcx", it_pic) 

'/*
'===============
'GL_FindImage
'
'Finds or loads the given image
'===============
'*/


'function Data_FindImage (_name as ZString ptr,_type as imagetype_t ) as ubyte ptr
' 
'
'	dim _image as image_t ptr 
'	dim as integer		i, _len 
'	dim as ubyte ptr	_pic, _palette 
'	dim as integer		_width, _height 
'
'	 if (_name = 0) then
'	  	return NULL '	//	ri.Sys_Error (ERR_DROP, "GL_FindImage: NULL name");
'	 end if
'	_len = strlen(_name) 
'	 if (_len<5) then
'	 	return NULL
'	 end if	'//	ri.Sys_Error (ERR_DROP, "GL_FindImage: bad name: %s", name);
'
'	 '// look for it
'	'for (i=0, image=gltextures ; i<numgltextures ; i++,image++)
'	_image = @gltextures(0)	
'	for i = 0 to numgltextures
'	 
' 	if ( strcmp(_name, _image->_name) = 0) then
' 	  print "reg"
' 		   	_image->registration_sequence = registration_sequence 
'	 		return _image 
' 	EndIf
' 	_image+=1
' next	
'
'	'//
'	'// load the pic from disk
'	'//
'	
'	
'	_pic = NULL 
'	_palette = NULL 
'	 if (strcmp(*(_name+_len-4), ".pcx") = 0) then
'	  printf(!"is pcx\n")
'	  print  "is pcx"  
'	 'sleep
'	 '
'	 
'	 'Draw_GetPalette ()
'   	LoadPCX (_name, @_pic, @_palette, @_width, @_height)
'   	 
'   	
'   	
'	 	if (_pic = null) then
'	 		return NULL  '// ri.Sys_Error (ERR_DROP, "GL_FindImage: can't load %s", name);
'	 	end if
'	 	  _image = GL_LoadPic (_name,_pic, _width, _height, _type, 8) 
'	 
'	 elseif (strcmp(*(_name+_len-4), ".wal") = 0) then
'	 
' 		_image = GL_LoadWal (_name) 
'	 
'	 elseif (strcmp(*(_name+_len-4), ".tga") = 0) then
'	 
' 		LoadTGA (_name, @_pic, @_width, @_height) 
'	 	if ( _pic = NULL) then
'	 	 return NULL  '// ri.Sys_Error (ERR_DROP, "GL_FindImage: can't load %s", name);
'	 	 EndIf
'	 	 
'	 	_image = GL_LoadPic (_name, _pic, _width, _height, _type, 32) 
'	
'	  else
'	 	return NULL 	'//	ri.Sys_Error (ERR_DROP, "GL_FindImage: bad extension on: %s", name);
'
'	 		
'	 	EndIf
'
'	 'if (_pic) then
'	  '	free(_pic)
'	 'endif 
'	 if (_palette) then
'	 	free(_palette) 
'    endif 
'	return _pic
'end function



function GL_FindImage (_name as ZString ptr,_type as imagetype_t ) as image_t ptr
 

	dim _image as image_t ptr 
	dim as integer		i, _len 
	dim as ubyte ptr	_pic, _palette 
	dim as integer		_width, _height 

	 if (_name = 0) then
	  	return NULL '	//	ri.Sys_Error (ERR_DROP, "GL_FindImage: NULL name");
	 end if
	_len = strlen(_name) 
	 if (_len<5) then
	 	return NULL
	 end if	'//	ri.Sys_Error (ERR_DROP, "GL_FindImage: bad name: %s", name);

	 '// look for it
	'for (i=0, image=gltextures ; i<numgltextures ; i++,image++)
	_image = @gltextures(0)	
	for i = 0 to numgltextures
	 
 	if ( strcmp(_name, _image->_name) = 0) then
 	  'print "reg"
 		   	_image->registration_sequence = registration_sequence 
	 		return _image 
 	EndIf
 	_image+=1
 next	

	'//
	'// load the pic from disk
	'//
	
	
	_pic = NULL 
	_palette = NULL 
	 if (strcmp(*(_name+_len-4), ".pcx") = 0) then
	  printf(!"is pcx\n")
	  print  "is pcx"  
	 'sleep
	 '
	 
	 'Draw_GetPalette ()
   	LoadPCX (_name, @_pic, @_palette, @_width, @_height)
   	 
   	
   	
	 	if (_pic = null) then
	 		 
	 		return NULL  '// ri.Sys_Error (ERR_DROP, "GL_FindImage: can't load %s", name);
	 	end if
	 	  _image = GL_LoadPic (_name,_pic, _width, _height, _type, 8) 
	 	  
	  _image->pic_d(0) =   _pic
   	 _image->pal_d =  _palette
   	 print "has alpha: "& _image->has_alpha
   	 
   	 
   	 
	 elseif (strcmp(*(_name+_len-4), ".wal") = 0) then
	 
 		 _image = GL_LoadWal (_name) 
	  print "has alpha: "& _image->has_alpha
	 
	 
	 elseif (strcmp(*(_name+_len-4), ".tga") = 0) then
	 
 		LoadTGA (_name, @_pic, @_width, @_height) 
	 	if ( _pic = NULL) then
	 	 return NULL  '// ri.Sys_Error (ERR_DROP, "GL_FindImage: can't load %s", name);
	 	 EndIf
	 	 
	 	_image = GL_LoadPic (_name, _pic, _width, _height, _type, 32) 
	   _image->pic_d(0) =   _pic
	  else
	 	return NULL 	'//	ri.Sys_Error (ERR_DROP, "GL_FindImage: bad extension on: %s", name);

	 		
	 	EndIf

	' if (_pic) then
	 ' 	free(_pic)
	' endif 
	' if (_palette) then
	' 	free(_palette) 
   ' endif 
	return _image 
end function




 function R_RegisterSkin (_name as zstring ptr) as image_s ptr
   	return GL_FindImage (_name, it_skin) 
 End Function
 

 




 
sub	GL_ShutdownImages ()
 
	dim i  as integer		 
   dim   _image 	as image_t ptr	
   _image= @gltextures(0)
   
  
   
	for  i=0 to numgltextures '-1
	  
		if (_image->registration_sequence = null) then
			continue for		'// free image_t slot
		end if
		
		'// free it
		'qglDeleteTextures (1, &image->texnum);
		memset (_image, 0, sizeof(*_image)) 
		_image+=1
	next
 	

	
	
	
	
	
End Sub











