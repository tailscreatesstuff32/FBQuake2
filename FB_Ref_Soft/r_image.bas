 #Include "FB_Ref_Soft\r_local.bi"


#define	MAX_RIMAGES	1024
dim shared  as  image_t		r_images(MAX_RIMAGES)
dim shared as 	 integer			numr_images




'/*
'===============
'R_ImageList_f
'===============
'*/

sub R_ScreenShot_f()
	
	
	
End Sub


sub	R_ImageList_f ()
 
	dim i  as integer		
	dim _image as	image_t	ptr  
	dim texels  as integer	

	ri.Con_Printf (PRINT_ALL, "------------------\n") 
	texels = 0 




  
	_image=@r_images(0)
	
	'for (i=0, image=r_images ; i<numr_images ; i++, image++)
	'{
'		if (image->registration_sequence <= 0)
	'		continue;
	'	texels += image->width*image->height;
	'	switch (image->type)
	'	{
	'	case it_skin:
	'		ri.Con_Printf (PRINT_ALL, "M");
	'		break;
	'	case it_sprite:
	'		ri.Con_Printf (PRINT_ALL, "S");
	'		break;
	'	case it_wall:
	'		ri.Con_Printf (PRINT_ALL, "W");
	'		break;
	'	case it_pic:
	'		ri.Con_Printf (PRINT_ALL, "P");
	'		break;
	'	default:
	'		ri.Con_Printf (PRINT_ALL, " ");
	'		break;
	'	}

	'	ri.Con_Printf (PRINT_ALL,  " %3i %3i : %s\n",
	'		image->width, image->height, image->name);
	'}
	'ri.Con_Printf (PRINT_ALL, "Total texel count: %i\n", texels);
	'
	'
	'
	' for i = 0 to numgltextures-1
   ' 	
   ' 	
 
   '  
	'	if (_image->texnum <= 0) then
	'		continue for
	'	end if	
	'		
	'	texels += _image->upload_width*_image->upload_height 
	'	select case (_image->_type)
	'				case it_skin 
	'		'ri.Con_Printf (PRINT_ALL, "M") 
	'	 
	'	case it_sprite 
	'		'ri.Con_Printf (PRINT_ALL, "S") 
	'	 
	'	case it_wall 
	'		'ri.Con_Printf (PRINT_ALL, "W") 
	'		 
	'	case it_pic 
	'		'ri.Con_Printf (PRINT_ALL, "P") 
	'	 
	'	default:
	'		'ri.Con_Printf (PRINT_ALL, " ") 
	'	 
	'		
	'		
	'	End Select
	' 'ri.Con_Printf (PRINT_ALL,  " %3i %3i %s: %s\n", _
	''		_image->upload_width, _image->upload_height, palstrings(_image->paletted), _image->_name)
	'
	'_image+=1
	' next
	
	
	
	
	
end sub










sub	GL_ImageList_f ()
	'dim i  as integer		
	'dim _image as	image_t	ptr  
	'dim texels  as integer		
	'dim  palstrings(2) as const zstring ptr => _
	'{ _
'		@"RGB", _
	'	@"PAL" _
	'} 
	'
		'ri.Con_Printf (PRINT_ALL, "------------------\n") 
'	texels = 0 

	
	'for (i=0, image=gltextures ; i<numgltextures ; i++, image++)
 
   ' for i = 0 to numgltextures-1
   ' 	
   ' 	
 
   '  
	'	if (_image->texnum <= 0) then
	'		continue for
	'	end if	
	'		
	'	texels += _image->upload_width*_image->upload_height 
	'	select case (_image->_type)
	'				case it_skin 
	'		'ri.Con_Printf (PRINT_ALL, "M") 
	'	 
	'	case it_sprite 
	'		'ri.Con_Printf (PRINT_ALL, "S") 
	'	 
	'	case it_wall 
	'		'ri.Con_Printf (PRINT_ALL, "W") 
	'		 
	'	case it_pic 
	'		'ri.Con_Printf (PRINT_ALL, "P") 
	'	 
	'	default:
	'		'ri.Con_Printf (PRINT_ALL, " ") 
	'	 
	'		
	'		
	'	End Select
	' 'ri.Con_Printf (PRINT_ALL,  " %3i %3i %s: %s\n", _
	''		_image->upload_width, _image->upload_height, palstrings(_image->paletted), _image->_name)
	'
	'_image+=1
   ' next
	' 

		 
	 
	'ri.Con_Printf (PRINT_ALL, "Total texel count (not counting mipmaps): %i\n", texels) 
	
	
	 
	 
	
End Sub



'//=======================================================

function R_FindFreeImage () as  image_t ptr
	
		dim as integer			i 

 
	dim as image_t ptr _image 


    _image=@r_images(0)
    
    
    
    
	'// find a free image_t
	for  i=0 to numr_images-1 
	
	if (_image->registration_sequence = NULL) then
		exit for
	EndIf
	
	
	_image+=1
	Next
 
	if (i = numr_images) then
		 if (numr_images = MAX_RIMAGES) then
		 			ri.Sys_Error (ERR_DROP, "MAX_RIMAGES") 
		 EndIf
	
		numr_images+=1
	EndIf
 
	_image = @r_images(i)

	return _image 
	
End function

 








