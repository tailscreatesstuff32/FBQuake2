'FINISHED FOR NOW//////////////////////////////////////////

/'
Copyright (C) 1997-2001 Id Software, Inc.

This program is free software you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

'/
'// r_aclip.c: clip routines for drawing Alias models directly to the screen

 #Include "FB_Ref_Soft\r_local.bi"
 
 static shared as  finalvert_t		_fv(2,8) 

declare sub R_AliasProjectAndClipTestFinalVert (_fv as finalvert_t ptr) 

extern "C"


declare sub R_Alias_clip_top (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr , _
	_out as finalvert_t ptr) 
declare sub R_Alias_clip_bottom (pfv0 as finalvert_t ptr, pfv1 as finalvert_t ptr, _
	_out as finalvert_t ptr ) 
declare sub R_Alias_clip_left (pfv0 as finalvert_t ptr, pfv1 as finalvert_t ptr, _
	_out as finalvert_t ptr ) 
declare sub R_Alias_clip_right (pfv0 as finalvert_t ptr, pfv1 as finalvert_t ptr, _
	_out as finalvert_t ptr ) 

end extern




/'
================
R_Alias_clip_z

pfv0 is the unclipped vertex, pfv1 is the z-clipped vertex
================
'/
sub R_Alias_clip_z (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr)
  dim as float		scale 

 	scale = (ALIAS_Z_CLIP_PLANE - pfv0->xyz(2)) / _
 			(pfv1->xyz(2) - pfv0->xyz(2)) 
 
 	_out->xyz(0) = pfv0->xyz(0) + (pfv1->xyz(0) - pfv0->xyz(0)) * scale 
 	_out->xyz(1) = pfv0->xyz(1) + (pfv1->xyz(1) - pfv0->xyz(1)) * scale 
 	_out->xyz(2) = ALIAS_Z_CLIP_PLANE 
'
 	_out->s =	pfv0->s + (pfv1->s - pfv0->s) * scale 
 	_out->t =	pfv0->t + (pfv1->t - pfv0->t) * scale 
 	_out->l =	pfv0->l + (pfv1->l - pfv0->l) * scale 
 
 	 R_AliasProjectAndClipTestFinalVert (_out) 
 
 
End Sub
 

 
 #ifndef id386
 
sub R_Alias_clip_left (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr)
 
	dim  as  float		scale 

 	if (_fv0->v >=pfv1->v ) then 
 
 		scale = cast(float,r_refdef.aliasvrect.x pfv0->u) / _
 				(pfv1->u - pfv0->u) 
   	_out->u  = pfv0->u  + ( pfv1->u  - pfv0->u ) * scale + 0.5 
 		_out->v  = pfv0->v  + ( pfv1->v  - pfv0->v ) * scale + 0.5 
 		_out->s  = pfv0->s  + ( pfv1->s  - pfv0->s ) * scale + 0.5 
 		_out->t  = pfv0->t  + ( pfv1->t  - pfv0->t ) * scale + 0.5 
 		_out->l  = pfv0->l  + ( pfv1->l  - pfv0->l ) * scale + 0.5 
 		_out->zi = pfv0->zi + ( pfv1->zi - pfv0->zi) * scale + 0.5 
 
 	else
 
 		scale = cast(float,r_refdef.aliasvrect.x - pfv1->u) / _
 				(pfv0->u - pfv1->u)) 
 	   _out->u  = pfv1->u  + ( pfv0->u  - pfv1->u ) * scale + 0.5 
 		_out->v  = pfv1->v  + ( pfv0->v  - pfv1->v ) * scale + 0.5 
 		_out->s  = pfv1->s  + ( pfv0->s  - pfv1->s ) * scale + 0.5 
 		_out->t  = pfv1->t  + ( pfv0->t  - pfv1->t ) * scale + 0.5 
 		_out->l  = pfv1->l  + ( pfv0->l  - pfv1->l ) * scale + 0.5 
 		_out->zi = pfv1->zi + ( pfv0->zi - pfv1->zi) * scale + 0.5 
 end if
