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

'MIGHT DELETE'''''''''''
'declare sub shut_down1()
''''''''''''''''''''''''

declare sub R_BeginRegistration (_map as ZString ptr)
declare function R_RegisterModel (_name as ZString) as model_s ptr
'declare function R_RegisterSkin (_name as ZString) as image_s
declare sub R_SetSky (_name as ZString ptr,rotate as float , axis as  vec3_t) 
declare sub	R_EndRegistration () 

 
dim re as refexport_t	
		

dim test_mod as model_t ptr

ri.FS_LoadFile = @FS_LoadFile
ri.FS_FreeFile = @FS_FreeFile
 

Qcommon_init( __FB_ARGC__, __FB_ARGV__ ) 
Draw_GetPalette ()
Draw_InitLocal ()
 
 
 
 'test_mod = mod_forname("maps/base1.bsp",_true)
   'test_mod = mod_forname("models/weapons/g_launch/tris.md2",_true)
 'test_mod = mod_forname("sprites/s_bfg .sp2",_true)


 'sleep
 
'
 re.BeginRegistration = @R_BeginRegistration
 
 
  're.BeginRegistration("base1")
 
  re.RegisterModel = @R_RegisterModel
 
  test_mod = re.RegisterModel("models/weapons/g_launch/tris.md2")
 
 'print test_mod

 
 'sleep
 
 
 'print *test_mod->skins(0)->pic_d(0)
 
 
  print test_mod->extradatasize
  print test_mod->extradata 
  
  
 #if 1
    
    dim oldw as Integer = test_mod->skins(0)->_width
     dim oldh as Integer = test_mod->skins(0)->_height
     
     
    for  y as integer = 0 to  test_mod->skins(0)->_height - 1
		for x as integer = 0 to  test_mod->skins(0)->_width - 1
	 ' pset((x+(_screenwidth/2))-(_Width/2), (y+(_screenheight/2))-(_height/2)),RGBA (RGBA_B(_pic[x+(y*_width)]), RGBA_G(_pic[x+(y*_width)]),RGBA_R(_pic[x+(y*_width)]),RGBA_A(_pic[x+(y*_width)]))  
	'	 pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height/2)),rgba(RGBA_R(_pic[x+(y*_width)]),RGBA_G(_pic[x+(y*_width)]),RGBA_B(_pic[x+(y*_width)]),255)   
	     'pset((x+(_screenwidth/2))-(wal_test1->_width/2), (y+(_screenheight/2))-(wal_test1->_height /2)),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])) )
 	 	  'line (x*wal_test1->_width,y*wal_test1->_height)-((x*wal_test1->_width)+1 ,(y* wal_test1->_height)+1 ),RGBA (RGBA_B(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])), RGBA_G(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_R(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])),RGBA_A(d_8to24table(wal_test1->pic_d[x+(y*wal_test1->_width)])))  ,BF 
 	 	  
 	 	  
 	 	  'screen width 80 - 160
 	 	  'screen width 60 - 120
 	 	  
 	 	  
 	     dim zoom as integer = 1
 	  	  dim ofx as Integer = (((_screenwidth/zoom)/2) -test_mod->skins(0)->_width/2)-10 '((wal_test1->_width/3)*3)  '((_screenwidth/2))-(wal_test1->_width/2) 
 	  	  dim ofy as Integer = (((_screenheight/zoom)/2) -test_mod->skins(0)->_height/2)'-20 '((_screenheight/2))-(wal_test1->_height /2) 
 	 	  
 	    line ((x+ofx)*zoom,(y+ofy)*zoom)-((x+ofx+1)*zoom,(y+ofy+1)*zoom),RGBA (RGBA_B(d_8to24table(test_mod->skins(0)->pic_d(0)[x+(y*test_mod->skins(0)->_width)])), RGBA_G(d_8to24table(test_mod->skins(0)->pic_d(0)[x+(y*test_mod->skins(0)->_width)])),RGBA_R(d_8to24table(test_mod->skins(0)->pic_d(0)[x+(y*test_mod->skins(0)->_width)])),RGBA_A(d_8to24table(test_mod->skins(0)->pic_d(0)[x+(y*test_mod->skins(0)->_width)])))  ,BF 

		 
		 
		Next
	 Next
 
 
' cls
  Mod_Modellist_f ()
 
 'sleep
 
 		if test_mod->skins(0)->pic_d(0) <> NULL then
			free (test_mod->skins(0)->pic_d(0)) 
			 
			 
		EndIf
	  	if test_mod->skins(0)->pal_d <> NULL then
			 
			  free (test_mod->skins(0)->pal_d) 
			 
	  		EndIf
	
 #endif
 
 
 
 
 
 
 Mod_Free(test_mod)
 
 
 
 
 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
   Mod_Freeall()
  
 
 	GL_ShutdownImages ()
 	
 	'MIGHT DELETE''''''''''''
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
  

 
 
 
 
  