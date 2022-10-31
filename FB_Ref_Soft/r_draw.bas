'FINISHED FOR NOW///////////////////////////////////////////////////////////////


#Include "FB_Ref_Soft\r_local.bi"

extern draw_chars as image_t ptr	
 
dim shared draw_chars as image_t ptr		
dim shared draw_con as image_t ptr	

dim shared draw_colormap as image_t ptr	

'extern	scrap_dirty  as qboolean	
declare sub Scrap_Upload () 

/'
=============
Draw_StretchPicImplementation
=============
'/
sub Draw_StretchPicImplementation (x as integer ,y as integer ,w as integer ,h as integer ,pic as image_t	ptr)
	dim as ubyte ptr			 dest,  source 
	dim as integer				v, u, sv 
	dim as integer				_height 
	dim as integer				f, fstep 
	dim as integer				skip 

	 if ((x < 0) or _
	 	(x + w > vid._width) or _
	 	(y + h > vid._height)) then
	  
 		ri.Sys_Error (ERR_FATAL,"Draw_Pic: bad coordinates") 
	end if

	_height = h 
	 if (y < 0) then
	 
 		skip = -y 
	 	_height += y 
	 	y = 0 
	 
	 else
	 	skip = 0 
    end if
	 dest = vid.buffer + y * vid.rowbytes + x 

	 'for (v=0 ; v<height ; v++, dest += vid.rowbytes)
	   for v = 0 to _height - 1
	   	
	    
  		sv = (skip + v)*pic->_height/h 
	 	source = pic->pixels(0) + sv*pic->_width 
	 	if (w  = pic->_width) then
	  		memcpy (dest, source, w) 
	 	else
	 	 
	 		f = 0 
	 		fstep = pic->_width*&H10000/w 
	 		u = 0
	 		do while u < w
	 		 
	 			dest[u] = source[f shr 16] 
	 			f += fstep 
	 			dest[u+1] = source[f shr 16] 
	 			f += fstep 
	 			dest[u+2] = source[f shr 16] 
	 			f += fstep 
	 			dest[u+3] = source[f shr 16] 
	 			f += fstep 
	      u+=4
	 		loop
	 	end if
	 	dest += vid.rowbytes
	 next
End Sub



'scrap_dirty = _true
sub Draw_Pic (x as integer ,y as integer ,_name as  ZString ptr)
    dim as image_t	ptr pic 
	 dim as ubyte		ptr	dest,  source 
	 dim as integer				v, u 
	 dim as integer				tbyte 
	 dim as integer				_height 

	 pic = Draw_FindPic (_name) 
	 if (pic = NULL) then
	   ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", _name) 
	 	return 
	 EndIf
	 if ((x < 0) or _
	 	(x + pic->_width > vid._width) or _
	 	(y + pic->_height > vid._height)) then
	 	return 	'//	ri.Sys_Error (ERR_FATAL,"Draw_Pic: bad coordinates");
 end if
	 _height = pic->_height 
	 source = pic->pixels(0)
	 if (y < 0) then
	 
 		_height += y 
	 	source += pic->_width*-y 
	 	y = 0 
	 end if

	 dest = vid.buffer + y * vid.rowbytes + x 

	  if (pic->transparent = NULL) then
 
 		for  v=0 to _height-1 
	 
	  		memcpy (dest, source, pic->_width) 
	 		dest += vid.rowbytes 
	 		source += pic->_width 
	  next
	 
	 else
 
 		if (pic->_width and 7) then
	'	 	// general
	 		for  v=0 to _height - 1  
	 
	 			for  u=0 to u < pic->_width
	 				 if ( (tbyte= source[u]) <> TRANSPARENT_COLOR) then
	 				 	dest[u] = tbyte 
	 				 EndIf
	 					
	 			Next


	 			dest += vid.rowbytes 
	 			source += pic->_width 
	 		next
	 	 
	 	else
	 	 	'// unwound
 	for v = 0 to _height-1
 		
	  			u = 0
	         do while u < pic->_width
	   			if ( (tbyte=source[u]) <> TRANSPARENT_COLOR) then
	   				dest[u] = tbyte 
	   			EndIf
	 				if ( (tbyte=source[u+1]) <> TRANSPARENT_COLOR) then
	 					dest[u+1] = tbyte
	 				EndIf
	 				if ( (tbyte=source[u+2]) <> TRANSPARENT_COLOR) then
	 					dest[u+2] = tbyte
	 				EndIf
	 				if ( (tbyte=source[u+3]) <> TRANSPARENT_COLOR) then
	 					dest[u+3] = tbyte
	 				EndIf
	 				if ( (tbyte=source[u+4]) <> TRANSPARENT_COLOR) then
	 					dest[u+4] = tbyte
	 				EndIf
      			if ( (tbyte=source[u+5]) <> TRANSPARENT_COLOR) then
      				dest[u+5] = tbyte
      			EndIf
	 				if ( (tbyte=source[u+6]) <> TRANSPARENT_COLOR) then
	 						dest[u+6] = tbyte 
	 				EndIf
	 				if ( (tbyte=source[u+7]) <> TRANSPARENT_COLOR) then
	 					dest[u+7] = tbyte 
	 				EndIf
	 				
	 				u+=8	
 			    loop
	 			dest += vid.rowbytes 
	 			source += pic->_width 
	 	 	next
	 	 
	 end if