end sub
'
'
sub R_Alias_clip_right (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr))
 
	dim as float		scale 

 	if ( _fv0->v >= pfv1->v ) then
 
 		scale = cast(float,r_refdef.aliasvrectright - pfv0->u ) / _
 				(pfv1->u - pfv0->u ) 
 		_out->u  = pfv0->u  + ( pfv1->u  - pfv0->u ) * scale + 0.5
 		_out->v  = pfv0->v  + ( pfv1->v  - pfv0->v ) * scale + 0.5
  		_out->s  = pfv0->s  + ( pfv1->s  - pfv0->s ) * scale + 0.5
 		_out->t  = pfv0->t  + ( pfv1->t  - pfv0->t ) * scale + 0.5
 		_out->l  = pfv0->l  + ( pfv1->l  - pfv0->l ) * scale + 0.5
 		_out->zi = pfv0->zi + ( pfv1->zi - pfv0->zi) * scale + 0.5
 
 	else
 
 		scale = cast(float,r_refdef.aliasvrectright - pfv1->u ) / _
 				(pfv0->u - pfv1->u )
 		_out->u  = pfv1->u  + ( pfv0->u  - pfv1->u ) * scale + 0.5
 		_out->v  = pfv1->v  + ( pfv0->v  - pfv1->v ) * scale + 0.5
 		_out->s  = pfv1->s  + ( pfv0->s  - pfv1->s ) * scale + 0.5
 		_out->t  = pfv1->t  + ( pfv0->t  - pfv1->t ) * scale + 0.5
 		_out->l  = pfv1->l  + ( pfv0->l  - pfv1->l ) * scale + 0.5
 		_out->zi = pfv1->zi + ( pfv0->zi - pfv1->zi) * scale + 0.5
 	end if
end sub
 
sub R_Alias_clip_top (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr)
 
	dim as float		scale

	if (_fv0->v >= pfv1->v) then
	 
		scale = cast(float,r_refdef.aliasvrect.y - pfv0->v) / _
				(pfv1->v - pfv0->v)
		_out->u  = pfv0->u  + ( pfv1->u  - pfv0->u ) * scale + 0.5
		_out->v  = pfv0->v  + ( pfv1->v  - pfv0->v ) * scale + 0.5
		_out->s  = pfv0->s  + ( pfv1->s  - pfv0->s ) * scale + 0.5
		_out->t  = pfv0->t  + ( pfv1->t  - pfv0->t ) * scale + 0.5
		_out->l  = pfv0->l  + ( pfv1->l  - pfv0->l ) * scale + 0.5
		_out->zi = pfv0->zi + ( pfv1->zi - pfv0->zi) * scale + 0.5
 
	else
	 
		scale = cast(float,r_refdef.aliasvrect.y - pfv1->v) / _
				(pfv0->v - pfv1->v)
		_out->u  = pfv1->u  + ( pfv0->u  - pfv1->u ) * scale + 0.5
		_out->v  = pfv1->v  + ( pfv0->v  - pfv1->v ) * scale + 0.5
		_out->s  = pfv1->s  + ( pfv0->s  - pfv1->s ) * scale + 0.5
		_out->t  = pfv1->t  + ( pfv0->t  - pfv1->t ) * scale + 0.5
		_out->l  = pfv1->l  + ( pfv0->l  - pfv1->l ) * scale + 0.5
		_out->zi = pfv1->zi + ( pfv0->zi - pfv1->zi) * scale + 0.5
 	end if
end  sub
 
sub R_Alias_clip_bottom (pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr)
 
	 dim as float		scale

 	if (_fv0->v >=pfv1->v) then
 
		scale = cast(float,r_refdef.aliasvrectbottom - pfv0->v) / _
				(pfv1->v - pfv0->v)

		_out->u  = pfv0->u  + ( pfv1->u  - pfv0->u ) * scale + 0.5
		_out->v  = pfv0->v  + ( pfv1->v  - pfv0->v ) * scale + 0.5
		_out->s  = pfv0->s  + ( pfv1->s  - pfv0->s ) * scale + 0.5
		_out->t  = pfv0->t  + ( pfv1->t  - pfv0->t ) * scale + 0.5
		_out->l  = pfv0->l  + ( pfv1->l  - pfv0->l ) * scale + 0.5
		_out->zi = pfv0->zi + ( pfv1->zi - pfv0->zi) * scale + 0.5
	 
	else
	 
		scale = (float)(r_refdef.aliasvrectbottom - pfv1->v) / _
				(pfv0->v - pfv1->v)

		_out->u  = pfv1->u  + ( pfv0->u  - pfv1->u ) * scale + 0.5
		_out->v  = pfv1->v  + ( pfv0->v  - pfv1->v ) * scale + 0.5
		_out->s  = pfv1->s  + ( pfv0->s  - pfv1->s ) * scale + 0.5
		_out->t  = pfv1->t  + ( pfv0->t  - pfv1->t ) * scale + 0.5
		_out->l  = pfv1->l  + ( pfv0->l  - pfv1->l ) * scale + 0.5
		_out->zi = pfv1->zi + ( pfv0->zi - pfv1->zi) * scale + 0.5
 	end if
end sub
 
 #endif
 

 
function R_AliasClip (_in as finalvert_t ptr ,_out as  finalvert_t ptr ,flag as integer , count as integer ,clip as sub(pfv0 as finalvert_t ptr,pfv1 as finalvert_t ptr, _out as finalvert_t ptr)) as Integer
 
	 dim as integer			i,j,k 
	 dim as integer			flags, oldflags
 	
 	j = count-1
 	k = 0
