'FINISHED FOR NOW''''''''''''''''''''''''''''''''''''''''

#define	MAX_MAP_LEAFS		65536
#define ALIAS_VERSION	8

#define	MAX_TRIANGLES	4096
#define MAX_VERTS		2048
#define MAX_FRAMES		512
#define MAX_MD2SKINS	32
#define	MAX_SKINNAME	64
#define	MAXLIGHTMAPS	4



'/*
'========================================================================
'
'The .pak files are just a linear collapse of a directory tree
'
'========================================================================
'*/

#define IDPAKHEADER		((asc("K") shl 24)+(asc("C") shl 16)+(asc("A")shl 8)+asc("P"))

type dpackfile_t
	
	_name as zstring*56 
	as integer		_filepos, _filelen 

End Type

type  dpackheader_t 
	
		ident as integer			 
		dirofs as integer	
	   dirlen as integer		
 
End Type
 
	

#define	MAX_FILES_IN_PACK	4096
''/*
'========================================================================
'
'PCX files are used for as many images as possible
'
'========================================================================
'*/
type pcx_t
	 as byte	manufacturer 
    as byte	 version 
    as byte	_encoding 
    as byte	bits_per_pixel 
    as ushort	xmin,ymin,xmax,ymax 
    as ushort	hres,vres 
    as ubyte  _palette(48-1)
    as byte	reserved 
    as byte	color_planes 
    as ushort	bytes_per_line 
    as ushort	palette_type 
    as byte	filler(58-1) 
    as ubyte _data 
 
	
	
End Type

'/*
'========================================================================
'
'.MD2 triangle model file format
'
'========================================================================
'*/

#define IDALIASHEADER		((asc("2") shl 24)+(asc("P") shl 16)+(asc("D")shl 8)+asc("I"))
#define ALIAS_VERSION	8

#define MAX_TRIANGLES	4096
#define MAX_VERTS		   2048
#define MAX_FRAMES		512
#define MAX_MD2SKINS	   32
#define MAX_SKINNAME	   64

type  dstvert_t
	s as short
   t  as short	
End Type
 

  type dtriangle_t  
  	  index_xyz(3)	as short	
     index_st(3) as short	
  End Type


 

 type dtrivertx_t
		v(3) as ubyte
      lightnormalindex	as ubyte	 
 End Type
 
#define DTRIVERTX_V0   0
#define DTRIVERTX_V1   1
#define DTRIVERTX_V2   2
#define DTRIVERTX_LNI  3
#define DTRIVERTX_SIZE 4
 
 type daliasframe_t 
 	scale(3) as float			
	translate(3) as float			
	_name as ZString * 16 
	verts(1) as dtrivertx_t	
 	
 End Type
 

 type dmdl_t
 	
  ident     	as integer
  version   	as integer
            
  skinwidth 	as integer
  skinheight	as integer
  framesize 	as integer	'// byte size of each frame
            
  num_skins 	as integer
  num_xyz   	as integer
  num_st    	as integer		'// greater than num_xyz for seams
  num_tris  	as integer
  num_glcmds	as integer	'/ dwords in strip/fan command list
  num_frames	as integer
            
  ofs_skins 	as integer		'// each skin is a MAX_SKINNAME string
  ofs_st    	as integer		'// byte offset from start for stverts
  ofs_tris  	as integer		'// offset for dtriangles
  ofs_frames	as integer		'// offset for first frame
  ofs_glcmds	as integer	
  ofs_end   	as integer	'// end of file

 
 	
 End Type
 


'/*
'========================================================================
'
'.SP2 sprite file format
'
'========================================================================
'*/


#define IDSPRITEHEADER		((asc("2") shl 24)+(asc("S") shl 16)+(asc("D")shl 8)+asc("I"))
 
#define SPRITE_VERSION	2

type dsprframe_t

	as integer		_width, _height 
	as integer	 origin_x, origin_y 	
	_name as zstring * MAX_SKINNAME
end type

type dsprite_t
	ident     	as integer
   version   	as integer
	numframes  as integer			
	frames(1) as dsprframe_t
End Type

'/*
'==============================================================================
'
'  .WAL texture file format
'
'==============================================================================
'*/  

#define	MIPLEVELS	4
type  miptex_s


	_name as zstring*32 
	as uinteger	_width, _height 
	offsets(MIPLEVELS) as uinteger 
	animname as zstring*32    
	flags as integer			
	contents as integer				
	value as integer				

	
	
End Type: type miptex_t as miptex_s 
 

'/*
'==============================================================================
'
'  .BSP file format
'
'==============================================================================
'*/

#define IDBSPHEADER	((asc("P") shl 24)+(asc("S") shl 16)+(asc("B")shl 8)+asc("I"))
 

#define BSPVERSION	38

 
#define	MAX_MAP_MODELS		1024
#define	MAX_MAP_BRUSHES		8192
#define	MAX_MAP_ENTITIES	2048
#define	MAX_MAP_ENTSTRING	&H40000
#define	MAX_MAP_TEXINFO		8192

#define	MAX_MAP_AREAS		256
#define	MAX_MAP_AREAPORTALS	1024
#define	MAX_MAP_PLANES		65536
#define	MAX_MAP_NODES		65536
#define	MAX_MAP_BRUSHSIDES	65536
#define	MAX_MAP_LEAFS		65536
#define	MAX_MAP_VERTS		65536
#define	MAX_MAP_FACES		65536
#define	MAX_MAP_LEAFFACES	65536
#define	MAX_MAP_LEAFBRUSHES 65536
#define	MAX_MAP_PORTALS		65536
#define	MAX_MAP_EDGES		128000
#define	MAX_MAP_SURFEDGES	256000
#define	MAX_MAP_LIGHTING	&H200000
#define	MAX_MAP_VISIBILITY	&H100000


#define	MAX_KEY		32
#define	MAX_VALUE	1024

'//=============================================================================

type lump_t
		as integer		fileofs, _filelen 
	
End Type
 

 

#define	LUMP_ENTITIES		0
#define	LUMP_PLANES			1
#define	LUMP_VERTEXES		2
#define	LUMP_VISIBILITY		3
#define	LUMP_NODES			4
#define	LUMP_TEXINFO		5
#define	LUMP_FACES			6
#define	LUMP_LIGHTING		7
#define	LUMP_LEAFS			8
#define	LUMP_LEAFFACES		9
#define	LUMP_LEAFBRUSHES	10
#define	LUMP_EDGES			11
#define	LUMP_SURFEDGES		12
#define	LUMP_MODELS			13
#define	LUMP_BRUSHES		14
#define	LUMP_BRUSHSIDES		15
#define	LUMP_POP			16
#define	LUMP_AREAS			17
#define	LUMP_AREAPORTALS	18
#define	HEADER_LUMPS		19

type dheader_t
	ident as integer			 
	version as integer			
	lumps(HEADER_LUMPS) as lump_t		 
	
End Type
 

 

type dmodel_t 
	as float		mins(3), maxs(3) 
	origin(3)	 as float			  
	headnode as integer			 
	as integer	firstface, numfaces  		
End Type
 
 
 

 


type dvertex_t 
	_point(3) as float		
End Type
 
 


 #define	PLANE_X			0
#define	PLANE_Y			1
#define	PLANE_Z			2

 
#define	PLANE_ANYX		3
#define	PLANE_ANYY		4
#define	PLANE_ANYZ		5

 

type dplane_t
	
	normal(3)  as float
	dist   as float	 
	_type  as integer			 
   
End Type
 
 
#define	CONTENTS_SOLID			1		 
#define	CONTENTS_WINDOW			2		 
#define	CONTENTS_AUX			4
#define	CONTENTS_LAVA			8
#define	CONTENTS_SLIME			16
#define	CONTENTS_WATER			32
#define	CONTENTS_MIST			64
#define	LAST_VISIBLE_CONTENTS	64

 

#define	CONTENTS_AREAPORTAL		&H8000

#define	CONTENTS_PLAYERCLIP		&H10000
#define	CONTENTS_MONSTERCLIP	&H20000

 
#define	CONTENTS_CURRENT_0		&H40000
#define	CONTENTS_CURRENT_90		&H80000
#define	CONTENTS_CURRENT_180	&H100000
#define	CONTENTS_CURRENT_270	&H200000
#define	CONTENTS_CURRENT_UP		&H400000
#define	CONTENTS_CURRENT_DOWN	&H800000

#define	CONTENTS_ORIGIN			&H1000000	 

#define	CONTENTS_MONSTER		&H2000000	 
#define	CONTENTS_DEADMONSTER	&H4000000
#define	CONTENTS_DETAIL			&H8000000	 
#define	CONTENTS_TRANSLUCENT	&H10000000	 
#define	CONTENTS_LADDER			&H20000000



#define	SURF_LIGHT		&H1		 

#define	SURF_SLICK		&H2		 

#define	SURF_SKY		&H4		 
#define	SURF_WARP		&H8		 
#define	SURF_TRANS33	&H10
#define	SURF_TRANS66	&H20
#define	SURF_FLOWING	&H40	 
#define	SURF_NODRAW		&H80	 


type dvis_t
 
	numclusters  as integer			
	bitofs(8,2) as integer		
end type

type dnode_t
	planenum as integer			 
	children(2) as integer  
	mins(3) as short		  
	maxs(3) as short		 
	firstface as ushort	
	numfaces as ushort
	
End Type
 


 

type texinfo_s
	vecs(2,4)	as float			 
	flags as integer		 		 
	value as integer	
	texture(32) as byte		
	nexttexinfo as integer		
    
	
End Type: type texinfo_t as texinfo_s
 

 
type dedge_t
	
	  as	ushort	v(2)
	
	
End Type 

 


#define	MAXLIGHTMAPS	4
type  dface_t
	
	planenum as ushort	
	side as short		

	firstedge as integer	 
	numedges as short			
	texinfo as short		

 
	styles(MAXLIGHTMAPS) as byte		
	lightofs as integer			 
 
End Type
 


type dleaf_t
	
		contents   as integer				

	cluster as short		 
	area as short		 

		mins(3)	 as short				 
      maxs(3) as	short			

	firstleafface as  ushort	
	numleaffaces as  ushort

		firstleafbrush as ushort
	numleafbrushes as ushort
	
	
End Type
 

 

type dbrushside_t
		planenum as ushort 
		texinfo as short
  
End Type
 


type dbrush_t 
	
	firstside as integer 
	numsides as integer			  
	contents as integer
 
	
End Type
 


#define	ANGLE_UP	-1
#define	ANGLE_DOWN	-2

 
#define	DVIS_PVS	0
#define	DVIS_PHS	1



type dareaportal_t
	portalnum as integer		
	otherarea as integer	
	
End Type

 
 

  

type t
 
		numareaportals as integer	 
	firstareaportal as  integer		
end type: type darea_t as t








































