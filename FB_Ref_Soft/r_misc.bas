#Include "FB_Ref_Soft\r_local.bi"

#define NUM_MIPS	4

dim shared as cvar_t	ptr sw_mipcap
dim shared as cvar_t	ptr sw_mipscale 


 
 type _TargaHeader  
 	
   as ubyte 	id_length, colormap_type, image_type 
 	as ushort	colormap_index, colormap_length 
 	as ubyte	colormap_size 
   as ushort	x_origin, y_origin, width, height 
 	as ubyte	pixel_size, attributes 
 
 	
 End Type: type TargaHeader as _TargaHeader

