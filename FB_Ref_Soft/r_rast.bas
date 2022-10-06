#Include "FB_Ref_Soft\r_local.bi"


dim shared as integer      sintable(1280) 
dim shared  as integer      intsintable(1280) 
dim shared  as integer		blanktable(1280) 		'// PGM


dim shared  as clipplane_t	 ptr entity_clipplanes 
dim shared  as clipplane_t	view_clipplanes(4) 
dim shared  as clipplane_t	world_clipplanes(16) 
