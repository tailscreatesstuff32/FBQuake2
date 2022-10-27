'FINISHED FOR NOW///////////////////////////////////////////////////
#Include "Game\qshared.bi"

'HERE TEMPORARILY MAYBE////////////////////////////////////
 declare sub Com_Printf CDecl (fmt as zstring ptr,...)
 declare sub sys_error CDecl (_error as zstring ptr,...)
'//////////////////////////////////////////////////////////



#define DEG2RAD( a ) ( a * M_PI ) / 180.0F

dim shared as vec3_t vec3_origin '=> {0,0,0} 
vec3_origin.v(0) = 0:vec3_origin.v(1) = 0:vec3_origin.v(2) = 0


'/////////////////////////////////////////////////////////////////////////////

#ifdef __FB_WIN32__
'#pragma optimize( "", off )
#endif

function _BOX_ON_PLANE_SIDE(emins as vec3_t ptr, emaxs as vec3_t ptr, p as cplane_s ptr) as integer
	       if p->_type < 3 then
       	if p->dist <= emins->v(p->_type) then
       		return 1
       	else
       		if (p)->dist >=  emaxs->v((p)->_type) then 
       		   return 2
       		else
       			return 3
       		EndIf 
 
       EndIf
	    BoxOnPlaneSide(emins,emaxs,p)
	EndIf
End Function


sub RotatePointAroundVector  ( dst  as vec3_t ptr, _dir  as vec3_t ptr,  _point  as const vec3_t ptr, degrees as float) 



 
	dim as float	m(3,3) 
	dim as float	im(3,3) 
	dim as float	zrot(3,3) 
	dim as float	tmpmat(3,3) 
	dim as float	rot(3,3)
	dim as integer	i 
	dim as vec3_t vr, vup, vf
	

   
  
 	vf.v(0) =  _dir->v(0)
 	vf.v(1) =  _dir->v(1) 
 	vf.v(2) =  _dir->v(2)  
 
 	 PerpendicularVector( @vr, @_dir ) 
 	 CrossProduct( @vr, @vf, @vup ) 
 
 
 
 
 	m(0,0) = vr.v(0) 
 	m(1,0) = vr.v(1)  
 	m(2,0) = vr.v(2)
 
   
 	m(0,1) = vup.v(0) 
 	m(1,1) = vup.v(1) 
 	m(2,1) = vup.v(2) 
 
   
 	m(0,2) = vf.v(0) 
 	m(1,2) = vf.v(1) 
 	m(2,2) = vf.v(2) 
 
 	memcpy( @im(0,0), @m(0,0), (ubound( im ) * sizeof(float)) ) 
 
 	im(0,1) = m(1,0) 
 	im(0,2) = m(2,0) 
 	im(1,0) = m(0,1) 
 	im(1,2) = m(2,1) 
 	im(2,0) = m(0,2) 
 	im(2,1) = m(1,2) 
 
 	memset( @zrot(0,0), 0, (ubound( zrot ) * sizeof(float)) ) 
 	
 	zrot(2,2) = 1.0F 
 	zrot(1,1) = zrot(2,2)
 	zrot(0,0) = zrot(1,1)

	zrot(0,0) =  cos( DEG2RAD( degrees ) )
	zrot(0,1) =  sin( DEG2RAD( degrees ) )
	zrot(1,0) = -sin( DEG2RAD( degrees ) ) 
 	zrot(1,1) =  cos( DEG2RAD( degrees ) ) 
 
 	 R_ConcatRotations( m(), zrot(), tmpmat() ) 
 	 R_ConcatRotations( tmpmat(), im(), rot() ) 
 
  for i = 0 to 3-1
  	
  	dst->v(i) = rot(i,0)  * _point->v(0) + rot(i,1) * _point->v(1) + rot(i,2) * _point->v(2)

  	
  	
  Next


 
end sub




#ifdef _WIN32
'#pragma optimize( "", on )
#endif

'///////////////////////////////////////////////////////////////////////////////////////////


'sub AngleVectors (vec3_t angles, vec3_t forward, vec3_t right, vec3_t up)
sub AngleVectors (angles as vec3_t ptr , forward as vec3_t ptr, _right as vec3_t  ptr,up as vec3_t ptr)
	
	dim as float		angle 
   static as  float		sr, sp, sy, cr, cp, cy 
	'// static to help MS compiler fp bugs
	angle = angles->v(YAW) * (M_PI*2 / 360)
	sy = sin(angle) 
	cy = cos(angle) 
	angle = angles->v(PITCH) * (M_PI*2 / 360) 
	sp = sin(angle)
	cp = cos(angle) 
	angle = angles->v(ROLL) * (M_PI*2 / 360) 
	sr = sin(angle) 
	cr = cos(angle)
	
	
	'MIGHT BE WRONG//////////////////
	 if  (forward)  then
	 
		forward->v(0) = cp*cy 
		forward->v(1) = cp*sy 
		forward->v(2) = -sp 
	 end if
	
	 	if (_right) then
	 
		_right->v(0) = (-1*sr*sp*cy+-1*cr*-sy) 
		_right->v(1) = (-1*sr*sp*sy+-1*cr*cy) 
		_right->v(2) = -1*sr*cp 
	 	end if
	
		 if (up) then
	  
		up->v(0) = (cr*sp*cy+-sr*-sy) 
		up->v(1) = (cr*sp*sy+-sr*cy) 
		up->v(2) = cr*cp 
		 end if
	
	
	
	
End Sub





