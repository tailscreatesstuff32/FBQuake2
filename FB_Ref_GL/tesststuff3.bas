 'Option Escape

'Declare Function main _
'  ( _
'    ByVal argc As Integer, _
'    ByVal argv As ZString Ptr Ptr _
'  ) As Integer
'
'  End main( __FB_ARGC__, __FB_ARGV__ ) 
' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 
' 
 
 
 
 extern _screenwidth as Integer
extern _screenheight as Integer


#define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CUInt( c )        And 255 )
#define RGBA_A( c ) ( CUInt( c ) Shr 24         )


#include "fbgfx.bi"
using fb

_screenwidth = 640
_screenheight = 480

dim shared as integer _screenwidth,_screenheight 
screenres _screenwidth,_screenheight,32,,GFX_ALPHA_PRIMITIVES 



#Include "gl_local.bi"

declare sub LoadTGA (_name as zstring ptr, _pic as ubyte ptr ptr,_width as  integer ptr ,  height as  integer ptr)
declare function GL_LoadWal(_name as ZString ptr) as image_t ptr

'MIGHT DELETE'''''''''''''
'declare sub shut_down1()
''''''''''''''''''''''''''

	 dim shared lev as Integer
	 
 lev = 0

 function Draw_TARGA (pic1 as zstring ptr) as integer 
 	
 	 		dim i  as integer	
	dim as integer 	r, g, b 
	dim v as uinteger
	dim as ubyte ptr 	 _pic,  _pal
	dim as integer		_width,_height 
 	
 	LoadTGA (pic1, @_pic, @_width, @_height)
 		 if (_pic = NULL) then
	 
		   printf  (!"Couldn't load %s\n", pic1)
		   
		   
		   return 0
 		 EndIf
 		 
 		 
	 	for  y as integer = 0 to  _height-1
		
		for x as integer = 0 to _width -1
		' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		  'pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
 pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA(RGBA_B(cast(uinteger ptr,_pic)[x+(y*_width)]),RGBA_G(cast(uinteger ptr,_pic)[x+(y*_width)]),RGBA_R(cast(uinteger ptr,_pic)[x+(y*_width)]),RGBA_A(cast(uinteger ptr,_pic)[x+(y*_width)]))
  


		 
		 
		Next
	 	Next
 
 
  
		
	free (_pic) 
   
 
 End Function


declare function Draw_FindPic (_name as ZString ptr) as image_t	ptr
 function Draw_PCX (pic1 as zstring ptr) as integer 
 		dim i  as integer	
	dim as integer 	r, g, b 
	dim v as uinteger
	dim as ubyte ptr 	 _pic,  _pal
	dim as integer		_width,_height
	dim test as image_s ptr

    'LoadPCX (pic1, @_pic, @_pal, @_width, @_height)
	 'if (_pal = NULL) then
		   ' ri.Sys_Error (ERR_FATAL, "Couldn't load pics/colormap.pcx") 
		   'print "Couldn't load pics/colormap.pcx"
		  
		 '  printf  (!"Couldn't load %s\n", pic1)
		   
		   
		  ' return 0
	 'EndIf
	 '
	 '	
		
	 '_pic = GL_FindImage(pic1, it_pic)
	 test = draw_findpic(pic1)
	 
	 if test  = NULL then
	 	 'beep
	     return 0
	 EndIf
	 
	 

	 
	  _width =  test->_width
	  _height =  test->_height
	  'print test->_width
	  'print test->_height
	  ' print"===================="
	   'print test->pic_d
	
	
	 
	   
	   
	 'for i = 0 to 256-1
	 '	
	 '	r = _pal[i*3+0] 
		'g = _pal[i*3+1] 
	'	b = _pal[i*3+2] 
	 '	
	 '	  v= (255 shl 24) + (r shl 0) + (g shl 8) + (b shl 16) 
		'd_8to24table(i) = LittleLong(v) 
		'
	 'Next
	 '
	 'd_8to24table(255) and= LittleLong(&Hffffff)
		

	for  y as integer = 0 to  _height-1
		
		for x as integer = 0 to _width -1
		 pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(d_8to24table(test->pic_d(lev)[x+(y*_width)])), RGBA_G(d_8to24table(test->pic_d(lev)[x+(y*_width)])),RGBA_R(d_8to24table(test->pic_d(lev)[x+(y*_width)])),RGBA_A(d_8to24table(test->pic_d(lev)[x+(y*_width)])) )
		 
		 
		 
	Next
	
	
		
		
	Next
	
 
		
		if test->pic_d(lev) <> NULL then
			free (test->pic_d(lev)) 
			 
			 
		EndIf
	 		if test->pal_d <> NULL then
			 
			  free (test->pal_d) 
			 
	 		EndIf
	
	 







	return 0
	

 End Function



 
