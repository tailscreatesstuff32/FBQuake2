

#include "gl_local.bi"


dim shared dottexture(8,8) as ubyte => _
{ _
	{0,0,0,0,0,0,0,0}, _
	{0,0,1,1,0,0,0,0}, _
	{0,1,1,1,1,0,0,0}, _
	{0,1,1,1,1,0,0,0}, _
	{0,0,1,1,0,0,0,0}, _
	{0,0,0,0,0,0,0,0}, _
	{0,0,0,0,0,0,0,0}, _
	{0,0,0,0,0,0,0,0} _
} 

sub R_InitParticleTexture ()
 
	dim as integer x,y 
	dim as ubyte data_ (8,8,4)
 
 for x = 0 to 8-1
 	for y = 0 to 8-1
 
 			data_(y,x,0) = 255 
   		data_(y,x,1) = 255 
 		   data_(y,x,2) = 255 
 			data_(y,x,3) = dottexture(x,y)*255 
     next
 	next
 r_particletexture = GL_LoadPic ("***particle***", cast(ubyte ptr,@data_(0,0,0)), 8, 8, it_sprite, 32) 
  
 
 for x = 0 to 8-1
 	for y = 0 to 8-1
 		   data_(y,x,0) = dottexture(x  and 3, y and 3)*255 
 			data_(y,x,1) = 0 ' dottexture[x&3][y&3]*255;
 			data_(y,x,2) = 0'dottexture[x&3][y&3]*255;
 			data_(y,x,3) = 255 
 
 		
 	Next
 Next 	
 	

 		r_notexture  = GL_LoadPic ("***r_notexture***", cast(ubyte ptr,@data_(0,0,0)), 8, 8, it_sprite, 32) 

end sub

 
 type _TargaHeader  
 	
   as ubyte 	id_length, colormap_type, image_type 
 	as ushort	colormap_index, colormap_length 
 	as ubyte	colormap_size 
   as ushort	x_origin, y_origin, width, height 
 	as ubyte	pixel_size, attributes 
 
 	
 End Type: type TargaHeader as _TargaHeader


 
sub GL_ScreenShot_f () 
 
   dim  buffer  as ubyte ptr 	
   dim picname as ZString * 80	
	dim checkname as  zstring * MAX_OSPATH 	 
   dim as integer			i, c, temp 
 	dim f as FILE ptr
 
   Com_sprintf (checkname, sizeof(checkname), "%s/scrnshot", ri.FS_Gamedir()) 
 	Sys_Mkdir (checkname) 
 
 strcpy(picname,"quake00.tga") 
'
 	for i=0  to 99 -1
 		picname[5] = i/10 + "0" 
   	picname[6] = (i mod 10) + "0"
'		Com_sprintf (checkname, sizeof(checkname), "%s/scrnshot/%s", ri.FS_Gamedir(), picname);
'		f = fopen (checkname, "rb");
   	if ( f =0 ) then
     	exit for	 
 		fclose (f)
 		end if 
  next
 	if (i =100) then
 		
 			ri.Con_Printf (PRINT_ALL, "SCR_ScreenShot_f: Couldn't create a file\n")
 	EndIf
 
 
 	return 
 
 	
 	
 	
 	Next 

  buffer = malloc(vid._width*vid._height*3 + 18) 
 	memset (buffer, 0, 18) 
 	buffer[2] = 2 
 	buffer[12] = vid._width and 255 
 	buffer[13] = vid._width shr 8 
   buffer[14] = vid._height and 255 
   buffer[15] = vid._height shr 8 
 	buffer[16] = 24 
 
 '	qglReadPixels (0, 0, vid._width, vid._height, GL_RGB, GL_UNSIGNED_BYTE, buffer+18 ) 
 
 
 	c = 18+vid._width*vid._height*3 
  for  i=18 to c - 1 step 3 
      temp = buffer[i] 
    	buffer[i] = buffer[i+2] 
 		buffer[i+2] = temp 
  	
  Next

 
 	f = fopen (checkname, "wb") 
 	fwrite (buffer, 1, c, f) 
   fclose (f) 
 
 	free (buffer) 
 	ri.Con_Printf (PRINT_ALL, "Wrote %s\n", picname) 
end sub

 sub GL_Strings_f()
   ri.Con_Printf (PRINT_ALL, "GL_VENDOR: %s\n", gl_config.vendor_string ) 
	ri.Con_Printf (PRINT_ALL, "GL_RENDERER: %s\n", gl_config.renderer_string ) 
	ri.Con_Printf (PRINT_ALL, "GL_VERSION: %s\n", gl_config.version_string ) 
   ri.Con_Printf (PRINT_ALL, "GL_EXTENSIONS: %s\n", gl_config.extensions_string ) 
 	
 End Sub




 sub GL_SetDefaultState()
 	
 qglClearColor (1,0, 0.5 , 0.5)
 qglCullFace(GL_FRONT) 
 qglEnable(GL_TEXTURE_2D) 
 
 qglEnable(GL_ALPHA_TEST) 
 qglAlphaFunc(GL_GREATER, 0.666) 
 
 qglDisable (GL_DEPTH_TEST) 
 qglDisable (GL_CULL_FACE) 
 qglDisable (GL_BLEND) 
 
 qglColor4f (1,1,1,1) 
 
 qglPolygonMode (GL_FRONT_AND_BACK, GL_FILL) 
 qglShadeModel (GL_FLAT) 
 
 GL_TextureMode( _gl_texturemode->_string ) 
 GL_TextureAlphaMode( _gl_texturealphamode->_string ) 
 GL_TextureSolidMode( _gl_texturesolidmode->_string ) 
 
 qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_min) 
 qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max) 
 
 qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT) 
 qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT) 
 
 qglBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) 
 
 	GL_TexEnv( GL_REPLACE ) 
 
  if ( qglPointParameterfEXT ) then
 
 	 dim attenuations(3) as float
 
 		attenuations(0) = gl_particle_att_a->value 
   	attenuations(1) = gl_particle_att_b->value 
 		attenuations(2) = gl_particle_att_c->value 
 
 		qglEnable( GL_POINT_SMOOTH ) 
 		qglPointParameterfEXT( GL_POINT_SIZE_MIN_EXT, gl_particle_min_size->value ) 
 		qglPointParameterfEXT( GL_POINT_SIZE_MAX_EXT, gl_particle_max_size->value ) 
 		qglPointParameterfvEXT( GL_DISTANCE_ATTENUATION_EXT, @attenuations(0)) 
 	end if
 
 if   (qglColorTableEXT <> NULL and gl_ext_palettedtexture->value)   then
 	
 	qglEnable( GL_SHARED_TEXTURE_PALETTE_EXT ) 
 
 	GL_SetTexturePalette( d_8to24table() ) 
 
 
 	GL_UpdateSwapInterval() 
 	
 End If
 
 	
 
 	
 	
 End Sub
 

 sub GL_UpdateSwapInterval()
 
	 if ( gl_swapinterval->modified ) then
	 	
 	gl_swapinterval->modified = _false 
 
   	if  gl_state.stereo_enabled   = 0 then
 
 #ifdef __FB_WIN32__
 		if ( qwglSwapIntervalEXT ) then
 			qwglSwapIntervalEXT( gl_swapinterval->value ) 
 				end if
 #endif
   
  end if
end if
 	
 	
	 	
	 	
 

 	
 End Sub
