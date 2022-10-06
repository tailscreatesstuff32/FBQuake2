#Include "gl_local.bi"

screenres 640,480,32




 'dim shared	ri as refimport_t
 
 
 
 
swap_init
 
ri.FS_LoadFile = @FS_LoadFile
ri.FS_FreeFile = @FS_FreeFile


Draw_GetPalette ()
'cls
 		'print hex(Biglong(d_8to24table(255)),8)

 
 
#define RGBA_R( c ) ( CUInt( c ) Shr 16 And 255 )
#define RGBA_G( c ) ( CUInt( c ) Shr  8 And 255 )
#define RGBA_B( c ) ( CUInt( c )        And 255 )
#define RGBA_A( c ) ( CUInt( c ) Shr 24         )

' d_8to24table(x+(y*16))
 
 
 for y as integer = 0 to  16-1
 	 for x as integer = 0 to 16-1
 	 	
 	 	'pset(x,y),d_8to24table(x+(y*16))
 	 	line (x*16,y*16)-((x*16)+16-1,(y*16)+16-1),RGBA(RGBA_B(d_8to24table(x+(y*16))), RGBA_G(d_8to24table(x+(y*16))),RGBA_R(d_8to24table(x+(y*16))),RGBA_A(d_8to24table(x+(y*16))))  ,BF 
 	 	
 	 	
 	 Next
 	
 Next
 
 
 
 
 
 
  
'sleep
 