end if	 
	
End Sub
sub  Draw_Char (x as integer, y as integer, num as integer)
 	dim as ubyte			ptr dest 
 	dim as ubyte			ptr source 
 	dim as integer		   drawline 	
   dim as integer			row, col
 
 	num and= 255 
 
 	if (num = 32 or num = 32+128) then
 		return 
 	EndIf
   	
 
 	if (y <= -8) then
 		return '// totally off screen
 	EndIf

 
'//	if ( ( y + 8 ) >= vid.height )
 	if ( ( y + 8 ) > vid._height ) then '		// PGM - status text was missing in sw...
 		return
 	EndIf

 
 #ifdef PARANOID
 	if (y > vid.height - 8 or x < 0 or x > vid.width - 8) then
 		ri.Sys_Error (ERR_FATAL,"Con_DrawCharacter: (%i, %i)", x, y) 
 	if (num < 0 or num > 255) then
 		ri.Sys_Error (ERR_FATAL,"Con_DrawCharacter: char %i", num) 
 #endif
 
 	row = num shr 4 
 	col = num and 15 
 	source = draw_chars->pixels(0) + (row shl 10) + (col shl 3) 
 
 	if (y < 0) then
 	'	 	// clipped
    	drawline = 8 + y 
    	source -= 128*y
    	y = 0	
    	else
    	
    	drawline = 8
 	EndIf

 	dest = vid.buffer + y*vid.rowbytes + x 
 
 	while (drawline)
 
 		if (source[0] <> TRANSPARENT_COLOR) then
 			dest[0] = source[0] 
 		EndIf
 		if (source[1] <> TRANSPARENT_COLOR) then
 			dest[1] = source[1] 
 		EndIf
 		if (source[2] <> TRANSPARENT_COLOR) then
 			dest[2] = source[2] 
 		EndIf
 		if (source[3] <> TRANSPARENT_COLOR) then
 			dest[3] = source[3] 
 		EndIf
 		if (source[4] <> TRANSPARENT_COLOR) then
 			dest[4] = source[4]
 		EndIf
 		if (source[5] <> TRANSPARENT_COLOR) then
 			dest[5] = source[5] 
 		EndIf
 		if (source[6] <> TRANSPARENT_COLOR) then
 			dest[6] = source[6]
 		EndIf
 		if (source[7] <> TRANSPARENT_COLOR) then
 			dest[7] = source[7]
 		EndIf
 		source += 128 
 		dest += vid.rowbytes 
 		drawline-=1
 	wend
	
	
End Sub

 sub Draw_StretchRaw ( x as integer, y as integer,w  as integer,h  as integer,cols as integer, rows  as integer,_data as ubyte ptr) 
    dim  as image_t pic   	

	 pic.pixels(0) = _data 
	 pic._width = cols 
	 pic._height = rows 
	 Draw_StretchPicImplementation (x, y, w, h, @pic) 
 End Sub