sub ProjectPointOnPlane( dst as vec3_t ptr, p as const vec3_t ptr, normal as const vec3_t  ptr)

   dim as float d 
	dim as vec3_t n 
	dim as float inv_denom 


    
    
	   inv_denom = 1.0F / DotProduct( normal, normal ) 
      d = DotProduct ( normal, p ) * inv_denom 
	
   
     d = DotProduct( normal, p ) * inv_denom


	  dst->v(0) = p->v(0) - d   * n.v(0) 
	  dst->v(1) = p->v(1) - d   * n.v(1) 
	  dst->v(2) = p->v(2) - d   * n.v(2) 
	  
	  
	  
	  
	  n.v(0) = normal->v(0) * inv_denom 
	  n.v(1) = normal->v(1) * inv_denom 
	  n.v(2) = normal->v(2) * inv_denom 
	  
	
End Sub
 
 
sub PerpendicularVector( dst as vec3_t ptr,src as  const  vec3_t ptr) 
	
	
	dim as integer	_pos 
	dim as integer i 
	dim as  float minelem = 1.0F 
	dim as  vec3_t tempvec 

	/'
	** find the smallest magnitude axially aligned vector
	'/
	 'for ( pos = 0, i = 0; i < 3; i++ )
	 _pos = 0
	  for   i = 0 to 3 -1 
	   
 		if ( fabs( src->v(i) ) < minelem ) then
 			_pos = i 
 			minelem = fabs( src->v(i) ) 
	  	
 		EndIf
	  Next
	  
	  
tempvec.v(2) = 0.0F
tempvec.v(1)  = 0.0F

	tempvec.v(0) = tempvec.v(1)  
	tempvec.v(_pos) = 1.0F 

	/'
	** project the point onto the plane defined by src
	'/
	ProjectPointOnPlane( @dst, @tempvec, @src ) 

	/'
	** normalize the result
	'/
	 VectorNormalize( @dst ) 
	
	
	
End Sub 
 

'/*
'================
'R_ConcatRotations
'================
'*/
sub R_ConcatRotations (in1() as float,in2() as float,_out() as float) 
 
				
	_out(0,0) = in1(0,0) * in2(0,0) + in1(0,1) * in2(1,0) + _
				in1(0,2) * in2(2,0) 
	_out(0,1) = in1(0,0) * in2(0,1) + in1(0,1) * in2(1,1) + _
				in1(0,2) * in2(2,1) 
	_out(0,2) = in1(0,0) * in2(0,2) + in1(0,1) * in2(1,2) + _
				in1(0,2) * in2(2,2) 
	_out(1,0) = in1(1,0) * in2(0,0) + in1(1,1) * in2(1,0) + _
				in1(1,2) * in2(2,0) 
	_out(1,1) = in1(1,0) * in2(0,1) + in1(1,1) * in2(1,1) + _
				in1(1,2) * in2(2,1) 
	_out(1,2) = in1(1,0) * in2(0,2) + in1(1,1) * in2(1,2) + _
				in1(1,2) * in2(2,2) 
	_out(2,0) = in1(2,0) * in2(0,0) + in1(2,1) * in2(1,0) + _
				in1(2,2) * in2(2,0) 
	_out(2,1) = in1(2,0) * in2(0,1) + in1(2,1) * in2(1,1) + _
				in1(2,2) * in2(2,1) 
	_out(2,2) = in1(2,0) * in2(0,2) + in1(2,1) * in2(1,2) + _
				in1(2,2) * in2(2,2) 
				
				
end sub





sub R_ConcatTransforms (in1() as float,in2() as float,_out() as float) 
 
	_out(0,0) = in1(0,0) * in2(0,0) + in1(0,1) * in2(1,0) + _
				in1(0,2) * in2(2,0) 
	_out(0,1) = in1(0,0) * in2(0,1) + in1(0,1) * in2(1,1) + _
				in1(0,2) * in2(2,1) 
	_out(0,2) = in1(0,0) * in2(0,2) + in1(0,1) * in2(1,2) + _
				in1(0,2) * in2(2,2) 
	_out(1,0) = in1(1,0) * in2(0,0) + in1(1,1) * in2(1,0) + _
				in1(1,2) * in2(2,0) 
	_out(1,1) = in1(1,0) * in2(0,1) + in1(1,1) * in2(1,1) + _
				in1(1,2) * in2(2,1) 
	_out(1,2) = in1(1,0) * in2(0,2) + in1(1,1) * in2(1,2) + _
				in1(1,2) * in2(2,2) 
	_out(2,0) = in1(2,0) * in2(0,0) + in1(2,1) * in2(1,0) + _
				in1(2,2) * in2(2,0) 
	_out(2,1) = in1(2,0) * in2(0,1) + in1(2,1) * in2(1,1) + _
				in1(2,2) * in2(2,1) 
	_out(2,2) = in1(2,0) * in2(0,2) + in1(2,1) * in2(1,2) + _
				in1(2,2) * in2(2,2) 
end sub




function Q_fabs (f as float ) as float
	#if 0
	if (f >= 0)
		return f 
  end if
	return -f 
#else
	 dim as integer tmp = * cast(integer ptr,   @f) 
	 tmp and= &H7FFFFFFF 
	 return * cast( float ptr, @tmp) 
#endif
	
End Function
 

'#if defined _M_IX86 && !defined C_ONLY
'#pragma warning (disable:4035)
 function Q_ftol naked ( f  as float ) as long

    static as integer tmp 
    
    asm
    fld dword ptr [esp+4]
	 fistp dword ptr [tmp]
	  mov eax, tmp
	  ret
    	
    End Asm

 End Function
 
