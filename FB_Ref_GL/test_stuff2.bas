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



 function Draw_PCX (pic1 as zstring ptr) as integer 
 		dim i  as integer	
	dim as integer 	r, g, b 
	dim v as uinteger
	dim as ubyte ptr 	 _pic,  _pal
	dim as integer		_width,_height 

    LoadPCX (pic1, @_pic, @_pal, @_width, @_height)
	 if (_pal = NULL) then
		   ' ri.Sys_Error (ERR_FATAL, "Couldn't load pics/colormap.pcx") 
		   'print "Couldn't load pics/colormap.pcx"
		  
		   printf  (!"Couldn't load %s\n", pic1)
		   
		   
		   return 0
	 EndIf
	 
	 	
		
	 
	 
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
		 pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(d_8to24table(_pic[x+(y*_width)])), RGBA_G(d_8to24table(_pic[x+(y*_width)])),RGBA_R(d_8to24table(_pic[x+(y*_width)])),RGBA_A(d_8to24table(_pic[x+(y*_width)])) )
		 
		 
		 
	Next
	
	
		
		
	Next
	
 
		
	free (_pic) 
	free (_pal) 

	return 0
	

 End Function





 'dim shared	ri as refimport_t
 
 
 
 



'Draw_PCX ("conback.pcx")

'draw_targa("devi_pic1_.tga")
 
'draw_targa("test1.tga")
 
 'draw_targa("devi_pic2_un.tga")
 
 
 'GL_loadwal("grass1_3.wal")
 
 

 
  

 
 
  
 
' 
 ri.FS_LoadFile = @FS_LoadFile
ri.FS_FreeFile = @FS_FreeFile



Qcommon_init( __FB_ARGC__, __FB_ARGV__ ) 
Draw_GetPalette ()

'Draw_PCX ("pics/conback.pcx")
draw_targa("env/space1bk.tga")


  'GL_FindImage("pics/colormap.pcx", NULL)
  
  
  
      

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
'sleep
'  Return 0
'
'End Function
' 
  

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 