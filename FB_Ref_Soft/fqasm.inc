 .equ id386,1


  .ifndef GLQUAKE

 
    // _d_pzbuffer:.long
	 _d_zistepv:.long
	 _d_zrowbytes:.long
	 _d_ziorigin:.long
	 _r_turb_s:.long
	 _r_turb_t:.long
	 _r_turb_pdest:.long
	 _r_turb_spancount:.long
	 _r_turb_turb:.long
	 _r_turb_pbase:.long
	 _r_turb_sstep:.long
	 _r_turb_tstep:.long
		_r_bmodelactive:.long
		_d_sdivzstepu:.long
		_d_tdivzstepu:.long
		_d_sdivzstepv:.long
		_d_tdivzstepv:.long
		_d_sdivzorigin:.long
		_d_tdivzorigin:.long
		_sadjust:.long
		_tadjust:.long
		_bbextents:.long
		_bbextentt:.long
		_cacheblock:.long
		_d_viewbuffer:.long
		_cachewidth:.long
		_d_zwidth:.long
	 _d_scantable:.long
	 _r_lightptr:.long
	 _r_numvblocks:.long
	 _prowdestbase:.long
	 _pbasesource:.long
	 _r_lightwidth:.long
	 _lightright:.long
	 _lightrightstep:.long
	 _lightdeltastep:.long
	 _lightdelta:.long
	 _sourcetstep:.long
	 _surfrowbytes:.long
	 _r_sourcemax:.long
	 _r_stepback:.long
	 _colormap:.long
	 _blocksize:.long
	 _sourcesstep:.long
	 _lightleft:.long
	 _blockdivshift:.long
	 _blockdivmask:.long
	 _lightleftstep:.long
	 _r_origin:.long
	 _r_ppn:.long
	 _r_pup:.long
	 _r_pright:.long
	 _ycenter:.long
	 _xcenter:.long
	 _d_vrectbottom_particle:.long
	 _d_vrectright_particle:.long
	 _d_vrecty:.long
	 _d_vrectx:.long
	 _d_pix_shift:.long
	 _d_pix_min:.long
	 _d_pix_max:.long
	 _d_y_aspect_shift:.long
	 _screenwidth:.long
	 _r_leftclipped:.long
	 _r_leftenter:.long
	 _r_rightclipped:.long
	 _r_rightenter:.long
	 _modelorg:.long
	 _xscale:.long
	 _r_refdef:.long
	 _yscale:.long
	 _r_leftexit:.long
	 _r_rightexit:.long
	 _r_lastvertvalid:.long
	 _cacheoffset:.long
	 _newedges:.long
	 _removeedges:.long
	 _r_pedge:.long
	 _r_framecount:.long
	 _r_u1:.long
	 _r_emitted:.long
	 _edge_p:.long
	 _surface_p:.long
	 _surfaces:.long
	 _r_lzi1:.long
	 _r_v1:.long
	 _r_ceilv1:.long
	 _r_nearzi:.long
	 _r_nearzionly:.long
	 _edge_aftertail:.long
	 _edge_tail:.long
	 _current_iv:.long
	 _edge_head_u_shift20:.long
	 _span_p:.long
	 _edge_head:.long
	 _fv:.long
	 _edge_tail_u_shift20:.long
	 _r_apverts:.long
	 _r_anumverts:.long
	 _aliastransform:.long
	 _r_avertexnormals:.long
	 _r_plightvec:.long
	 _r_ambientlight:.long
	 _r_shadelight:.long
	 _aliasxcenter:.long
	 _aliasycenter:.long
	 _a_sstepxfrac:.long
	 _r_affinetridesc:.long
	 _acolormap:.long
	 _d_pcolormap:.long
	 _d_sfrac:.long
	 _d_ptex:.long
	 _d_pedgespanpackage:.long
	 _d_tfrac:.long
	 _d_light:.long
	 _d_zi:.long
	 _d_pdest:.long
	 _d_pz:.long
	 _d_aspancount:.long
	 _erroradjustup:.long
	 _errorterm:.long
	 _d_xdenom:.long
	 _r_p0:.long
	 _r_p1:.long
	 _r_p2:.long
	 _a_tstepxfrac:.long
	 _r_sstepx:.long
	 _r_tstepx:.long
	 _a_ststepxwhole:.long
	 _zspantable:.long
	 _skintable:.long
	 _r_zistepx:.long
	 _erroradjustdown:.long
	 _d_countextrastep:.long
	 _ubasestep:.long
	 _r_lstepx:.long
	 _a_spans:.long
	 _d_pdestextrastep:.long
	 _d_pzextrastep:.long
	 _d_sfracextrastep:.long
	 _d_ptexextrastep:.long
	 _d_tfracextrastep:.long
	 _d_lightextrastep:.long
	 _d_ziextrastep:.long
	 _d_pdestbasestep:.long
	 _d_pzbasestep:.long
	 _d_sfracbasestep:.long
	 _d_ptexbasestep:.long
	 _d_tfracbasestep:.long
	 _d_lightbasestep:.long
	 _d_zibasestep:.long
	 _r_lstepy:.long
	 _r_sstepy:.long
	 _r_tstepy:.long
	 _r_zistepy:.long
	 _D_PolysetSetEdgeTable:.long
	 _D_RasterizeAliasPolySmooth:.long

	 float_point5:.long
	 Float2ToThe31nd:.long
	 izistep:.long
	 izi:.long
	 FloatMinus2ToThe31nd:.long
	 float_1:.long
	 float_particle_z_clip:.long
	 float_minus_1:.long
	 float_0:.long
	 fp_16:.long
	 fp_64k:.long
	 fp_1m:.long
	 fp_1m_minus_1:.long
	 fp_8 :.long
	 entryvec_table:.long
	 advancetable:.long
	 sstep:.long
	 tstep:.long
	 pspantemp:.long
	 counttemp:.long
	 jumptemp:.long
	 reciprocal_table:.long
	 DP_Count:.long
	 DP_u:.long
	 DP_v:.long
	 DP_32768:.long
	 DP_Color:.long
	 DP_Pix:.long
	 DP_EntryTable:.long
		pbase:.long
	 s:.long
	 t:.long
	 sfracf:.long
	 tfracf:.long
	 snext:.long
	 tnext:.long
		spancountminus1:.long
	 zi16stepu:.long
	 sdivz16stepu:.long
	 tdivz16stepu:.long
		zi8stepu:.long
	 sdivz8stepu:.long
	 tdivz8stepu:.long
	 reciprocal_table_16:.long
	 entryvec_table_16:.long
	 fp_64kx64k:.long
	 pz:.long
	 spr8entryvec_table:.long

