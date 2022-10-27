#Include "FB_Ref_Soft\r_local.bi"

dim shared as vec3_t r_pright, r_pup, r_ppn 

#define PARTICLE_33     0
#define PARTICLE_66     1
#define PARTICLE_OPAQUE 2


type partparms_t
   as particle_t ptr particle 
	as integer         level 
	as integer         _color 
End Type
 
 
 static shared as partparms_t partparms 
'''''''''''''''''''''''''''''''''''''''''''
dim shared as pixel_t ptr  vid_alphamap
 
vid_alphamap = @vid.alphamap

dim shared partparms_level as integer ptr
partparms_level = @partparms.level

dim shared partparms_particle as particle_t ptr
partparms_particle  = @partparms_particle

dim shared partparms_color as integer ptr
partparms_color  = @partparms_color


'''''''''''''''''''''''''''''''''''''''''''





#if id386 '&& !defined __linux__


static shared as ulong s_prefetch_address 

/'
** BlendParticleXX
**
** Inputs:
** EAX = color
** EDI = pdest
**
** Scratch:
** EBX = scratch (dstcolor)
** EBP = scratch
**
** Outputs:
** none
'/


sub R_DrawParticles ()
	
End Sub

sub BlendParticle33 naked ()

	
 	

 
	asm
		
 	   .intel_syntax noprefix
			'//	return vid.alphamap[color + dstcolor*256]#
			
	 'mov ebp, vid.alphamap
	 mov ebp, dword ptr [vid_alphamap]
	 xor ebx, ebx

	 mov bl,  byte ptr [edi]
	 shl ebx, 8

	 add ebp, ebx
	 add ebp, eax

	 mov al,  byte ptr [ebp]

	 mov byte ptr [edi], al

	 ret	
		
		
	End Asm

	 
End Sub
 

 

sub BlendParticle66 naked ()
	asm
		   .intel_syntax noprefix
	 '//	return vid.alphamap[pcolor*256 + dstcolor]#
	 'mov ebp, vid.alphamap
	 mov ebp, dword ptr [vid_alphamap]
	 xor ebx, ebx

	 shl eax,  8
	 mov bl,   byte ptr [edi]

	 add ebp, ebx
	 add ebp, eax

	 mov al,  byte ptr [ebp]

	 mov byte ptr [edi], al

	 ret
		
	End Asm

End Sub
 
sub BlendParticle100 naked ()
asm
		   .intel_syntax noprefix
    mov byte ptr [edi], al
	 ret
End Asm

End Sub




