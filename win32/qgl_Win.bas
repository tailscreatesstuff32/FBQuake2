' WORK IN PROGRESS''''''''''''''''''''''''''''''''''''
#Include "gl_local.bi"
#Include "win32\glw_win.bi"

dim shared glw_state as glwstate_t  


 dim shared  qglRotatef as sub (angle as GLfloat,x as GLfloat,y as GLfloat,z as GLfloat)
 
 dim shared  qwglChoosePixelFormat as function (as HDC, as CONST PIXELFORMATDESCRIPTOR ptr) as Integer
 dim shared  qwglDescribePixelFormat as function (as HDC, as integer,as UINT, as LPPIXELFORMATDESCRIPTOR)  as Integer
 dim shared  qwglGetPixelFormat as function (as HDC) as integer   
 dim shared  qwglSetPixelFormat as function  (as HDC, as integer,as CONST PIXELFORMATDESCRIPTOR ptr) as BOOL 
 dim shared  qwglSwapBuffers  as function (as HDC)  as BOOL 
 
 dim shared  qwglCopyContext as function(as HGLRC, as HGLRC, as UINT) as BOOL  
 dim shared  qwglCreateContext as function(as HDC)  as HGLRC
 dim shared  qwglCreateLayerContext as function(as HDC, as integer) as HGLRC
 dim shared  qwglDeleteContext as function(as HGLRC) as bool
 dim shared  qwglGetCurrentContext as function() as HGLRC 
 dim shared  qwglGetCurrentDC as function() as HDC
 dim shared  qwglGetProcAddress as function(as LPCSTR) as PROC  
 dim shared  qwglMakeCurrent as  function(as HDC, as HGLRC) as BOOL 
 dim shared  qwglShareLists as function(as HGLRC,as HGLRC)  as BOOL 
 dim shared  qwglUseFontBitmaps as function(as HDC, as DWORD, as DWORD, as DWORD) as BOOL
 
 dim shared  qwglUseFontOutlines as function(as HDC, as DWORD, as DWORD,as DWORD,as FLOAT, _
                                          as FLOAT,as integer,as LPGLYPHMETRICSFLOAT) as BOOL 
 
 dim shared  qwglDescribeLayerPlane as function(as HDC,as integer,as integer,as UINT, _
                                           as LPLAYERPLANEDESCRIPTOR) as bool
 dim shared  qwglSetLayerPaletteEntries  as function(as HDC,as integer, as integer,as integer, _
                                               as CONST COLORREF ptr)  as integer
 dim shared  qwglGetLayerPaletteEntries  as function (as HDC, as integer,as integer,as integer, _
                                              as COLORREF ptr)   as integer
 dim shared  qwglRealizeLayerPalette as  function (as HDC, as integer,as BOOL) as BOOL
 dim shared  qwglSwapLayerBuffers as function(as HDC,as UINT) as BOOL 
 
 
 
 
 dim shared   qglAccum  as sub(op as GLenum ,value as GLfloat ) 
 dim shared   qglAlphaFunc  as sub(func as GLenum , ref as GLclampf) 
 'dim shared   qglAreTexturesResident  as function(n as GLsizei , textures as const GLuint ptr , residences as GLboolean ptr ) as GLboolean 
 dim shared   qglArrayElement as sub (i as GLint ) 
 dim shared   qglBegin  as sub(mode as GLenum ) 
 dim shared   qglBindTexture  as sub(target as GLenum , texture as GLuint) 
 dim shared   qglBitmap  as sub(_width as GLsizei , _height as GLsizei ,xorig as GLfloat , yorig as GLfloat, xmove as GLfloat,ymove as GLfloat ,  bitmap as const GLubyte ptr ) 
 dim shared   qglBlendFunc  as sub(sfactor as GLenum ,dfactor as GLenum ) 
 dim shared   qglCallList  as sub(_list as GLuint ) 
 dim shared   qglCallLists as sub (n as GLsizei , _type as GLenum,lists as const GLvoid ptr) 
 dim shared   qglClear as sub(mask as GLbitfield ) 
 dim shared   qglClearAccum  as sub(_red as GLfloat ,_green as GLfloat ,_blue as GLfloat ,alpha_ as GLfloat ) 
 dim shared   qglClearColor as sub (_red as GLclampf ,_green  as GLclampf,_blue as GLclampf ,alpha_ as GLclampf )
 dim shared   qglClearDepth as sub(_depth as GLclampd ) 
 dim shared   qglClearIndex  as sub( c as GLfloat) 
 dim shared   qglClearStencil as sub (s as GLint) 
 dim shared   qglClipPlane  as sub(plane as GLenum , equation as const GLdouble ptr) 
 dim shared   qglColor3b  as sub ( _red as GLbyte,_green as GLbyte ,_blue as GLbyte ) 
 dim shared   qglColor3bv  as sub(v as const GLbyte ptr) 
 dim shared   qglColor3d as sub(_red as GLdouble ,_green as GLdouble , _blue as GLdouble) 
 dim shared   qglColor3dv as sub(v as const GLdouble ptr) 
 dim shared   qglColor3f  as sub (_red as GLfloat ,_green as GLfloat  , _blue as GLfloat ) 
 dim shared   qglColor3fv  as sub(v as const GLfloat ptr) 
 dim shared   qglColor3i  as sub(_red as GLint,_green as GLint ,_blue as GLint) 
 dim shared   qglColor3iv  as sub (v as const GLint ptr) 
 dim shared   qglColor3sv as sub(v as const GLshort ptr) 
 dim shared   qglColor3ub as sub(_red as GLubyte ,_green as GLubyte ,_blue as GLubyte) 
 dim shared   qglColor3ubv as sub(v as const GLubyte ptr) 
 dim shared   qglColor3ui as sub(_red as GLuint , _green as GLuint , _blue as GLuint) 
 dim shared   qglColor3uiv as sub(v as const GLuint ptr) 
 dim shared   qglColor3us  as sub(_red as GLushort ,_green as GLushort ,_blue as GLushort ) 
 dim shared   qglColor3usv as sub(v as const GLushort ptr ) 
 dim shared   qglColor4b as sub (_red as GLbyte ,_green as GLbyte ,_blue as GLbyte ,alpha_ as GLbyte ) 
 dim shared   qglColor4bv  as sub( v as const GLbyte ptr ) 
 dim shared   qglColor4d  as sub (_red as GLdouble ,_green as GLdouble , _blue as GLdouble, alpha_ as GLdouble ) 
 dim shared   qglColor4dv  as sub(v as const GLDouble ptr) 
 dim shared   qglColor4f  as sub ( _red  as GLfloat,_green  as GLfloat, _blue  as GLfloat, alpha_  as GLfloat) 
 dim shared   qglColor4fv as sub (v as const GLfloat ptr) 
 dim shared   qglColor3s  as sub (_red as GLshort ,_green as GLshort , _blue as GLshort) 
 dim shared   qglColor4i  as sub(_red as GLint,_green as GLint ,_blue as GLint, alpha_ as GLint ) 
 dim shared   qglColor4iv as sub(v as const GLint ptr) 
'void ( APIENTRY * qglColor4s )(GLshort red, GLshort green, GLshort blue, GLshort alpha);
'void ( APIENTRY * qglColor4sv )(const GLshort *v);
'void ( APIENTRY * qglColor4ub )(GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
'void ( APIENTRY * qglColor4ubv )(const GLubyte *v);
'void ( APIENTRY * qglColor4ui )(GLuint red, GLuint green, GLuint blue, GLuint alpha);
'void ( APIENTRY * qglColor4uiv )(const GLuint *v);
'void ( APIENTRY * qglColor4us )(GLushort red, GLushort green, GLushort blue, GLushort alpha);
'void ( APIENTRY * qglColor4usv )(const GLushort *v);
'void ( APIENTRY * qglColorMask )(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
'void ( APIENTRY * qglColorMaterial )(GLenum face, GLenum mode);
'void ( APIENTRY * qglColorPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
'void ( APIENTRY * qglCopyPixels )(GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
'void ( APIENTRY * qglCopyTexImage1D )(GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLint border);
'void ( APIENTRY * qglCopyTexImage2D )(GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
'void ( APIENTRY * qglCopyTexSubImage1D )(GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
'void ( APIENTRY * qglCopyTexSubImage2D )(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
'void ( APIENTRY * qglCullFace )(GLenum mode);
'void ( APIENTRY * qglDeleteLists )(GLuint list, GLsizei range);
'void ( APIENTRY * qglDeleteTextures )(GLsizei n, const GLuint *textures);
'void ( APIENTRY * qglDepthFunc )(GLenum func);
'void ( APIENTRY * qglDepthMask )(GLboolean flag);
'void ( APIENTRY * qglDepthRange )(GLclampd zNear, GLclampd zFar);
'void ( APIENTRY * qglDisable )(GLenum cap);
'void ( APIENTRY * qglDisableClientState )(GLenum array);
'void ( APIENTRY * qglDrawArrays )(GLenum mode, GLint first, GLsizei count);
'void ( APIENTRY * qglDrawBuffer )(GLenum mode);
'void ( APIENTRY * qglDrawElements )(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
'void ( APIENTRY * qglDrawPixels )(GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
'void ( APIENTRY * qglEdgeFlag )(GLboolean flag);
'void ( APIENTRY * qglEdgeFlagPointer )(GLsizei stride, const GLvoid *pointer);
'void ( APIENTRY * qglEdgeFlagv )(const GLboolean *flag);
'void ( APIENTRY * qglEnable )(GLenum cap);
'void ( APIENTRY * qglEnableClientState )(GLenum array);
dim shared qglEnd  as sub() 
dim shared qglEndList as sub()
dim shared qglEvalCoord1d as sub(u as GLdouble ) 
dim shared qglEvalCoord1dv as sub(u as const GLdouble ptr) 
dim shared qglEvalCoord1f  as sub( u as GLfloat) 
dim shared qglEvalCoord1fv as sub(u as const GLfloat ptr) 
dim shared qglEvalCoord2d as sub(u as GLdouble ,v as GLdouble) 
'void ( APIENTRY * qglEvalCoord2dv )(const GLdouble *u);
'void ( APIENTRY * qglEvalCoord2f )(GLfloat u, GLfloat v);
'void ( APIENTRY * qglEvalCoord2fv )(const GLfloat *u);
'void ( APIENTRY * qglEvalMesh1 )(GLenum mode, GLint i1, GLint i2);
'void ( APIENTRY * qglEvalMesh2 )(GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
dim shared  qglEvalPoint1 as sub(i as GLint ) 
'void ( APIENTRY * qglEvalPoint2 )(GLint i, GLint j);
'void ( APIENTRY * qglFeedbackBuffer )(GLsizei size, GLenum type, GLfloat *buffer);
dim shared  qglFinish as sub() 
dim shared qglFlush as sub () 
'void ( APIENTRY * qglFogf )(GLenum pname, GLfloat param);
'void ( APIENTRY * qglFogfv )(GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglFogi )(GLenum pname, GLint param);
'void ( APIENTRY * qglFogiv )(GLenum pname, const GLint *params);
'void ( APIENTRY * qglFrontFace )(GLenum mode);
'void ( APIENTRY * qglFrustum )(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
'GLuint ( APIENTRY * qglGenLists )(GLsizei range);
'void ( APIENTRY * qglGenTextures )(GLsizei n, GLuint *textures);
'void ( APIENTRY * qglGetBooleanv )(GLenum pname, GLboolean *params);
'void ( APIENTRY * qglGetClipPlane )(GLenum plane, GLdouble *equation);
'void ( APIENTRY * qglGetDoublev )(GLenum pname, GLdouble *params);
 dim shared qglGetError as function() as  GLenum
'void ( APIENTRY * qglGetFloatv )(GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetIntegerv )(GLenum pname, GLint *params);
'void ( APIENTRY * qglGetLightfv )(GLenum light, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetLightiv )(GLenum light, GLenum pname, GLint *params);
'void ( APIENTRY * qglGetMapdv )(GLenum target, GLenum query, GLdouble *v);
'void ( APIENTRY * qglGetMapfv )(GLenum target, GLenum query, GLfloat *v);
'void ( APIENTRY * qglGetMapiv )(GLenum target, GLenum query, GLint *v);
'void ( APIENTRY * qglGetMaterialfv )(GLenum face, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetMaterialiv )(GLenum face, GLenum pname, GLint *params);
'void ( APIENTRY * qglGetPixelMapfv )(GLenum map, GLfloat *values);
'void ( APIENTRY * qglGetPixelMapuiv )(GLenum map, GLuint *values);
'void ( APIENTRY * qglGetPixelMapusv )(GLenum map, GLushort *values);
'void ( APIENTRY * qglGetPointerv )(GLenum pname, GLvoid* *params);
'void ( APIENTRY * qglGetPolygonStipple )(GLubyte *mask);
'const GLubyte * ( APIENTRY * qglGetString )(GLenum name);
'void ( APIENTRY * qglGetTexEnvfv )(GLenum target, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetTexEnviv )(GLenum target, GLenum pname, GLint *params);
'void ( APIENTRY * qglGetTexGendv )(GLenum coord, GLenum pname, GLdouble *params);
'void ( APIENTRY * qglGetTexGenfv )(GLenum coord, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetTexGeniv )(GLenum coord, GLenum pname, GLint *params);
'void ( APIENTRY * qglGetTexImage )(GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
'void ( APIENTRY * qglGetTexLevelParameterfv )(GLenum target, GLint level, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetTexLevelParameteriv )(GLenum target, GLint level, GLenum pname, GLint *params);
'void ( APIENTRY * qglGetTexParameterfv )(GLenum target, GLenum pname, GLfloat *params);
'void ( APIENTRY * qglGetTexParameteriv )(GLenum target, GLenum pname, GLint *params);
'void ( APIENTRY * qglHint )(GLenum target, GLenum mode);
'void ( APIENTRY * qglIndexMask )(GLuint mask);
'void ( APIENTRY * qglIndexPointer )(GLenum type, GLsizei stride, const GLvoid *pointer);
'void ( APIENTRY * qglIndexd )(GLdouble c);
'void ( APIENTRY * qglIndexdv )(const GLdouble *c);
'void ( APIENTRY * qglIndexf )(GLfloat c);
'void ( APIENTRY * qglIndexfv )(const GLfloat *c);
'void ( APIENTRY * qglIndexi )(GLint c);
'void ( APIENTRY * qglIndexiv )(const GLint *c);
'void ( APIENTRY * qglIndexs )(GLshort c);
'void ( APIENTRY * qglIndexsv )(const GLshort *c);
'void ( APIENTRY * qglIndexub )(GLubyte c);
'void ( APIENTRY * qglIndexubv )(const GLubyte *c);
'void ( APIENTRY * qglInitNames )(void);
dim shared  qglInterleavedArrays  as sub(_format as GLenum ,_stride as GLsizei ,_pointer as const GLvoid ptr) 
dim shared  qglIsEnabled  as function( _cap as GLenum) as GLboolean
dim shared  qglIsList  as function(_list as GLuint ) as GLboolean 
dim shared  qglIsTexture as function (texture as GLuint  ) as GLboolean 
'void ( APIENTRY * qglLightModelf )(GLenum pname, GLfloat param);
'void ( APIENTRY * qglLightModelfv )(GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglLightModeli )(GLenum pname, GLint param);
'void ( APIENTRY * qglLightModeliv )(GLenum pname, const GLint *params);
'void ( APIENTRY * qglLightf )(GLenum light, GLenum pname, GLfloat param);
'void ( APIENTRY * qglLightfv )(GLenum light, GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglLighti )(GLenum light, GLenum pname, GLint param);
'void ( APIENTRY * qglLightiv )(GLenum light, GLenum pname, const GLint *params);
'void ( APIENTRY * qglLineStipple )(GLint factor, GLushort pattern);
'void ( APIENTRY * qglLineWidth )(GLfloat width);
'void ( APIENTRY * qglListBase )(GLuint base);
dim shared qglLoadIdentity as sub()
'void ( APIENTRY * qglLoadMatrixd )(const GLdouble *m);
'void ( APIENTRY * qglLoadMatrixf )(const GLfloat *m);
'void ( APIENTRY * qglLoadName )(GLuint name);
'void ( APIENTRY * qglLogicOp )(GLenum opcode);
'void ( APIENTRY * qglMap1d )(GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
'void ( APIENTRY * qglMap1f )(GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
'void ( APIENTRY * qglMap2d )(GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
'void ( APIENTRY * qglMap2f )(GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
'void ( APIENTRY * qglMapGrid1d )(GLint un, GLdouble u1, GLdouble u2);
'void ( APIENTRY * qglMapGrid1f )(GLint un, GLfloat u1, GLfloat u2);
'void ( APIENTRY * qglMapGrid2d )(GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
'void ( APIENTRY * qglMapGrid2f )(GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
'void ( APIENTRY * qglMaterialf )(GLenum face, GLenum pname, GLfloat param);
'void ( APIENTRY * qglMaterialfv )(GLenum face, GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglMateriali )(GLenum face, GLenum pname, GLint param);
'void ( APIENTRY * qglMaterialiv )(GLenum face, GLenum pname, const GLint *params);
'void ( APIENTRY * qglMatrixMode )(GLenum mode);
'void ( APIENTRY * qglMultMatrixd )(const GLdouble *m);
'void ( APIENTRY * qglMultMatrixf )(const GLfloat *m);
'void ( APIENTRY * qglNewList )(GLuint list, GLenum mode);
'void ( APIENTRY * qglNormal3b )(GLbyte nx, GLbyte ny, GLbyte nz);
'void ( APIENTRY * qglNormal3bv )(const GLbyte *v);
'void ( APIENTRY * qglNormal3d )(GLdouble nx, GLdouble ny, GLdouble nz);
'void ( APIENTRY * qglNormal3dv )(const GLdouble *v);
'void ( APIENTRY * qglNormal3f )(GLfloat nx, GLfloat ny, GLfloat nz);
'void ( APIENTRY * qglNormal3fv )(const GLfloat *v);
'void ( APIENTRY * qglNormal3i )(GLint nx, GLint ny, GLint nz);
'void ( APIENTRY * qglNormal3iv )(const GLint *v);
'void ( APIENTRY * qglNormal3s )(GLshort nx, GLshort ny, GLshort nz);
'void ( APIENTRY * qglNormal3sv )(const GLshort *v);
'void ( APIENTRY * qglNormalPointer )(GLenum type, GLsizei stride, const GLvoid *pointer);
'void ( APIENTRY * qglOrtho )(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
'void ( APIENTRY * qglPassThrough )(GLfloat token);
'void ( APIENTRY * qglPixelMapfv )(GLenum map, GLsizei mapsize, const GLfloat *values);
'void ( APIENTRY * qglPixelMapuiv )(GLenum map, GLsizei mapsize, const GLuint *values);
'void ( APIENTRY * qglPixelMapusv )(GLenum map, GLsizei mapsize, const GLushort *values);
'void ( APIENTRY * qglPixelStoref )(GLenum pname, GLfloat param);
'void ( APIENTRY * qglPixelStorei )(GLenum pname, GLint param);
'void ( APIENTRY * qglPixelTransferf )(GLenum pname, GLfloat param);
'void ( APIENTRY * qglPixelTransferi )(GLenum pname, GLint param);
'void ( APIENTRY * qglPixelZoom )(GLfloat xfactor, GLfloat yfactor);
'void ( APIENTRY * qglPointSize )(GLfloat size);
'void ( APIENTRY * qglPolygonMode )(GLenum face, GLenum mode);
'void ( APIENTRY * qglPolygonOffset )(GLfloat factor, GLfloat units);
'void ( APIENTRY * qglPolygonStipple )(const GLubyte *mask);
dim shared qglPopAttrib as sub () 
dim shared qglPopClientAttrib as sub ()
dim shared qglPopMatrix  as sub()
dim shared qglPopName as sub ()
'void ( APIENTRY * qglPrioritizeTextures )(GLsizei n, const GLuint *textures, const GLclampf *priorities);
'void ( APIENTRY * qglPushAttrib )(GLbitfield mask);
'void ( APIENTRY * qglPushClientAttrib )(GLbitfield mask);
'void ( APIENTRY * qglPushMatrix )(void);
'void ( APIENTRY * qglPushName )(GLuint name);
'void ( APIENTRY * qglRasterPos2d )(GLdouble x, GLdouble y);
'void ( APIENTRY * qglRasterPos2dv )(const GLdouble *v);
'void ( APIENTRY * qglRasterPos2f )(GLfloat x, GLfloat y);
'void ( APIENTRY * qglRasterPos2fv )(const GLfloat *v);
'void ( APIENTRY * qglRasterPos2i )(GLint x, GLint y);
'void ( APIENTRY * qglRasterPos2iv )(const GLint *v);
'void ( APIENTRY * qglRasterPos2s )(GLshort x, GLshort y);
'void ( APIENTRY * qglRasterPos2sv )(const GLshort *v);
'void ( APIENTRY * qglRasterPos3d )(GLdouble x, GLdouble y, GLdouble z);
'void ( APIENTRY * qglRasterPos3dv )(const GLdouble *v);
'void ( APIENTRY * qglRasterPos3f )(GLfloat x, GLfloat y, GLfloat z);
'void ( APIENTRY * qglRasterPos3fv )(const GLfloat *v);
'void ( APIENTRY * qglRasterPos3i )(GLint x, GLint y, GLint z);
'void ( APIENTRY * qglRasterPos3iv )(const GLint *v);
'void ( APIENTRY * qglRasterPos3s )(GLshort x, GLshort y, GLshort z);
'void ( APIENTRY * qglRasterPos3sv )(const GLshort *v);
'void ( APIENTRY * qglRasterPos4d )(GLdouble x, GLdouble y, GLdouble z, GLdouble w);
'void ( APIENTRY * qglRasterPos4dv )(const GLdouble *v);
'void ( APIENTRY * qglRasterPos4f )(GLfloat x, GLfloat y, GLfloat z, GLfloat w);
'void ( APIENTRY * qglRasterPos4fv )(const GLfloat *v);
'void ( APIENTRY * qglRasterPos4i )(GLint x, GLint y, GLint z, GLint w);
'void ( APIENTRY * qglRasterPos4iv )(const GLint *v);
'void ( APIENTRY * qglRasterPos4s )(GLshort x, GLshort y, GLshort z, GLshort w);
'void ( APIENTRY * qglRasterPos4sv )(const GLshort *v);
'void ( APIENTRY * qglReadBuffer )(GLenum mode);
'void ( APIENTRY * qglReadPixels )(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
'void ( APIENTRY * qglRectd )(GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
'void ( APIENTRY * qglRectdv )(const GLdouble *v1, const GLdouble *v2);
'void ( APIENTRY * qglRectf )(GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
'void ( APIENTRY * qglRectfv )(const GLfloat *v1, const GLfloat *v2);
'void ( APIENTRY * qglRecti )(GLint x1, GLint y1, GLint x2, GLint y2);
'void ( APIENTRY * qglRectiv )(const GLint *v1, const GLint *v2);
dim shared qglRects as sub( x1 as GLshort,  y1  as GLshort, x2  as GLshort ,  y2  as  GLshort) 
'void ( APIENTRY * qglRectsv )(const GLshort *v1, const GLshort *v2);
dim shared qglRenderMode  as function(_mode as GLenum ) as GLint
dim shared qglRotated  as sub(angle as GLdouble ,x as GLdouble ,y as  GLdouble,z as GLdouble ) 
'void ( APIENTRY * qglRotatef )(GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
'void ( APIENTRY * qglScaled )(GLdouble x, GLdouble y, GLdouble z);
'void ( APIENTRY * qglScalef )(GLfloat x, GLfloat y, GLfloat z);
'void ( APIENTRY * qglScissor )(GLint x, GLint y, GLsizei width, GLsizei height);
'void ( APIENTRY * qglSelectBuffer )(GLsizei size, GLuint *buffer);
'void ( APIENTRY * qglShadeModel )(GLenum mode);
'void ( APIENTRY * qglStencilFunc )(GLenum func, GLint ref, GLuint mask);
'void ( APIENTRY * qglStencilMask )(GLuint mask);
'void ( APIENTRY * qglStencilOp )(GLenum fail, GLenum zfail, GLenum zpass);
'void ( APIENTRY * qglTexCoord1d )(GLdouble s);
'void ( APIENTRY * qglTexCoord1dv )(const GLdouble *v);
'void ( APIENTRY * qglTexCoord1f )(GLfloat s);
'void ( APIENTRY * qglTexCoord1fv )(const GLfloat *v);
'void ( APIENTRY * qglTexCoord1i )(GLint s);
'void ( APIENTRY * qglTexCoord1iv )(const GLint *v);
'void ( APIENTRY * qglTexCoord1s )(GLshort s);
'void ( APIENTRY * qglTexCoord1sv )(const GLshort *v);
'void ( APIENTRY * qglTexCoord2d )(GLdouble s, GLdouble t);
'void ( APIENTRY * qglTexCoord2dv )(const GLdouble *v);
'void ( APIENTRY * qglTexCoord2f )(GLfloat s, GLfloat t);
'void ( APIENTRY * qglTexCoord2fv )(const GLfloat *v);
'void ( APIENTRY * qglTexCoord2i )(GLint s, GLint t);
'void ( APIENTRY * qglTexCoord2iv )(const GLint *v);
'void ( APIENTRY * qglTexCoord2s )(GLshort s, GLshort t);
'void ( APIENTRY * qglTexCoord2sv )(const GLshort *v);
'void ( APIENTRY * qglTexCoord3d )(GLdouble s, GLdouble t, GLdouble r);
'void ( APIENTRY * qglTexCoord3dv )(const GLdouble *v);
'void ( APIENTRY * qglTexCoord3f )(GLfloat s, GLfloat t, GLfloat r);
'void ( APIENTRY * qglTexCoord3fv )(const GLfloat *v);
'void ( APIENTRY * qglTexCoord3i )(GLint s, GLint t, GLint r);
'void ( APIENTRY * qglTexCoord3iv )(const GLint *v);
'void ( APIENTRY * qglTexCoord3s )(GLshort s, GLshort t, GLshort r);
'void ( APIENTRY * qglTexCoord3sv )(const GLshort *v);
'void ( APIENTRY * qglTexCoord4d )(GLdouble s, GLdouble t, GLdouble r, GLdouble q);
'void ( APIENTRY * qglTexCoord4dv )(const GLdouble *v);
'void ( APIENTRY * qglTexCoord4f )(GLfloat s, GLfloat t, GLfloat r, GLfloat q);
'void ( APIENTRY * qglTexCoord4fv )(const GLfloat *v);
'void ( APIENTRY * qglTexCoord4i )(GLint s, GLint t, GLint r, GLint q);
'void ( APIENTRY * qglTexCoord4iv )(const GLint *v);
'void ( APIENTRY * qglTexCoord4s )(GLshort s, GLshort t, GLshort r, GLshort q);
'void ( APIENTRY * qglTexCoord4sv )(const GLshort *v);
'void ( APIENTRY * qglTexCoordPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
'void ( APIENTRY * qglTexEnvf )(GLenum target, GLenum pname, GLfloat param);
'void ( APIENTRY * qglTexEnvfv )(GLenum target, GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglTexEnvi )(GLenum target, GLenum pname, GLint param);
'void ( APIENTRY * qglTexEnviv )(GLenum target, GLenum pname, const GLint *params);
'void ( APIENTRY * qglTexGend )(GLenum coord, GLenum pname, GLdouble param);
'void ( APIENTRY * qglTexGendv )(GLenum coord, GLenum pname, const GLdouble *params);
'void ( APIENTRY * qglTexGenf )(GLenum coord, GLenum pname, GLfloat param);
'void ( APIENTRY * qglTexGenfv )(GLenum coord, GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglTexGeni )(GLenum coord, GLenum pname, GLint param);
'void ( APIENTRY * qglTexGeniv )(GLenum coord, GLenum pname, const GLint *params);
'void ( APIENTRY * qglTexImage1D )(GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
'void ( APIENTRY * qglTexImage2D )(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
'void ( APIENTRY * qglTexParameterf )(GLenum target, GLenum pname, GLfloat param);
'void ( APIENTRY * qglTexParameterfv )(GLenum target, GLenum pname, const GLfloat *params);
'void ( APIENTRY * qglTexParameteri )(GLenum target, GLenum pname, GLint param);
'void ( APIENTRY * qglTexParameteriv )(GLenum target, GLenum pname, const GLint *params);
'void ( APIENTRY * qglTexSubImage1D )(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
'void ( APIENTRY * qglTexSubImage2D )(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
'void ( APIENTRY * qglTranslated )(GLdouble x, GLdouble y, GLdouble z);
 dim shared qglTranslatef as sub (x as GLfloat , y as GLfloat, z as GLfloat) 
 'void ( APIENTRY * qglVertex2d )(GLdouble x, GLdouble y);
'void ( APIENTRY * qglVertex2dv )(const GLdouble *v);
'void ( APIENTRY * qglVertex2f )(GLfloat x, GLfloat y);
'void ( APIENTRY * qglVertex2fv )(const GLfloat *v);
'void ( APIENTRY * qglVertex2i )(GLint x, GLint y);
'void ( APIENTRY * qglVertex2iv )(const GLint *v);
'void ( APIENTRY * qglVertex2s )(GLshort x, GLshort y);
'void ( APIENTRY * qglVertex2sv )(const GLshort *v);
'void ( APIENTRY * qglVertex3d )(GLdouble x, GLdouble y, GLdouble z);
'void ( APIENTRY * qglVertex3dv )(const GLdouble *v);
'void ( APIENTRY * qglVertex3f )(GLfloat x, GLfloat y, GLfloat z);
'void ( APIENTRY * qglVertex3fv )(const GLfloat *v);
'void ( APIENTRY * qglVertex3i )(GLint x, GLint y, GLint z);
'void ( APIENTRY * qglVertex3iv )(const GLint *v);
'void ( APIENTRY * qglVertex3s )(GLshort x, GLshort y, GLshort z);
'void ( APIENTRY * qglVertex3sv )(const GLshort *v);
'void ( APIENTRY * qglVertex4d )(GLdouble x, GLdouble y, GLdouble z, GLdouble w);
'void ( APIENTRY * qglVertex4dv )(const GLdouble *v);
'void ( APIENTRY * qglVertex4f )(GLfloat x, GLfloat y, GLfloat z, GLfloat w);
'void ( APIENTRY * qglVertex4fv )(const GLfloat *v);
'void ( APIENTRY * qglVertex4i )(GLint x, GLint y, GLint z, GLint w);
'void ( APIENTRY * qglVertex4iv )(const GLint *v);
'void ( APIENTRY * qglVertex4s )(GLshort x, GLshort y, GLshort z, GLshort w);
'void ( APIENTRY * qglVertex4sv )(const GLshort *v);
'void ( APIENTRY * qglVertexPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
dim shared qglViewport as sub (x as GLint ,y as GLint ,_width as GLsizei ,_height as GLsizei ) 
'
dim shared  qglLockArraysEXT as sub (as integer,as integer) 
dim shared  qglUnlockArraysEXT  as sub ()
'
dim shared qwglSwapIntervalEXT as function( interval as integer) as BOOL   
dim shared  qwglGetDeviceGammaRampEXT as function( as zstring ptr, as zstring ptr, as zstring ptr ) as BOOL
dim shared qwglSetDeviceGammaRampEXT as function( as const zstring ptr, as const zstring ptr,as const zstring ptr ) as bool
dim shared  qglPointParameterfEXT as sub(param as GLenum ,value as GLfloat  ) 
dim shared qglPointParameterfvEXT as sub(param as GLenum ,value as const GLfloat ptr ) 
dim shared   qglColorTableEXT as sub(as integer,as integer,as integer,as integer,as integer,as  const any ptr ) 
dim shared qglSelectTextureSGIS as sub(as GLenum ) 
dim shared  qglMTexCoord2fSGIS as sub(as GLenum,as GLfloat,as GLfloat ) 
dim shared  qglActiveTextureARB as sub (as GLenum ) 
dim shared  qglClientActiveTextureARB as sub  (as  GLenum ) 

 
 

static shared dllAccum as sub (op as GLenum ,value as GLfloat )
 
static  shared dllAlphaFunc as sub (func as GLenum ,ref as GLclampf ) 
dim     shared dllAreTexturesResident  as function(n as GLsizei , textures as const GLuint ptr , residences as GLboolean ptr ) as GLboolean 
static  shared dllArrayElement  as sub (i as GLint) 
static  shared dllBegin  as sub( mode as GLenum) 
static  shared dllBindTexture  as sub ( target as GLenum, texture as GLuint) 
static  shared dllBitmap  as sub(_width as GLsizei , _height as GLsizei ,xorig as GLfloat , yorig as GLfloat, xmove as GLfloat,ymove as GLfloat ,  bitmap as const GLubyte ptr ) 
static  shared dllBlendFunc as sub(sfactor as GLenum ,dfactor as GLenum ) 
static  shared dllCallList as sub (_list as GLuint ) 
static  shared dllCallLists as sub (n as GLsizei , _type as GLenum,lists as const GLvoid ptr) 
static  shared dllClear  as sub(mask as GLbitfield ) 
static  shared dllClearAccum as sub(_red as GLfloat ,_green as GLfloat ,_blue as GLfloat ,alpha_ as GLfloat ) 
static  shared dllClearColor  as sub ( _red as GLclampf, green as GLclampf,blue as GLclampf, alpha_ as GLclampf) 
static  shared dllClearDepth as sub(_depth as GLclampd ) 
static  shared dllClearIndex  as sub( c as GLfloat) 
static  shared dllClearStencil  as sub( s as GLint) 
static  shared dllClipPlane as sub(plane as GLenum ,equation as const GLdouble ptr ) 
static  shared dllColor3b as sub(_red as GLbyte ,_green as GLbyte , _blue as GLbyte) 
static  shared dllColor3bv as sub (v as const GLbyte ptr) 
static  shared dllColor3d as sub( _red as GLdouble, _green as GLdouble ,_blue as GLdouble ) 
static  shared dllColor3dv  as sub(v as const GLdouble ptr) 
static  shared dllColor3f  as sub(_red as GLfloat ,_green as GLfloat ,_blue as GLfloat) 
static  shared dllColor3fv  as sub(v as const GLfloat ptr) 
static  shared dllColor3i  as sub(_red as GLint,_green as GLint, _blue as GLint) 
static  shared dllColor3iv  as sub(v as const GLint ptr) 
static  shared dllColor3s  as sub(_red as GLshort ,_green as GLshort, _blue as GLshort) 
static  shared dllColor3sv  as sub(v as const GLShort ptr) 
static  shared dllColor3ub  as sub (_red as GLubyte ,_green as GLubyte , _blue as GLubyte) 
static  shared dllColor3ubv  as sub (v as const GLubyte ptr) 
static  shared dllColor3ui as sub (_red as GLuint ,_green as GLuint , _blue as GLuint) 
static  shared dllColor3uiv as sub(v as const GLuint ptr) 
static  shared dllColor3us as sub (_red as GLushort, _green as GLushort, _blue as GLushort) 
static  shared dllColor3usv as sub(v as const GLushort ptr) 
static  shared dllColor4b  as sub(_red as GLbyte ,_green as GLbyte ,_blue as GLbyte ,alpha_ as GLbyte ) 
static  shared dllColor4bv  as sub(v as const GLbyte ptr) 
'static void ( APIENTRY * dllColor4d )(GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha);
'static void ( APIENTRY * dllColor4dv )(const GLdouble *v);
'static void ( APIENTRY * dllColor4f )(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
'static void ( APIENTRY * dllColor4fv )(const GLfloat *v);
'static void ( APIENTRY * dllColor4i )(GLint red, GLint green, GLint blue, GLint alpha);
'static void ( APIENTRY * dllColor4iv )(const GLint *v);
'static void ( APIENTRY * dllColor4s )(GLshort red, GLshort green, GLshort blue, GLshort alpha);
'static void ( APIENTRY * dllColor4sv )(const GLshort *v);
'static void ( APIENTRY * dllColor4ub )(GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
'static void ( APIENTRY * dllColor4ubv )(const GLubyte *v);
'static void ( APIENTRY * dllColor4ui )(GLuint red, GLuint green, GLuint blue, GLuint alpha);
'static void ( APIENTRY * dllColor4uiv )(const GLuint *v);
'static void ( APIENTRY * dllColor4us )(GLushort red, GLushort green, GLushort blue, GLushort alpha);
'static void ( APIENTRY * dllColor4usv )(const GLushort *v);
'static void ( APIENTRY * dllColorMask )(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
'static void ( APIENTRY * dllColorMaterial )(GLenum face, GLenum mode);
'static void ( APIENTRY * dllColorPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
'static void ( APIENTRY * dllCopyPixels )(GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
'static void ( APIENTRY * dllCopyTexImage1D )(GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLint border);
'static void ( APIENTRY * dllCopyTexImage2D )(GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
'static void ( APIENTRY * dllCopyTexSubImage1D )(GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
'static void ( APIENTRY * dllCopyTexSubImage2D )(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
 static shared dllCullFace as sub(_mode as GLenum ) 
'static void ( APIENTRY * dllDeleteLists )(GLuint list, GLsizei range);
'static void ( APIENTRY * dllDeleteTextures )(GLsizei n, const GLuint *textures);
'static void ( APIENTRY * dllDepthFunc )(GLenum func);
'static void ( APIENTRY * dllDepthMask )(GLboolean flag);
'static void ( APIENTRY * dllDepthRange )(GLclampd zNear, GLclampd zFar);
'static void ( APIENTRY * dllDisable )(GLenum cap);
'static void ( APIENTRY * dllDisableClientState )(GLenum array);
'static void ( APIENTRY * dllDrawArrays )(GLenum mode, GLint first, GLsizei count);
'static void ( APIENTRY * dllDrawBuffer )(GLenum mode);
'static void ( APIENTRY * dllDrawElements )(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
'static void ( APIENTRY * dllDrawPixels )(GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
'static void ( APIENTRY * dllEdgeFlag )(GLboolean flag);
'static void ( APIENTRY * dllEdgeFlagPointer )(GLsizei stride, const GLvoid *pointer);
'static void ( APIENTRY * dllEdgeFlagv )(const GLboolean *flag);
'static void ( APIENTRY * dllEnable )(GLenum cap);
'static void ( APIENTRY * dllEnableClientState )(GLenum array);
'static void ( APIENTRY * dllEnd )(void);
'static void ( APIENTRY * dllEndList )(void);
'static void ( APIENTRY * dllEvalCoord1d )(GLdouble u);
'static void ( APIENTRY * dllEvalCoord1dv )(const GLdouble *u);
'static void ( APIENTRY * dllEvalCoord1f )(GLfloat u);
'static void ( APIENTRY * dllEvalCoord1fv )(const GLfloat *u);
'static void ( APIENTRY * dllEvalCoord2d )(GLdouble u, GLdouble v);
'static void ( APIENTRY * dllEvalCoord2dv )(const GLdouble *u);
'static void ( APIENTRY * dllEvalCoord2f )(GLfloat u, GLfloat v);
'static void ( APIENTRY * dllEvalCoord2fv )(const GLfloat *u);
'static void ( APIENTRY * dllEvalMesh1 )(GLenum mode, GLint i1, GLint i2);
'static void ( APIENTRY * dllEvalMesh2 )(GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
'static void ( APIENTRY * dllEvalPoint1 )(GLint i);
'static void ( APIENTRY * dllEvalPoint2 )(GLint i, GLint j);
'static void ( APIENTRY * dllFeedbackBuffer )(GLsizei size, GLenum type, GLfloat *buffer);
static shared dllFinish as sub ()
static shared dllFlush  as sub() 
'static void ( APIENTRY * dllFogf )(GLenum pname, GLfloat param);
'static void ( APIENTRY * dllFogfv )(GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllFogi )(GLenum pname, GLint param);
'static void ( APIENTRY * dllFogiv )(GLenum pname, const GLint *params);
'static void ( APIENTRY * dllFrontFace )(GLenum mode);
'static void ( APIENTRY * dllFrustum )(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
'GLuint ( APIENTRY * dllGenLists )(GLsizei range);
'static void ( APIENTRY * dllGenTextures )(GLsizei n, GLuint *textures);
'static void ( APIENTRY * dllGetBooleanv )(GLenum pname, GLboolean *params);
'static void ( APIENTRY * dllGetClipPlane )(GLenum plane, GLdouble *equation);
'static void ( APIENTRY * dllGetDoublev )(GLenum pname, GLdouble *params);
 static  shared dllGetError as function() as GLenum
'static void ( APIENTRY * dllGetFloatv )(GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetIntegerv )(GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetLightfv )(GLenum light, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetLightiv )(GLenum light, GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetMapdv )(GLenum target, GLenum query, GLdouble *v);
'static void ( APIENTRY * dllGetMapfv )(GLenum target, GLenum query, GLfloat *v);
'static void ( APIENTRY * dllGetMapiv )(GLenum target, GLenum query, GLint *v);
'static void ( APIENTRY * dllGetMaterialfv )(GLenum face, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetMaterialiv )(GLenum face, GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetPixelMapfv )(GLenum map, GLfloat *values);
'static void ( APIENTRY * dllGetPixelMapuiv )(GLenum map, GLuint *values);
'static void ( APIENTRY * dllGetPixelMapusv )(GLenum map, GLushort *values);
'static void ( APIENTRY * dllGetPointerv )(GLenum pname, GLvoid* *params);
'static void ( APIENTRY * dllGetPolygonStipple )(GLubyte *mask);
'const GLubyte * ( APIENTRY * dllGetString )(GLenum name);
'static void ( APIENTRY * dllGetTexEnvfv )(GLenum target, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetTexEnviv )(GLenum target, GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetTexGendv )(GLenum coord, GLenum pname, GLdouble *params);
'static void ( APIENTRY * dllGetTexGenfv )(GLenum coord, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetTexGeniv )(GLenum coord, GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetTexImage )(GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
'static void ( APIENTRY * dllGetTexLevelParameterfv )(GLenum target, GLint level, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetTexLevelParameteriv )(GLenum target, GLint level, GLenum pname, GLint *params);
'static void ( APIENTRY * dllGetTexParameterfv )(GLenum target, GLenum pname, GLfloat *params);
'static void ( APIENTRY * dllGetTexParameteriv )(GLenum target, GLenum pname, GLint *params);
'static void ( APIENTRY * dllHint )(GLenum target, GLenum mode);
'static void ( APIENTRY * dllIndexMask )(GLuint mask);
'static void ( APIENTRY * dllIndexPointer )(GLenum type, GLsizei stride, const GLvoid *pointer);
'static void ( APIENTRY * dllIndexd )(GLdouble c);
'static void ( APIENTRY * dllIndexdv )(const GLdouble *c);
'static void ( APIENTRY * dllIndexf )(GLfloat c);
'static void ( APIENTRY * dllIndexfv )(const GLfloat *c);
'static void ( APIENTRY * dllIndexi )(GLint c);
'static void ( APIENTRY * dllIndexiv )(const GLint *c);
'static void ( APIENTRY * dllIndexs )(GLshort c);
'static void ( APIENTRY * dllIndexsv )(const GLshort *c);
'static void ( APIENTRY * dllIndexub )(GLubyte c);
'static void ( APIENTRY * dllIndexubv )(const GLubyte *c);
'static void ( APIENTRY * dllInitNames )(void);
'static void ( APIENTRY * dllInterleavedArrays )(GLenum format, GLsizei stride, const GLvoid *pointer);
'GLboolean ( APIENTRY * dllIsEnabled )(GLenum cap);
'GLboolean ( APIENTRY * dllIsList )(GLuint list);
'GLboolean ( APIENTRY * dllIsTexture )(GLuint texture);
'static void ( APIENTRY * dllLightModelf )(GLenum pname, GLfloat param);
'static void ( APIENTRY * dllLightModelfv )(GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllLightModeli )(GLenum pname, GLint param);
'static void ( APIENTRY * dllLightModeliv )(GLenum pname, const GLint *params);
'static void ( APIENTRY * dllLightf )(GLenum light, GLenum pname, GLfloat param);
'static void ( APIENTRY * dllLightfv )(GLenum light, GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllLighti )(GLenum light, GLenum pname, GLint param);
'static void ( APIENTRY * dllLightiv )(GLenum light, GLenum pname, const GLint *params);
'static void ( APIENTRY * dllLineStipple )(GLint factor, GLushort pattern);
'static void ( APIENTRY * dllLineWidth )(GLfloat width);
'static void ( APIENTRY * dllListBase )(GLuint base);
'static void ( APIENTRY * dllLoadIdentity )(void);
'static void ( APIENTRY * dllLoadMatrixd )(const GLdouble *m);
'static void ( APIENTRY * dllLoadMatrixf )(const GLfloat *m);
'static void ( APIENTRY * dllLoadName )(GLuint name);
'static void ( APIENTRY * dllLogicOp )(GLenum opcode);
'static void ( APIENTRY * dllMap1d )(GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
'static void ( APIENTRY * dllMap1f )(GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
'static void ( APIENTRY * dllMap2d )(GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
'static void ( APIENTRY * dllMap2f )(GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
'static void ( APIENTRY * dllMapGrid1d )(GLint un, GLdouble u1, GLdouble u2);
'static void ( APIENTRY * dllMapGrid1f )(GLint un, GLfloat u1, GLfloat u2);
'static void ( APIENTRY * dllMapGrid2d )(GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
'static void ( APIENTRY * dllMapGrid2f )(GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
'static void ( APIENTRY * dllMaterialf )(GLenum face, GLenum pname, GLfloat param);
'static void ( APIENTRY * dllMaterialfv )(GLenum face, GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllMateriali )(GLenum face, GLenum pname, GLint param);
'static void ( APIENTRY * dllMaterialiv )(GLenum face, GLenum pname, const GLint *params);
'static void ( APIENTRY * dllMatrixMode )(GLenum mode);
'static void ( APIENTRY * dllMultMatrixd )(const GLdouble *m);
'static void ( APIENTRY * dllMultMatrixf )(const GLfloat *m);
'static void ( APIENTRY * dllNewList )(GLuint list, GLenum mode);
'static void ( APIENTRY * dllNormal3b )(GLbyte nx, GLbyte ny, GLbyte nz);
'static void ( APIENTRY * dllNormal3bv )(const GLbyte *v);
'static void ( APIENTRY * dllNormal3d )(GLdouble nx, GLdouble ny, GLdouble nz);
'static void ( APIENTRY * dllNormal3dv )(const GLdouble *v);
'static void ( APIENTRY * dllNormal3f )(GLfloat nx, GLfloat ny, GLfloat nz);
'static void ( APIENTRY * dllNormal3fv )(const GLfloat *v);
'static void ( APIENTRY * dllNormal3i )(GLint nx, GLint ny, GLint nz);
'static void ( APIENTRY * dllNormal3iv )(const GLint *v);
'static void ( APIENTRY * dllNormal3s )(GLshort nx, GLshort ny, GLshort nz);
'static void ( APIENTRY * dllNormal3sv )(const GLshort *v);
'static void ( APIENTRY * dllNormalPointer )(GLenum type, GLsizei stride, const GLvoid *pointer);
'static void ( APIENTRY * dllOrtho )(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
'static void ( APIENTRY * dllPassThrough )(GLfloat token);
'static void ( APIENTRY * dllPixelMapfv )(GLenum map, GLsizei mapsize, const GLfloat *values);
'static void ( APIENTRY * dllPixelMapuiv )(GLenum map, GLsizei mapsize, const GLuint *values);
'static void ( APIENTRY * dllPixelMapusv )(GLenum map, GLsizei mapsize, const GLushort *values);
'static void ( APIENTRY * dllPixelStoref )(GLenum pname, GLfloat param);
'static void ( APIENTRY * dllPixelStorei )(GLenum pname, GLint param);
'static void ( APIENTRY * dllPixelTransferf )(GLenum pname, GLfloat param);
'static void ( APIENTRY * dllPixelTransferi )(GLenum pname, GLint param);
'static void ( APIENTRY * dllPixelZoom )(GLfloat xfactor, GLfloat yfactor);
'static void ( APIENTRY * dllPointSize )(GLfloat size);
'static void ( APIENTRY * dllPolygonMode )(GLenum face, GLenum mode);
'static void ( APIENTRY * dllPolygonOffset )(GLfloat factor, GLfloat units);
'static void ( APIENTRY * dllPolygonStipple )(const GLubyte *mask);
'static void ( APIENTRY * dllPopAttrib )(void);
'static void ( APIENTRY * dllPopClientAttrib )(void);
'static void ( APIENTRY * dllPopMatrix )(void);
'static void ( APIENTRY * dllPopName )(void);
'static void ( APIENTRY * dllPrioritizeTextures )(GLsizei n, const GLuint *textures, const GLclampf *priorities);
'static void ( APIENTRY * dllPushAttrib )(GLbitfield mask);
'static void ( APIENTRY * dllPushClientAttrib )(GLbitfield mask);
'static void ( APIENTRY * dllPushMatrix )(void);
'static void ( APIENTRY * dllPushName )(GLuint name);
'static void ( APIENTRY * dllRasterPos2d )(GLdouble x, GLdouble y);
'static void ( APIENTRY * dllRasterPos2dv )(const GLdouble *v);
'static void ( APIENTRY * dllRasterPos2f )(GLfloat x, GLfloat y);
'static void ( APIENTRY * dllRasterPos2fv )(const GLfloat *v);
'static void ( APIENTRY * dllRasterPos2i )(GLint x, GLint y);
'static void ( APIENTRY * dllRasterPos2iv )(const GLint *v);
'static void ( APIENTRY * dllRasterPos2s )(GLshort x, GLshort y);
'static void ( APIENTRY * dllRasterPos2sv )(const GLshort *v);
'static void ( APIENTRY * dllRasterPos3d )(GLdouble x, GLdouble y, GLdouble z);
'static void ( APIENTRY * dllRasterPos3dv )(const GLdouble *v);
'static void ( APIENTRY * dllRasterPos3f )(GLfloat x, GLfloat y, GLfloat z);
'static void ( APIENTRY * dllRasterPos3fv )(const GLfloat *v);
'static void ( APIENTRY * dllRasterPos3i )(GLint x, GLint y, GLint z);
'static void ( APIENTRY * dllRasterPos3iv )(const GLint *v);
'static void ( APIENTRY * dllRasterPos3s )(GLshort x, GLshort y, GLshort z);
'static void ( APIENTRY * dllRasterPos3sv )(const GLshort *v);
'static void ( APIENTRY * dllRasterPos4d )(GLdouble x, GLdouble y, GLdouble z, GLdouble w);
'static void ( APIENTRY * dllRasterPos4dv )(const GLdouble *v);
'static void ( APIENTRY * dllRasterPos4f )(GLfloat x, GLfloat y, GLfloat z, GLfloat w);
'static void ( APIENTRY * dllRasterPos4fv )(const GLfloat *v);
'static void ( APIENTRY * dllRasterPos4i )(GLint x, GLint y, GLint z, GLint w);
'static void ( APIENTRY * dllRasterPos4iv )(const GLint *v);
'static void ( APIENTRY * dllRasterPos4s )(GLshort x, GLshort y, GLshort z, GLshort w);
'static void ( APIENTRY * dllRasterPos4sv )(const GLshort *v);
'static void ( APIENTRY * dllReadBuffer )(GLenum mode);
'static void ( APIENTRY * dllReadPixels )(GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
'static void ( APIENTRY * dllRectd )(GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
'static void ( APIENTRY * dllRectdv )(const GLdouble *v1, const GLdouble *v2);
'static void ( APIENTRY * dllRectf )(GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
'static void ( APIENTRY * dllRectfv )(const GLfloat *v1, const GLfloat *v2);
'static void ( APIENTRY * dllRecti )(GLint x1, GLint y1, GLint x2, GLint y2);
'static void ( APIENTRY * dllRectiv )(const GLint *v1, const GLint *v2);
'static void ( APIENTRY * dllRects )(GLshort x1, GLshort y1, GLshort x2, GLshort y2);
'static void ( APIENTRY * dllRectsv )(const GLshort *v1, const GLshort *v2);
static shared  dllRenderMode  as function(_mode as GLenum ) as GLint
static shared dllRotated (angle as GLdouble ,x as  GLdouble , y as  GLdouble,z as GLdouble ) 
'static void ( APIENTRY * dllRotatef )(GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
'static void ( APIENTRY * dllScaled )(GLdouble x, GLdouble y, GLdouble z);
'static void ( APIENTRY * dllScalef )(GLfloat x, GLfloat y, GLfloat z);
'static void ( APIENTRY * dllScissor )(GLint x, GLint y, GLsizei width, GLsizei height);
'static void ( APIENTRY * dllSelectBuffer )(GLsizei size, GLuint *buffer);
'static void ( APIENTRY * dllShadeModel )(GLenum mode);
'static void ( APIENTRY * dllStencilFunc )(GLenum func, GLint ref, GLuint mask);
'static void ( APIENTRY * dllStencilMask )(GLuint mask);
'static void ( APIENTRY * dllStencilOp )(GLenum fail, GLenum zfail, GLenum zpass);
'static void ( APIENTRY * dllTexCoord1d )(GLdouble s);
'static void ( APIENTRY * dllTexCoord1dv )(const GLdouble *v);
'static void ( APIENTRY * dllTexCoord1f )(GLfloat s);
'static void ( APIENTRY * dllTexCoord1fv )(const GLfloat *v);
'static void ( APIENTRY * dllTexCoord1i )(GLint s);
'static void ( APIENTRY * dllTexCoord1iv )(const GLint *v);
'static void ( APIENTRY * dllTexCoord1s )(GLshort s);
'static void ( APIENTRY * dllTexCoord1sv )(const GLshort *v);
'static void ( APIENTRY * dllTexCoord2d )(GLdouble s, GLdouble t);
'static void ( APIENTRY * dllTexCoord2dv )(const GLdouble *v);
'static void ( APIENTRY * dllTexCoord2f )(GLfloat s, GLfloat t);
'static void ( APIENTRY * dllTexCoord2fv )(const GLfloat *v);
'static void ( APIENTRY * dllTexCoord2i )(GLint s, GLint t);
'static void ( APIENTRY * dllTexCoord2iv )(const GLint *v);
'static void ( APIENTRY * dllTexCoord2s )(GLshort s, GLshort t);
'static void ( APIENTRY * dllTexCoord2sv )(const GLshort *v);
'static void ( APIENTRY * dllTexCoord3d )(GLdouble s, GLdouble t, GLdouble r);
'static void ( APIENTRY * dllTexCoord3dv )(const GLdouble *v);
'static void ( APIENTRY * dllTexCoord3f )(GLfloat s, GLfloat t, GLfloat r);
'static void ( APIENTRY * dllTexCoord3fv )(const GLfloat *v);
'static void ( APIENTRY * dllTexCoord3i )(GLint s, GLint t, GLint r);
'static void ( APIENTRY * dllTexCoord3iv )(const GLint *v);
'static void ( APIENTRY * dllTexCoord3s )(GLshort s, GLshort t, GLshort r);
'static void ( APIENTRY * dllTexCoord3sv )(const GLshort *v);
'static void ( APIENTRY * dllTexCoord4d )(GLdouble s, GLdouble t, GLdouble r, GLdouble q);
'static void ( APIENTRY * dllTexCoord4dv )(const GLdouble *v);
'static void ( APIENTRY * dllTexCoord4f )(GLfloat s, GLfloat t, GLfloat r, GLfloat q);
'static void ( APIENTRY * dllTexCoord4fv )(const GLfloat *v);
'static void ( APIENTRY * dllTexCoord4i )(GLint s, GLint t, GLint r, GLint q);
'static void ( APIENTRY * dllTexCoord4iv )(const GLint *v);
'static void ( APIENTRY * dllTexCoord4s )(GLshort s, GLshort t, GLshort r, GLshort q);
'static void ( APIENTRY * dllTexCoord4sv )(const GLshort *v);
'static void ( APIENTRY * dllTexCoordPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
'static void ( APIENTRY * dllTexEnvf )(GLenum target, GLenum pname, GLfloat param);
'static void ( APIENTRY * dllTexEnvfv )(GLenum target, GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllTexEnvi )(GLenum target, GLenum pname, GLint param);
'static void ( APIENTRY * dllTexEnviv )(GLenum target, GLenum pname, const GLint *params);
'static void ( APIENTRY * dllTexGend )(GLenum coord, GLenum pname, GLdouble param);
'static void ( APIENTRY * dllTexGendv )(GLenum coord, GLenum pname, const GLdouble *params);
'static void ( APIENTRY * dllTexGenf )(GLenum coord, GLenum pname, GLfloat param);
'static void ( APIENTRY * dllTexGenfv )(GLenum coord, GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllTexGeni )(GLenum coord, GLenum pname, GLint param);
'static void ( APIENTRY * dllTexGeniv )(GLenum coord, GLenum pname, const GLint *params);
'static void ( APIENTRY * dllTexImage1D )(GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
'static void ( APIENTRY * dllTexImage2D )(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
'static void ( APIENTRY * dllTexParameterf )(GLenum target, GLenum pname, GLfloat param);
'static void ( APIENTRY * dllTexParameterfv )(GLenum target, GLenum pname, const GLfloat *params);
'static void ( APIENTRY * dllTexParameteri )(GLenum target, GLenum pname, GLint param);
'static void ( APIENTRY * dllTexParameteriv )(GLenum target, GLenum pname, const GLint *params);
'static void ( APIENTRY * dllTexSubImage1D )(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
'static void ( APIENTRY * dllTexSubImage2D )(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
'static void ( APIENTRY * dllTranslated )(GLdouble x, GLdouble y, GLdouble z);
'static void ( APIENTRY * dllTranslatef )(GLfloat x, GLfloat y, GLfloat z);
'static void ( APIENTRY * dllVertex2d )(GLdouble x, GLdouble y);
'static void ( APIENTRY * dllVertex2dv )(const GLdouble *v);
'static void ( APIENTRY * dllVertex2f )(GLfloat x, GLfloat y);
'static void ( APIENTRY * dllVertex2fv )(const GLfloat *v);
'static void ( APIENTRY * dllVertex2i )(GLint x, GLint y);
'static void ( APIENTRY * dllVertex2iv )(const GLint *v);
'static void ( APIENTRY * dllVertex2s )(GLshort x, GLshort y);
'static void ( APIENTRY * dllVertex2sv )(const GLshort *v);
'static void ( APIENTRY * dllVertex3d )(GLdouble x, GLdouble y, GLdouble z);
'static void ( APIENTRY * dllVertex3dv )(const GLdouble *v);
'static void ( APIENTRY * dllVertex3f )(GLfloat x, GLfloat y, GLfloat z);
'static void ( APIENTRY * dllVertex3fv )(const GLfloat *v);
'static void ( APIENTRY * dllVertex3i )(GLint x, GLint y, GLint z);
'static void ( APIENTRY * dllVertex3iv )(const GLint *v);
'static void ( APIENTRY * dllVertex3s )(GLshort x, GLshort y, GLshort z);
'static void ( APIENTRY * dllVertex3sv )(const GLshort *v);
'static void ( APIENTRY * dllVertex4d )(GLdouble x, GLdouble y, GLdouble z, GLdouble w);
'static void ( APIENTRY * dllVertex4dv )(const GLdouble *v);
'static void ( APIENTRY * dllVertex4f )(GLfloat x, GLfloat y, GLfloat z, GLfloat w);
'static void ( APIENTRY * dllVertex4fv )(const GLfloat *v);
'static void ( APIENTRY * dllVertex4i )(GLint x, GLint y, GLint z, GLint w);
'static void ( APIENTRY * dllVertex4iv )(const GLint *v);
'static void ( APIENTRY * dllVertex4s )(GLshort x, GLshort y, GLshort z, GLshort w);
'static void ( APIENTRY * dllVertex4sv )(const GLshort *v);
'static void ( APIENTRY * dllVertexPointer )(GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
 static   dllViewport  as  sub(x as GLint ,y as GLint ,_width as GLsizei ,_height as GLsizei ) 
 
#define GPA( a ) GetProcAddress( glw_state.hinstOpenGL, a )

sub QGL_Shutdown()
 
	if (glw_state.hinstOpenGL <> null ) then
				FreeLibrary( glw_state.hinstOpenGL ) 
		glw_state.hinstOpenGL = NULL 
		
	EndIf
 

 

	glw_state.hinstOpenGL = NULL

	qglAccum                     = NULL
	qglAlphaFunc                 = NULL
	qglAreTexturesResident       = NULL
	qglArrayElement              = NULL
	qglBegin                     = NULL
	qglBindTexture               = NULL
	qglBitmap                    = NULL
	qglBlendFunc                 = NULL
	qglCallList                  = NULL
	qglCallLists                 = NULL
	qglClear                     = NULL
	qglClearAccum                = NULL
	qglClearColor                = NULL
	qglClearDepth                = NULL
	qglClearIndex                = NULL
	qglClearStencil              = NULL
	qglClipPlane                 = NULL
	qglColor3b                   = NULL
	qglColor3bv                  = NULL
	qglColor3d                   = NULL
	qglColor3dv                  = NULL
	qglColor3f                   = NULL
	qglColor3fv                  = NULL
	qglColor3i                   = NULL
	qglColor3iv                  = NULL
	qglColor3s                   = NULL
	qglColor3sv                  = NULL
	qglColor3ub                  = NULL
	qglColor3ubv                 = NULL
	qglColor3ui                  = NULL
	qglColor3uiv                 = NULL
	qglColor3us                  = NULL
	qglColor3usv                 = NULL
	qglColor4b                   = NULL
	qglColor4bv                  = NULL
	qglColor4d                   = NULL
	qglColor4dv                  = NULL
	qglColor4f                   = NULL
	qglColor4fv                  = NULL
	qglColor4i                   = NULL
	qglColor4iv                  = NULL
	qglColor4s                   = NULL
	qglColor4sv                  = NULL
	qglColor4ub                  = NULL
	qglColor4ubv                 = NULL
	qglColor4ui                  = NULL
	qglColor4uiv                 = NULL
	qglColor4us                  = NULL
	qglColor4usv                 = NULL
	qglColorMask                 = NULL
	qglColorMaterial             = NULL
	qglColorPointer              = NULL
	qglCopyPixels                = NULL
	qglCopyTexImage1D            = NULL
	qglCopyTexImage2D            = NULL
	qglCopyTexSubImage1D         = NULL
	qglCopyTexSubImage2D         = NULL
	qglCullFace                  = NULL
	qglDeleteLists               = NULL
	qglDeleteTextures            = NULL
	qglDepthFunc                 = NULL
	qglDepthMask                 = NULL
	qglDepthRange                = NULL
	qglDisable                   = NULL
	qglDisableClientState        = NULL
	qglDrawArrays                = NULL
	qglDrawBuffer                = NULL
	qglDrawElements              = NULL
	qglDrawPixels                = NULL
	qglEdgeFlag                  = NULL
	qglEdgeFlagPointer           = NULL
	qglEdgeFlagv                 = NULL
	qglEnable                    = NULL
	qglEnableClientState         = NULL
	qglEnd                       = NULL
	qglEndList                   = NULL
	qglEvalCoord1d               = NULL
	qglEvalCoord1dv              = NULL
	qglEvalCoord1f               = NULL
	qglEvalCoord1fv              = NULL
	qglEvalCoord2d               = NULL
	qglEvalCoord2dv              = NULL
	qglEvalCoord2f               = NULL
	qglEvalCoord2fv              = NULL
	qglEvalMesh1                 = NULL
	qglEvalMesh2                 = NULL
	qglEvalPoint1                = NULL
	qglEvalPoint2                = NULL
	qglFeedbackBuffer            = NULL
	qglFinish                    = NULL
	qglFlush                     = NULL
	qglFogf                      = NULL
	qglFogfv                     = NULL
	qglFogi                      = NULL
	qglFogiv                     = NULL
	qglFrontFace                 = NULL
	qglFrustum                   = NULL
	qglGenLists                  = NULL
	qglGenTextures               = NULL
	qglGetBooleanv               = NULL
	qglGetClipPlane              = NULL
	qglGetDoublev                = NULL
	qglGetError                  = NULL
	qglGetFloatv                 = NULL
	qglGetIntegerv               = NULL
	qglGetLightfv                = NULL
	qglGetLightiv                = NULL
	qglGetMapdv                  = NULL
	qglGetMapfv                  = NULL
	qglGetMapiv                  = NULL
	qglGetMaterialfv             = NULL
	qglGetMaterialiv             = NULL
	qglGetPixelMapfv             = NULL
	qglGetPixelMapuiv            = NULL
	qglGetPixelMapusv            = NULL
	qglGetPointerv               = NULL
	qglGetPolygonStipple         = NULL
	qglGetString                 = NULL
	qglGetTexEnvfv               = NULL
	qglGetTexEnviv               = NULL
	qglGetTexGendv               = NULL
	qglGetTexGenfv               = NULL
	qglGetTexGeniv               = NULL
	qglGetTexImage               = NULL
	qglGetTexLevelParameterfv    = NULL
	qglGetTexLevelParameteriv    = NULL
	qglGetTexParameterfv         = NULL
	qglGetTexParameteriv         = NULL
	qglHint                      = NULL
	qglIndexMask                 = NULL
	qglIndexPointer              = NULL
	qglIndexd                    = NULL
	qglIndexdv                   = NULL
	qglIndexf                    = NULL
	qglIndexfv                   = NULL
	qglIndexi                    = NULL
	qglIndexiv                   = NULL
	qglIndexs                    = NULL
	qglIndexsv                   = NULL
	qglIndexub                   = NULL
	qglIndexubv                  = NULL
	qglInitNames                 = NULL
	qglInterleavedArrays         = NULL
	qglIsEnabled                 = NULL
	qglIsList                    = NULL
	qglIsTexture                 = NULL
	qglLightModelf               = NULL
	qglLightModelfv              = NULL
	qglLightModeli               = NULL
	qglLightModeliv              = NULL
	qglLightf                    = NULL
	qglLightfv                   = NULL
	qglLighti                    = NULL
	qglLightiv                   = NULL
	qglLineStipple               = NULL
	qglLineWidth                 = NULL
	qglListBase                  = NULL
	qglLoadIdentity              = NULL
	qglLoadMatrixd               = NULL
	qglLoadMatrixf               = NULL
	qglLoadName                  = NULL
	qglLogicOp                   = NULL
	qglMap1d                     = NULL
	qglMap1f                     = NULL
	qglMap2d                     = NULL
	qglMap2f                     = NULL
	qglMapGrid1d                 = NULL
	qglMapGrid1f                 = NULL
	qglMapGrid2d                 = NULL
	qglMapGrid2f                 = NULL
	qglMaterialf                 = NULL
	qglMaterialfv                = NULL
	qglMateriali                 = NULL
	qglMaterialiv                = NULL
	qglMatrixMode                = NULL
	qglMultMatrixd               = NULL
	qglMultMatrixf               = NULL
	qglNewList                   = NULL
	qglNormal3b                  = NULL
	qglNormal3bv                 = NULL
	qglNormal3d                  = NULL
	qglNormal3dv                 = NULL
	qglNormal3f                  = NULL
	qglNormal3fv                 = NULL
	qglNormal3i                  = NULL
	qglNormal3iv                 = NULL
	qglNormal3s                  = NULL
	qglNormal3sv                 = NULL
	qglNormalPointer             = NULL
	qglOrtho                     = NULL
	qglPassThrough               = NULL
	qglPixelMapfv                = NULL
	qglPixelMapuiv               = NULL
	qglPixelMapusv               = NULL
	qglPixelStoref               = NULL
	qglPixelStorei               = NULL
	qglPixelTransferf            = NULL
	qglPixelTransferi            = NULL
	qglPixelZoom                 = NULL
	qglPointSize                 = NULL
	qglPolygonMode               = NULL
	qglPolygonOffset             = NULL
	qglPolygonStipple            = NULL
	qglPopAttrib                 = NULL
	qglPopClientAttrib           = NULL
	qglPopMatrix                 = NULL
	qglPopName                   = NULL
	qglPrioritizeTextures        = NULL
	qglPushAttrib                = NULL
	qglPushClientAttrib          = NULL
	qglPushMatrix                = NULL
	qglPushName                  = NULL
	qglRasterPos2d               = NULL
	qglRasterPos2dv              = NULL
	qglRasterPos2f               = NULL
	qglRasterPos2fv              = NULL
	qglRasterPos2i               = NULL
	qglRasterPos2iv              = NULL
	qglRasterPos2s               = NULL
	qglRasterPos2sv              = NULL
	qglRasterPos3d               = NULL
	qglRasterPos3dv              = NULL
	qglRasterPos3f               = NULL
	qglRasterPos3fv              = NULL
	qglRasterPos3i               = NULL
	qglRasterPos3iv              = NULL
	qglRasterPos3s               = NULL
	qglRasterPos3sv              = NULL
	qglRasterPos4d               = NULL
	qglRasterPos4dv              = NULL
	qglRasterPos4f               = NULL
	qglRasterPos4fv              = NULL
	qglRasterPos4i               = NULL
	qglRasterPos4iv              = NULL
	qglRasterPos4s               = NULL
	qglRasterPos4sv              = NULL
	qglReadBuffer                = NULL
	qglReadPixels                = NULL
	qglRectd                     = NULL
	qglRectdv                    = NULL
	qglRectf                     = NULL
	qglRectfv                    = NULL
	qglRecti                     = NULL
	qglRectiv                    = NULL
	qglRects                     = NULL
	qglRectsv                    = NULL
	qglRenderMode                = NULL
	qglRotated                   = NULL
	qglRotatef                   = NULL
	qglScaled                    = NULL
	qglScalef                    = NULL
	qglScissor                   = NULL
	qglSelectBuffer              = NULL
	qglShadeModel                = NULL
	qglStencilFunc               = NULL
	qglStencilMask               = NULL
	qglStencilOp                 = NULL
	qglTexCoord1d                = NULL
	qglTexCoord1dv               = NULL
	qglTexCoord1f                = NULL
	qglTexCoord1fv               = NULL
	qglTexCoord1i                = NULL
	qglTexCoord1iv               = NULL
	qglTexCoord1s                = NULL
	qglTexCoord1sv               = NULL
	qglTexCoord2d                = NULL
	qglTexCoord2dv               = NULL
	qglTexCoord2f                = NULL
	qglTexCoord2fv               = NULL
	qglTexCoord2i                = NULL
	qglTexCoord2iv               = NULL
	qglTexCoord2s                = NULL
	qglTexCoord2sv               = NULL
	qglTexCoord3d                = NULL
	qglTexCoord3dv               = NULL
	qglTexCoord3f                = NULL
	qglTexCoord3fv               = NULL
	qglTexCoord3i                = NULL
	qglTexCoord3iv               = NULL
	qglTexCoord3s                = NULL
	qglTexCoord3sv               = NULL
	qglTexCoord4d                = NULL
	qglTexCoord4dv               = NULL
	qglTexCoord4f                = NULL
	qglTexCoord4fv               = NULL
	qglTexCoord4i                = NULL
	qglTexCoord4iv               = NULL
	qglTexCoord4s                = NULL
	qglTexCoord4sv               = NULL
	qglTexCoordPointer           = NULL
	qglTexEnvf                   = NULL
	qglTexEnvfv                  = NULL
	qglTexEnvi                   = NULL
	qglTexEnviv                  = NULL
	qglTexGend                   = NULL
	qglTexGendv                  = NULL
	qglTexGenf                   = NULL
	qglTexGenfv                  = NULL
	qglTexGeni                   = NULL
	qglTexGeniv                  = NULL
	qglTexImage1D                = NULL
	qglTexImage2D                = NULL
	qglTexParameterf             = NULL
	qglTexParameterfv            = NULL
	qglTexParameteri             = NULL
	qglTexParameteriv            = NULL
	qglTexSubImage1D             = NULL
	qglTexSubImage2D             = NULL
	qglTranslated                = NULL
	qglTranslatef                = NULL
	qglVertex2d                  = NULL
	qglVertex2dv                 = NULL
	qglVertex2f                  = NULL
	qglVertex2fv                 = NULL
	qglVertex2i                  = NULL
	qglVertex2iv                 = NULL
	qglVertex2s                  = NULL
	qglVertex2sv                 = NULL
	qglVertex3d                  = NULL
	qglVertex3dv                 = NULL
	qglVertex3f                  = NULL
	qglVertex3fv                 = NULL
	qglVertex3i                  = NULL
	qglVertex3iv                 = NULL
	qglVertex3s                  = NULL
	qglVertex3sv                 = NULL
	qglVertex4d                  = NULL
	qglVertex4dv                 = NULL
	qglVertex4f                  = NULL
	qglVertex4fv                 = NULL
	qglVertex4i                  = NULL
	qglVertex4iv                 = NULL
	qglVertex4s                  = NULL
	qglVertex4sv                 = NULL
	qglVertexPointer             = NULL
	qglViewport                  = NULL

	qwglCopyContext              = NULL
	qwglCreateContext            = NULL
	qwglCreateLayerContext       = NULL
	qwglDeleteContext            = NULL
	qwglDescribeLayerPlane       = NULL
	qwglGetCurrentContext        = NULL
	qwglGetCurrentDC             = NULL
	qwglGetLayerPaletteEntries   = NULL
	qwglGetProcAddress           = NULL
	qwglMakeCurrent              = NULL
	qwglRealizeLayerPalette      = NULL
	qwglSetLayerPaletteEntries   = NULL
	qwglShareLists               = NULL
	qwglSwapLayerBuffers         = NULL
	qwglUseFontBitmaps           = NULL
	qwglUseFontOutlines          = NULL

	qwglChoosePixelFormat        = NULL
	qwglDescribePixelFormat      = NULL
	qwglGetPixelFormat           = NULL
	qwglSetPixelFormat           = NULL
	qwglSwapBuffers              = NULL

	qwglSwapIntervalEXT	= NULL

	qwglGetDeviceGammaRampEXT = NULL
	qwglSetDeviceGammaRampEXT = NULL
end if
 
function QGL_Init( dllname as const zstring ptr) as qboolean
	
	
	 
	scope '{
	dim envbuffer(1024) as ubyte 
	dim g as float

	'	g = 2.00 * ( 0.8 - ( vid_gamma->value - 0.5 ) ) + 1.0F;
	 	Com_sprintf( envbuffer, sizeof(envbuffer), "SSTV2_GAMMA=%f", g ) 
	 	putenv( envbuffer ) 
	 	Com_sprintf( envbuffer, sizeof(envbuffer), "SST_GAMMA=%f", g );
	 	putenv( envbuffer ) 
	end scope '}
    
	
	g = 10
	
	
	if (glw_state.hinstOpenGL = LoadLibrary(dllname)) = 0 then
		
		dim buf as zstring ptr
		ri.Con_Printf( PRINT_ALL, "%s\n", buf )
	return _false
		
	EndIf
	
 
 	gl_config.allow_cds = _true

	 qglAccum                     = dllAccum = GPA( "glAccum" )
	 qglAlphaFunc                 = dllAlphaFunc = GPA( "glAlphaFunc" )
	 qglAreTexturesResident       = dllAreTexturesResident = GPA( "glAreTexturesResident" )
	 qglArrayElement              = dllArrayElement = GPA( "glArrayElement" )
	 qglBegin                     = dllBegin = GPA( "glBegin" )
	 qglBindTexture               = dllBindTexture = GPA( "glBindTexture" )
	 qglBitmap                    = dllBitmap = GPA( "glBitmap" )
	 qglBlendFunc                 = dllBlendFunc = GPA( "glBlendFunc" )
	 qglCallList                  = dllCallList = GPA( "glCallList" )
	 qglCallLists                 = dllCallLists = GPA( "glCallLists" )
	 qglClear                     = dllClear = GPA( "glClear" )
	 qglClearAccum                = dllClearAccum = GPA( "glClearAccum" )
	 qglClearColor                = dllClearColor = GPA( "glClearColor" )
	 qglClearDepth                = dllClearDepth = GPA( "glClearDepth" )
	qglClearIndex                = dllClearIndex = GPA( "glClearIndex" )
	qglClearStencil              = dllClearStencil = GPA( "glClearStencil" )
	qglClipPlane                 = dllClipPlane = GPA( "glClipPlane" )
	qglColor3b                   = dllColor3b = GPA( "glColor3b" )
	qglColor3bv                  = dllColor3bv = GPA( "glColor3bv" )
	qglColor3d                   = dllColor3d = GPA( "glColor3d" )
	qglColor3dv                  = dllColor3dv = GPA( "glColor3dv" )
	qglColor3f                   = dllColor3f = GPA( "glColor3f" )
	qglColor3fv                  = dllColor3fv = GPA( "glColor3fv" )
	qglColor3i                   = dllColor3i = GPA( "glColor3i" )
	qglColor3iv                  = dllColor3iv = GPA( "glColor3iv" )
	qglColor3s                   = dllColor3s = GPA( "glColor3s" )
	qglColor3sv                  = dllColor3sv = GPA( "glColor3sv" )
	qglColor3ub                  = dllColor3ub = GPA( "glColor3ub" )
	qglColor3ubv                 = dllColor3ubv = GPA( "glColor3ubv" )
	qglColor3ui                  = dllColor3ui = GPA( "glColor3ui" )
	qglColor3uiv                 = dllColor3uiv = GPA( "glColor3uiv" )
	qglColor3us                  = dllColor3us = GPA( "glColor3us" )
	qglColor3usv                 = dllColor3usv = GPA( "glColor3usv" )
	qglColor4b                   = dllColor4b = GPA( "glColor4b" )
	qglColor4bv                  = dllColor4bv = GPA( "glColor4bv" )
	qglColor4d                   = dllColor4d = GPA( "glColor4d" )
	qglColor4dv                  = dllColor4dv = GPA( "glColor4dv" )
	qglColor4f                   = dllColor4f = GPA( "glColor4f" )
	qglColor4fv                  = dllColor4fv = GPA( "glColor4fv" )
	qglColor4i                   = dllColor4i = GPA( "glColor4i" )
	qglColor4iv                  = dllColor4iv = GPA( "glColor4iv" )
	qglColor4s                   = dllColor4s = GPA( "glColor4s" )
	qglColor4sv                  = dllColor4sv = GPA( "glColor4sv" )
	qglColor4ub                  = dllColor4ub = GPA( "glColor4ub" )
	qglColor4ubv                 = dllColor4ubv = GPA( "glColor4ubv" )
	qglColor4ui                  = dllColor4ui = GPA( "glColor4ui" )
	qglColor4uiv                 = dllColor4uiv = GPA( "glColor4uiv" )
	qglColor4us                  = dllColor4us = GPA( "glColor4us" )
	qglColor4usv                 = dllColor4usv = GPA( "glColor4usv" )
	qglColorMask                 = dllColorMask = GPA( "glColorMask" )
	qglColorMaterial             = dllColorMaterial = GPA( "glColorMaterial" )
	qglColorPointer              = dllColorPointer = GPA( "glColorPointer" )
	qglCopyPixels                = dllCopyPixels = GPA( "glCopyPixels" )
	qglCopyTexImage1D            = dllCopyTexImage1D = GPA( "glCopyTexImage1D" )
	qglCopyTexImage2D            = dllCopyTexImage2D = GPA( "glCopyTexImage2D" )
	qglCopyTexSubImage1D         = dllCopyTexSubImage1D = GPA( "glCopyTexSubImage1D" )
	qglCopyTexSubImage2D         = dllCopyTexSubImage2D = GPA( "glCopyTexSubImage2D" )
	qglCullFace                  = dllCullFace = GPA( "glCullFace" )
	qglDeleteLists               = dllDeleteLists = GPA( "glDeleteLists" )
	qglDeleteTextures            = dllDeleteTextures = GPA( "glDeleteTextures" )
	qglDepthFunc                 = dllDepthFunc = GPA( "glDepthFunc" )
	qglDepthMask                 = dllDepthMask = GPA( "glDepthMask" )
	qglDepthRange                = dllDepthRange = GPA( "glDepthRange" )
	qglDisable                   = dllDisable = GPA( "glDisable" )
	qglDisableClientState        = dllDisableClientState = GPA( "glDisableClientState" )
	qglDrawArrays                = dllDrawArrays = GPA( "glDrawArrays" )
	qglDrawBuffer                = dllDrawBuffer = GPA( "glDrawBuffer" )
	qglDrawElements              = dllDrawElements = GPA( "glDrawElements" )
	qglDrawPixels                = dllDrawPixels = GPA( "glDrawPixels" )
	qglEdgeFlag                  = dllEdgeFlag = GPA( "glEdgeFlag" )
	qglEdgeFlagPointer           = dllEdgeFlagPointer = GPA( "glEdgeFlagPointer" )
	qglEdgeFlagv                 = dllEdgeFlagv = GPA( "glEdgeFlagv" )
	qglEnable                    = 	dllEnable                    = GPA( "glEnable" )
	qglEnableClientState         = 	dllEnableClientState         = GPA( "glEnableClientState" )
	qglEnd                       = 	dllEnd                       = GPA( "glEnd" )
	qglEndList                   = 	dllEndList                   = GPA( "glEndList" )
	qglEvalCoord1d				 = 	dllEvalCoord1d				 = GPA( "glEvalCoord1d" )
	qglEvalCoord1dv              = 	dllEvalCoord1dv              = GPA( "glEvalCoord1dv" )
	qglEvalCoord1f               = 	dllEvalCoord1f               = GPA( "glEvalCoord1f" )
	qglEvalCoord1fv              = 	dllEvalCoord1fv              = GPA( "glEvalCoord1fv" )
	qglEvalCoord2d               = 	dllEvalCoord2d               = GPA( "glEvalCoord2d" )
	qglEvalCoord2dv              = 	dllEvalCoord2dv              = GPA( "glEvalCoord2dv" )
	qglEvalCoord2f               = 	dllEvalCoord2f               = GPA( "glEvalCoord2f" )
	qglEvalCoord2fv              = 	dllEvalCoord2fv              = GPA( "glEvalCoord2fv" )
	qglEvalMesh1                 = 	dllEvalMesh1                 = GPA( "glEvalMesh1" )
	qglEvalMesh2                 = 	dllEvalMesh2                 = GPA( "glEvalMesh2" )
	qglEvalPoint1                = 	dllEvalPoint1                = GPA( "glEvalPoint1" )
	qglEvalPoint2                = 	dllEvalPoint2                = GPA( "glEvalPoint2" )
	qglFeedbackBuffer            = 	dllFeedbackBuffer            = GPA( "glFeedbackBuffer" )
	qglFinish                    = 	dllFinish                    = GPA( "glFinish" )
	qglFlush                     = 	dllFlush                     = GPA( "glFlush" )
	qglFogf                      = 	dllFogf                      = GPA( "glFogf" )
	qglFogfv                     = 	dllFogfv                     = GPA( "glFogfv" )
	qglFogi                      = 	dllFogi                      = GPA( "glFogi" )
	qglFogiv                     = 	dllFogiv                     = GPA( "glFogiv" )
	qglFrontFace                 = 	dllFrontFace                 = GPA( "glFrontFace" )
	qglFrustum                   = 	dllFrustum                   = GPA( "glFrustum" )
	qglGenLists                  = 	dllGenLists                  = GPA( "glGenLists" )
	qglGenTextures               = 	dllGenTextures               = GPA( "glGenTextures" )
	qglGetBooleanv               = 	dllGetBooleanv               = GPA( "glGetBooleanv" )
	qglGetClipPlane              = 	dllGetClipPlane              = GPA( "glGetClipPlane" )
	qglGetDoublev                = 	dllGetDoublev                = GPA( "glGetDoublev" )
	qglGetError                  = 	dllGetError                  = GPA( "glGetError" )
	qglGetFloatv                 = 	dllGetFloatv                 = GPA( "glGetFloatv" )
	qglGetIntegerv               = 	dllGetIntegerv               = GPA( "glGetIntegerv" )
	qglGetLightfv                = 	dllGetLightfv                = GPA( "glGetLightfv" )
	qglGetLightiv                = 	dllGetLightiv                = GPA( "glGetLightiv" )
	qglGetMapdv                  = 	dllGetMapdv                  = GPA( "glGetMapdv" )
	qglGetMapfv                  = 	dllGetMapfv                  = GPA( "glGetMapfv" )
	qglGetMapiv                  = 	dllGetMapiv                  = GPA( "glGetMapiv" )
	qglGetMaterialfv             = 	dllGetMaterialfv             = GPA( "glGetMaterialfv" )
	qglGetMaterialiv             = 	dllGetMaterialiv             = GPA( "glGetMaterialiv" )
	qglGetPixelMapfv             = 	dllGetPixelMapfv             = GPA( "glGetPixelMapfv" )
	qglGetPixelMapuiv            = 	dllGetPixelMapuiv            = GPA( "glGetPixelMapuiv" )
	qglGetPixelMapusv            = 	dllGetPixelMapusv            = GPA( "glGetPixelMapusv" )
	qglGetPointerv               = 	dllGetPointerv               = GPA( "glGetPointerv" )
	qglGetPolygonStipple         = 	dllGetPolygonStipple         = GPA( "glGetPolygonStipple" )
	qglGetString                 = 	dllGetString                 = GPA( "glGetString" )
	qglGetTexEnvfv               = 	dllGetTexEnvfv               = GPA( "glGetTexEnvfv" )
	qglGetTexEnviv               = 	dllGetTexEnviv               = GPA( "glGetTexEnviv" )
	qglGetTexGendv               = 	dllGetTexGendv               = GPA( "glGetTexGendv" )
	qglGetTexGenfv               = 	dllGetTexGenfv               = GPA( "glGetTexGenfv" )
	qglGetTexGeniv               = 	dllGetTexGeniv               = GPA( "glGetTexGeniv" )
	qglGetTexImage               = 	dllGetTexImage               = GPA( "glGetTexImage" )
	qglGetTexLevelParameterfv    = 	dllGetTexLevelParameterfv    = GPA( "glGetLevelParameterfv" )
	qglGetTexLevelParameteriv    = 	dllGetTexLevelParameteriv    = GPA( "glGetLevelParameteriv" )
	qglGetTexParameterfv         = 	dllGetTexParameterfv         = GPA( "glGetTexParameterfv" )
	qglGetTexParameteriv         = 	dllGetTexParameteriv         = GPA( "glGetTexParameteriv" )
	qglHint                      = 	dllHint                      = GPA( "glHint" )
	qglIndexMask                 = 	dllIndexMask                 = GPA( "glIndexMask" )
	qglIndexPointer              = 	dllIndexPointer              = GPA( "glIndexPointer" )
	qglIndexd                    = 	dllIndexd                    = GPA( "glIndexd" )
	qglIndexdv                   = 	dllIndexdv                   = GPA( "glIndexdv" )
	qglIndexf                    = 	dllIndexf                    = GPA( "glIndexf" )
	qglIndexfv                   = 	dllIndexfv                   = GPA( "glIndexfv" )
	qglIndexi                    = 	dllIndexi                    = GPA( "glIndexi" )
	qglIndexiv                   = 	dllIndexiv                   = GPA( "glIndexiv" )
	qglIndexs                    = 	dllIndexs                    = GPA( "glIndexs" )
	qglIndexsv                   = 	dllIndexsv                   = GPA( "glIndexsv" )
	qglIndexub                   = 	dllIndexub                   = GPA( "glIndexub" )
	qglIndexubv                  = 	dllIndexubv                  = GPA( "glIndexubv" )
	qglInitNames                 = 	dllInitNames                 = GPA( "glInitNames" )
	qglInterleavedArrays         = 	dllInterleavedArrays         = GPA( "glInterleavedArrays" )
	qglIsEnabled                 = 	dllIsEnabled                 = GPA( "glIsEnabled" )
	qglIsList                    = 	dllIsList                    = GPA( "glIsList" )
	qglIsTexture                 = 	dllIsTexture                 = GPA( "glIsTexture" )
	qglLightModelf               = 	dllLightModelf               = GPA( "glLightModelf" )
	qglLightModelfv              = 	dllLightModelfv              = GPA( "glLightModelfv" )
	qglLightModeli               = 	dllLightModeli               = GPA( "glLightModeli" )
	qglLightModeliv              = 	dllLightModeliv              = GPA( "glLightModeliv" )
	qglLightf                    = 	dllLightf                    = GPA( "glLightf" )
	qglLightfv                   = 	dllLightfv                   = GPA( "glLightfv" )
	qglLighti                    = 	dllLighti                    = GPA( "glLighti" )
	qglLightiv                   = 	dllLightiv                   = GPA( "glLightiv" )
	qglLineStipple               = 	dllLineStipple               = GPA( "glLineStipple" )
	qglLineWidth                 = 	dllLineWidth                 = GPA( "glLineWidth" )
	qglListBase                  = 	dllListBase                  = GPA( "glListBase" )
	qglLoadIdentity              = 	dllLoadIdentity              = GPA( "glLoadIdentity" )
	qglLoadMatrixd               = 	dllLoadMatrixd               = GPA( "glLoadMatrixd" )
	qglLoadMatrixf               = 	dllLoadMatrixf               = GPA( "glLoadMatrixf" )
	qglLoadName                  = 	dllLoadName                  = GPA( "glLoadName" )
	qglLogicOp                   = 	dllLogicOp                   = GPA( "glLogicOp" )
	qglMap1d                     = 	dllMap1d                     = GPA( "glMap1d" )
	qglMap1f                     = 	dllMap1f                     = GPA( "glMap1f" )
	qglMap2d                     = 	dllMap2d                     = GPA( "glMap2d" )
	qglMap2f                     = 	dllMap2f                     = GPA( "glMap2f" )
	qglMapGrid1d                 = 	dllMapGrid1d                 = GPA( "glMapGrid1d" )
	qglMapGrid1f                 = 	dllMapGrid1f                 = GPA( "glMapGrid1f" )
	qglMapGrid2d                 = 	dllMapGrid2d                 = GPA( "glMapGrid2d" )
	qglMapGrid2f                 = 	dllMapGrid2f                 = GPA( "glMapGrid2f" )
	qglMaterialf                 = 	dllMaterialf                 = GPA( "glMaterialf" )
	qglMaterialfv                = 	dllMaterialfv                = GPA( "glMaterialfv" )
	qglMateriali                 = 	dllMateriali                 = GPA( "glMateriali" )
	qglMaterialiv                = 	dllMaterialiv                = GPA( "glMaterialiv" )
	qglMatrixMode                = 	dllMatrixMode                = GPA( "glMatrixMode" )
	qglMultMatrixd               = 	dllMultMatrixd               = GPA( "glMultMatrixd" )
	qglMultMatrixf               = 	dllMultMatrixf               = GPA( "glMultMatrixf" )
	qglNewList                   = 	dllNewList                   = GPA( "glNewList" )
	qglNormal3b                  = 	dllNormal3b                  = GPA( "glNormal3b" )
	qglNormal3bv                 = 	dllNormal3bv                 = GPA( "glNormal3bv" )
	qglNormal3d                  = 	dllNormal3d                  = GPA( "glNormal3d" )
	qglNormal3dv                 = 	dllNormal3dv                 = GPA( "glNormal3dv" )
	qglNormal3f                  = 	dllNormal3f                  = GPA( "glNormal3f" )
	qglNormal3fv                 = 	dllNormal3fv                 = GPA( "glNormal3fv" )
	qglNormal3i                  = 	dllNormal3i                  = GPA( "glNormal3i" )
	qglNormal3iv                 = 	dllNormal3iv                 = GPA( "glNormal3iv" )
	qglNormal3s                  = 	dllNormal3s                  = GPA( "glNormal3s" )
	qglNormal3sv                 = 	dllNormal3sv                 = GPA( "glNormal3sv" )
	qglNormalPointer             = 	dllNormalPointer             = GPA( "glNormalPointer" )
	qglOrtho                     = 	dllOrtho                     = GPA( "glOrtho" )
	qglPassThrough               = 	dllPassThrough               = GPA( "glPassThrough" )
	qglPixelMapfv                = 	dllPixelMapfv                = GPA( "glPixelMapfv" )
	qglPixelMapuiv               = 	dllPixelMapuiv               = GPA( "glPixelMapuiv" )
	qglPixelMapusv               = 	dllPixelMapusv               = GPA( "glPixelMapusv" )
	qglPixelStoref               = 	dllPixelStoref               = GPA( "glPixelStoref" )
	qglPixelStorei               = 	dllPixelStorei               = GPA( "glPixelStorei" )
	qglPixelTransferf            = 	dllPixelTransferf            = GPA( "glPixelTransferf" )
	qglPixelTransferi            = 	dllPixelTransferi            = GPA( "glPixelTransferi" )
	qglPixelZoom                 = 	dllPixelZoom                 = GPA( "glPixelZoom" )
	qglPointSize                 = 	dllPointSize                 = GPA( "glPointSize" )
	qglPolygonMode               = 	dllPolygonMode               = GPA( "glPolygonMode" )
	qglPolygonOffset             = 	dllPolygonOffset             = GPA( "glPolygonOffset" )
	qglPolygonStipple            = 	dllPolygonStipple            = GPA( "glPolygonStipple" )
	qglPopAttrib                 = 	dllPopAttrib                 = GPA( "glPopAttrib" )
	qglPopClientAttrib           = 	dllPopClientAttrib           = GPA( "glPopClientAttrib" )
	qglPopMatrix                 = 	dllPopMatrix                 = GPA( "glPopMatrix" )
	qglPopName                   = 	dllPopName                   = GPA( "glPopName" )
	qglPrioritizeTextures        = 	dllPrioritizeTextures        = GPA( "glPrioritizeTextures" )
	qglPushAttrib                = 	dllPushAttrib                = GPA( "glPushAttrib" )
	qglPushClientAttrib          = 	dllPushClientAttrib          = GPA( "glPushClientAttrib" )
	qglPushMatrix                = 	dllPushMatrix                = GPA( "glPushMatrix" )
	qglPushName                  = 	dllPushName                  = GPA( "glPushName" )
	qglRasterPos2d               = 	dllRasterPos2d               = GPA( "glRasterPos2d" )
	qglRasterPos2dv              = 	dllRasterPos2dv              = GPA( "glRasterPos2dv" )
	qglRasterPos2f               = 	dllRasterPos2f               = GPA( "glRasterPos2f" )
	qglRasterPos2fv              = 	dllRasterPos2fv              = GPA( "glRasterPos2fv" )
	qglRasterPos2i               = 	dllRasterPos2i               = GPA( "glRasterPos2i" )
	qglRasterPos2iv              = 	dllRasterPos2iv              = GPA( "glRasterPos2iv" )
	qglRasterPos2s               = 	dllRasterPos2s               = GPA( "glRasterPos2s" )
	qglRasterPos2sv              = 	dllRasterPos2sv              = GPA( "glRasterPos2sv" )
	qglRasterPos3d               = 	dllRasterPos3d               = GPA( "glRasterPos3d" )
	qglRasterPos3dv              = 	dllRasterPos3dv              = GPA( "glRasterPos3dv" )
	qglRasterPos3f               = 	dllRasterPos3f               = GPA( "glRasterPos3f" )
	qglRasterPos3fv              = 	dllRasterPos3fv              = GPA( "glRasterPos3fv" )
	qglRasterPos3i               = 	dllRasterPos3i               = GPA( "glRasterPos3i" )
	qglRasterPos3iv              = 	dllRasterPos3iv              = GPA( "glRasterPos3iv" )
	qglRasterPos3s               = 	dllRasterPos3s               = GPA( "glRasterPos3s" )
	qglRasterPos3sv              = 	dllRasterPos3sv              = GPA( "glRasterPos3sv" )
	qglRasterPos4d               = 	dllRasterPos4d               = GPA( "glRasterPos4d" )
	qglRasterPos4dv              = 	dllRasterPos4dv              = GPA( "glRasterPos4dv" )
	qglRasterPos4f               = 	dllRasterPos4f               = GPA( "glRasterPos4f" )
	qglRasterPos4fv              = 	dllRasterPos4fv              = GPA( "glRasterPos4fv" )
	qglRasterPos4i               = 	dllRasterPos4i               = GPA( "glRasterPos4i" )
	qglRasterPos4iv              = 	dllRasterPos4iv              = GPA( "glRasterPos4iv" )
	qglRasterPos4s               = 	dllRasterPos4s               = GPA( "glRasterPos4s" )
	qglRasterPos4sv              = 	dllRasterPos4sv              = GPA( "glRasterPos4sv" )
	qglReadBuffer                = 	dllReadBuffer                = GPA( "glReadBuffer" )
	qglReadPixels                = 	dllReadPixels                = GPA( "glReadPixels" )
	qglRectd                     = 	dllRectd                     = GPA( "glRectd" )
	qglRectdv                    = 	dllRectdv                    = GPA( "glRectdv" )
	qglRectf                     = 	dllRectf                     = GPA( "glRectf" )
	qglRectfv                    = 	dllRectfv                    = GPA( "glRectfv" )
	qglRecti                     = 	dllRecti                     = GPA( "glRecti" )
	qglRectiv                    = 	dllRectiv                    = GPA( "glRectiv" )
	qglRects                     = 	dllRects                     = GPA( "glRects" )
	qglRectsv                    = 	dllRectsv                    = GPA( "glRectsv" )
	qglRenderMode                = 	dllRenderMode                = GPA( "glRenderMode" )
	qglRotated                   = 	dllRotated                   = GPA( "glRotated" )
	qglRotatef                   = 	dllRotatef                   = GPA( "glRotatef" )
	qglScaled                    = 	dllScaled                    = GPA( "glScaled" )
	qglScalef                    = 	dllScalef                    = GPA( "glScalef" )
	qglScissor                   = 	dllScissor                   = GPA( "glScissor" )
	qglSelectBuffer              = 	dllSelectBuffer              = GPA( "glSelectBuffer" )
	qglShadeModel                = 	dllShadeModel                = GPA( "glShadeModel" )
	qglStencilFunc               = 	dllStencilFunc               = GPA( "glStencilFunc" )
	qglStencilMask               = 	dllStencilMask               = GPA( "glStencilMask" )
	qglStencilOp                 = 	dllStencilOp                 = GPA( "glStencilOp" )
	qglTexCoord1d                = 	dllTexCoord1d                = GPA( "glTexCoord1d" )
	qglTexCoord1dv               = 	dllTexCoord1dv               = GPA( "glTexCoord1dv" )
	qglTexCoord1f                = 	dllTexCoord1f                = GPA( "glTexCoord1f" )
	qglTexCoord1fv               = 	dllTexCoord1fv               = GPA( "glTexCoord1fv" )
	qglTexCoord1i                = 	dllTexCoord1i                = GPA( "glTexCoord1i" )
	qglTexCoord1iv               = 	dllTexCoord1iv               = GPA( "glTexCoord1iv" )
	qglTexCoord1s                = 	dllTexCoord1s                = GPA( "glTexCoord1s" )
	qglTexCoord1sv               = 	dllTexCoord1sv               = GPA( "glTexCoord1sv" )
	qglTexCoord2d                = 	dllTexCoord2d                = GPA( "glTexCoord2d" )
	qglTexCoord2dv               = 	dllTexCoord2dv               = GPA( "glTexCoord2dv" )
	qglTexCoord2f                = 	dllTexCoord2f                = GPA( "glTexCoord2f" )
	qglTexCoord2fv               = 	dllTexCoord2fv               = GPA( "glTexCoord2fv" )
	qglTexCoord2i                = 	dllTexCoord2i                = GPA( "glTexCoord2i" )
	qglTexCoord2iv               = 	dllTexCoord2iv               = GPA( "glTexCoord2iv" )
	qglTexCoord2s                = 	dllTexCoord2s                = GPA( "glTexCoord2s" )
	qglTexCoord2sv               = 	dllTexCoord2sv               = GPA( "glTexCoord2sv" )
	qglTexCoord3d                = 	dllTexCoord3d                = GPA( "glTexCoord3d" )
	qglTexCoord3dv               = 	dllTexCoord3dv               = GPA( "glTexCoord3dv" )
	qglTexCoord3f                = 	dllTexCoord3f                = GPA( "glTexCoord3f" )
	qglTexCoord3fv               = 	dllTexCoord3fv               = GPA( "glTexCoord3fv" )
	qglTexCoord3i                = 	dllTexCoord3i                = GPA( "glTexCoord3i" )
	qglTexCoord3iv               = 	dllTexCoord3iv               = GPA( "glTexCoord3iv" )
	qglTexCoord3s                = 	dllTexCoord3s                = GPA( "glTexCoord3s" )
	qglTexCoord3sv               = 	dllTexCoord3sv               = GPA( "glTexCoord3sv" )
	qglTexCoord4d                = 	dllTexCoord4d                = GPA( "glTexCoord4d" )
	qglTexCoord4dv               = 	dllTexCoord4dv               = GPA( "glTexCoord4dv" )
	qglTexCoord4f                = 	dllTexCoord4f                = GPA( "glTexCoord4f" )
	qglTexCoord4fv               = 	dllTexCoord4fv               = GPA( "glTexCoord4fv" )
	qglTexCoord4i                = 	dllTexCoord4i                = GPA( "glTexCoord4i" )
	qglTexCoord4iv               = 	dllTexCoord4iv               = GPA( "glTexCoord4iv" )
	qglTexCoord4s                = 	dllTexCoord4s                = GPA( "glTexCoord4s" )
	qglTexCoord4sv               = 	dllTexCoord4sv               = GPA( "glTexCoord4sv" )
	qglTexCoordPointer           = 	dllTexCoordPointer           = GPA( "glTexCoordPointer" )
	qglTexEnvf                   = 	dllTexEnvf                   = GPA( "glTexEnvf" )
	qglTexEnvfv                  = 	dllTexEnvfv                  = GPA( "glTexEnvfv" )
	qglTexEnvi                   = 	dllTexEnvi                   = GPA( "glTexEnvi" )
	qglTexEnviv                  = 	dllTexEnviv                  = GPA( "glTexEnviv" )
	qglTexGend                   = 	dllTexGend                   = GPA( "glTexGend" )
	qglTexGendv                  = 	dllTexGendv                  = GPA( "glTexGendv" )
	qglTexGenf                   = 	dllTexGenf                   = GPA( "glTexGenf" )
	qglTexGenfv                  = 	dllTexGenfv                  = GPA( "glTexGenfv" )
	qglTexGeni                   = 	dllTexGeni                   = GPA( "glTexGeni" )
	qglTexGeniv                  = 	dllTexGeniv                  = GPA( "glTexGeniv" )
	qglTexImage1D                = 	dllTexImage1D                = GPA( "glTexImage1D" )
	qglTexImage2D                = 	dllTexImage2D                = GPA( "glTexImage2D" )
	qglTexParameterf             = 	dllTexParameterf             = GPA( "glTexParameterf" )
	qglTexParameterfv            = 	dllTexParameterfv            = GPA( "glTexParameterfv" )
	qglTexParameteri             = 	dllTexParameteri             = GPA( "glTexParameteri" )
	qglTexParameteriv            = 	dllTexParameteriv            = GPA( "glTexParameteriv" )
	qglTexSubImage1D             = 	dllTexSubImage1D             = GPA( "glTexSubImage1D" )
	qglTexSubImage2D             = 	dllTexSubImage2D             = GPA( "glTexSubImage2D" )
	qglTranslated                = 	dllTranslated                = GPA( "glTranslated" )
	qglTranslatef                = 	dllTranslatef                = GPA( "glTranslatef" )
	qglVertex2d                  = 	dllVertex2d                  = GPA( "glVertex2d" )
	qglVertex2dv                 = 	dllVertex2dv                 = GPA( "glVertex2dv" )
	qglVertex2f                  = 	dllVertex2f                  = GPA( "glVertex2f" )
	qglVertex2fv                 = 	dllVertex2fv                 = GPA( "glVertex2fv" )
	qglVertex2i                  = 	dllVertex2i                  = GPA( "glVertex2i" )
	qglVertex2iv                 = 	dllVertex2iv                 = GPA( "glVertex2iv" )
	qglVertex2s                  = 	dllVertex2s                  = GPA( "glVertex2s" )
	qglVertex2sv                 = 	dllVertex2sv                 = GPA( "glVertex2sv" )
	qglVertex3d                  = 	dllVertex3d                  = GPA( "glVertex3d" )
	qglVertex3dv                 = 	dllVertex3dv                 = GPA( "glVertex3dv" )
	qglVertex3f                  = 	dllVertex3f                  = GPA( "glVertex3f" )
	qglVertex3fv                 = 	dllVertex3fv                 = GPA( "glVertex3fv" )
	qglVertex3i                  = 	dllVertex3i                  = GPA( "glVertex3i" )
	qglVertex3iv                 = 	dllVertex3iv                 = GPA( "glVertex3iv" )
	qglVertex3s                  = 	dllVertex3s                  = GPA( "glVertex3s" )
	qglVertex3sv                 = 	dllVertex3sv                 = GPA( "glVertex3sv" )
	qglVertex4d                  = 	dllVertex4d                  = GPA( "glVertex4d" )
	qglVertex4dv                 = 	dllVertex4dv                 = GPA( "glVertex4dv" )
	qglVertex4f                  = 	dllVertex4f                  = GPA( "glVertex4f" )
	qglVertex4fv                 = 	dllVertex4fv                 = GPA( "glVertex4fv" )
	qglVertex4i                  = 	dllVertex4i                  = GPA( "glVertex4i" )
	qglVertex4iv                 = 	dllVertex4iv                 = GPA( "glVertex4iv" )
	qglVertex4s                  = 	dllVertex4s                  = GPA( "glVertex4s" )
	qglVertex4sv                 = 	dllVertex4sv                 = GPA( "glVertex4sv" )
	qglVertexPointer             = 	dllVertexPointer             = GPA( "glVertexPointer" )
	qglViewport                  = 	dllViewport                  = GPA( "glViewport" )

	 qwglCopyContext              = GPA( "wglCopyContext" )
	 qwglCreateContext            = GPA( "wglCreateContext" )
	 qwglCreateLayerContext       = GPA( "wglCreateLayerContext" )
	 qwglDeleteContext            = GPA( "wglDeleteContext" )
	 qwglDescribeLayerPlane       = GPA( "wglDescribeLayerPlane" )
	 qwglGetCurrentContext        = GPA( "wglGetCurrentContext" )
	 qwglGetCurrentDC             = GPA( "wglGetCurrentDC" )
	 qwglGetLayerPaletteEntries   = GPA( "wglGetLayerPaletteEntries" )
	 qwglGetProcAddress           = GPA( "wglGetProcAddress" )
	 qwglMakeCurrent              = GPA( "wglMakeCurrent" )
	 qwglRealizeLayerPalette      = GPA( "wglRealizeLayerPalette" )
	 qwglSetLayerPaletteEntries   = GPA( "wglSetLayerPaletteEntries" )
	 qwglShareLists               = GPA( "wglShareLists" )
	 qwglSwapLayerBuffers         = GPA( "wglSwapLayerBuffers" )
	 qwglUseFontBitmaps           = GPA( "wglUseFontBitmapsA" )
	 qwglUseFontOutlines          = GPA( "wglUseFontOutlinesA" )

	 qwglChoosePixelFormat        = GPA( "wglChoosePixelFormat" )
	 qwglDescribePixelFormat      = GPA( "wglDescribePixelFormat" )
	 qwglGetPixelFormat           = GPA( "wglGetPixelFormat" )
	 qwglSetPixelFormat           = GPA( "wglSetPixelFormat" )
	 qwglSwapBuffers              = GPA( "wglSwapBuffers" )

	qwglSwapIntervalEXT = 0
	qglPointParameterfEXT = 0
	qglPointParameterfvEXT = 0
	qglColorTableEXT = 0
 	qglSelectTextureSGIS = 0
 	qglMTexCoord2fSGIS = 0

	return _false
 	
 	
 	
 End Function
 
	
 
  
  

  
  
 sub QGL_Shutdown()
 	
 	
 	'qglRotatef = NULL
 	
 	
 	
 	
 	
 	
 	
 	
 End Sub
 
 
sub GLimp_EnableLogging( enable as qboolean  )
 
	if ( enable ) then
		
		if (glw_state.log_fp = 0 ) then
			
					 
	   'dim  newtime  as tm ptr 
		'dim aclock  as time_t
		'dim buffer(1024) as ubyte 

		'	'time( &aclock ) 
		'	newtime = localtime( @aclock ) 

		'	asctime( newtime ) 

		'	Com_sprintf( buffer, sizeof(buffer), "%s/gl.log", ri.FS_Gamedir() ) 
		'	glw_state.log_fp = fopen( buffer, "wt" ) 

		'	fprintf( glw_state.log_fp, "%s\n", asctime( newtime ) ) 
			
			
		EndIf
		
		qglAccum                     = logAccum
		qglAlphaFunc                 = logAlphaFunc
		qglAreTexturesResident       = logAreTexturesResident
		qglArrayElement              = logArrayElement
		qglBegin                     = logBegin
		qglBindTexture               = logBindTexture
		qglBitmap                    = logBitmap
		qglBlendFunc                 = logBlendFunc
		qglCallList                  = logCallList
		qglCallLists                 = logCallLists
		qglClear                     = logClear
		qglClearAccum                = logClearAccum
		qglClearColor                = logClearColor
		qglClearDepth                = logClearDepth
		qglClearIndex                = logClearIndex
		qglClearStencil              = logClearStencil
		qglClipPlane                 = logClipPlane
		qglColor3b                   = logColor3b
		qglColor3bv                  = logColor3bv
		qglColor3d                   = logColor3d
		qglColor3dv                  = logColor3dv
		qglColor3f                   = logColor3f
		qglColor3fv                  = logColor3fv
		qglColor3i                   = logColor3i
		qglColor3iv                  = logColor3iv
		qglColor3s                   = logColor3s
		qglColor3sv                  = logColor3sv
		qglColor3ub                  = logColor3ub
		qglColor3ubv                 = logColor3ubv
		qglColor3ui                  = logColor3ui
		qglColor3uiv                 = logColor3uiv
		qglColor3us                  = logColor3us
		qglColor3usv                 = logColor3usv
		qglColor4b                   = logColor4b
		qglColor4bv                  = logColor4bv
		qglColor4d                   = logColor4d
		qglColor4dv                  = logColor4dv
		qglColor4f                   = logColor4f
		qglColor4fv                  = logColor4fv
		qglColor4i                   = logColor4i
		qglColor4iv                  = logColor4iv
		qglColor4s                   = logColor4s
		qglColor4sv                  = logColor4sv
		qglColor4ub                  = logColor4ub
		qglColor4ubv                 = logColor4ubv
		qglColor4ui                  = logColor4ui
		qglColor4uiv                 = logColor4uiv
		qglColor4us                  = logColor4us
		qglColor4usv                 = logColor4usv
		qglColorMask                 = logColorMask
		qglColorMaterial             = logColorMaterial
		qglColorPointer              = logColorPointer
		qglCopyPixels                = logCopyPixels
		qglCopyTexImage1D            = logCopyTexImage1D
		qglCopyTexImage2D            = logCopyTexImage2D
		qglCopyTexSubImage1D         = logCopyTexSubImage1D
		qglCopyTexSubImage2D         = logCopyTexSubImage2D
		qglCullFace                  = logCullFace
		qglDeleteLists               = logDeleteLists 
		qglDeleteTextures            = logDeleteTextures 
		qglDepthFunc                 = logDepthFunc 
		qglDepthMask                 = logDepthMask 
		qglDepthRange                = logDepthRange 
		qglDisable                   = logDisable 
		qglDisableClientState        = logDisableClientState 
		qglDrawArrays                = logDrawArrays 
		qglDrawBuffer                = logDrawBuffer 
		qglDrawElements              = logDrawElements 
		qglDrawPixels                = logDrawPixels 
		qglEdgeFlag                  = logEdgeFlag 
		qglEdgeFlagPointer           = logEdgeFlagPointer 
		qglEdgeFlagv                 = logEdgeFlagv 
		qglEnable                    = 	logEnable                    
		qglEnableClientState         = 	logEnableClientState         
		qglEnd                       = 	logEnd                       
		qglEndList                   = 	logEndList                   
		qglEvalCoord1d				 = 	logEvalCoord1d				 
		qglEvalCoord1dv              = 	logEvalCoord1dv              
		qglEvalCoord1f               = 	logEvalCoord1f               
		qglEvalCoord1fv              = 	logEvalCoord1fv              
		qglEvalCoord2d               = 	logEvalCoord2d               
		qglEvalCoord2dv              = 	logEvalCoord2dv              
		qglEvalCoord2f               = 	logEvalCoord2f               
		qglEvalCoord2fv              = 	logEvalCoord2fv              
		qglEvalMesh1                 = 	logEvalMesh1                 
		qglEvalMesh2                 = 	logEvalMesh2                 
		qglEvalPoint1                = 	logEvalPoint1                
		qglEvalPoint2                = 	logEvalPoint2                
		qglFeedbackBuffer            = 	logFeedbackBuffer            
		qglFinish                    = 	logFinish                    
		qglFlush                     = 	logFlush                     
		qglFogf                      = 	logFogf                      
		qglFogfv                     = 	logFogfv                     
		qglFogi                      = 	logFogi                      
		qglFogiv                     = 	logFogiv                     
		qglFrontFace                 = 	logFrontFace                 
		qglFrustum                   = 	logFrustum                   
		qglGenLists                  = 	logGenLists                  
		qglGenTextures               = 	logGenTextures               
		qglGetBooleanv               = 	logGetBooleanv               
		qglGetClipPlane              = 	logGetClipPlane              
		qglGetDoublev                = 	logGetDoublev                
		qglGetError                  = 	logGetError                  
		qglGetFloatv                 = 	logGetFloatv                 
		qglGetIntegerv               = 	logGetIntegerv               
		qglGetLightfv                = 	logGetLightfv                
		qglGetLightiv                = 	logGetLightiv                
		qglGetMapdv                  = 	logGetMapdv                  
		qglGetMapfv                  = 	logGetMapfv                  
		qglGetMapiv                  = 	logGetMapiv                  
		qglGetMaterialfv             = 	logGetMaterialfv             
		qglGetMaterialiv             = 	logGetMaterialiv             
		qglGetPixelMapfv             = 	logGetPixelMapfv             
		qglGetPixelMapuiv            = 	logGetPixelMapuiv            
		qglGetPixelMapusv            = 	logGetPixelMapusv            
		qglGetPointerv               = 	logGetPointerv               
		qglGetPolygonStipple         = 	logGetPolygonStipple         
		qglGetString                 = 	logGetString                 
		qglGetTexEnvfv               = 	logGetTexEnvfv               
		qglGetTexEnviv               = 	logGetTexEnviv               
		qglGetTexGendv               = 	logGetTexGendv               
		qglGetTexGenfv               = 	logGetTexGenfv               
		qglGetTexGeniv               = 	logGetTexGeniv               
		qglGetTexImage               = 	logGetTexImage               
		qglGetTexLevelParameterfv    = 	logGetTexLevelParameterfv    
		qglGetTexLevelParameteriv    = 	logGetTexLevelParameteriv    
		qglGetTexParameterfv         = 	logGetTexParameterfv         
		qglGetTexParameteriv         = 	logGetTexParameteriv         
		qglHint                      = 	logHint                      
		qglIndexMask                 = 	logIndexMask                 
		qglIndexPointer              = 	logIndexPointer              
		qglIndexd                    = 	logIndexd                    
		qglIndexdv                   = 	logIndexdv                   
		qglIndexf                    = 	logIndexf                    
		qglIndexfv                   = 	logIndexfv                   
		qglIndexi                    = 	logIndexi                    
		qglIndexiv                   = 	logIndexiv                   
		qglIndexs                    = 	logIndexs                    
		qglIndexsv                   = 	logIndexsv                   
		qglIndexub                   = 	logIndexub                   
		qglIndexubv                  = 	logIndexubv                  
		qglInitNames                 = 	logInitNames                 
		qglInterleavedArrays         = 	logInterleavedArrays         
		qglIsEnabled                 = 	logIsEnabled                 
		qglIsList                    = 	logIsList                    
		qglIsTexture                 = 	logIsTexture                 
		qglLightModelf               = 	logLightModelf               
		qglLightModelfv              = 	logLightModelfv              
		qglLightModeli               = 	logLightModeli               
		qglLightModeliv              = 	logLightModeliv              
		qglLightf                    = 	logLightf                    
		qglLightfv                   = 	logLightfv                   
		qglLighti                    = 	logLighti                    
		qglLightiv                   = 	logLightiv                   
		qglLineStipple               = 	logLineStipple               
		qglLineWidth                 = 	logLineWidth                 
		qglListBase                  = 	logListBase                  
		qglLoadIdentity              = 	logLoadIdentity              
		qglLoadMatrixd               = 	logLoadMatrixd               
		qglLoadMatrixf               = 	logLoadMatrixf               
		qglLoadName                  = 	logLoadName                  
		qglLogicOp                   = 	logLogicOp                   
		qglMap1d                     = 	logMap1d                     
		qglMap1f                     = 	logMap1f                     
		qglMap2d                     = 	logMap2d                     
		qglMap2f                     = 	logMap2f                     
		qglMapGrid1d                 = 	logMapGrid1d                 
		qglMapGrid1f                 = 	logMapGrid1f                 
		qglMapGrid2d                 = 	logMapGrid2d                 
		qglMapGrid2f                 = 	logMapGrid2f                 
		qglMaterialf                 = 	logMaterialf                 
		qglMaterialfv                = 	logMaterialfv                
		qglMateriali                 = 	logMateriali                 
		qglMaterialiv                = 	logMaterialiv                
		qglMatrixMode                = 	logMatrixMode                
		qglMultMatrixd               = 	logMultMatrixd               
		qglMultMatrixf               = 	logMultMatrixf               
		qglNewList                   = 	logNewList                   
		qglNormal3b                  = 	logNormal3b                  
		qglNormal3bv                 = 	logNormal3bv                 
		qglNormal3d                  = 	logNormal3d                  
		qglNormal3dv                 = 	logNormal3dv                 
		qglNormal3f                  = 	logNormal3f                  
		qglNormal3fv                 = 	logNormal3fv                 
		qglNormal3i                  = 	logNormal3i                  
		qglNormal3iv                 = 	logNormal3iv                 
		qglNormal3s                  = 	logNormal3s                  
		qglNormal3sv                 = 	logNormal3sv                 
		qglNormalPointer             = 	logNormalPointer             
		qglOrtho                     = 	logOrtho                     
		qglPassThrough               = 	logPassThrough               
		qglPixelMapfv                = 	logPixelMapfv                
		qglPixelMapuiv               = 	logPixelMapuiv               
		qglPixelMapusv               = 	logPixelMapusv               
		qglPixelStoref               = 	logPixelStoref               
		qglPixelStorei               = 	logPixelStorei               
		qglPixelTransferf            = 	logPixelTransferf            
		qglPixelTransferi            = 	logPixelTransferi            
		qglPixelZoom                 = 	logPixelZoom                 
		qglPointSize                 = 	logPointSize                 
		qglPolygonMode               = 	logPolygonMode               
		qglPolygonOffset             = 	logPolygonOffset             
		qglPolygonStipple            = 	logPolygonStipple            
		qglPopAttrib                 = 	logPopAttrib                 
		qglPopClientAttrib           = 	logPopClientAttrib           
		qglPopMatrix                 = 	logPopMatrix                 
		qglPopName                   = 	logPopName                   
		qglPrioritizeTextures        = 	logPrioritizeTextures        
		qglPushAttrib                = 	logPushAttrib                
		qglPushClientAttrib          = 	logPushClientAttrib          
		qglPushMatrix                = 	logPushMatrix                
		qglPushName                  = 	logPushName                  
		qglRasterPos2d               = 	logRasterPos2d               
		qglRasterPos2dv              = 	logRasterPos2dv              
		qglRasterPos2f               = 	logRasterPos2f               
		qglRasterPos2fv              = 	logRasterPos2fv              
		qglRasterPos2i               = 	logRasterPos2i               
		qglRasterPos2iv              = 	logRasterPos2iv              
		qglRasterPos2s               = 	logRasterPos2s               
		qglRasterPos2sv              = 	logRasterPos2sv              
		qglRasterPos3d               = 	logRasterPos3d               
		qglRasterPos3dv              = 	logRasterPos3dv              
		qglRasterPos3f               = 	logRasterPos3f               
		qglRasterPos3fv              = 	logRasterPos3fv              
		qglRasterPos3i               = 	logRasterPos3i               
		qglRasterPos3iv              = 	logRasterPos3iv              
		qglRasterPos3s               = 	logRasterPos3s               
		qglRasterPos3sv              = 	logRasterPos3sv              
		qglRasterPos4d               = 	logRasterPos4d               
		qglRasterPos4dv              = 	logRasterPos4dv              
		qglRasterPos4f               = 	logRasterPos4f               
		qglRasterPos4fv              = 	logRasterPos4fv              
		qglRasterPos4i               = 	logRasterPos4i               
		qglRasterPos4iv              = 	logRasterPos4iv              
		qglRasterPos4s               = 	logRasterPos4s               
		qglRasterPos4sv              = 	logRasterPos4sv              
		qglReadBuffer                = 	logReadBuffer                
		qglReadPixels                = 	logReadPixels                
		qglRectd                     = 	logRectd                     
		qglRectdv                    = 	logRectdv                    
		qglRectf                     = 	logRectf                     
		qglRectfv                    = 	logRectfv                    
		qglRecti                     = 	logRecti                     
		qglRectiv                    = 	logRectiv                    
		qglRects                     = 	logRects                     
		qglRectsv                    = 	logRectsv                    
		qglRenderMode                = 	logRenderMode                
		qglRotated                   = 	logRotated                   
		qglRotatef                   = 	logRotatef                   
		qglScaled                    = 	logScaled                    
		qglScalef                    = 	logScalef                    
		qglScissor                   = 	logScissor                   
		qglSelectBuffer              = 	logSelectBuffer              
		qglShadeModel                = 	logShadeModel                
		qglStencilFunc               = 	logStencilFunc               
		qglStencilMask               = 	logStencilMask               
		qglStencilOp                 = 	logStencilOp                 
		qglTexCoord1d                = 	logTexCoord1d                
		qglTexCoord1dv               = 	logTexCoord1dv               
		qglTexCoord1f                = 	logTexCoord1f                
		qglTexCoord1fv               = 	logTexCoord1fv               
		qglTexCoord1i                = 	logTexCoord1i                
		qglTexCoord1iv               = 	logTexCoord1iv               
		qglTexCoord1s                = 	logTexCoord1s                
		qglTexCoord1sv               = 	logTexCoord1sv               
		qglTexCoord2d                = 	logTexCoord2d                
		qglTexCoord2dv               = 	logTexCoord2dv               
		qglTexCoord2f                = 	logTexCoord2f                
		qglTexCoord2fv               = 	logTexCoord2fv               
		qglTexCoord2i                = 	logTexCoord2i                
		qglTexCoord2iv               = 	logTexCoord2iv               
		qglTexCoord2s                = 	logTexCoord2s                
		qglTexCoord2sv               = 	logTexCoord2sv               
		qglTexCoord3d                = 	logTexCoord3d                
		qglTexCoord3dv               = 	logTexCoord3dv               
		qglTexCoord3f                = 	logTexCoord3f                
		qglTexCoord3fv               = 	logTexCoord3fv               
		qglTexCoord3i                = 	logTexCoord3i                
		qglTexCoord3iv               = 	logTexCoord3iv               
		qglTexCoord3s                = 	logTexCoord3s                
		qglTexCoord3sv               = 	logTexCoord3sv               
		qglTexCoord4d                = 	logTexCoord4d                
		qglTexCoord4dv               = 	logTexCoord4dv               
		qglTexCoord4f                = 	logTexCoord4f                
		qglTexCoord4fv               = 	logTexCoord4fv               
		qglTexCoord4i                = 	logTexCoord4i                
		qglTexCoord4iv               = 	logTexCoord4iv               
		qglTexCoord4s                = 	logTexCoord4s                
		qglTexCoord4sv               = 	logTexCoord4sv               
		qglTexCoordPointer           = 	logTexCoordPointer           
		qglTexEnvf                   = 	logTexEnvf                   
		qglTexEnvfv                  = 	logTexEnvfv                  
		qglTexEnvi                   = 	logTexEnvi                   
		qglTexEnviv                  = 	logTexEnviv                  
		qglTexGend                   = 	logTexGend                   
		qglTexGendv                  = 	logTexGendv                  
		qglTexGenf                   = 	logTexGenf                   
		qglTexGenfv                  = 	logTexGenfv                  
		qglTexGeni                   = 	logTexGeni                   
		qglTexGeniv                  = 	logTexGeniv                  
		qglTexImage1D                = 	logTexImage1D                
		qglTexImage2D                = 	logTexImage2D                
		qglTexParameterf             = 	logTexParameterf             
		qglTexParameterfv            = 	logTexParameterfv            
		qglTexParameteri             = 	logTexParameteri             
		qglTexParameteriv            = 	logTexParameteriv            
		qglTexSubImage1D             = 	logTexSubImage1D             
		qglTexSubImage2D             = 	logTexSubImage2D             
		qglTranslated                = 	logTranslated                
		qglTranslatef                = 	logTranslatef                
		qglVertex2d                  = 	logVertex2d                  
		qglVertex2dv                 = 	logVertex2dv                 
		qglVertex2f                  = 	logVertex2f                  
		qglVertex2fv                 = 	logVertex2fv                 
		qglVertex2i                  = 	logVertex2i                  
		qglVertex2iv                 = 	logVertex2iv                 
		qglVertex2s                  = 	logVertex2s                  
		qglVertex2sv                 = 	logVertex2sv                 
		qglVertex3d                  = 	logVertex3d                  
		qglVertex3dv                 = 	logVertex3dv                 
		qglVertex3f                  = 	logVertex3f                  
		qglVertex3fv                 = 	logVertex3fv                 
		qglVertex3i                  = 	logVertex3i                  
		qglVertex3iv                 = 	logVertex3iv                 
		qglVertex3s                  = 	logVertex3s                  
		qglVertex3sv                 = 	logVertex3sv                 
		qglVertex4d                  = 	logVertex4d                  
		qglVertex4dv                 = 	logVertex4dv                 
		qglVertex4f                  = 	logVertex4f                  
		qglVertex4fv                 = 	logVertex4fv                 
		qglVertex4i                  = 	logVertex4i                  
		qglVertex4iv                 = 	logVertex4iv                 
		qglVertex4s                  = 	logVertex4s                  
		qglVertex4sv                 = 	logVertex4sv                 
		qglVertexPointer             = 	logVertexPointer             
		qglViewport                  = 	logViewport                  
	 
	else
	 
		qglAccum                     = dllAccum
		qglAlphaFunc                 = dllAlphaFunc
		qglAreTexturesResident       = dllAreTexturesResident
		qglArrayElement              = dllArrayElement
		qglBegin                     = dllBegin
		qglBindTexture               = dllBindTexture
		qglBitmap                    = dllBitmap
		qglBlendFunc                 = dllBlendFunc
		qglCallList                  = dllCallList
		qglCallLists                 = dllCallLists
		qglClear                     = dllClear
		qglClearAccum                = dllClearAccum
		qglClearColor                = dllClearColor
		qglClearDepth                = dllClearDepth
		qglClearIndex                = dllClearIndex
		qglClearStencil              = dllClearStencil
		qglClipPlane                 = dllClipPlane
		qglColor3b                   = dllColor3b
		qglColor3bv                  = dllColor3bv
		qglColor3d                   = dllColor3d
		qglColor3dv                  = dllColor3dv
		qglColor3f                   = dllColor3f
		qglColor3fv                  = dllColor3fv
		qglColor3i                   = dllColor3i
		qglColor3iv                  = dllColor3iv
		qglColor3s                   = dllColor3s
		qglColor3sv                  = dllColor3sv
		qglColor3ub                  = dllColor3ub
		qglColor3ubv                 = dllColor3ubv
		qglColor3ui                  = dllColor3ui
		qglColor3uiv                 = dllColor3uiv
		qglColor3us                  = dllColor3us
		qglColor3usv                 = dllColor3usv
		qglColor4b                   = dllColor4b
		qglColor4bv                  = dllColor4bv
		qglColor4d                   = dllColor4d
		qglColor4dv                  = dllColor4dv
		qglColor4f                   = dllColor4f
		qglColor4fv                  = dllColor4fv
		qglColor4i                   = dllColor4i
		qglColor4iv                  = dllColor4iv
		qglColor4s                   = dllColor4s
		qglColor4sv                  = dllColor4sv
		qglColor4ub                  = dllColor4ub
		qglColor4ubv                 = dllColor4ubv
		qglColor4ui                  = dllColor4ui
		qglColor4uiv                 = dllColor4uiv
		qglColor4us                  = dllColor4us
		qglColor4usv                 = dllColor4usv
		qglColorMask                 = dllColorMask
		qglColorMaterial             = dllColorMaterial
		qglColorPointer              = dllColorPointer
		qglCopyPixels                = dllCopyPixels
		qglCopyTexImage1D            = dllCopyTexImage1D
		qglCopyTexImage2D            = dllCopyTexImage2D
		qglCopyTexSubImage1D         = dllCopyTexSubImage1D
		qglCopyTexSubImage2D         = dllCopyTexSubImage2D
		qglCullFace                  = dllCullFace
		qglDeleteLists               = dllDeleteLists 
		qglDeleteTextures            = dllDeleteTextures 
		qglDepthFunc                 = dllDepthFunc 
		qglDepthMask                 = dllDepthMask 
		qglDepthRange                = dllDepthRange 
		qglDisable                   = dllDisable 
		qglDisableClientState        = dllDisableClientState 
		qglDrawArrays                = dllDrawArrays 
		qglDrawBuffer                = dllDrawBuffer 
		qglDrawElements              = dllDrawElements 
		qglDrawPixels                = dllDrawPixels 
		qglEdgeFlag                  = dllEdgeFlag 
		qglEdgeFlagPointer           = dllEdgeFlagPointer 
		qglEdgeFlagv                 = dllEdgeFlagv 
		qglEnable                    = 	dllEnable                    
		qglEnableClientState         = 	dllEnableClientState         
		qglEnd                       = 	dllEnd                       
		qglEndList                   = 	dllEndList                   
		qglEvalCoord1d				 = 	dllEvalCoord1d				 
		qglEvalCoord1dv              = 	dllEvalCoord1dv              
		qglEvalCoord1f               = 	dllEvalCoord1f               
		qglEvalCoord1fv              = 	dllEvalCoord1fv              
		qglEvalCoord2d               = 	dllEvalCoord2d               
		qglEvalCoord2dv              = 	dllEvalCoord2dv              
		qglEvalCoord2f               = 	dllEvalCoord2f               
		qglEvalCoord2fv              = 	dllEvalCoord2fv              
		qglEvalMesh1                 = 	dllEvalMesh1                 
		qglEvalMesh2                 = 	dllEvalMesh2                 
		qglEvalPoint1                = 	dllEvalPoint1                
		qglEvalPoint2                = 	dllEvalPoint2                
		qglFeedbackBuffer            = 	dllFeedbackBuffer            
		qglFinish                    = 	dllFinish                    
		qglFlush                     = 	dllFlush                     
		qglFogf                      = 	dllFogf                      
		qglFogfv                     = 	dllFogfv                     
		qglFogi                      = 	dllFogi                      
		qglFogiv                     = 	dllFogiv                     
		qglFrontFace                 = 	dllFrontFace                 
		qglFrustum                   = 	dllFrustum                   
		qglGenLists                  = 	dllGenLists                  
		qglGenTextures               = 	dllGenTextures               
		qglGetBooleanv               = 	dllGetBooleanv               
		qglGetClipPlane              = 	dllGetClipPlane              
		qglGetDoublev                = 	dllGetDoublev                
		qglGetError                  = 	dllGetError                  
		qglGetFloatv                 = 	dllGetFloatv                 
		qglGetIntegerv               = 	dllGetIntegerv               
		qglGetLightfv                = 	dllGetLightfv                
		qglGetLightiv                = 	dllGetLightiv                
		qglGetMapdv                  = 	dllGetMapdv                  
		qglGetMapfv                  = 	dllGetMapfv                  
		qglGetMapiv                  = 	dllGetMapiv                  
		qglGetMaterialfv             = 	dllGetMaterialfv             
		qglGetMaterialiv             = 	dllGetMaterialiv             
		qglGetPixelMapfv             = 	dllGetPixelMapfv             
		qglGetPixelMapuiv            = 	dllGetPixelMapuiv            
		qglGetPixelMapusv            = 	dllGetPixelMapusv            
		qglGetPointerv               = 	dllGetPointerv               
		qglGetPolygonStipple         = 	dllGetPolygonStipple         
		qglGetString                 = 	dllGetString                 
		qglGetTexEnvfv               = 	dllGetTexEnvfv               
		qglGetTexEnviv               = 	dllGetTexEnviv               
		qglGetTexGendv               = 	dllGetTexGendv               
		qglGetTexGenfv               = 	dllGetTexGenfv               
		qglGetTexGeniv               = 	dllGetTexGeniv               
		qglGetTexImage               = 	dllGetTexImage               
		qglGetTexLevelParameterfv    = 	dllGetTexLevelParameterfv    
		qglGetTexLevelParameteriv    = 	dllGetTexLevelParameteriv    
		qglGetTexParameterfv         = 	dllGetTexParameterfv         
		qglGetTexParameteriv         = 	dllGetTexParameteriv         
		qglHint                      = 	dllHint                      
		qglIndexMask                 = 	dllIndexMask                 
		qglIndexPointer              = 	dllIndexPointer              
		qglIndexd                    = 	dllIndexd                    
		qglIndexdv                   = 	dllIndexdv                   
		qglIndexf                    = 	dllIndexf                    
		qglIndexfv                   = 	dllIndexfv                   
		qglIndexi                    = 	dllIndexi                    
		qglIndexiv                   = 	dllIndexiv                   
		qglIndexs                    = 	dllIndexs                    
		qglIndexsv                   = 	dllIndexsv                   
		qglIndexub                   = 	dllIndexub                   
		qglIndexubv                  = 	dllIndexubv                  
		qglInitNames                 = 	dllInitNames                 
		qglInterleavedArrays         = 	dllInterleavedArrays         
		qglIsEnabled                 = 	dllIsEnabled                 
		qglIsList                    = 	dllIsList                    
		qglIsTexture                 = 	dllIsTexture                 
		qglLightModelf               = 	dllLightModelf               
		qglLightModelfv              = 	dllLightModelfv              
		qglLightModeli               = 	dllLightModeli               
		qglLightModeliv              = 	dllLightModeliv              
		qglLightf                    = 	dllLightf                    
		qglLightfv                   = 	dllLightfv                   
		qglLighti                    = 	dllLighti                    
		qglLightiv                   = 	dllLightiv                   
		qglLineStipple               = 	dllLineStipple               
		qglLineWidth                 = 	dllLineWidth                 
		qglListBase                  = 	dllListBase                  
		qglLoadIdentity              = 	dllLoadIdentity              
		qglLoadMatrixd               = 	dllLoadMatrixd               
		qglLoadMatrixf               = 	dllLoadMatrixf               
		qglLoadName                  = 	dllLoadName                  
		qglLogicOp                   = 	dllLogicOp                   
		qglMap1d                     = 	dllMap1d                     
		qglMap1f                     = 	dllMap1f                     
		qglMap2d                     = 	dllMap2d                     
		qglMap2f                     = 	dllMap2f                     
		qglMapGrid1d                 = 	dllMapGrid1d                 
		qglMapGrid1f                 = 	dllMapGrid1f                 
		qglMapGrid2d                 = 	dllMapGrid2d                 
		qglMapGrid2f                 = 	dllMapGrid2f                 
		qglMaterialf                 = 	dllMaterialf                 
		qglMaterialfv                = 	dllMaterialfv                
		qglMateriali                 = 	dllMateriali                 
		qglMaterialiv                = 	dllMaterialiv                
		qglMatrixMode                = 	dllMatrixMode                
		qglMultMatrixd               = 	dllMultMatrixd               
		qglMultMatrixf               = 	dllMultMatrixf               
		qglNewList                   = 	dllNewList                   
		qglNormal3b                  = 	dllNormal3b                  
		qglNormal3bv                 = 	dllNormal3bv                 
		qglNormal3d                  = 	dllNormal3d                  
		qglNormal3dv                 = 	dllNormal3dv                 
		qglNormal3f                  = 	dllNormal3f                  
		qglNormal3fv                 = 	dllNormal3fv                 
		qglNormal3i                  = 	dllNormal3i                  
		qglNormal3iv                 = 	dllNormal3iv                 
		qglNormal3s                  = 	dllNormal3s                  
		qglNormal3sv                 = 	dllNormal3sv                 
		qglNormalPointer             = 	dllNormalPointer             
		qglOrtho                     = 	dllOrtho                     
		qglPassThrough               = 	dllPassThrough               
		qglPixelMapfv                = 	dllPixelMapfv                
		qglPixelMapuiv               = 	dllPixelMapuiv               
		qglPixelMapusv               = 	dllPixelMapusv               
		qglPixelStoref               = 	dllPixelStoref               
		qglPixelStorei               = 	dllPixelStorei               
		qglPixelTransferf            = 	dllPixelTransferf            
		qglPixelTransferi            = 	dllPixelTransferi            
		qglPixelZoom                 = 	dllPixelZoom                 
		qglPointSize                 = 	dllPointSize                 
		qglPolygonMode               = 	dllPolygonMode               
		qglPolygonOffset             = 	dllPolygonOffset             
		qglPolygonStipple            = 	dllPolygonStipple            
		qglPopAttrib                 = 	dllPopAttrib                 
		qglPopClientAttrib           = 	dllPopClientAttrib           
		qglPopMatrix                 = 	dllPopMatrix                 
		qglPopName                   = 	dllPopName                   
		qglPrioritizeTextures        = 	dllPrioritizeTextures        
		qglPushAttrib                = 	dllPushAttrib                
		qglPushClientAttrib          = 	dllPushClientAttrib          
		qglPushMatrix                = 	dllPushMatrix                
		qglPushName                  = 	dllPushName                  
		qglRasterPos2d               = 	dllRasterPos2d               
		qglRasterPos2dv              = 	dllRasterPos2dv              
		qglRasterPos2f               = 	dllRasterPos2f               
		qglRasterPos2fv              = 	dllRasterPos2fv              
		qglRasterPos2i               = 	dllRasterPos2i               
		qglRasterPos2iv              = 	dllRasterPos2iv              
		qglRasterPos2s               = 	dllRasterPos2s               
		qglRasterPos2sv              = 	dllRasterPos2sv              
		qglRasterPos3d               = 	dllRasterPos3d               
		qglRasterPos3dv              = 	dllRasterPos3dv              
		qglRasterPos3f               = 	dllRasterPos3f               
		qglRasterPos3fv              = 	dllRasterPos3fv              
		qglRasterPos3i               = 	dllRasterPos3i               
		qglRasterPos3iv              = 	dllRasterPos3iv              
		qglRasterPos3s               = 	dllRasterPos3s               
		qglRasterPos3sv              = 	dllRasterPos3sv              
		qglRasterPos4d               = 	dllRasterPos4d               
		qglRasterPos4dv              = 	dllRasterPos4dv              
		qglRasterPos4f               = 	dllRasterPos4f               
		qglRasterPos4fv              = 	dllRasterPos4fv              
		qglRasterPos4i               = 	dllRasterPos4i               
		qglRasterPos4iv              = 	dllRasterPos4iv              
		qglRasterPos4s               = 	dllRasterPos4s               
		qglRasterPos4sv              = 	dllRasterPos4sv              
		qglReadBuffer                = 	dllReadBuffer                
		qglReadPixels                = 	dllReadPixels                
		qglRectd                     = 	dllRectd                     
		qglRectdv                    = 	dllRectdv                    
		qglRectf                     = 	dllRectf                     
		qglRectfv                    = 	dllRectfv                    
		qglRecti                     = 	dllRecti                     
		qglRectiv                    = 	dllRectiv                    
		qglRects                     = 	dllRects                     
		qglRectsv                    = 	dllRectsv                    
		qglRenderMode                = 	dllRenderMode                
		qglRotated                   = 	dllRotated                   
		qglRotatef                   = 	dllRotatef                   
		qglScaled                    = 	dllScaled                    
		qglScalef                    = 	dllScalef                    
		qglScissor                   = 	dllScissor                   
		qglSelectBuffer              = 	dllSelectBuffer              
		qglShadeModel                = 	dllShadeModel                
		qglStencilFunc               = 	dllStencilFunc               
		qglStencilMask               = 	dllStencilMask               
		qglStencilOp                 = 	dllStencilOp                 
		qglTexCoord1d                = 	dllTexCoord1d                
		qglTexCoord1dv               = 	dllTexCoord1dv               
		qglTexCoord1f                = 	dllTexCoord1f                
		qglTexCoord1fv               = 	dllTexCoord1fv               
		qglTexCoord1i                = 	dllTexCoord1i                
		qglTexCoord1iv               = 	dllTexCoord1iv               
		qglTexCoord1s                = 	dllTexCoord1s                
		qglTexCoord1sv               = 	dllTexCoord1sv               
		qglTexCoord2d                = 	dllTexCoord2d                
		qglTexCoord2dv               = 	dllTexCoord2dv               
		qglTexCoord2f                = 	dllTexCoord2f                
		qglTexCoord2fv               = 	dllTexCoord2fv               
		qglTexCoord2i                = 	dllTexCoord2i                
		qglTexCoord2iv               = 	dllTexCoord2iv               
		qglTexCoord2s                = 	dllTexCoord2s                
		qglTexCoord2sv               = 	dllTexCoord2sv               
		qglTexCoord3d                = 	dllTexCoord3d                
		qglTexCoord3dv               = 	dllTexCoord3dv               
		qglTexCoord3f                = 	dllTexCoord3f                
		qglTexCoord3fv               = 	dllTexCoord3fv               
		qglTexCoord3i                = 	dllTexCoord3i                
		qglTexCoord3iv               = 	dllTexCoord3iv               
		qglTexCoord3s                = 	dllTexCoord3s                
		qglTexCoord3sv               = 	dllTexCoord3sv               
		qglTexCoord4d                = 	dllTexCoord4d                
		qglTexCoord4dv               = 	dllTexCoord4dv               
		qglTexCoord4f                = 	dllTexCoord4f                
		qglTexCoord4fv               = 	dllTexCoord4fv               
		qglTexCoord4i                = 	dllTexCoord4i                
		qglTexCoord4iv               = 	dllTexCoord4iv               
		qglTexCoord4s                = 	dllTexCoord4s                
		qglTexCoord4sv               = 	dllTexCoord4sv               
		qglTexCoordPointer           = 	dllTexCoordPointer           
		qglTexEnvf                   = 	dllTexEnvf                   
		qglTexEnvfv                  = 	dllTexEnvfv                  
		qglTexEnvi                   = 	dllTexEnvi                   
		qglTexEnviv                  = 	dllTexEnviv                  
		qglTexGend                   = 	dllTexGend                   
		qglTexGendv                  = 	dllTexGendv                  
		qglTexGenf                   = 	dllTexGenf                   
		qglTexGenfv                  = 	dllTexGenfv                  
		qglTexGeni                   = 	dllTexGeni                   
		qglTexGeniv                  = 	dllTexGeniv                  
		qglTexImage1D                = 	dllTexImage1D                
		qglTexImage2D                = 	dllTexImage2D                
		qglTexParameterf             = 	dllTexParameterf             
		qglTexParameterfv            = 	dllTexParameterfv            
		qglTexParameteri             = 	dllTexParameteri             
		qglTexParameteriv            = 	dllTexParameteriv            
		qglTexSubImage1D             = 	dllTexSubImage1D             
		qglTexSubImage2D             = 	dllTexSubImage2D             
		qglTranslated                = 	dllTranslated                
		qglTranslatef                = 	dllTranslatef                
		qglVertex2d                  = 	dllVertex2d                  
		qglVertex2dv                 = 	dllVertex2dv                 
		qglVertex2f                  = 	dllVertex2f                  
		qglVertex2fv                 = 	dllVertex2fv                 
		qglVertex2i                  = 	dllVertex2i                  
		qglVertex2iv                 = 	dllVertex2iv                 
		qglVertex2s                  = 	dllVertex2s                  
		qglVertex2sv                 = 	dllVertex2sv                 
		qglVertex3d                  = 	dllVertex3d                  
		qglVertex3dv                 = 	dllVertex3dv                 
		qglVertex3f                  = 	dllVertex3f                  
		qglVertex3fv                 = 	dllVertex3fv                 
		qglVertex3i                  = 	dllVertex3i                  
		qglVertex3iv                 = 	dllVertex3iv                 
		qglVertex3s                  = 	dllVertex3s                  
		qglVertex3sv                 = 	dllVertex3sv                 
		qglVertex4d                  = 	dllVertex4d                  
		qglVertex4dv                 = 	dllVertex4dv                 
		qglVertex4f                  = 	dllVertex4f                  
		qglVertex4fv                 = 	dllVertex4fv                 
		qglVertex4i                  = 	dllVertex4i                  
		qglVertex4iv                 = 	dllVertex4iv                 
		qglVertex4s                  = 	dllVertex4s                  
		qglVertex4sv                 = 	dllVertex4sv                 
		qglVertexPointer             = 	dllVertexPointer             
		qglViewport                  = 	dllViewport                  
EndIf
 
end sub
 
 
 sub GLimp_LogNewFrame()
 	
 		fprintf( glw_state.log_fp, "*** R_BeginFrame ***\n" ) 
 End Sub
 

 
 
 
 

'#pragma warning (default : 4113 4133 4047 )

