#Include "FB_Ref_Soft\r_local.bi"


dim shared as  mtexinfo_t		r_skytexinfo(6)
 
dim shared as qboolean		r_nearzionly


dim shared as integer      sintable(1280) 
dim shared  as integer      intsintable(1280) 
dim shared  as integer		blanktable(1280) 		'// PGM


dim shared  as clipplane_t	 ptr entity_clipplanes 
dim shared  as clipplane_t	view_clipplanes(4) 
dim shared  as clipplane_t	world_clipplanes(16) 

dim shared  as qboolean		r_lastvertvalid

dim shared  as integer				r_emitted 
dim shared  as float			      r_nearzi 
dim shared as float			r_u1, r_v1, r_lzi1
dim shared as integer	   r_ceilv1

dim shared as integer		cacheoffset 

extern "C"

extern as medge_t			ptr r_pedge


extern as qboolean		r_leftclipped, r_rightclipped 

extern as mvertex_t	r_leftenter, r_leftexit 
extern as mvertex_t	r_rightenter, r_rightexit 


 
end extern


dim shared  as mvertex_t	r_leftenter, r_leftexit 
dim shared  as mvertex_t	r_rightenter, r_rightexit 


dim shared  as qboolean 	r_leftclipped, r_rightclipped
dim shared as medge_t			ptr r_pedge 
