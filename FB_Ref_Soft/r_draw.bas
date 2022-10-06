
#Include "FB_Ref_Soft\r_local.bi"

extern draw_chars as image_t ptr	


dim shared draw_chars as image_t ptr		
dim shared draw_con as image_t ptr	


'extern	scrap_dirty  as qboolean	
declare sub Scrap_Upload () 


'scrap_dirty = _true
sub Draw_Pic (x as integer ,y as integer ,_name as  ZString ptr)
	
	
End Sub
sub  Draw_Char (x as integer, y as integer, c as integer)
	
	
	
End Sub

 sub Draw_StretchRaw ( x as integer, y as integer,w  as integer,h  as integer,cols as integer, rows  as integer,_data as ubyte ptr) 
 	
 End Sub


sub  Draw_Fill (x as integer, y as integer,w  as integer,h  as integer,c as integer ) 
	
End Sub

sub  Draw_StretchPic (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
	
End Sub

sub  Draw_TileClear (x as integer, y as integer,w  as integer,h  as integer,_name as ZString ptr)
	
	
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
		beep
	 	_image = R_FindImage (_name+1, it_pic) 
	end if

	return _image 
end function

sub Draw_InitLocal ()
	 
	  draw_chars = Draw_FindPic ("conchars") 
	
End Sub





sub Draw_GetPicSize (w as integer ptr,  h as integer ptr ,pic as zstring ptr)
	dim gl as image_t ptr

	'gl = Draw_FindPic (pic) 
	'if (gl = NULL) then
	'    *h  = -1 
	'	 *w = *h
	'	return 
	'end if
	'*w = gl->_width 
	'*h = gl->_height 
 
End Sub
 
 sub Draw_FadeScreen
 	
 	
 End Sub








function R_RegisterSkin (_name as ZString ptr ) as image_s ptr
	
End Function
	