'#pragma warning (default:4035)
'#endif
 
/'
===============
LerpAngle

===============
'/
function LerpAngle (a2 as float ,a1 as  float ,_frac as float ) as float
	
		if (a1 - a2 > 180) then
		a1 -= 360
	EndIf
 
	if (a1 - a2 < -180) then
		a1 += 360
	EndIf
 
	return a2 + _frac *   (a1 - a2) 
	
End Function 
 
 
function anglemod(a as float ) as float
	#if 0
	if (a >= 0) then
		a -= 360*cast(integer,a/360) 
	else
		a += 360*( 1 + cast(integer,-a/360) ) 
#endif
	a = (360.0/65536) * (cast(integer,a*(65536/360.0)) and 65535) 
	return a 
End Function
 
 
	'dim shared as integer		i 
	'dim shared as vec3_t	corners(2) 


'// this is the slow, general version
function BoxOnPlaneSide2 (emins as vec3_t ptr ,emaxs as vec3_t ptr, p as cplane_s ptr) as integer 
	dim as integer		i 
	dim  as float	dist1, dist2 
	dim as integer		sides 
	dim as vec3_t	corners(2) 

	for i = 0 to 3-1
	   if (p->_normal.v(i) < 0) then
		 
			corners(0).v(i) = emins->v(i) 
			corners(1).v(i) = emaxs->v(i) 
		 
		else
		 
			corners(1).v(i) = emins->v(i)  
			corners(0).v(i) = emaxs->v(i) 
		end if
	Next
	 

 
	 dist1 = DotProduct (@p->_normal, @corners(0)) - p->dist 
	 dist2 = DotProduct (@p->_normal, @corners(1)) - p->dist 
	 sides = 0 
	if (dist1 >= 0) then
		sides = 1
	EndIf
 
	if (dist2 < 0) then
		sides or= 2
	EndIf
 
	return sides 
End Function
 
 
 
 
 
'#if !id386 || defined __linux__ 
 
#ifndef  id386
 
BoxOnPlaneSide (emins as vec3_t ptr, vec3_t as vec3_t ptr,  p as cplane_s ptr) as integer 
 
	dim as float	dist1, dist2 
	dim as integer		sides 

'// fast axial cases
	if (p->type < 3) then
	    if (p->dist <= emins->v(p->type)) then
	    	return 1
	    EndIf
		if (p->dist >= emaxs->v(p->type)) then
			return 2
		EndIf	 
		return 3 
	EndIf
 
	
'// general case
	select case  p->signbits)
	 
	case 0 
dist1 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emaxs->v(2)
dist2 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emins->v(2)
	 
	case 1 
dist1 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emaxs->v(2)
dist2 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emins->v(2)
 
	case 2 
dist1 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emaxs->v(2)
dist2 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emins->v(2)
	 
	case 3 
dist1 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emaxs->v(2)
dist2 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emins->v(2)
		 
	case 4 
dist1 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emins->v(2)
dist2 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emaxs->v(2)
		 
	case 5 
dist1 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emins->v(2)
dist2 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emaxs->v(2)
		 
	case 6 
dist1 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emins->v(2)
dist2 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emaxs->v(2)
		 
	case 7 
dist1 = p->_normal.v(0)*emins->v(0) + p->_normal.v(1)*emins->v(1) + p->_normal.v(2)*emins->v(2)
dist2 = p->_normal.v(0)*emaxs->v(0) + p->_normal.v(1)*emaxs->v(1) + p->_normal.v(2)*emaxs->v(2)
		 
	case else
		dist1 = dist2 = 0 		'// shut up compiler
		assert( 0 ) 
	 
end select

	sides = 0 
	if (dist1 >= p->dist) then
		sides or= 1 
	end if
	if (dist2 < p->dist) then
		sides or= 2
	EndIf
	 

	assert( sides <> 0 ) 

	return sides 
 end function
 #else
 '#pragma warning( disable: 4035 )
 
 'function BoxOnPlaneSide naked (emins as vec3_t , emaxs as vec3_t ,  _plane as cplane_s ptr)  as integer 
 function BoxOnPlaneSide ( emins as vec3_t ptr, emaxs as vec3_t ptr, _plane as cplane_s ptr) as integer 

  
   static as integer bops_initialized 
	static as integer Ljmptab(8)
	
	
	
   asm  
.intel_syntax noprefix
		push ebx
			
		cmp bops_initialized, 1
		je  initialized
		mov bops_initialized, 1
		
		mov dword ptr Ljmptab[0*4], offset Lcase0
		mov dword ptr Ljmptab[1*4], offset Lcase1
		mov dword ptr Ljmptab[2*4], offset Lcase2
		mov dword ptr Ljmptab[3*4], offset Lcase3
		mov dword ptr Ljmptab[4*4], offset Lcase4
		mov dword ptr Ljmptab[5*4], offset Lcase5
		mov dword ptr Ljmptab[6*4], offset Lcase6
		mov dword ptr Ljmptab[7*4], offset Lcase7
			
initialized:

		mov edx,ds:dword ptr[4+12+esp]
		mov ecx,ds:dword ptr[4+4+esp]
		xor eax,eax
		mov ebx,ds:dword ptr[4+8+esp]
		mov al,ds:byte ptr[17+edx]
		cmp al,8
		jge Lerror
		fld ds:dword ptr[0+edx]
		fld st(0)
		jmp dword ptr[Ljmptab+eax*4]