.endif




	 _fpu_ceil_cw:.long
	  _fpu_chop_cw:.long
	  _snd_scaletable:.long
	 _paintbuffer:.long
	  _snd_linear_count:.long
	 _snd_p:.long
	 _snd_vol:.long
	 _snd_out:.long
 	_vright:.long
 	_vup:.long
	  _vpn:.long
	  _BOPS_Error:.long

// ; plane_t structure
// ; !!! if this is changed, it must be changed in model.h too !!!
// ; !!! if the size of this is changed, the array lookup in SV_HullPointContents
// ;     must be changed too !!!
 pl_normal	=		0
 pl_dist		=		12
 pl_type		=		16
 pl_signbits	=		17
 pl_pad		=		18
 pl_size		=		20

// // ; hull_t structure
// // ; !!! if this is changed, it must be changed in model.h too !!!
 hu_clipnodes		=		0
 hu_planes			=		4
 hu_firstclipnode	=		8
 hu_lastclipnode		=		12
 hu_clip_mins		=		16
 hu_clip_maxs		=		28
 hu_size  			=		40

// // ; dnode_t structure
// // ; !!! if this is changed, it must be changed in bspfile.h too !!!
 nd_planenum		=		0
 nd_children		=		4
 nd_mins			=		8
 nd_maxs			=		20
 nd_firstface	=		32
 nd_numfaces		=		36
 nd_size			=		40

// // ; sfxcache_t structure
// // ; !!! if this is changed, it much be changed in sound.h too !!!
 sfxc_length		=		0
 sfxc_loopstart	=		4
 sfxc_speed		=		8
 sfxc_width		=		12
 sfxc_stereo		=		16
 sfxc_data		=		20

// // ; channel_t structure
// // ; !!! if this is changed, it much be changed in sound.h too !!!
 ch_sfx			=		0
 ch_leftvol		=		4
 ch_rightvol		=		8
 ch_end			=		12
 ch_pos			=		16
 ch_looping		=		20
 ch_entnum		=		24
 ch_entchannel	=		28
 ch_origin		=		32
 ch_dist_mult	=		44
 ch_master_vol	=		48
 ch_size			=		52