sub  Draw_Fill (x as integer, y as integer,w  as integer,h  as integer,c as integer ) 
	 dim as ubyte	ptr	dest 
	 dim as integer				u, v 

	 if (x+w > vid._width)  then
	 	w = vid._width - x
	 EndIf
	  
	 if (y+h > vid._height) then
	 	h = vid._height - y
	 EndIf
	 	 
	 if (x < 0) then
	 
 		w += x 
	 	x = 0 
	 end if
	 
	 if (y < 0) then
	 	h += y
	 	y = 0
	 EndIf
 
	 if (w < 0 or h < 0) then
	 	return 
	 EndIf
	 	
	 	
	 dest = vid.buffer + y*vid.rowbytes + x 
	 for  v=0 to h-1  
	 	for  u=0 to w-1 
	 		dest[u] = c 
	 	next
	 	dest += vid.rowbytes
	 next
End Sub

sub  Draw_StretchPic (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
	 dim as image_t	ptr pic 

	 pic = Draw_FindPic (_name) 
	 if ( pic = NULL) then
	 
 		ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", _name) 
	 	return 
	end if
	 Draw_StretchPicImplementation (x, y, w, h, pic) 
End Sub

sub  Draw_TileClear (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
	dim as	integer			i, j 
	dim as ubyte	ptr	psrc 
	dim as ubyte	ptr pdest 
	dim as image_t		ptr pic 
	dim as	integer			x2 

	 if (x < 0) then
	 
    	w += x 
	 	x = 0 
	 end if
	 if (y < 0) then
	 
 		h += y 
	 	y = 0 
	 endif
	 if (x + w > vid._width) then
	 	w = vid._width - x
	 EndIf
	 if (y + h > vid._height) then
	 	h = vid._height - y
	 EndIf
	   
	 
	 if (w <= 0 or h <= 0) then
	 	return 
	 EndIf
	 	

	 pic = Draw_FindPic (_name) 
	 if ( pic = NULL) then
	 	ri.Con_Printf (PRINT_ALL, "Can't find pic: %s\n", _name) 
	 	return 
	 EndIf
	 
 
	 x2 = x + w 
	 pdest = vid.buffer + y*vid.rowbytes 
	 for i = 0 to h-1
	 	psrc = pic->pixels(0) + pic->_width * ((i+y) and 63)
	 	pdest += vid.rowbytes
	 	
	   for  j=x  to x2-1
			pdest[j] = psrc[j and 63] 
	 Next
	Next 
	 
  
	
End Sub

'/*
'=============
'Draw_FindPic
'=============
'*/
function Draw_FindPic (_name as ZString ptr) as image_t	ptr
 
	dim _image as  image_t ptr
	dim fullname as ZString * MAX_QPATH
     
   
	if (_name[0] <> asc("/") and _name[0] <> asc(!"\\")) then
  
		Com_sprintf (fullname, sizeof(fullname), "pics/%s.pcx", _name)
 
	 	 _image = R_FindImage (fullname, it_pic) 
	 
	else
	 
	 	_image = R_FindImage (_name+1, it_pic) 
	end if

	return _image 
end function

sub Draw_InitLocal ()
	 
	  draw_chars = Draw_FindPic ("conchars")
	   
End Sub





sub Draw_GetPicSize (w as integer ptr,  h as integer ptr ,pic as zstring ptr)
	dim gl as image_t ptr

	 gl = Draw_FindPic (pic) 
	 if (gl = NULL) then
	     *h  = -1 
	 	 *w = *h
	 	return 
	 end if
	 *w = gl->_width 
	 *h = gl->_height 
 
End Sub
 
 
 
/'
================
Draw_FadeScreen

================
'/ 
 sub Draw_FadeScreen
   dim as integer			x,y 
	dim as ubyte	ptr pbuf 
	dim as integer	t 

	for  y=0 to vid._height-1 
	 
		pbuf = cast(ubyte ptr,vid.buffer + vid.rowbytes*y) 
		t = (y and 1) shl 1 

		for  x = 0 to vid._width-1 
		 
			if ((x and 3) <> t) then
				pbuf[x] = 0 
		   end if
	   next
 	next
 End Sub


