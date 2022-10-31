'/*
'Copyright (C) 1997-2001 Id Software, Inc.
'
'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
'
'See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
'
'*/

#ifndef __MODEL__
#define __MODEL__

'/*
'
'd*_t structures are on-disk representations
'm*_t structures are in-memory
'
'*/






'/*
'==============================================================================
'
'BRUSH MODELS
'
'==============================================================================
'*/



'//
'// in memory representation
'//
'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type mvertex_t
	as 	vec3_t		position 
End Type
 

 

#define	SIDE_FRONT	0
#define	SIDE_BACK	1
#define	SIDE_ON		2



'// plane_t structure
'// !!! if this is changed, it must be changed in asm_i386.h too !!!
type  mplane_s
	
	as vec3_t normal 
	as float	 dist 
	as ubyte _type
	as ubyte	signbits
	as ubyte	pad(2)
	
	
End Type: type mplane_t as mplane_s



'// FIXME: differentiate from texinfo SURF_ flags
#define	SURF_PLANEBACK		2
#define	SURF_DRAWSKY		4			'// sky brush face
#define SURF_DRAWTURB		&H10
#define SURF_DRAWBACKGROUND	&H40
#define SURF_DRAWSKYBOX		&H80		'// sky box

#define SURF_FLOW			&H100		'//PGM


 


'// !!! if this is changed, it must be changed in asm_draw.h too !!!
type  medge_t
	  v(2) as ushort  
	 cachededgeoffset as UInteger
End Type
 



type mtexinfo_s
	vecs(2,4) as float
	mipadjust as float
	flags as integer		
	numframes as  integer		
	_image as image_t ptr	 
	 _next as mtexinfo_s ptr '// animation chain
end type: type mtexinfo_t as mtexinfo_s 


 type  msurface_s
 
 
 
   visframe 	as integer					'// should be drawn when node is crossed

	dlightframe as integer		   
	dlightbits as integer			
 
	 plane  as mplane_t ptr	
	 flags as integer 
	 
 	 firstedge as integer '// look up in model->surfedges[], negative numbers
	 numedges as integer '// are backwards edges
	 
'// surface generation data	  
	 as surfcache_s  ptr cachespots(MIPLEVELS)

	  
	 texturemins(2) as short	
	 extents(2) as short	
	 
	 texinfo as	mtexinfo_t ptr	
	 	
'// lighting info
	  styles(MAXLIGHTMAPS) as ubyte 
	 samples as byte ptr		'// [numstyles*surfsize] 
	 



	
	nextalphasurface as msurface_s  ptr 
	
 end type: type msurface_t  as msurface_s




#define	CONTENTS_NODE	-1



type  mnode_s
	contents as integer			
 	visframe as integer	
 	 
	minmaxs(6) as float	
	
	parent  as mnode_s ptr
	
	plane as mplane_t ptr
	
	children(2) as	 mnode_s ptr
	
	firstsurface as UShort
	numsurfaces as UShort
end type :type mnode_t as mnode_s



 'ADJUSTED
type  mleaf_s
	contents 	 as	integer 
   visframe as integer		
	minmaxs(6) as float	
	parent 	as	mnode_s ptr
	cluster 	as integer	
	area as integer			
	firstmarksurface as msurface_t ptr ptr
   nummarksurfaces 	as integer
   key as integer 			
end type :type mleaf_t as mleaf_s
 


'//
'// Whole model
'//

 enum modtype_t   
 mod_bad, mod_brush, mod_sprite, mod_alias  
 
 
 End Enum

 
 


'ADJUSTED
' vec3_t broken needs fixing
type model_s_
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
   
 	submodels as dmodel_t	ptr
	numplanes as  integer
		
 	planes as cplane_t ptr
   numleafs as integer	
   
   leafs as mleaf_t ptr		 
	numvertexes  as	integer
			
 	vertexes as mvertex_t	ptr
   numedges  as integer	
   		
   edges as medge_t ptr
 	numnodes as	integer
 			
   firstnode as	integer	
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









'//============================================================================

declare sub  Mod_Init () 
declare sub  Mod_ClearAll ()
declare function Mod_ForName (_name as zstring ptr, crash as qboolean ) as model_t ptr
declare function Mod_Extradata (_mod as model_t ptr) as any ptr  	'// handles caching
declare sub	Mod_TouchModel (_name as zstring ptr) 

declare function Mod_PointInLeaf (p as float ptr ,model as model_t ptr) as mleaf_t ptr
declare function Mod_ClusterPVS (cluster as integer ,model as  model_t ptr) as ubyte	ptr

 declare function _Hunk_Begin (maxsize as integer) as any ptr
 declare function _Hunk_Alloc (_size as integer) as any ptr
 declare function _Hunk_End () as integer
 declare sub _Hunk_Free (_base as any ptr)

declare sub  Mod_Modellist_f () 
declare sub  Mod_FreeAll () 
declare sub  Mod_Free (_mod as model_t ptr) 

extern	as integer		registration_sequence 

#endif	'// __MODEL__

 