// // ; portable_samplepair_t structure
// // ; !!! if this is changed, it much be changed in sound.h too !!!
 psp_left		=		0
 psp_right		=		4
 psp_size		=		8

// // ; !!! if this is changed, it must be changed in r_local.h too !!!
//NEAR_CLIP	=		0.01

// // ; !!! if this is changed, it must be changed in r_local.h too !!!
 CYCLE	=		128

// // ; espan_t structure
// // ; !!! if this is changed, it must be changed in r_shared.h too !!!
 espan_t_u    	=		0
 espan_t_v	    =		4
 espan_t_count   =		8
 espan_t_pnext	=		12
 espan_t_size    =		16

// // ; sspan_t structure
// // ; !!! if this is changed, it must be changed in d_local.h too !!!
 sspan_t_u    	=		0
 sspan_t_v	    =		4
  sspan_t_count   =		8
 sspan_t_size    =		12

// // ; spanpackage_t structure
// // ; !!! if this is changed, it must be changed in d_polyset.c too !!!
 spanpackage_t_pdest				=		0
 spanpackage_t_pz				=		4
 spanpackage_t_count				=		8
 spanpackage_t_ptex				=		12
 spanpackage_t_sfrac				=		16
 spanpackage_t_tfrac				=		20
 spanpackage_t_light				=		24
 spanpackage_t_zi				=		28
 spanpackage_t_size				=		32 

// // ; edge_t structure
// // ; !!! if this is changed, it must be changed in r_shared.h too !!!
 et_u			=		0
 et_u_step		=		4
 et_prev			=		8
 et_next			=		12
 et_surfs		=		16
 et_nextremove	=		20
 et_nearzi		=		24
 et_owner		=		28
 et_size			=		32

// // ; surf_t structure
// // ; !!! if this is changed, it must be changed in r_shared.h too !!!
 SURF_T_SHIFT	=		6
 st_next			=		0
 st_prev			=		4
 st_spans		=		8
 st_key			=		12
 st_last_u		=		16
 st_spanstate	=		20
 st_flags		=		24
 st_data			=		28
 st_entity		=		32
 st_nearzi		=		36
 st_insubmodel	=		40
 st_d_ziorigin	=		44
 st_d_zistepu	=		48
 st_d_zistepv	=		52
 st_pad			=		56
 st_size			=		64

// // ; clipplane_t structure
// // ; !!! if this is changed, it must be changed in r_local.h too !!!
 cp_normal		=		0
 cp_dist			=		12
 cp_next			=		16
 cp_leftedge		=		20
 cp_rightedge	=		21
 cp_reserved		=		22
 cp_size			=		24

// // ; medge_t structure
// // ; !!! if this is changed, it must be changed in model.h too !!!
 me_v				=		0
 me_cachededgeoffset	=		4
 me_size				=		8

// // ; mvertex_t structure
// // ; !!! if this is changed, it must be changed in model.h too !!!
 mv_position		=		0
 mv_size			=		12

// // ; refdef_t structure
// // ; !!! if this is changed, it must be changed in render.h too !!!
 rd_vrect					=		0
 rd_aliasvrect				=		20
 rd_vrectright				=		40
 rd_vrectbottom				=		44
 rd_aliasvrectright			=		48
 rd_aliasvrectbottom			=		52
 rd_vrectrightedge			=		56
 rd_fvrectx					=		60
 rd_fvrecty					=		64
 rd_fvrectx_adj				=		68
 rd_fvrecty_adj				=		72
 rd_vrect_x_adj_shift20		=		76
 rd_vrectright_adj_shift20	=		80
 rd_fvrectright_adj			=		84
 rd_fvrectbottom_adj			=		88
 rd_fvrectright				=		92
 rd_fvrectbottom				=		96
 rd_horizontalFieldOfView	=		100
 rd_xOrigin					=		104
 rd_yOrigin					=		108
 rd_vieworg					=		112
 rd_viewangles				=		124
 rd_ambientlight				=		136
 rd_size						=		140

//; mtriangle_t structure
//; !!! if this is changed, it must be changed in model.h too !!!
 mtri_facesfront		=		0
 mtri_vertindex		=		4
 mtri_size			=		16	/*; !!! if this changes, array indexing in !!!*/
								/*; !!! d_polysa.s must be changed to match !!!8*/
 mtri_shift			=		4