ri.FS_LoadFile = @FS_LoadFile
ri.FS_FreeFile = @FS_FreeFile



Qcommon_init( __FB_ARGC__, __FB_ARGV__ ) 
Draw_GetPalette ()
 
 
 dim wal_test1 as image_t ptr
 
 
  'Draw_PCX("conchars") 


Draw_InitLocal ()

    'GL_FindImage("pics/m_main.pcx", it_pic) 
    
    
    
  ' Draw_PCX("conback") 
    wal_test1 = GL_FindImage("textures/e1u1/crate1_3.wal",It_wall)
  
  
  
  
  
  
 '   print wal_test1->pic_d[1]
 '   
 '   
 '   	 	for  y as integer = 0 to  wal_test1->_height - 1
		
	'	for x as integer = 0 to  wal_test1->_width - 1
		' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		  'pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
 'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),RGBA(RGBA_B(wal_test1->pic_d[x+(y*wal_test1->_width )]),RGBA_G(wal_test1->pic_d[x+(y*wal_test1->_width)]),RGBA_R(wal_test1->pic_d[x+(y*wal_test1->_width)]),RGBA_A(wal_test1->pic_d[x+(y*wal_test1->_width)]))
 ' 


		 
		 
	'	Next
	 '	Next
 '
    
    dim oldw as Integer = wal_test1->_width
     dim oldh as Integer = wal_test1->_height
     
     
     for  y as integer = 0 to  wal_test1->_height - 1
		for x as integer = 0 to  wal_test1->_width - 1
	 ' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		 'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
	     'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height /2)),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])) )
 	 	  'line (x*wal_test1->_width,y*wal_test1->_height)-((x*wal_test1->_width)+1 ,(y* wal_test1->_height)+1 ),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])))  ,BF 
 	 	  
 	 	  
 	 	  'screen width 80 - 160
 	 	  'screen width 60 - 120
 	 	  
 	 	  
 	 	  dim zoom as integer = 4
 	 	  dim ofx as Integer = (((_screenwidth/zoom)/2) -wal_test1->_width/2)-10 '((wal_test1->_width/3)*3)  '((_screenwidth/2))-(wal_test1->_width/2) 
 	 	  dim ofy as Integer = (((_screenheight/zoom)/2) -wal_test1->_height/2)'-20 '((_screenheight/2))-(wal_test1->_height /2) 
 	 	  
 	 	  line ((x+ofx)*zoom,(y+ofy)*zoom)-((x+ofx+1)*zoom,(y+ofy+1)*zoom),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])))  ,BF 

		 
		 
		Next
	 	Next
 
 
 
 
 
 
 		if wal_test1->pic_d(lev) <> NULL then
			free (wal_test1->pic_d(lev)) 
			 
			 
		EndIf
	 		if wal_test1->pal_d <> NULL then
			 
			  free (wal_test1->pal_d) 
			 
	 		EndIf
	
	 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

lev = 1


wal_test1->_width = oldw
wal_test1->_height = oldh

wal_test1->_width /=2
wal_test1->_height /=2


      for  y as integer = 0 to   wal_test1->_height  - 1
		for x as integer = 0 to  wal_test1->_width - 1
	 ' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		 'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
	     'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height /2)),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])) )
 	 	  'line (x*wal_test1->_width,y*wal_test1->_height)-((x*wal_test1->_width)+1 ,(y* wal_test1->_height)+1 ),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])))  ,BF 
 	 	  
 	 	  
 	 	  'screen width 80 - 160
 	 	  'screen width 60 - 120
 	 	  
 	 	  
 	 	  dim zoom as integer = 4
 	 	  dim ofx as Integer = (((_screenwidth/zoom)/2) -wal_test1->_width/2)+35+10 '((wal_test1->_width/3)*3)  '((_screenwidth/2))-(wal_test1->_width/2) 
 	 	  dim ofy as Integer = (((_screenheight/zoom)/2) -wal_test1->_height/2) - 16 '((_screenheight/2))-(wal_test1->_height /2) 
 	   line ((x+ofx)*zoom,(y+ofy)*zoom)-((x+ofx+1)*zoom,(y+ofy+1)*zoom),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])))  ,BF 
		 
		 
		Next
	 	Next
 
 
 
 
 
 
 		if wal_test1->pic_d(lev) <> NULL then
			free (wal_test1->pic_d(lev)) 
			 
			 
		EndIf
	 		if wal_test1->pal_d <> NULL then
			 
			  free (wal_test1->pal_d) 
			 
	 		EndIf
	
	 
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