'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''''''''''''
'had to change a few things for now

/'
** R_DrawParticle (asm version)
**
** Since we use __declspec( naked ) we don't have a stack frame
** that we can use.  Since I want to reserve EBP anyway, I tossed
** all the important variables into statics.  This routine isn't
** meant to be re-entrant, so this shouldn't cause any problems
** other than a slightly higher global memory footprint.
**
'/
sub R_DrawParticle naked ()
 
	static as vec3_t	     _local, transformed 
	static as float	     zi 
	static as integer      u, v, tmp 
	static as short        izi 
	static as integer      ebpsave 

	static as  function() as ubyte blendfunc 

	/'
	** must be memvars since x86 can't load constants
	** directly.  I guess I could use fld1, but that
	** actually costs one more clock than fld [one]!
	'/
	static as float    _particle_z_clip    = PARTICLE_Z_CLIP 
	static as float     one                 = 1.0F 
	static as float    point_five         = 0.5F  
	static as float    eight_thousand_hex = &H8000 
	
  asm
	/'
	** save trashed variables
	'/
	  .intel_syntax noprefix
	 mov  ebpsave, ebp
	 push esi
	 push edi

	'/*
	'** transform the particle
	'*/
	'// VectorSubtract (pparticle->origin, r_origin, local);
	  'mov  esi, partparms.particle
	  mov  esi, dword ptr [partparms_particle]
	 fld  dword ptr [esi+0]          # p_o.x
	 fsub dword ptr [r_origin+0]     # p_o.x-r_o.x
	 fld  dword ptr [esi+4]          # p_o.y | p_o.x-r_o.x
	 fsub dword ptr [r_origin+4]     # p_o.y-r_o.y | p_o.x-r_o.x
	 fld  dword ptr [esi+8]          # p_o.z | p_o.y-r_o.y | p_o.x-r_o.x
	 fsub dword ptr [r_origin+8]     # p_o.z-r_o.z | p_o.y-r_o.y | p_o.x-r_o.x
	 fxch st(2)                      # p_o.x-r_o.x | p_o.y-r_o.y | p_o.z-r_o.z
	 fstp dword ptr [_local+0]        # p_o.y-r_o.y | p_o.z-r_o.z
	 fstp dword ptr [_local+4]        # p_o.z-r_o.z
	 fstp dword ptr [_local+8]        # (empty)

	' transformed[0] = DotProduct(local, r_pright);
	' transformed[1] = DotProduct(local, r_pup);
	' transformed[2] = DotProduct(local, r_ppn);
	 fld  dword ptr [_local+0]        # l.x
	 fmul dword ptr [r_pright+0]     # l.x*pr.x
	 fld  dword ptr [_local+4]        # l.y | l.x*pr.x
	 fmul dword ptr [r_pright+4]     # l.y*pr.y | l.x*pr.x
	 fld  dword ptr [_local+8]        # l.z | l.y*pr.y | l.x*pr.x
	 fmul dword ptr [r_pright+8]     # l.z*pr.z | l.y*pr.y | l.x*pr.x
	 fxch st(2)                      # l.x*pr.x | l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y + l.z*pr.z
	 fstp  dword ptr [transformed+0] # (empty)

	 fld  dword ptr [_local+0]        # l.x
	 fmul dword ptr [_r_pup+0]        # l.x*pr.x
	 fld  dword ptr [_local+4]        # l.y | l.x*pr.x
	 fmul dword ptr [r_pup+4]        # l.y*pr.y | l.x*pr.x
	 fld  dword ptr [_local+8]        # l.z | l.y*pr.y | l.x*pr.x
	 fmul dword ptr [r_pup+8]        # l.z*pr.z | l.y*pr.y | l.x*pr.x
	 fxch st(2)                      # l.x*pr.x | l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y + l.z*pr.z
	 fstp  dword ptr [transformed+4] # (empty)

	 fld  dword ptr [_local+0]        # l.x
	 fmul dword ptr [r_ppn+0]        # l.x*pr.x
	 fld  dword ptr [_local+4]        # l.y | l.x*pr.x
	 fmul dword ptr [r_ppn+4]        # l.y*pr.y | l.x*pr.x
	 fld  dword ptr [_local+8]        # l.z | l.y*pr.y | l.x*pr.x
	 fmul dword ptr [r_ppn+8]        # l.z*pr.z | l.y*pr.y | l.x*pr.x
	 fxch st(2)                      # l.x*pr.x | l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y | l.z*pr.z
	 faddp st(1), st                 # l.x*pr.x + l.y*pr.y + l.z*pr.z
	 fstp  dword ptr [transformed+8] # (empty)

	/'
	** make sure that the transformed particle is not in front of
	** the particle Z clip plane.  We can do the comparison in 
	** integer space since we know the sign of one of the inputs
	** and can figure out the sign of the other easily enough.
	'/
	'//	if (transformed[2] < PARTICLE_Z_CLIP)
	'//		return#

	 mov  eax, dword ptr [transformed+8]
	 and  eax, eax
	 js   _end
	 cmp  eax, _particle_z_clip
	 jl   _end

	/'
	** project the point by initiating the 1/z calc
	'/
	'//	zi = 1.0 / transformed[2]#
	
	  fld   dword ptr [one] #IN NAKED 
	  
 	  fdiv  dword ptr [transformed+8]
 
	/'
	** bind the blend function pointer to the appropriate blender
	** while we're dividing
	'/
	'//if ( level == PARTICLE_33 )
	'//	blendparticle = BlendParticle33#
	'//else if ( level == PARTICLE_66 )
	'//	blendparticle = BlendParticle66#
	'//else 
	'//	blendparticle = BlendParticle100#

	 'cmp partparms.level, PARTICLE_66
	 cmp dword ptr[partparms_level], PARTICLE_66
	 je  blendfunc_66
	 jl  blendfunc_33
	 lea ebx, BlendParticle100
	 jmp done_selecting_blend_func
blendfunc_33:
	 lea ebx, BlendParticle33
	 jmp done_selecting_blend_func
blendfunc_66:
	 lea ebx, BlendParticle66
done_selecting_blend_func:
	 mov blendfunc, ebx

	'// prefetch the next particle
	 mov ebp, s_prefetch_address
	 mov ebp, [ebp]

	'// finish the above divide
	  fstp  dword ptr [zi] #IN NAKED 

	'// u = (int)(xcenter + zi * transformed[0] + 0.5)#
	'// v = (int)(ycenter - zi * transformed[1] + 0.5)#
	 fld   dword ptr [zi]                           # zi
	 fmul  dword ptr [transformed+0]    # zi * transformed[0]
	 fld   dword ptr [zi]                          # zi | zi * transformed[0]
	 fmul  dword ptr [transformed+4]    # zi * transformed[1] | zi * transformed[0]
	 fxch  st(1)                        # zi * transformed[0] | zi * transformed[1]
	 fadd  dword ptr [xcenter]                      # xcenter + zi * transformed[0] | zi * transformed[1]
	 fxch  st(1)                        # zi * transformed[1] | xcenter + zi * transformed[0]
	 fld   dword ptr [ycenter]                      # ycenter | zi * transformed[1] | xcenter + zi * transformed[0]
    fsubrp st(1), st(0)                # ycenter - zi * transformed[1] | xcenter + zi * transformed[0]
  	 fxch  st(1)                        # xcenter + zi * transformed[0] | ycenter + zi * transformed[1]
  	 fadd  dword ptr [point_five]                   # xcenter + zi * transformed[0] + 0.5 | ycenter - zi * transformed[1]
  	 fxch  st(1)                        # ycenter - zi * transformed[1] | xcenter + zi * transformed[0] + 0.5 
  	 fadd  dword ptr [point_five]                   # ycenter - zi * transformed[1] + 0.5 | xcenter + zi * transformed[0] + 0.5 
  	 fxch  st(1)                        # u | v
  	 fistp dword ptr [u]                # v
  	 fistp dword ptr [v]                # (empty)

	/'
	** clip out the particle
	'/

	'//	if ((v > d_vrectbottom_particle) || 
	'//		(u > d_vrectright_particle) ||
	'//		(v < d_vrecty) ||
	'//		(u < d_vrectx))
	'//	{
	'//		return#
	'//	}

	 mov ebx, u
	 mov ecx, v
	 cmp ecx, d_vrectbottom_particle
	 jg  _end
	 cmp ecx, d_vrecty
	 jl  _end
	 cmp ebx, d_vrectright_particle
	 jg  _end
	 cmp ebx, d_vrectx
	 jl  _end

	/'
	** compute addresses of zbuffer, framebuffer, and 
	** compute the Z-buffer reference value.
	**
	** EBX      = U
	** ECX      = V
	**
	** Outputs:
	** ESI = Z-buffer address
	** EDI = framebuffer address
	''/
	'// ESI = d_pzbuffer + (d_zwidth * v) + u#
	 mov esi, d_pzbuffer             # esi = d_pzbuffer
	 mov eax, d_zwidth               # eax = d_zwidth
	 mul ecx                         # eax = d_zwidth*v
	 add eax, ebx                    # eax = d_zwidth*v+u
	 shl eax, 1                      # eax = 2*(d_zwidth*v+u)
	 add esi, eax                    # esi = ( short * ) ( d_pzbuffer + ( d_zwidth * v ) + u )

	'// initiate
	'// izi = (int)(zi * 0x8000)#
	 fld  dword ptr [zi]
	 fmul dword ptr [eight_thousand_hex]

	'// EDI = pdest = d_viewbuffer + d_scantable[v] + u#
	 lea edi, [d_scantable+ecx*4]
	 mov edi, [edi]
	 add edi, d_viewbuffer
	 add edi, ebx

	'// complete
	'// izi = (int)(zi * 0x8000)#
	 fistp dword ptr [tmp]
	 mov   eax, tmp
	 mov   izi, ax

	/'
	** determine the screen area covered by the particle,
	** which also means clamping to a min and max
	'/
	'	pix = izi >> d_pix_shift#
	 xor edx, edx
	 mov dx, izi
	 mov ecx, d_pix_shift
	 shr dx, cl

	'	if (pix < d_pix_min)
	'		pix = d_pix_min#
	 cmp edx, d_pix_min
	 jge check_pix_max
	 mov edx, d_pix_min
	 jmp skip_pix_clamp

	'	else if (pix > d_pix_max)
	'		pix = d_pix_max#
check_pix_max:
	 cmp edx, d_pix_max
	 jle skip_pix_clamp
	 mov edx, d_pix_max

skip_pix_clamp:

	/'
	** render the appropriate pixels
	**
	** ECX = count (used for inner loop)
	** EDX = count (used for outer loop)
	** ESI = zbuffer
	** EDI = framebuffer
	'/
	 mov ecx, edx

	 cmp ecx, 1
	 ja  over

over:

	/'
	** at this point:
	**
	** ECX = count
	'/
	 push ecx
	 push edi
	 push esi

top_of_pix_vert_loop:

top_of_pix_horiz_loop:

	'//	for ( # count # count--, pz += d_zwidth, pdest += screenwidth)
	'//	{
	'//		for (i=0 # i<pix # i++)
	'//		{
	'//			if (pz[i] <= izi)
	'//			{
	'//				pdest[i] = blendparticle( color, pdest[i] )#
	'//			}
	'//		}
	'//	}
	 xor   eax, eax

	 mov   ax, word ptr [esi]

	 cmp   ax, izi
	 jg    end_of_horiz_loop

#if ENABLE_ZWRITES_FOR_PARTICLES
  	 mov   bp, izi
  	 mov   word ptr [esi], bp
#endif

	' mov   eax, partparms.color
     mov   eax, dword ptr [partparms_color]
	 call  [blendfunc]

	 add   edi, 1
	 add   esi, 2

end_of_horiz_loop:

	 dec   ecx
	 jnz   top_of_pix_horiz_loop

	 pop   esi
	 pop   edi

	 mov   ebp, d_zwidth
	 shl   ebp, 1

	 add   esi, ebp
	 add   edi, [r_screenwidth]

	 pop   ecx
	 push  ecx

	 push  edi
	 push  esi

	 dec   edx
	 jnz   top_of_pix_vert_loop

	 pop   ecx
	 pop   ecx
	 pop   ecx

 _end:
	 pop edi
	 pop esi
	 mov ebp, ebpsave
	 ret
	
 	end asm
 	
	
 end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''



#else

















 function BlendParticle33( pcolor as integer, dstcolor as integer) as ubyte static
 	 
	return vid.alphamap[pcolor + dstcolor*256] 
 	
 End Function

 

 function BlendParticle66( int pcolor, int dstcolor ) as ubyte static 
 		return vid.alphamap[pcolor*256+dstcolor]
 End Function
 

 

 function  BlendParticle100( int pcolor, int dstcolor )as ubyte static 
 
	dstcolor = dstcolor 
	return pcolor 
 
End Function







 #endif