#Include "FB_Ref_Soft\r_local.bi"

dim shared as ubyte	ptr r_turb_pbase, r_turb_pdest 
dim shared as fixed16_t		r_turb_s, r_turb_t, r_turb_sstep, r_turb_tstep 
dim shared as integer			   r_turb_turb 
dim shared as integer			 	r_turb_spancount 

declare sub D_DrawTurbulent8Span () 


 
'/*
'=============
'D_WarpScreen
'
'this performs a slight compression of the screen at the same time as
'the sine warp, to keep the edges from wrapping
'=============
'*/
sub D_WarpScreen ()
 dim  as   integer		w, h 
 dim  as   integer		u,v, u2, v2  
 dim  as   ubyte	   ptr dest 
 dim  as   integer	 ptr turb 
 dim  as   integer	 ptr col 
 dim  as   ubyte	   ptr ptr row 
	
	static as integer	cached_width, cached_height
End Sub
 


'	;
'	static byte	*rowptr[1200+AMP2*2];
'	static int	column[1600+AMP2*2];
'
'	//
'	// these are constant over resolutions, and can be saved
'	//
'	w = r_newrefdef.width;
'	h = r_newrefdef.height;
'	if (w != cached_width || h != cached_height)
'	{
'		cached_width = w;
'		cached_height = h;
'		for (v=0 ; v<h+AMP2*2 ; v++)
'		{
'			v2 = (int)((float)v/(h + AMP2 * 2) * r_refdef.vrect.height);
'			rowptr[v] = r_warpbuffer + (WARP_WIDTH * v2);
'		}
'
'		for (u=0 ; u<w+AMP2*2 ; u++)
'		{
'			u2 = (int)((float)u/(w + AMP2 * 2) * r_refdef.vrect.width);
'			column[u] = u2;
'		}
'	}
'
'	turb = intsintable + ((int)(r_newrefdef.time*SPEED)&(CYCLE-1));
'	dest = vid.buffer + r_newrefdef.y * vid.rowbytes + r_newrefdef.x;
'
'	for (v=0 ; v<h ; v++, dest += vid.rowbytes)
'	{
'		col = &column[turb[v]];
'		row = &rowptr[v];
'		for (u=0 ; u<w ; u+=4)
'		{
'			dest[u+0] = row[turb[u+0]][col[u+0]];
'			dest[u+1] = row[turb[u+1]][col[u+1]];
'			dest[u+2] = row[turb[u+2]][col[u+2]];
'			dest[u+3] = row[turb[u+3]][col[u+3]];
'		}
'	}
'}
