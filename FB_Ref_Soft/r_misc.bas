#Include "FB_Ref_Soft\r_local.bi"

#define NUM_MIPS	4

dim shared as cvar_t	ptr sw_mipcap
dim shared as cvar_t	ptr sw_mipscale 


extern "C"
extern alias_colormap as zstring ptr 
end extern


dim shared alias_colormap as zstring ptr 

 dim shared as integer		d_scantable(MAXHEIGHT)
 
 
 
 type _TargaHeader  
 	
   as ubyte 	id_length, colormap_type, image_type 
 	as ushort	colormap_index, colormap_length 
 	as ubyte	colormap_size 
   as ushort	x_origin, y_origin, width, height 
 	as ubyte	pixel_size, attributes 
 
 	
 End Type: type TargaHeader as _TargaHeader
 
dim shared as Integer	d_pix_min, d_pix_max, d_pix_shift 
 
 
dim shared	as integer d_vrectx, d_vrecty, d_vrectright_particle, d_vrectbottom_particle 

sub R_SetupFrame ()
	
	
End Sub


 sub R_TransformFrustum ()
 	
 End Sub



'#if !(defined __linux__ && defined __i386__)
 #ifndef  id386
'
'/*
'================
'TransformVector
'================
'*/
'void TransformVector (vec3_t in, vec3_t out)
'{'
'	out[0] = DotProduct(in,vright);'
	'out[1] = DotProduct(in,vup);
'	out[2] = DotProduct(in,vpn);		
'}
'
 #else
 
 
'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''
sub TransformVector naked (vin as  vec3_t ptr ,vout as vec3_t ptr)
 asm
 	
 	   .intel_syntax noprefix
 	   
	 mov eax, dword ptr [esp+4]
	 mov edx, dword ptr [esp+8]

	 fld  dword ptr [eax+0]
	 fmul dword ptr [vright+0]
	 fld  dword ptr [eax+0]
	 fmul dword ptr [vup+0]
	 fld  dword ptr [eax+0]
	 fmul dword ptr [vpn+0]

	 fld  dword ptr [eax+4]
	 fmul dword ptr [vright+4]
	 fld  dword ptr [eax+4]
	 fmul dword ptr [vup+4]
	 fld  dword ptr [eax+4]
	 fmul dword ptr [vpn+4]

	 fxch st(2)

	 faddp st(5), st(0)
	 faddp st(3), st(0)
	 faddp st(1), st(0)

	 fld  dword ptr [eax+8]
	 fmul dword ptr [vright+8]
	 fld  dword ptr [eax+8]
	 fmul dword ptr [vup+8]
	 fld  dword ptr [eax+8]
	 fmul dword ptr [vpn+8]

	 fxch st(2)

	 faddp st(5), st(0)
	 faddp st(3), st(0)
	 faddp st(1), st(0)

	 fstp dword ptr [edx+8]
	 fstp dword ptr [edx+4]
	 fstp dword ptr [edx+0]

	 ret
 end asm
end sub

#endif
'#endif


/'
=============
R_PrintAliasStats
=============
'/
sub R_PrintAliasStats ()
	ri.Con_Printf (PRINT_ALL,!"%3i polygon model drawn\n", r_amodels_drawn) 
End Sub
 
 
sub R_PrintTimes  ()
	
End Sub

sub R_PrintDSpeeds
	
End Sub


#if	 id386

/'
================
R_SurfacePatch
================
'/
sub R_SurfacePatch ()
	'// we only patch code on Intel
End Sub
 
#endif	'// !id386
