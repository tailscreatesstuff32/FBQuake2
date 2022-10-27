'FINISHED FOR NOW/////////////////////////////////////////////

/'
Copyright (C) 1997-2001 Id Software, Inc.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

'/
'// r_sprite.c
 #Include "FB_Ref_Soft\r_local.bi"


extern as polydesc_t  r_polydesc 


declare sub R_BuildPolygonFromSurface(fa as msurface_t ptr) 
declare sub R_PolygonCalculateGradients () 

declare sub R_PolyChooseSpanletRoutine(alpha_ as float ,isturbulent as qboolean  ) 

extern as vec5_t r_clip_verts(2,MAXWORKINGVERTS+2)

declare sub R_ClipAndDrawPoly ( alpha_ as float , isturbulent as integer , textured as qboolean )


 
/'
** R_DrawSprite
**
** Draw currententity / currentmodel as a single texture
** mapped polygon
'/
 
sub R_DrawSprite ()
 
	dim as vec5_t	 ptr pverts 
	dim as vec3_t		_left, up, _right, down 
	dim as dsprite_t	 ptr s_psprite 
	dim as dsprframe_t	ptr s_psprframe 


	s_psprite = cast(dsprite_t ptr,currentmodel->extradata)
 #if 0
 	if (currententity->frame >= s_psprite->numframes _
 		or currententity->frame < 0) then
 
      	ri.Con_Printf (PRINT_ALL, !"No such sprite frame %i\n", _
   			currententity->frame) 
 		currententity->frame = 0 
   end if
 #endif
 	currententity->frame mod%= s_psprite->numframes 
 
 	s_psprframe = @s_psprite->frames(currententity->frame)
 
 	r_polydesc.pixels       = currentmodel->skins(currententity->frame)->pixels(0)
 	r_polydesc.pixel_width  = s_psprframe->_width 
 	r_polydesc.pixel_height = s_psprframe->_height 
 	r_polydesc.dist         = 0 
 
'	// generate the sprite's axes, completely parallel to the viewplane.
 	_VectorCopy (@vup, @r_polydesc.vup) 
 	_VectorCopy (@vright,@r_polydesc.vright) 
 	_VectorCopy (@vpn, @r_polydesc.vpn) 
 
'// build the sprite poster in worldspace
 	 VectorScale (@r_polydesc.vright, _
 		s_psprframe->_width - s_psprframe->origin_x, @_right) 
 	VectorScale (@r_polydesc.vup, _
 		s_psprframe->_height - s_psprframe->origin_y, @up) 
 	VectorScale (@r_polydesc.vright, _
 		-s_psprframe->origin_x, @_left) 
 	VectorScale (@r_polydesc.vup, _
 		-s_psprframe->origin_y, @down) 
 
'	// invert UP vector for sprites
 	VectorInverse( @r_polydesc.vup ) 
 
 	pverts = @r_clip_verts(0,0) 
 
 	pverts[0].v(0) = r_entorigin.v(0) + up.v(0) + _left.v(0) 
 	pverts[0].v(1) = r_entorigin.v(1) + up.v(1) + _left.v(1) 
 	pverts[0].v(2) = r_entorigin.v(2) + up.v(2) + _left.v(2) 
 	pverts[0].v(3) = 0 
 	pverts[0].v(4) = 0  

	pverts[1].v(0) = r_entorigin.v(0) + up.v(0) + _right.v(0)
	pverts[1].v(1) = r_entorigin.v(1) + up.v(1) + _right.v(1)
	pverts[1].v(2) = r_entorigin.v(2) + up.v(2) + _right.v(2)
	pverts[1].v(3) = s_psprframe->_width
	pverts[1].v(4) = 0

	pverts[2].v(0) = r_entorigin.v(0) + down.v(0) + _right.v(0)
	pverts[2].v(1) = r_entorigin.v(1) + down.v(1) + _right.v(1)
	pverts[2].v(2) = r_entorigin.v(2) + down.v(2) + _right.v(2)
	pverts[2].v(3) = s_psprframe->_width
	pverts[2].v(4) = s_psprframe->_height

	pverts[3].v(0) = r_entorigin.v(0) + down.v(0) + _left.v(0)
	pverts[3].v(1) = r_entorigin.v(1) + down.v(1) + _left.v(1)
	pverts[3].v(2) = r_entorigin.v(2) + down.v(2) + _left.v(2)
	pverts[3].v(3) = 0
 	pverts[3].v(4) = s_psprframe->_height 
 
 	 r_polydesc.nump = 4 
 	 r_polydesc.s_offset = ( r_polydesc.pixel_width  shr 1) 
 	 r_polydesc.t_offset = ( r_polydesc.pixel_height shr 1) 
 	 _VectorCopy( @modelorg, @r_polydesc.viewer_position(0) ) 
 
 	 r_polydesc.stipple_parity = 1 
 	 if ( currententity->flags and RF_TRANSLUCENT )  then
 	 	R_ClipAndDrawPoly ( currententity->alpha_, _false, _true )
 	 else
 	 	R_ClipAndDrawPoly ( 1.0F, false, true )
 	 EndIf
 
 
 	r_polydesc.stipple_parity = 0 
end sub


 