lev = 2

wal_test1->_width = oldw
wal_test1->_height = oldh

wal_test1->_width /=4
wal_test1->_height /=4


      for  y as integer = 0 to   wal_test1->_height  - 1
		for x as integer = 0 to  wal_test1->_width - 1
	 ' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		 'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
	     'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height /2)),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])) )
 	 	  'line (x*wal_test1->_width,y*wal_test1->_height)-((x*wal_test1->_width)+1 ,(y* wal_test1->_height)+1 ),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])))  ,BF 
 	 	  
 	 	  
 	 	  'screen width 80 - 160
 	 	  'screen width 60 - 120
 	 	  
 	 	  
 	 	  dim zoom as integer = 4
 	 	  dim ofx as Integer = (((_screenwidth/zoom)/2) -wal_test1->_width/2)+(35+10)-8'((wal_test1->_width/3)*3)  '((_screenwidth/2))-(wal_test1->_width/2) 
 	 	  dim ofy as Integer = (((_screenheight/zoom)/2) -wal_test1->_height/2)+14'((_screenheight/2))-(wal_test1->_height /2) 
 	   line ((x+ofx)*zoom,(y+ofy)*zoom)-((x+ofx+1)*zoom,(y+ofy+1)*zoom),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])))  ,BF 
		 
		 
		Next
	 	Next
 
 
 
 
 
 
 		if wal_test1->pic_d(lev) <> NULL then
			free (wal_test1->pic_d(lev)) 
			 
			 
		EndIf
	 		if wal_test1->pal_d <> NULL then
			 
			  free (wal_test1->pal_d) 
			 
	 		EndIf
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
 
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

lev = 3
wal_test1->_width = oldw
wal_test1->_height = oldh

wal_test1->_width /=8
wal_test1->_height /=8


      for  y as integer = 0 to   wal_test1->_height  - 1
		for x as integer = 0 to  wal_test1->_width - 1
	 ' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
		 'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
	     'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height /2)),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])) )
 	 	  'line (x*wal_test1->_width,y*wal_test1->_height)-((x*wal_test1->_width)+1 ,(y* wal_test1->_height)+1 ),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])))  ,BF 
 	 	  
 	 	  
 	 	  'screen width 80 - 160
 	 	  'screen width 60 - 120
 	 	  
 	 	  
 	 	  dim zoom as integer = 4
 	 	  dim ofx as Integer = (((_screenwidth/zoom)/2) -wal_test1->_width/2)+45+(14-4)  '((wal_test1->_width/3)*3)  '((_screenwidth/2))-(wal_test1->_width/2) 
 	 	  dim ofy as Integer = (((_screenheight/zoom)/2) -wal_test1->_height/2)+10 '((_screenheight/2))-(wal_test1->_height /2) 
 	   line ((x+ofx)*zoom,(y+ofy)*zoom)-((x+ofx+1)*zoom,(y+ofy+1)*zoom),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d(lev)[x+(y*wal_test1->_width)])))  ,BF 
		 
		 
		Next
	 	Next
 
 
 
 
 
 
 		if wal_test1->pic_d(lev) <> NULL then
			free (wal_test1->pic_d(lev)) 
			 
			 
		EndIf
	 		if wal_test1->pal_d <> NULL then
			 
			  free (wal_test1->pal_d) 
			 
	 		EndIf
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
    
  '+wal_test1->_height-1  
  '+wal_test1->_width-1
  
  
  
  
   'GL_bind(wal_test1->texnum)
 	GL_ShutdownImages ()
 	
 	'MIGHT DELETE!'''''''''''
	shut_down1()     
   '''''''''''''''''''''''''
'sleep
 




 

'Private Function main _
'  ( _
'    ByVal argc As Integer, _
'    ByVal argv As ZString Ptr Ptr _
'  ) As Integer
'
'
' 
' ri.FS_LoadFile = @FS_LoadFile
'ri.FS_FreeFile = @FS_FreeFile
'
'
'
'Qcommon_init(argc,argv)
'
'   GL_FindImage("pics/conback.pcx", NULL)
'      
'
sleep
'  Return 0
'
'End Function
' 
  

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 