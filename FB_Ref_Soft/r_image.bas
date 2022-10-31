 'FINISHED FOR NOW//////////////////////////////////////////////////
 
 
 
 #Include "FB_Ref_Soft\r_local.bi"


#define	MAX_RIMAGES	1024
dim shared  as  image_t		r_images(MAX_RIMAGES)
dim shared as 	 integer			numr_images


/'
================
R_FreeUnusedImages

Any image that was not touched on this registration sequence
will be freed.
================
'/
sub R_FreeUnusedImages ()
	dim as integer		i 
	dim as image_t	ptr image 

 
	
	image=@r_images(0)
	for i = 0 to numr_images-1
		
 
	
		if (image->registration_sequence = registration_sequence) then
			Com_PageInMemory (cast(ubyte ptr,image->pixels(0)), image->_width*image->_height)  
			continue for
		EndIf
 
		if (image->registration_sequence = NULL) then
			continue for		'// free texture	
		EndIf
		
		if (image->_type = it_pic) then
			continue for		'// don't free pics
		EndIf
		
		'// free it
		free (image->pixels(0)) 	'// the other mip levels just follow
		memset (image, 0, sizeof(*image)) 
		
		
	next
End Sub
 
 





'/*
'===============
'R_ImageList_f
'===============
'*/
sub	R_ImageList_f ()
 
	dim i  as integer		
	dim _image as	image_t	ptr  
	dim texels  as integer	

	ri.Con_Printf (PRINT_ALL, !"------------------\n") 
	texels = 0 
 
	_image=@r_images(0)
 
 
 
	for  i=0 to numr_images 
	 
		if (_image->registration_sequence <= 0) then
			continue for
		EndIf
			
		texels += _image->_width*_image->_height 
		select case (_image->_type)
			
	 case it_skin 
			ri.Con_Printf (PRINT_ALL, "M") 
 
		case it_sprite 
			ri.Con_Printf (PRINT_ALL, "S") 
		 
		case it_wall 
			ri.Con_Printf (PRINT_ALL, "W") 
			 
		case it_pic 
			ri.Con_Printf (PRINT_ALL, "P") 
		 
			case else
			ri.Con_Printf (PRINT_ALL, " ") 
		End Select
 
 
		ri.Con_Printf (PRINT_ALL,  !" %3i %3i : %s\n", _
			_image->_width, _image->_height, _image->_name) 
			
			_image+=1
next
	ri.Con_Printf (PRINT_ALL, !"Total texel count: %i\n", texels) 
	
	
	
	
	
end sub


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
    dim _size as integer

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
    
    
    
    	_size = _image->_width*_image->_height * (256+64+16+4)/256 
	_image->pixels(0) = malloc (_size) 
	_image->pixels(1) = _image->pixels(0) + _image->_width*_image->_height 
	
	'_image->pixels(2) = _image->pixels(1) + _image->_width*_image->_height/4 
	'_image->pixels(3) = _image->pixels(2) + _image->_width*_image->_height/16 
    
    
    
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


  
 type _TargaHeader  
 	
   as ubyte 	id_length, colormap_type, image_type 
 	as ushort	colormap_index, colormap_length 
 	as ubyte	colormap_size 
   as ushort	x_origin, y_origin, _width, _height 
 	as ubyte	pixel_size, attributes 
 
 	
 End Type: type TargaHeader as _TargaHeader

'WORKING SO FAR

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
	for i = 0 to numr_images-1
	 
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
'R_RegisterSkin
'===============
'*/
function R_RegisterSkin (_name as ZString ptr ) as image_s ptr
	return R_FindImage (_name, it_skin)
End Function
	


'/*
'===============
'R_InitImages
'===============
'*/
sub	R_InitImages ()
	registration_sequence = 1 
End Sub

	
 

