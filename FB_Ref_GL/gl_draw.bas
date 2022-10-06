' WORK IN PROGRESS''''''''''''''''''''''''''''''''''''



#Include "gl_local.bi"

extern draw_chars as image_t ptr	


dim shared draw_chars as image_t ptr		
dim shared draw_con as image_t ptr	


'extern	scrap_dirty  as qboolean	
declare sub Scrap_Upload () 


'scrap_dirty = _true

sub Draw_InitLocal ()
 
 
 
	 
	 draw_chars = GL_FindImage ("pics/conchars.pcx", it_pic) 
	 'print draw_chars->texnum
	 
	 
	 GL_Bind( draw_chars->texnum )
	 'qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST) 
	 'qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST) 
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
	 glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST) 
	
End Sub


'/*
'=============
'Draw_FindPic
'=============
'*/
function Draw_FindPic (_name as ZString ptr) as image_t	ptr
 
	dim gl as  image_t ptr
	dim fullname as ZString * MAX_QPATH
     
   
	if (_name[0] <> asc(!"/") and _name[0] <> asc(!"\\") then
  
		Com_sprintf (fullname, sizeof(fullname), "pics/%s.pcx", _name)
 
		 gl = GL_FindImage (fullname, it_pic) 
	 
	else
		beep
		 gl = GL_FindImage (_name+1, it_pic) 
	end if

	return gl 
end function



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
 