for i = 0 to count
 		oldflags = _in[j].flags and flags
 		flags = _in[i].flags and flags
 
 		if (flags and oldflags) then
    		continue for
    	end if
 		if (oldflags xor flags) then
 
 			clip (@_in[j], @_in[i], @_out[k]) 
 			_out[k].flags = 0
 			if (_out[k].u < r_refdef.aliasvrect.x) then
 				_out[k].flags or= ALIAS_LEFT_CLIP
 			EndIf
 			

 			if (_out[k].v < r_refdef.aliasvrect.y) then
 				_out[k].flags or= ALIAS_TOP_CLIP
 			EndIf
 				
 			if (_out[k].u > r_refdef.aliasvrectright) then
 				_out[k].flags or= ALIAS_RIGHT_CLIP
 			EndIf
 				

 			if (_out[k].v > r_refdef.aliasvrectbottom) then
 				_out[k].flags or= ALIAS_BOTTOM_CLIP	
 			EndIf
 				_
 			k+=1
 		end if
 		if ( flags = NULL) then
 		 
 			_out[k] = _in[i]
 			k+=1
 		end if
next
 	
 	return k
end function
 
 
 /'
 ================
 R_AliasClipTriangle
 ================
'/
sub R_AliasClipTriangle (index0 as finalvert_t ptr,index1 as finalvert_t ptr,index2 as finalvert_t ptr)
 
   dim as integer				i, k, pingpong 
 	dim as uinteger		   clipflags 
 
'// copy vertexes and fix seam texture coordinates
 _fv(0,0) = *index0 
 	_fv(0,1) = *index1 
 	_fv(0,2) = *index2 
 
'// clip
 	clipflags = _fv(0,0).flags or _fv(0,1).flags or _fv(0,2).flags 
 
 	if (clipflags and ALIAS_Z_CLIP) then
 
 		k = R_AliasClip (@_fv(0,0), @_fv(1,0), ALIAS_Z_CLIP, 3, @R_Alias_clip_z())
 		if (k =  0) then
 			return
 		EndIf
 			
 
 	pingpong = 1
 		clipflags = _fv(1,0).flags xor _fv(1,1).flags xor _fv(1,2).flags
 
 	else
 
 		pingpong = 0
 	k = 3
 	end if
 
 	if (clipflags and ALIAS_LEFT_CLIP) then
 
 		k = R_AliasClip (@_fv(pingpong,0), @_fv(pingpong xor 1,0), _
 							ALIAS_LEFT_CLIP, k, @R_Alias_clip_left())
 		if (k = 0) then
 			return
 		EndIf
 
 		pingpong xor= 1
 	end if
 
 	if (clipflags and ALIAS_RIGHT_CLIP) then
 
 		k = R_AliasClip (@_fv(pingpong,0), @_fv(pingpong xor 1,0), _
  						ALIAS_RIGHT_CLIP, k, @R_Alias_clip_right())
 	if (k =  0) then
 		return
 	EndIf
 			
 
 		pingpong xor= 1
 	end if
 
 	if (clipflags and ALIAS_BOTTOM_CLIP) then
 
 		k = R_AliasClip (@_fv(pingpong,0), @_fv(pingpong xor 1,0), _
 							ALIAS_BOTTOM_CLIP, k,@R_Alias_clip_bottom())
 		if (k = 0) then
 			return
 		EndIf
 			
 
 		pingpong xor= 1
 	end if
 
 	if (clipflags and ALIAS_TOP_CLIP) then
 
 		k = R_AliasClip (@_fv(pingpong,0), @_fv(pingpong xor 1,0), _
 							ALIAS_TOP_CLIP, k, @R_Alias_clip_top())
 		if (k = 0) then
 			return
 		EndIf
 			
 
 		pingpong xor= 1
 end if
'
 	for  i=0  to k -1   
 
 		if (_fv(pingpong,i).u < r_refdef.aliasvrect.x) then
 			_fv(pingpong,i).u = r_refdef.aliasvrect.x
 		elseif (_fv(pingpong,i).u > r_refdef.aliasvrectright) then
 			_fv(pingpong,i).u = r_refdef.aliasvrectright
      end if
 		if (_fv(pingpong,i).v < r_refdef.aliasvrect.y) then
   		_fv(pingpong,i).v = r_refdef.aliasvrect.y
 		elseif (_fv(pingpong,i).v > r_refdef.aliasvrectbottom) then
 			_fv(pingpong,i).v = r_refdef.aliasvrectbottom
 		end if
 		_fv(pingpong,i).flags = 0
 	next
 
'// draw triangles
 	for  i = 1 to (k-1)-1 
		aliastriangleparms.a = @_fv(pingpong,0)
 		aliastriangleparms.b = @_fv(pingpong,i)
 		aliastriangleparms.c = @_fv(pingpong,i+1)
 		R_DrawTriangle()
 		
 	Next
 
 
end sub

 