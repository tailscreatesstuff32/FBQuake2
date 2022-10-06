'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''


type mvertex_t 

		position as vec3_t	
end type
'
type mmodel_t 
 
	as vec3_t		mins, maxs  
	as vec3_t		origin 	 
	radius as float	
 	headnode as integer			
	visleafs as integer			 
	as integer firstface, numfaces 
end type
 
#define	SIDE_FRONT	0
#define	SIDE_BACK	1
#define	SIDE_ON		2


#define SURF_PLANEBACK		2
#define SURF_DRAWSKY		4
#define SURF_DRAWTURB		&H10
#define SURF_DRAWBACKGROUND	&H40
#define SURF_UNDERWATER		&H80
'
'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type  medge_t
	  v(2) as ushort  
	 cachededgeoffset as UInteger
End Type
 

'
type mtexinfo_s
	vecs(2,4) as float
	flags as integer		
	numframes as  integer		
	_next as   mtexinfo_s ptr	
	_image as image_t ptr	 
end type: type mtexinfo_t as mtexinfo_s
'
 #define	VERTEXSIZE	7
'
type glpoly_s
	_next as glpoly_s ptr
	_chain as glpoly_s ptr
	numverts as  integer	
	flags as	integer				 
	verts(4,VERTEXSIZE) 	as float
 end type: type glpoly_t as glpoly_s
'
 type  msurface_s
 
 isframe as integer 
	 plane  as cplane_t ptr	
	 flags as integer 
 	 firstedge as integer 
	 numedges as integer 
	 texturemins(2) as short	
	 extents(2) as short	
    as	integer			light_s, light_t 
    as	integer			dlight_s, dlight_t 
	 polys as	glpoly_t ptr			 
 	 texturechain as msurface_s ptr 
	 lightmapchain  as  msurface_s ptr 
    texinfo as	mtexinfo_t ptr	 
	 dlightframe as integer		
    dlightbits as	integer			
	 lightmaptexturenum as integer	
	 styles(MAXLIGHTMAPS) as ubyte
	 cached_light(MAXLIGHTMAPS) as float	 
	 samples as byte ptr		 
 end type: type msurface_t  as msurface_s
 
type  mnode_s
	contents as integer			
 	visframe as integer	 
	minmaxs(6) as float	
	parent  as mnode_s ptr
	plane as cplane_t ptr
	children(2) as	 mnode_s ptr
	firstsurface as UShort
	numsurfaces as UShort
end type :type mnode_t as mnode_s
 
type  mleaf_s
	contents 	 as	integer 
   visframe as integer		
	minmaxs(6) as float	
	parent 	as	mnode_s ptr
	cluster 	as integer	
	area as integer			
	firstmarksurface as msurface_t ptr
   nummarksurfaces 	as integer			
end type :type mleaf_t as mleaf_s
 

 
 enum modtype_t   
 mod_bad, mod_brush, mod_sprite, mod_alias  
 
 
 End Enum

' vec3_t broken needs fixing
type model_s
	_name as ZString * MAX_QPATH 
	registration_sequence  as integer		
	
 	_type  as modtype_t	
 	numframes  as integer
 			
 	flags as 	integer		
 	
	as	vec3_t		mins, maxs 
	
	radius as  float
	clipbox as  qboolean 
	
	as vec3_t		clipmins, clipmaxs 
   as	integer	firstmodelsurface, nummodelsurfaces 
   
 	lightmap as Integer
   numsubmodels as Integer
   
 	submodels as mmodel_t	ptr
	numplanes as  integer
		
 	planes as cplane_t ptr
   numleafs as integer	
   
   leafs as mleaf_t ptr		 
	numvertexes  as	integer
			
 	vertexes as mvertex_t	ptr
   numedges  as integer	
   		
   edges as medge_t ptr
 	numnode as	integer
 			
   firstnod as	integer	
   nodes  as mnode_t	ptr
   
   numtexinfo   as integer			
	texinfo  as mtexinfo_t ptr
	
 	numsurfaces as integer		
 	surfaces as msurface_t ptr
 	
   numsurfedges as integer			
 	surfedges as integer ptr
 	
   nummarksurfaces  as integer			
   marksurfaces as msurface_t ptr ptr
   
   vis  as dvis_t	ptr
   
   lightdata as ubyte	 ptr
   
  '// for alias models and skins
  	skins(MAX_MD2SKINS)	as image_t ptr	 
   extradatasize as integer		 
	extradata as any ptr 
end type:type model_t as model_s

 
declare sub	Mod_Init ()
declare sub Mod_ClearAll() 
declare function Mod_ForName (  _name as ZString ptr, crash as qboolean  ) as model_t ptr
declare function _Mod_PointInLeaf ( p as float ptr ,  model as model_t ptr) as mleaf_t ptr
declare function Mod_PointInLeaf ( p as vec3_t,  model as model_t ptr) as mleaf_t ptr
declare function Mod_ClusterPVS ( cluster as integer, model as model_t ptr) as ubyte ptr
'
declare sub 	Mod_Modellist_f () 
'
 declare function _Hunk_Begin (maxsize as integer) as any ptr
 declare function _Hunk_Alloc (_size as integer) as any ptr
 declare function _Hunk_End () as integer
 declare sub _Hunk_Free (_base as any ptr)

declare sub Mod_FreeAll ()
declare sub Mod_Free (  _mod as model_t ptr)
 