Lcase0:
		fmul ds:dword ptr[ebx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ebx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase1:
		fmul ds:dword ptr[ecx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ebx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase2:
		fmul ds:dword ptr[ebx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ecx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase3:
		fmul ds:dword ptr[ecx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ecx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase4:
		fmul ds:dword ptr[ebx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ebx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase5:
		fmul ds:dword ptr[ecx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ebx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase6:
		fmul ds:dword ptr[ebx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ecx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ecx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
		jmp LSetSides
Lcase7:
		fmul ds:dword ptr[ecx]
		fld ds:dword ptr[0+4+edx]
		fxch st(2)
		fmul ds:dword ptr[ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[4+ecx]
		fld ds:dword ptr[0+8+edx]
		fxch st(2)
		fmul ds:dword ptr[4+ebx]
		fxch st(2)
		fld st(0)
		fmul ds:dword ptr[8+ecx]
		fxch st(5)
		faddp st(3),st(0)
		fmul ds:dword ptr[8+ebx]
		fxch st(1)
		faddp st(3),st(0)
		fxch st(3)
		faddp st(2),st(0)
LSetSides:
		faddp st(2),st(0)
		fcomp ds:dword ptr[12+edx]
		xor ecx,ecx
		fnstsw ax
		fcomp ds:dword ptr[12+edx]
		and ah,1
		xor ah,1
		add cl,ah
		fnstsw ax
		and ah,1
		add ah,ah
		add cl,ah
		pop ebx
		mov eax,ecx
		ret
Lerror:
		int 3
   end asm
 
	
 End Function

'#pragma warning( default: 4035 )
 #endif
 
sub ClearBounds (mins as vec3_t ptr,maxs as vec3_t ptr)
		mins->v(0) = mins->v(1) = mins->v(2) = 99999 
	   maxs->v(0) = maxs->v(1) = maxs->v(2) = -99999 
End Sub
 
 
sub AddPointToBounds (_v as vec3_t ptr, mins as  vec3_t ptr , maxs as vec3_t ptr)
	 
 dim as	integer		i 
	 dim as vec_t	_val 
 
 	for i=0 to 3-1
 		_val = _v->v(i)
     if (_val < mins->v(i)) then
     	mins->v(i) = _val 
     EndIf
 		

		if (_val > maxs->v(i)) then
			maxs->v(i) = _val 
		EndIf
 
 	Next
 
End Sub

function VectorCompare (v1 as vec3_t ptr ,v2 as vec3_t ptr ) as integer 
	
		if (v1->v(0)  <> v2->v(0) or v1->v(1) <> v2->v(1)  <> v1->v(2) <> v2->v(2)) then
		return 0 
	EndIf
			
			
	return 1 
End Function
 

  
 
function VectorNormalize (_v as vec3_t ptr ) as vec_t 
	
	 	  dim as float	length, ilength 

	length = _v->v(0)*_v->v(0) + _v->v(1)*_v->v(1) + _v->v(2)*_v->v(2) 
	length = sqrt (length) 		'// FIXME

	if (length) then
		ilength = 1/length 
		_v->v(0) = _v->v(0)*ilength 
		_v->v(1) = _v->v(1)*ilength 
		_v->v(2) = _v->v(2)*ilength 
		
	EndIf
 
	return length 
	
	
	
End Function
 


 

function VectorNormalize2 (_v as vec3_t ptr ,_out as vec3_t ptr ) as vec_t 
   dim as float	length, ilength 

	length = _v->v(0)*_v->v(0) + _v->v(1)*_v->v(1) + _v->v(2)*_v->v(2) 
	length = sqrt (length) 		'// FIXME

	if (length) then
		ilength = 1/length 
		_out->v(0) = _v->v(0)*ilength 
		_out->v(1) = _v->v(1)*ilength 
		_out->v(2) = _v->v(2)*ilength 
		
	EndIf
 
	return length 
	
End Function

 sub VectorMA (veca as vec3_t ptr ,scale as float , vecb as vec3_t ptr, vecc as vec3_t ptr)
 	
 	 
	vecc->v(0) = veca->v(0) + scale*vecb->v(0) 
	vecc->v(1) = veca->v(1) + scale*vecb->v(1) 
	vecc->v(2) = veca->v(2) + scale*vecb->v(2) 
 	
 End Sub

 function _DotProduct (v1 as vec3_t ptr,v2 as vec3_t ptr ) as vec_t
 	return v1->v(0)*v2->v(0) + v1->v(1)*v2->v(1) + v1->v(2)*v2->v(2) 
 End Function
 
 sub _VectorSubtract (veca as vec3_t ptr,vecb as vec3_t ptr ,_out as  vec3_t ptr )
 	
 	_out->v(0) = veca->v(0)-vecb->v(0)
	_out->v(1) = veca->v(1)-vecb->v(1)
	_out->v(2) = veca->v(2)-vecb->v(2)
 	
 End Sub
 
 sub _VectorAdd (veca as vec3_t ptr,vecb as vec3_t ptr ,_out as  vec3_t ptr )
 	
   _out->v(0) = veca->v(0)+vecb->v(0)
	_out->v(1) = veca->v(1)+vecb->v(1)
	_out->v(2) = veca->v(2)+vecb->v(2)
 	
 End Sub
 
 sub  _VectorCopy (_in as  vec3_t ptr,_out as  vec3_t ptr)
 	
   _out->v(0) = _in->v(0) 
	_out->v(1) = _in->v(1) 
	_out->v(2) = _in->v(2) 
	
 End Sub
	
sub CrossProduct (v1 as vec3_t ptr, v2 as vec3_t ptr,cross as vec3_t ptr)
   cross->v(0) = v1->v(1)* v2->v(2) - v1->v(2)* v2->v(1) 
	cross->v(1) = v1->v(2)* v2->v(0) - v1->v(0)* v2->v(2) 
	cross->v(2) = v1->v(0)* v2->v(1) - v1->v(1)* v2->v(0) 
End Sub

'declare function sqrt(x as double ) as double 

function VectorLength(_v as vec3_t ptr) as vec_t
	
		dim as integer i 
	dim as float	length 
	
	length = 0 
	for i = 0 to 3-1
		length += _v->v(i)*_v->v(i) 
		length = sqrt (length) 	'// FIXME
	Next
	return length 
End Function
 
sub VectorInverse (_v as vec3_t ptr )
   _v->v(0) = -_v->v(0) 
	_v->v(1) = -_v->v(1) 
	_v->v(2) = -_v->v(2) 
	
End Sub
 
sub VectorScale (_in as vec3_t ptr ,scale as  vec_t ,_out as vec3_t ptr )
	_out->v(0) = _in->v(0)*scale 
	_out->v(1) = _in->v(1)*scale 
	_out->v(2) = _in->v(2)*scale 
End Sub
 
 


function Q_log2(_val as integer ) as integer 
   dim answer as integer =0 
	while (_val)
		answer+=1	
		_val shr= 1
	Wend 
		
	return answer 

End Function
 

 
 '//====================================================================================

 
 /'
============
COM_SkipPath
============
'/
function COM_SkipPath (pathname as zstring ptr) as zstring ptr
	
  dim last  as zstring ptr
 	
 	last = pathname 
 	while (*pathname)
 
 	if (*pathname = asc(!"/")) then
 		last = pathname+1
 	EndIf
 	 pathname+=1
 
 wend
 	return last 
 
	
End function
 

/'
============
COM_StripExtension
============
'/
sub COM_StripExtension (_in  as ZString ptr,_out as ZString ptr)
	 while (*_in and *_in <> ".")
	 	 	*_out = *_in
	 	_out+=1
	 	_in+=1	
	 Wend

	 	 
	 *_out = 0 
	
	
End Sub


 /'
============
COM_FileExtension
============
'/
function COM_FileExtension (_in  as ZString ptr) as zstring ptr
	 static as zstring * 8  exten 
	dim as integer		i 

	  while (*_in and *_in <> ".")
	  	_in+=1
	  Wend
	    
	 if (*_in = NULL) then
	 		return @""
	 EndIf	 	 
	 _in+=1
	 
	
	do while i <7 and *_in
		exten[i] = *_in 
		i+=1
		_in+=1
	Loop
	
	 	
	 exten[i] = 0 
  return @exten 
End Function
 


 /'
============
COM_FileBase
============
'/
sub COM_FileBase (_in  as ZString ptr,_out as ZString ptr)
	
	
	 dim as zstring ptr  s,  s2 
	 
	 s = _in + strlen(_in) - 1 
	'
	 while (s <> _in and *s <> asc(!"."))
	 	s-=1
	 wend
	'
	
	
	s2 = s
	do while s2 <>_in and *s2 <> asc("/")
	s2-=1	
	Loop
	 
	 if (s-s2 < 2) then
	 	_out[0] = 0
	 
	 else
	 
 		s-=1
	 	strncpy (_out,s2+1, s-s2) 
	 	_out[s-s2] = 0 
	end if
	
	
End Sub
 
 
'/*
'============
'COM_FilePath
'
'Returns the path up to, but not including the last /
'============
'*/
sub COM_FilePath (_in as zstring ptr, _out  as zstring ptr)
	dim as	zstring ptr s
	
	s = _in + strlen(_in) - 1 
	
	while (s <> _in and *s <> asc("/"))
		s-=1	
	Wend
 

	strncpy (_out,_in, s-_in) 
	_out[s-_in] = 0 
	
	
End Sub
  
' /*
'==================
'COM_DefaultExtension
'==================
'*/
sub COM_DefaultExtension (path as zstring ptr, extension as zstring ptr)
		dim src  as zstring ptr 
'//
'// if path doesn't have a .EXT, append extension
'// (extension should include the .)
'//
	src = path + strlen(path) - 1 

	while (*src <> "/" and src <> path) 
		

	 
			if (*src = ".") then
				return                 '// it has an extension
		
			EndIf
     src-=1 
	Wend

	strcat (path, extension) 
 
End Sub
 

 '/*
'============================================================================
'
'					BYTE ORDER FUNCTIONS
'
'============================================================================
'*/


dim shared 	bigendien as qboolean


dim shared  _BigShort as function(l as short )as short
dim shared  _LittleShort as function(l as short )as short
dim shared  _BigLong as function(l as integer )as integer
dim shared  _LittleLong as function(l as integer )as integer
dim shared  _BigFloat as function(l as float )as float
dim shared  _LittleFloat as function(l as float )as float

function BigShort(l as short) as short:return _BigShort(l):End Function	
function LittleShort(l as short) as short:return _LittleShort(l):End Function	
function BigLong(l as integer) as integer:return _BigLong(l):End Function
function LittleLong(l as integer) as integer:return _LittleLong(l):End Function
function BigFloat(l as float) as float:return _BigFloat(l):End Function
function LittleFloat(l as Float) as Float:return _LittleFloat(l):End Function
	
function ShortSwap (l as short ) as short  
 	dim as ubyte    b1,b2 

	b1 = l and 255 
	b2 = (l shr 8) and 255 
	return (b1 shl 8) + b2 
 
 	
End Function
function	ShortNoSwap (l as short ) as  short
	return l
End Function 
function LongSwap ( l as integer) as integer 
  dim	as ubyte    b1,b2,b3,b4 

	b1 = l and 255 
	b2 = (l shr 8) and 255 
	b3 = (l shr 16)and 255 
	b4 = (l shr 24) and 255 

	return (cast(integer,b1)shl 24) + (cast(integer,b2) shl 16) + (cast(integer,b3) shl 8)  + b4 
  	
 End Function
function LongNoSwap ( l as integer) as integer
	
		return l 
	
End Function 
function	FloatNoSwap (l as float ) as  float
	return l
End Function
function FloatSwap (f as Float ) as Float 
 	 
 	union _f
 		f as float 
		b(4) as ubyte	
 	End Union: dim as _f dat1,dat2
	 
	dat1.f = f
	dat2.b(0) = dat1.b(3)
	dat2.b(1) = dat1.b(2)
	dat2.b(2) = dat1.b(1)
	dat2.b(3) = dat1.b(0)
	return dat2.f 

 End Function

'/*
'================
'Swap_Init
'================
'*/


sub Swap_Init ()
  
	dim	swaptest(2) as UByte => {1,0} 

'// set the byte swapping variables in a portable manner	
	if ( *cast(short ptr, @swaptest(0))  = 1) then
	 
		 bigendien = _false 
		 _BigShort = @ShortSwap 
		 _LittleShort = @ShortNoSwap 
		 _BigLong = @LongSwap 
		 _LittleLong = @LongNoSwap 
		 _BigFloat = @FloatSwap 
		 _LittleFloat = @FloatNoSwap 
 
	else
 
		 bigendien = _true 
		 _BigShort = @ShortNoSwap 
		 _LittleShort = @ShortSwap 
		 _BigLong = @LongNoSwap 
		 _LittleLong = @LongSwap 
	    _BigFloat = @FloatNoSwap 
		 _LittleFloat = @FloatSwap 
 
	end if
end sub

'/*
'============
'va
'
'does a varargs printf into a temp buffer, so I don't need to have
'varargs versions of all text functions.
'FIXME: make this buffer size safe someday
'============
'*/

'ptr
function _va cdecl(_format  as ZString ptr, ...) as ZString ptr
	dim argptr as	va_list		 
	static  	_string as ZString *1024
	
	cva_start (argptr, _format) 
	vsprintf (_string, _format,argptr) 
	cva_end (argptr) 

	return @_string 	
End Function
 
dim shared as zstring * MAX_TOKEN_CHARS	com_token 

'/*
'==============
'COM_Parse
'
'Parse a token out of a string
'==============
'*/
function COM_Parse (data_p as zstring ptr ptr) as zstring ptr
 
	dim  as  integer		c 
	dim  as  integer		_len 
   dim  as zstring  ptr _data 


  



	_data = *data_p
	
	
  'print "in COM_Parse"
  '
  '
  'print *_data
  'sleep
 'print *_data 
 'sleep


	 
	_len = 0 
	com_token[0] = 0 
	
	if (_data = null) then
	 
		*data_p = NULL 
		return @"" 
	end if
		


	
'// skip whitespace
skipwhite:
 c = *_data 
	while ( c <= asc(" "))

		
		if (c = 0) then
		 
			*data_p = NULL 
			return @"" 
		end if
		_data+=1
	wend

'// skip // comments
	if (c= asc("/") and _data[1] = asc("/")) then
		 while (*_data and *_data <> asc(!"\n"))
		 		_data+=1
		 Wend
		
		goto skipwhite 
		
	EndIf
 
 
 

	
'// handle quoted strings specially
 	if (c =  asc(!"\"")) then
 	_data+=1 
 		while (1)
         
    		c = *_data:_data+=1 
    		
    		if (c = asc(!"\"") or  c = NULL) then
    		
 
 			    com_token[_len] = 0 
 				*data_p = _data 
 				return @com_token 
    		
        end if
 			if (_len < MAX_TOKEN_CHARS) then
 				com_token[_len] = c
 				_len+=1
 			EndIf
 
 		wend
end if

 '// parse a regular word
	do
	 
		if (_len < MAX_TOKEN_CHARS) then
		 com_token[_len] = c 
			_len+=1 
		 end if
		_data+=1
		c = *_data
			
			

 
	loop while (c>32) 
 
	
	
	
	if (_len =  MAX_TOKEN_CHARS) then
	 
'//		Com_Printf ("Token exceeded %i chars, discarded.\n", MAX_TOKEN_CHARS);
		_len = 0 
	end if
	com_token[_len] = 0 

	*data_p = _data 
	return @com_token 
end function







/'
===============
Com_PageInMemory

===============
'/
dim shared as integer	paged_total 

sub Com_PageInMemory (buffer as ubyte ptr,size as integer )
   dim as integer		i 

i = size-1
do while i > 0
	paged_total += buffer[i] 
	i-=4096
Loop
 
End Sub
 
 
 
 
 
 
 
 
 
 
 
 
'/*
'============================================================================
'
'					LIBRARY REPLACEMENT FUNCTIONS
'
'============================================================================
'*/

 function Q_stricmp (s1 as zstring ptr, s2 as zstring ptr) as integer
 	
 #if defined(__FB_WIN32__)
	return _stricmp (s1, s2) 
#else
	return strcasecmp (s1, s2) 
#endif

 End Function
  
'WORKS FINE''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 function Q_strncasecmp (s1 as zstring ptr,s2 as zstring ptr,n as  integer ) as Integer
 
	dim as integer		c1, c2 
	
	do
	 
		c1 = *s1:s1+=1 
		c2 = *s2:s2+=1
    
    
 	


		if (n = 0) then
			return 0 		'// strings are equal until end point
		EndIf
		n-=1	
		
		if (c1 <> c2) then
		 
			if (c1 >= asc("a")  and c1 <= asc("z")) then
				c1 -= (asc("a") - asc("A"))
			end if
			if (c2 >= asc("a") and c2 <= asc("z")) then
				c2 -= (asc("a") - asc("A"))
			end if
			if (c1 <> c2) then
				return -1 		'// strings not equal
			
			end if
			
		 end if
	  loop while  c1  

	return 0 		'// strings are equal
end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'WORKS FINE'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function Q_strcasecmp ( s1 as zstring ptr,s2 as zstring ptr) as integer
		return Q_strncasecmp (s1, s2, 99999) 
	
End Function
 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

sub Com_sprintf cdecl (dest as ZString ptr, _size as integer ,fmt  as ZString ptr, ...)
	
	 
	dim _len  as integer		
	dim argptr as va_list 
	 dim  bigbuffer as ZString * &H10000

	cva_start (argptr,fmt) 
	_len = vsprintf (bigbuffer,fmt,argptr) 
	cva_end (argptr) 
	if (_len >= _size) then
				'Com_Printf ("Com_sprintf: overflow of %i in %i\n", len, size) 
		printf(!"Com_sprintf: overflow of %i in %i\n", _len, _size)
	EndIf

	strncpy (dest, bigbuffer, _size-1) 
 

	
End Sub


'/'
'=====================================================================
'
'  INFO STRINGS
'
'=====================================================================
''/
'
'/*
'===============
'Info_ValueForKey
'
'Searches the string for the given
'key and returns the associated value, or an empty string.
'===============
'*/
function Info_ValueForKey (s as zstring ptr, key as zstring ptr) as zstring ptr
 
	 dim as zstring * 512	pkey  
	 static as	zstring * 512  value(2) 	'// use two buffers so compares
                   '								// work without stomping on each other
 	static	as integer	valueindex 
   dim as zstring	ptr o 
 	
 	valueindex xor= 1 
 	if (*s = asc(!"\\")) then
 		s+=1
 	End If
 		
 	while (1)
 
 		o = @pkey 
 		while (*s <> asc(!"\\"))
 	 
 			if ( *s = null) then
 				return @"" 
 			EndIf
 			*o	= *s
 			 
 			o+=1 
 			s+=1
 			 
 		wend
   	*o = 0 
   	s+=1
 
 		o = @value(valueindex) 
 
 		while (*s <> asc(!"\\") and *s)
    
 			if ( *s = NULL) then
 				return @"" 	
 			EndIf
  			
 			 *o	= *s
 			 
 			o+=1 
 			s+=1
 			 
 		wend
 		*o = 0 
 
   	if ( strcmp (key, pkey) = 0 ) then
   		return @value(valueindex)
   	EndIf
 			 
 
 		if ( *s = NULL) then
 			return @""
 		EndIf
 			 
 		s+=1
 	wend
end function

sub Info_RemoveKey (s as zstring ptr,  key as zstring ptr)
 
	dim as zstring ptr start 
	dim as zstring * 512	pkey 
	dim as zstring * 512 value 
	dim as zstring	ptr o 

	if (strstr (key, asc(!"\\"))) then
			 
'//		Com_Printf ("Can't use a key with a \\\n");
		return 
		
	EndIf

	 

	while (1)
	 
		start = s 
		if (*s = asc(!"\\")) then
			s+=1 
		EndIf
		o = @pkey 
		while (*s <> asc(!"\\"))
		 
			if (*s = NULL) then
					return
			EndIf
			
			
				*o = *s
		 	   s+=1
				o+=1
		wend
		*o = 0 
		s+=1

		o = @value 
		 while (*s <> asc(!"\\") and *s)
		 	if (*s = null) then
		 		
		 		return 
		 EndIf
		 	
		 		*o = *s
	      	 o+=1
		 	  	 s+=1 
		 
		 	
		 Wend
	 
	 
		 o = 0 

		 if (strcmp (key, pkey) = NULL) then
		 strcpy (start, s) 	'// remove this part
	   	return 
		 	
		 EndIf
	 
 
		 if ( *s = null) then
		 	return
		 	end if
	 
		wend
end sub


/'
==================
Info_Validate

Some characters are illegal in info strings because they
can mess up the server's parsing
==================
'/
 function Info_Validate (s as ZString ptr) as qboolean
 
	if (strstr (s, !"\"")) then
		return _false 
	end if
	if (strstr (s, !";")) then
		return _false
	end if 
	return _true 
 end function





sub Info_SetValueForKey (s as zstring ptr, _key as zstring ptr,value as zstring ptr)

	 dim as zstring	ptr v 
	 dim as zstring * MAX_INFO_STRING  newi
	 
	 
	 dim as integer		c 
	dim as  integer		maxsize = MAX_INFO_STRING 

	  if  strstr(_key,  !"\\" ) <> NULL or strstr(value,  !"\\") <> NULL   then
	 	Com_Printf (!"Can't use keys or values with a \\\n") 
	 	return 
	  End If
 
  
  if (strstr (_key, !";") <> NULL ) then
  
    	Com_Printf (!"Can't use keys or values with a semicolon\n") 
 	 	return 
 	 end if
 
   if (strstr (_key, !"\"") <> NULL or strstr (value, !"\"") <> NULL ) then
  
  		Com_Printf (!"Can't use keys or values with a \"\n") 
 	 	return 
   end if
 
    if (strlen(_key) > MAX_INFO_KEY-1 or strlen(value) > MAX_INFO_KEY-1) then
    	Com_Printf (!"Keys and values must be < 64 characters.\n")
    	return
    EndIf
 
  Info_RemoveKey (s, _key) 
 if (value = NULL or  strlen(value) = 0) then
 	return 
 EndIf
   	
 
 	 Com_sprintf (newi, sizeof(newi), !"\\%s\\%s", _key, value) 
 
	if (strlen(newi) + strlen(s) > maxsize) then
		Com_Printf (!"Info string length exceeded\n")
		return 
	EndIf
 
	'// only copy ascii values
 	 s += strlen(s) 
	 v = @newi 
	 while (*v)
	 			c = *v
	 			v+=1
	 	c and= 127 		'// strip high bits
	 	if (c >= 32 and c < 127) then
	 		*s = c
	 		 s+=1   
	 	EndIf
 
	 Wend
 	
 	*s = 0
end sub

'//====================================================================



























 'sub RotatePointAroundVector  '( dst as vec3_t ,_dir as const vec3_t , _point as const vec3_t ,degrees as float  )
 'sub RotatePointAroundVector  ( dst  as vec_tp, _dir  as vec_tp,  _point  as const vec_tp, degrees as float) 

'
' 
'	dim as float	m(3,3) 
'	dim as float	im(3,3) 
'	dim as float	zrot(3,3) 
'	dim as float	tmpmat(3,3) 
'	dim as float	rot(3,3)
'	dim as integer	i 
'	dim as vec3_t vr, vup, vf
'	
'	'''
'	dim as vec_tp vp 
'   '''
'   
'   vp = @vf
' 	vp[0] =  _dir[0] 
' 	vp[1] =  _dir[1] 
' 	vp[2] =  _dir[2] 
' 
''	PerpendicularVector( vr, dir );
''	CrossProduct( vr, vf, vup );
' 
' 
' 
'   vp = @vr
' 	m(0,0) = vp[0] 
' 	m(1,0) = vp[1] 
' 	m(2,0) = vp[2] 
' 
'   vp = @vup
' 	m(0,1) = vp[0] 
' 	m(1,1) = vp[1] 
' 	m(2,1) = vp[2] 
' 
'   vp = @vf
' 	m(0,2) = vp[0] 
' 	m(1,2) = vp[1] 
' 	m(2,2) = vp[2] 
' 
' 	memcpy( @im(0,0), @m(0,0), (ubound( im ) * sizeof(float)) ) 
' 
' 	im(0,1) = m(1,0) 
' 	im(0,2) = m(2,0) 
' 	im(1,0) = m(0,1) 
' 	im(1,2) = m(2,1) 
' 	im(2,0) = m(0,2) 
' 	im(2,1) = m(1,2) 
' 
' 	memset( @zrot(0,0), 0, (ubound( zrot ) * sizeof(float)) ) 
' 	
' 	zrot(2,2) = 1.0F 
' 	zrot(1,1) = zrot(2,2)
' 	zrot(0,0) = zrot(1,1)
'
'	zrot(0,0) = cos( DEG2RAD( degrees ) )
'	zrot(0,1) = sin( DEG2RAD( degrees ) )
'	zrot(1,0) = -sin( DEG2RAD( degrees ) ) 
' 	zrot(1,1) = cos( DEG2RAD( degrees ) ) 
' 
' 	'R_ConcatRotations( m, zrot, tmpmat ) 
' 	'R_ConcatRotations( tmpmat, im, rot ) 
' 
'  for i = 0 to 3-1
'  	
'  	dst[i] = rot(i,0)  * _point[0] + rot(i,1) * _point[1] + rot(i,2) * _point[2] 
'
'  	
'  	
'  Next
'




 
	
'sub ProjectPointOnPlane( vec3_t dst, const vec3_t p, const vec3_t normal )
'sub ProjectPointOnPlane( dst as vec_tp , p as const vec_tp , normal as const vec_tp  )
   'dim as float d 
	'dim as vec3_t n 
	'dim as vec_tp np
	'dim as float inv_denom 


   ' 
   ' 
	'  inv_denom = 1.0F / DotProduct2( normal, normal ) 

	'  d = DotProduct2( normal, p ) * inv_denom 
	'
   ' np = @n 
	' np[0] = normal[0] * inv_denom 
	' np[1] = normal[1] * inv_denom 
	' np[2] = normal[2] * inv_denom 

	'  dst[0] = p[0] - d   * np[0] 
	'  dst[1] = p[1] - d   * np[1] 
	'  dst[2] = p[2] - d   * np[2] 
	


 












 
 


 
 
 
 
 

 



 
 























 






'short	(*_LittleShort) (short l);
'int		(*_BigLong) (int l);
'int		(*_LittleLong) (int l);
'float	(*_BigFloat) (float l);
'float	(*_LittleFloat) (float l);

'short	BigShort(short l){return _BigShort(l);}
'short	LittleShort(short l) {return _LittleShort(l);}
'int		BigLong (int l) {return _BigLong(l);}
'int		LittleLong (int l) {return _LittleLong(l);}
'float	BigFloat (float l) {return _BigFloat(l);}
'float	LittleFloat (float l) {return _LittleFloat(l);}