function R_LoadWal(_name as ZString ptr) as image_t ptr
  
	dim as  miptex_t ptr  mt  	 
	dim as integer		    ofs 
    dim    as 	image_t	ptr	_image 

	ri.FS_LoadFile (_name, cast(any ptr ptr,@mt)) 
	if ( mt = null) then
		
	ri.Con_Printf (PRINT_ALL, "R_LoadWal: can't load %s\n", _name)
		return r_notexture_mip 
	 
	EndIf
	
 
 _image = R_FindFreeImage ()
 strcpy (_image->_name, _name)
 _image->_width = LittleLong (mt->_width)
 _image->_height = LittleLong (mt->_height)
 	_image->_type = it_wall
	_image->registration_sequence = registration_sequence
    
    ofs = LittleLong (mt->offsets(1)) 
 
	ri.FS_FreeFile (cast(any ptr, mt)) 
 
	return _image



 End Function
'''''''''''''''''''''''''''''''''''''''''''''''''





function GL_LoadPic ( _name as zstring ptr, pic as ubyte ptr,_width as integer ,_height  as integer , _type as  imagetype_t, _bits as Integer) as image_t ptr


	dim as 	image_t	 ptr	_image
	dim as integer			i, c, b

		_image = R_FindFreeImage ()
	if (strlen(_name) >= sizeof(_image->_name)) then
		 ri.Sys_Error (ERR_DROP, !"Draw_LoadPic: \"%s\" is too long", _name) 
	end if
	strcpy (_image->_name, _name)
	_image->registration_sequence = registration_sequence

	_image->_width = _width
	_image->_height = _height
	_image->_type = _type

	c = _width*_height
	_image->pixels(0) = malloc (c)
	_image->transparent = _false
	for  i=0 to c-1
			b = pic[i]
		if  b  = 255  then
			_image->transparent = _true
		EndIf
	
	
		_image->pixels(0)[i] = b
	Next






	return _image


End Function


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

'//
'// load the file
'//
_len = ri.FS_LoadFile (filename, cast(any ptr ptr,@raw))


if ( raw = NULL) then
	ri.Con_Printf (PRINT_DEVELOPER, !"Bad pcx file %s\n", filename)
	return
EndIf

'//
'// parse the PCX file
'//
pcx = cast(pcx_t ptr,raw )

pcx->xmin = LittleShort(pcx->xmin)
pcx->ymin = LittleShort(pcx->ymin)
pcx->xmax = LittleShort(pcx->xmax)
pcx->ymax = LittleShort(pcx->ymax)
pcx->hres = LittleShort(pcx->hres)
pcx->vres = LittleShort(pcx->vres)
pcx->bytes_per_line = LittleShort(pcx->bytes_per_line)
pcx->palette_type = LittleShort(pcx->palette_type)

raw = @pcx->_data
'
if (pcx->manufacturer <> &H0a _
	or pcx->version <> 5 _
	or pcx->_encoding <> 1 _
	or pcx->bits_per_pixel <> 8 _
	or pcx->xmax >= 640 _
	or pcx->ymax >= 480) _
	then
	ri.Con_Printf (PRINT_ALL, "Bad pcx file %s\n", filename)

	return

end if

_out = malloc ( (pcx->ymax+1) * (pcx->xmax+1) )

*_pic = _out

pix = _out

if (_palette <> NULL) then

	*_palette = malloc(768)
	memcpy (*_palette, cast(ubyte ptr,pcx) + _len - 768, 768)


EndIf


if (_width) then
*_width = pcx->xmax+1:end if


if (_height) then
*_height = pcx->ymax+1:end if


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
	free (*_pic)
	*_pic = NULL

EndIf

ri.FS_FreeFile (pcx)

End Sub

 

function R_FindImage (_name as ZString ptr,_type as imagetype_t ) as image_t ptr
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
	_image = @r_images(0)	
	for i = 0 to numr_images
	 
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
 
 
   	LoadPCX (_name, @_pic, @_palette, @_width, @_height)
	 	if (_pic = null) then
	 		 
	 		return NULL  
	 	end if
	 	  _image = GL_LoadPic (_name,_pic, _width, _height, _type, 8) 

	 elseif (strcmp(*(_name+_len-4), ".wal") = 0) then
	 
 		 _image = R_LoadWal (_name) 
	
	 elseif (strcmp(*(_name+_len-4), ".tga") = 0) then
 		return NULL       '// ri.Sys_Error (ERR_DROP, "R_FindImage: can't load %s in software renderer", name);
	  else
	 	return NULL 		'// ri.Sys_Error (ERR_DROP, "R_FindImage: bad extension on: %s", name);
	 EndIf

	 if (_pic) then
	  	free(_pic)
	 endif 
	 if (_palette) then
	 	free(_palette) 
    endif 
	return _image 


end function


'FINISHED FOR NOW'''''''''''''''''''''''''''''''
sub	R_ShutdownImages  ()


dim as integer		i
dim as image_t ptr _image

_image = @r_images(0)

for  i= 0 to numr_images - 1
if ( _image->registration_sequence) then

	continue for

EndIf

'// free it
free (_image->pixels(0)) 	'// the other mip levels just follow
memset (_image, 0, sizeof(*_image))

_image+=1
Next




End Sub
''''''''''''''''''''''''''''''''''''''''''''''''''
'/*
'===============
'R_InitImages
'===============
'*/
sub	R_InitImages ()
	registration_sequence = 1 
End Sub

	
 

