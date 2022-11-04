#Include "FB_Ref_Soft\r_local.bi"


dim shared as integer rand1k(0 to ...)  => { _
0, 144, 49, 207, 149, 122, 89, 229, 210, 191,_
44, 219, 181, 131, 77, 3, 23, 93, 37, 42,    _
253, 114, 30, 1, 2, 96, 136, 146, 154, 155,  _
42, 169, 115, 90, 14, 155, 200, 205, 133, 77, _
224, 186, 244, 236, 138, 36, 118, 60, 220, 53,  _
199, 215, 255, 255, 156, 100, 68, 76, 215, 6, _
96, 23, 173, 14, 2, 235, 70, 69, 150, 176, _
214, 185, 124, 52, 190, 119, 117, 242, 190, 27, _
153, 98, 188, 155, 146, 92, 38, 57, 108, 205, _
132, 253, 192, 88, 43, 168, 125, 16, 179, 129, _
37, 243, 36, 231, 177, 77, 109, 18, 247, 174, _
39, 224, 210, 149, 48, 45, 209, 121, 39, 129, _
187, 103, 71, 145, 174, 193, 184, 121, 31, 94, _
213, 8, 132, 169, 109, 26, 243, 235, 140, 88, _
120, 95, 216, 81, 116, 69, 251, 76, 189, 145, _
50, 194, 214, 101, 128, 227, 7, 254, 146, 12, _
136, 49, 215, 160, 168, 50, 215, 31, 28, 190, _
80, 240, 73, 86, 35, 187, 213, 181, 153, 191, _
64, 36, 0, 15, 206, 218, 53, 29, 141, 3, _
29, 116, 192, 175, 139, 18, 111, 51, 178, 74, _
111, 59, 147, 136, 160, 41, 129, 246, 178, 236, _
48, 86, 45, 254, 117, 255, 24, 160, 24, 112, _
238, 12, 229, 74, 58, 196, 105, 51, 160, 154, _
115, 119, 153, 162, 218, 212, 159, 184, 144, 96, _
47, 188, 142, 231, 62, 48, 154, 178, 149, 89, _
126, 20, 189, 156, 158, 176, 205, 38, 147, 222, _
233, 157, 186, 11, 170, 249, 80, 145, 78, 44, _
27, 222, 217, 190, 39, 83, 20, 19, 164, 209, _
139, 114, 104, 76, 119, 128, 39, 82, 188, 80, _
211, 245, 223, 185, 76, 241, 32, 16, 200, 134, _
156, 244, 18, 224, 167, 82, 26, 129, 58, 74, _
235, 141, 169, 29, 126, 97, 127, 203, 130, 97, _
176, 136, 155, 101, 1, 181, 25, 159, 220, 125, _
191, 127, 97, 201, 141, 91, 244, 161, 45, 95, _
33, 190, 243, 156, 7, 84, 14, 163, 33, 216, _
221, 152, 184, 218, 3, 32, 181, 157, 55, 16, _
43, 159, 87, 81, 94, 169, 205, 206, 134, 156, _
204, 230, 37, 161, 103, 64, 34, 218, 16, 109, _
146, 77, 140, 57, 79, 28, 206, 34, 72, 201, _
229, 202, 190, 157, 92, 219, 58, 221, 58, 63, _
138, 252, 13, 20, 134, 109, 24, 66, 228, 59, _
37, 32, 238, 20, 12, 15, 86, 234, 102, 110, _
242, 214, 136, 215, 177, 101, 66, 1, 134, 244, _
102, 61, 149, 65, 175, 241, 111, 227, 1, 240, _
153, 201, 147, 36, 56, 98, 1, 106, 21, 168, _
218, 16, 207, 169, 177, 205, 135, 175, 36, 176, _
186, 199, 7, 222, 164, 180, 21, 141, 242, 15, _
70, 37, 251, 158, 74, 236, 94, 177, 55, 39, _
61, 133, 230, 27, 231, 113, 20, 200, 43, 249, _
198, 222, 53, 116, 0, 192, 29, 103, 79, 254, _
9, 64, 48, 63, 39, 158, 226, 240, 50, 199, _
165, 168, 232, 116, 235, 170, 38, 162, 145, 108, _
241, 138, 148, 137, 65, 101, 89, 9, 203, 50, _
17, 99, 151, 18, 50, 39, 164, 116, 154, 178, _
112, 175, 101, 213, 151, 51, 243, 224, 100, 252, _
47, 229, 147, 113, 160, 181, 12, 73, 66, 104, _
229, 181, 186, 229, 100, 101, 231, 79, 99, 146, _
90, 187, 190, 188, 189, 35, 51, 69, 174, 233, _
94, 132, 28, 232, 51, 132, 167, 112, 176, 23, _
20, 19, 7, 90, 78, 178, 36, 101, 17, 172, _
185, 50, 177, 157, 167, 139, 25, 139, 12, 249, _
118, 248, 186, 135, 174, 177, 95, 99, 12, 207, _
43, 15, 79, 200, 54, 82, 124, 2, 112, 130, _
155, 194, 102, 89, 215, 241, 159, 255, 13, 144, _
221, 99, 78, 72, 6, 156, 100, 4, 7, 116, _
219, 239, 102, 186, 156, 206, 224, 149, 152, 20, _
203, 118, 151, 150, 145, 208, 172, 87, 2, 68, _
87, 59, 197, 95, 222, 29, 185, 161, 228, 46, _
137, 230, 199, 247, 50, 230, 204, 244, 217, 227, _
160, 47, 157, 67, 64, 187, 201, 43, 182, 123, _
20, 206, 218, 31, 78, 146, 121, 195, 49, 186, _
254, 3, 165, 177, 44, 18, 70, 173, 214, 142, _
95, 199, 59, 163, 59, 52, 248, 72, 5, 196, _
38, 12, 2, 89, 164, 87, 106, 106, 23, 139, _
179, 86, 168, 224, 137, 145, 13, 119, 66, 109, _
221, 124, 22, 144, 181, 199, 221, 217, 75, 221, _
165, 191, 212, 195, 223, 232, 233, 133, 112, 27, _
90, 210, 109, 43, 0, 168, 198, 16, 22, 98, _
175, 206, 39, 36, 12, 88, 4, 250, 165, 13, _
234, 163, 110, 5, 62, 100, 167, 200, 5, 211, _
35, 162, 140, 251, 118, 54, 76, 200, 87, 123, _
155, 26, 252, 193, 38, 116, 182, 255, 198, 164, _
159, 242, 176, 74, 145, 74, 140, 182, 63, 139, _
126, 243, 171, 195, 159, 114, 204, 190, 253, 52, _
161, 232, 151, 235, 129, 125, 115, 227, 240, 46, _
64, 51, 187, 240, 160, 10, 164, 8, 142, 139, _
114, 15, 254, 32, 153, 12, 44, 169, 85, 80, _
167, 105, 109, 56, 173, 42, 127, 129, 205, 111, _
1, 86, 96, 32, 211, 187, 228, 164, 166, 131, _
187, 188, 245, 119, 92, 28, 231, 210, 116, 27, _
222, 194, 10, 106, 239, 17, 42, 54, 29, 151, _
30, 158, 148, 176, 187, 234, 171, 76, 207, 96, _
255, 197, 52, 43, 99, 46, 148, 50, 245, 48, _
97, 77, 30, 50, 11, 197, 194, 225, 0, 114, _
109, 205, 118, 126, 191, 61, 143, 23, 236, 228, _
219, 15, 125, 161, 191, 193, 65, 232, 202, 51, _
141, 13, 133, 202, 180, 6, 187, 141, 234, 224, _
204, 78, 101, 123, 13, 166, 0, 196, 193, 56, _
39, 14, 171, 8, 88, 178, 204, 111, 251, 162, _
75, 122, 223, 20, 25, 36, 36, 235, 79, 95, _
208, 11, 208, 61, 229, 65, 68, 53, 58, 216, _
223, 227, 216, 155, 10, 44, 47, 91, 115, 47, _
228, 159, 139, 233 _
_
_ /'#Include "FB_Ref_Soft\rand1k.bi" '/
} 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



#define MASK_1K	&H3FF
dim shared as integer		rand1k_index = 0 

'// TODO: put in span spilling to shrink list size
'// !!! if this is changed, it must be changed in d_polysa.s too !!!
#define DPS_MAXSPANS			MAXHEIGHT+1	


 

type spanpackage_t 
	
   as any ptr	 pdest 
	as short	 ptr   pz 
	as integer	   count 
	as ubyte			ptex 
	as integer	  sfrac, tfrac, light, zi 
  

End Type


type edgetable
	as integer		isflattop 
	as integer		numleftedges 
	as integer		ptr pleftedgevert0 
	as integer		ptr pleftedgevert1 
	as integer		ptr pleftedgevert2 
	as integer		numrightedges 
	as integer		ptr prightedgevert0 
	as integer		ptr prightedgevert1 
	as integer		ptr prightedgevert2 
 
	
End Type



dim shared as aliastriangleparms_t aliastriangleparms 
dim shared as integer	r_p0(6), r_p1(6), r_p2(6) 

dim shared as ubyte ptr d_pcolormap 


 extern as integer			d_aflatcolor
dim shared as integer			d_aflatcolor 
dim shared as integer			d_xdenom 



dim shared as edgetable	ptr pedgetable 

dim shared as edgetable	edgetables(12) => { _
	(0, 1, @r_p0(0), @r_p2(0), NULL, 		2, @r_p0(0), @r_p1(0), @r_p2(0)), _
	(0, 2, @r_p1(0), @r_p0(0), @r_p2(0),   1, @r_p1(0), @r_p2(0), NULL), _
	(1, 1, @r_p0(0), @r_p2(0), NULL, 		1, @r_p1(0), @r_p2(0), NULL), _
	(0, 1, @r_p1(0), @r_p0(0), NULL, 		2, @r_p1(0), @r_p2(0), @r_p0(0) ), _
	(0, 2, @r_p0(0), @r_p2(0), @r_p1(0),   1, @r_p0(0), @r_p1(0), NULL), _
	(0, 1, @r_p2(0), @r_p1(0), NULL, 		1, @r_p2(0), @r_p0(0), NULL), _
	(0, 1, @r_p2(0), @r_p1(0), NULL, 		2, @r_p2(0), @r_p0(0), @r_p1(0) ), _
	(0, 2, @r_p2(0), @r_p1(0), @r_p0(0),   1, @r_p2(0), @r_p0(0), NULL), _
	(0, 1, @r_p1(0), @r_p0(0), NULL, 		1, @r_p1(0), @r_p2(0), NULL), _
	(1, 1, @r_p2(0), @r_p1(0), NULL, 		1, @r_p0(0), @r_p1(0), NULL), _
	(1, 1, @r_p1(0), @r_p0(0), NULL, 		1, @r_p2(0), @r_p0(0), NULL), _
	(0, 1, @r_p0(0), @r_p2(0), NULL, 		1, @r_p0(0), @r_p1(0), NULL)  _
} 

dim shared  as integer				a_sstepxfrac, a_tstepxfrac, r_lstepx, a_ststepxwhole 
dim shared  as integer				r_sstepx, r_tstepx, r_lstepy, r_sstepy, r_tstepy 
dim shared  as integer				r_zistepx, r_zistepy 
dim shared  as integer				d_aspancount, d_countextrastep 

extern "C"


extern as spanpackage_t			ptr a_spans 
extern as spanpackage_t			ptr d_pedgespanpackage 


extern as ubyte				  ptr	 d_pdest,  d_ptex 
extern as short 	  			  ptr d_pz 
extern as integer						d_sfrac, d_tfrac, d_light, d_zi 
extern as integer						d_ptexextrastep, d_sfracextrastep 
extern as integer						d_tfracextrastep, d_lightextrastep, d_pdestextrastep 
extern as integer						d_lightbasestep, d_pdestbasestep, d_ptexbasestep 
extern as integer						d_sfracbasestep, d_tfracbasestep 
extern as integer						d_ziextrastep, d_zibasestep 
extern as integer						d_pzextrastep, d_pzbasestep 



end extern



dim shared as spanpackage_t			ptr a_spans 
dim shared as spanpackage_t			ptr d_pedgespanpackage 


dim shared as ubyte					ptr d_pdest,  d_ptex 
dim shared as short 	  				ptr	d_pz 
dim shared as integer						d_sfrac, d_tfrac, d_light, d_zi 
dim shared as integer						d_ptexextrastep, d_sfracextrastep 
dim shared as integer						d_tfracextrastep, d_lightextrastep, d_pdestextrastep 
dim shared as integer						d_lightbasestep, d_pdestbasestep, d_ptexbasestep 
dim shared as integer						d_sfracbasestep, d_tfracbasestep 
dim shared as integer						d_ziextrastep, d_zibasestep 
dim shared as integer						d_pzextrastep, d_pzbasestep 


type adivtab_t 
	as integer		quotient 
	as integer		remainder 
End Type

 static shared as adivtab_t	adivtab(32*32) '=>' {
'#include "adivtab.h"
'};

dim shared as ubyte ptr skintable(MAX_LBM_HEIGHT) 
dim shared as integer		skinwidth 
dim shared as ubyte	ptr skinstart 


dim shared as sub(pspanpackage as spanpackage_t ptr)  d_pdrawspans 
 

declare sub R_PolysetDrawSpans8_33 (pspanpackage as spanpackage_t ptr) 
declare sub R_PolysetDrawSpans8_66 (pspanpackage as spanpackage_t ptr) 

extern "C"
declare sub R_PolysetDrawSpans8_Opaque (pspanpackage as spanpackage_t ptr) 
end extern 
 
declare sub R_PolysetDrawThreshSpans8 (pspanpackage as spanpackage_t ptr) 
declare sub R_PolysetCalcGradients (skinwidth as integer ) 
declare sub R_DrawNonSubdiv () 
declare sub R_PolysetSetEdgeTable ()
declare sub R_RasterizeAliasPolySmooth () 
declare sub R_PolysetScanLeftEdge( _height as integer) 
declare sub R_PolysetScanLeftEdge_C(_height as integer) 





'// ======================
'// PGM
'// 64 65 66 67 68 69 70 71   72 73 74 75 76 77 78 79
dim shared as UByte iractive = 0
dim shared as ubyte irtable(256) =>	 { 79, 78, 77, 76, 75, 74, 73, 72, _		/' black/white'/
 												   71, 70, 69, 68, 67, 66, 65, 64, _
 												   _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' dark taupe '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' slate grey '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  208, 208, 208, 208, 208, 208, 208, 208, _	/' unused?'/
												  64, 66, 68, 70, 72, 74, 76, 78, _		      /' dark yellow'/
												  _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' dark red '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' grey/tan '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  _
												  64, 66, 68, 70, 72, 74, 76, 78, _		/'  chocolate '/
												  68, 67, 66, 65, 64, 65, 66, 67, _		/' mauve / teal '/
												  68, 69, 70, 71, 72, 73, 74, 75, _
												  76, 76, 77, 77, 78, 78, 79, 79, _	
												  _	
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' more mauve'/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' olive '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/'  maroon '/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' sky blue'/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  _
												  64, 65, 66, 67, 68, 69, 70, 71, _ 		/' olive again'/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' nuclear green'/
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' bright yellow'/
												  _
												  64, 65, 66, 67, 68, 69, 70, 71, _		/' fire colors'/
												  72, 73, 74, 75, 76, 77, 78, 79, _
												  208, 208, 64, 64, 70, 71, 72, 64, _		/' mishmash1'/
												  66, 68, 70, 64, 65, 66, 67, 68} 		/' mishmash2'/					 
						 
'// PGM
'// ======================						 

'/*
'================
'R_PolysetUpdateTables
'================
'*/
sub R_PolysetUpdateTables ()
	dim  as integer		i 
	dim  as ubyte	  ptr s 
	
	if  r_affinetridesc.skinwidth <> skinwidth or _
		 r_affinetridesc.pskin <> skinstart  then
 
		skinwidth = r_affinetridesc.skinwidth 
		skinstart = r_affinetridesc.pskin 
		s = skinstart 
		for  i = 0 to MAX_LBM_HEIGHT-1   
			skintable(i) = s 
			s+=skinwidth	
		next
		
	end if
	
End Sub
  
  
  
'/*
'================
'R_DrawTriangle
'================
'*/
sub R_DrawTriangle()
 
	dim as spanpackage_t spans(DPS_MAXSPANS)

	dim as integer dv1_ab, dv0_ac 
	dim as integer dv0_ab, dv1_ac 

	/'
	d_xdenom = ( aliastriangleparms.a->v[1] - aliastriangleparms.b->v[1] ) * ( aliastriangleparms.a->v[0] - aliastriangleparms.c->v[0] ) -
			   ( aliastriangleparms.a->v[0] - aliastriangleparms.b->v[0] ) * ( aliastriangleparms.a->v[1] - aliastriangleparms.c->v[1] );
	'/

	dv0_ab = aliastriangleparms.a->u - aliastriangleparms.b->u 
	dv1_ab = aliastriangleparms.a->v - aliastriangleparms.b->v 

	if (  ( dv0_ab or dv1_ab ) = 0 ) then
		return
	end if

	dv0_ac = aliastriangleparms.a->u - aliastriangleparms.c->u 
	dv1_ac = aliastriangleparms.a->v - aliastriangleparms.c->v 

	if (  ( dv0_ac or dv1_ac ) = 0 ) then
		return 
	EndIf
		

	d_xdenom = ( dv0_ac * dv1_ab ) - ( dv0_ab * dv1_ac ) 

	if ( d_xdenom < 0 ) then
	 
		a_spans = @spans(0) 

		r_p0(0) = aliastriangleparms.a->u 		'// u
		r_p0(1) = aliastriangleparms.a->v 		'// v
		r_p0(2) = aliastriangleparms.a->s 		'// s
		r_p0(3) = aliastriangleparms.a->t 		'// t
		r_p0(4) = aliastriangleparms.a->l 		'// light
		r_p0(5) = aliastriangleparms.a->zi 		'// iz

		r_p1(0) = aliastriangleparms.b->u 
		r_p1(1) = aliastriangleparms.b->v 
		r_p1(2) = aliastriangleparms.b->s 
		r_p1(3) = aliastriangleparms.b->t 
		r_p1(4) = aliastriangleparms.b->l 
		r_p1(5) = aliastriangleparms.b->zi 

		r_p2(0) = aliastriangleparms.c->u 
		r_p2(1) = aliastriangleparms.c->v 
		r_p2(2) = aliastriangleparms.c->s 
		r_p2(3) = aliastriangleparms.c->t 
		r_p2(4) = aliastriangleparms.c->l 
		r_p2(5) = aliastriangleparms.c->zi 

		R_PolysetSetEdgeTable () 
		R_RasterizeAliasPolySmooth () 
	end if
end sub


'/*
'===================
'FloorDivMod
'
'Returns mathematically correct (floor-based) quotient and remainder for
'numer and denom, both of which should contain no fractional part. The
'quotient must fit in 32 bits.
'FIXME: GET RID OF THIS! (FloorDivMod)
'====================
'*/
sub FloorDivMod (numer as float ,denom as float , quotient as integer ptr, _
		_rem as integer ptr )
 
	dim as integer	q, r 
	dim as float	x 

	if (numer >= 0.0) then
	 

		x = floor(numer / denom) 
		q = cast(integer,x) 
		r = cast(integer,floor(numer - (x * denom))) 
	 
	else
	 
	'//
	'// perform operations with positive values, and fix mod to make floor-based
	'//
	 	x = floor(-numer / denom) 
	 	q = -cast(integer,x) 
	 	r = cast(integer,floor(-numer - (x * denom))) 
	 	if (r <> 0) then
	 
	 		q-=1
	 		r = cast(integer,denom) - r 
	 	end if
	end if

	*quotient = q 
	*_rem = r 
end sub



'/*
'===================
'R_PolysetSetUpForLineScan
'====================
'*/
sub R_PolysetSetUpForLineScan( startvertu as fixed8_t ,startvertv as fixed8_t , _
		endvertu as fixed8_t ,endvertv as fixed8_t )
 
	dim as float		dm, dn 
	dim as integer    tm, tn 
	dim as adivtab_t	ptr ptemp

'// TODO: implement x86 version

	errorterm = -1 

	tm = endvertu - startvertu 
	tn = endvertv - startvertv 

	if (((tm <= 16) and (tm >= -15)) and _
		((tn <= 16) and (tn >= -15))) then
	 
		ptemp = @adivtab(((tm+15) shl 5) + (tn+15)) 
		ubasestep = ptemp->quotient 
		erroradjustup = ptemp->remainder 
		erroradjustdown = tn 
	 
	else
	 
		dm = tm 
		dn = tn 

		FloorDivMod (dm, dn, @ubasestep, @erroradjustup) 

		erroradjustdown = dn 
	end if
end sub 




'/*
'================
'R_PolysetFillSpans8
'================
'*/
sub R_PolysetFillSpans8 (pspanpackage as spanpackage_t ptr )
 
 	dim as integer				_color 
'
'' FIXME: do z buffering
 d_aflatcolor+=1
   _color = d_aflatcolor
'
 do while (1)
   
 	dim as 	integer	 lcount 
 	dim as 	ubyte	ptr lpdest 
 
   	lcount = pspanpackage->count 
 
 		if (lcount = -1) then
   		 return 
 		EndIf
 			
 
 		if (lcount) then
 			   		lpdest = pspanpackage->pdest 
 
 			do
  		 
 				 *lpdest = _color: lpdest+=1 
 				
 				 lcount-=1
 			loop	 while (lcount) 
 			
 		EndIf
 
 		pspanpackage+=1
 	 loop
end sub 


sub R_RasterizeAliasPolySmooth () 
	
	
	
End Sub

'/*
'================
'R_PolysetSetEdgeTable
'================
'*/
sub R_PolysetSetEdgeTable ()
 
	dim as integer			edgetableindex 

	edgetableindex = 0 	'// assume the vertices are already in
						'//  top to bottom order

'//
'// determine which edges are right & left, and the order in which
'// to rasterize them
'//
	if (r_p0(1) >= r_p1(1)) then
	 if (r_p0(1) = r_p1(1)) then
 
	 		if (r_p0(1) < r_p2(1)) then
		   	pedgetable = @edgetables(2) 
		 	else
		   	pedgetable = @edgetables(5) 
			end if
		 	return 
		 
		 else
		 
	 	edgetableindex = 1 
 
		EndIf
	EndIf
 


	if (r_p0(1) = r_p2(1)) then
		
			if (edgetableindex) then
			pedgetable = @edgetables(8)
		else
			pedgetable = @edgetables(9)

		return 
		
	EndIf
	 
 
	elseif (r_p1(1) = r_p2(1)) then
 
		if (edgetableindex) then
			pedgetable = @edgetables(10) 
		else
			pedgetable = @edgetables(11) 
		end if
		return 
	end if

	 if (r_p0(1) > r_p2(1)) then
	 	edgetableindex += 2
	 EndIf
	 	 

	 if (r_p1(1) > r_p2(1)) then
	 	edgetableindex += 4 
	 EndIf
	 	

	pedgetable = @edgetables(edgetableindex) 
end sub



'/*
'================
'R_PolysetCalcGradients
'================
'*/

extern "C"
extern as uinteger fpu_sp24_ceil_cw, fpu_ceil_cw, fpu_chop_cw 
end extern


'#if id386 && !defined __linux__

'FINISHED FOR NOW'''''''''''''''''''''''''''''''''''''''''''''
#if id386

sub R_PolysetCalcGradients(skinwidth as integer  )
 




	static as float xstepdenominv, ystepdenominv, t0, t1 
	static as float p01_minus_p21, p11_minus_p21, p00_minus_p20, p10_minus_p20 
	static as float one = 1.0F, negative_one = -1.0F  
	static as ulong t0_int, t1_int 

 	
'
'	/*
'	p00_minus_p20 = r_p0[0] - r_p2[0];
'	p01_minus_p21 = r_p0[1] - r_p2[1];
'	p10_minus_p20 = r_p1[0] - r_p2[0];
'	p11_minus_p21 = r_p1[1] - r_p2[1];
'	*/
'
 
asm
	   .intel_syntax noprefix
	   
 	 mov eax, dword ptr [r_p0+0]
	 mov ebx, dword ptr [r_p0+4]
	 sub eax, dword ptr [r_p2+0]
	 sub ebx, dword ptr [r_p2+4]
	 mov p00_minus_p20, eax
	 mov p01_minus_p21, ebx
	 fild dword ptr p00_minus_p20
	 fild dword ptr p01_minus_p21
	 mov eax, dword ptr [r_p1+0]
	 mov ebx, dword ptr [r_p1+4]
	 sub eax, dword ptr [r_p2+0]
	 sub ebx, dword ptr [r_p2+4]
	 fstp p01_minus_p21
	 fstp p00_minus_p20
	 mov p10_minus_p20, eax
	 mov p11_minus_p21, ebx
	 fild dword ptr p10_minus_p20
	 fild dword ptr p11_minus_p21
	 fstp p11_minus_p21
	 fstp p10_minus_p20

	 
	' 	/*
	'xstepdenominv = 1.0 / (float)d_xdenom;

	'ystepdenominv = -xstepdenominv;
	'*/

	'/*
	'** put FPU in single precision ceil mode
	'*/
 	 fldcw word ptr [fpu_sp24_ceil_cw]
 	 fldcw word ptr [fpu_ceil_cw]

	 fild  dword ptr d_xdenom    #; d_xdenom
	 fdivr one                   #; 1 / d_xdenom
	 fst   xstepdenominv         #; 
	 fmul  negative_one          #; -( 1 / d_xdenom )
	 
'	 // ceil () for light so positive steps are exaggerated, negative steps
'// diminished,  pushing us away from underflow toward overflow. Underflow is
'// very visible, overflow is very unlikely, because of ambient lighting
''	/*
'	t0 = r_p0[4] - r_p2[4];
'	t1 = r_p1[4] - r_p2[4];
'	r_lstepx = (int)
'			ceil((t1 * p01_minus_p21 - t0 * p11_minus_p21) * xstepdenominv);
'	r_lstepy = (int)
'			ceil((t1 * p00_minus_p20 - t0 * p10_minus_p20) * ystepdenominv);
'	*/
	 mov   eax, dword ptr [r_p0+16]
	 mov   ebx, dword ptr [r_p1+16]
	 sub   eax, dword ptr [r_p2+16]
	 sub   ebx, dword ptr [r_p2+16]

	 fstp  ystepdenominv       # (empty)

	 mov   t0_int, eax
	 mov   t1_int, ebx
	 fild  t0_int              # t0
	 fild  t1_int              # t1 | t0
	 fxch  st(1)               # t0 | t1
	 fstp  t0                  # t1
	 fst   t1                  # t1
	 fmul  p01_minus_p21       # t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p01_minus_p21
	 fmul  p11_minus_p21       # t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t1                  # t1 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p00_minus_p20       # t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p10_minus_p20       # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fxch  st(2)               # t0 * p11_minus_p21 | t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21
	 fsubp st(3), st           # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fsubrp st(1), st          # t1 * p00_minus_p20 - t0 * p10_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fxch  st(1)               # t1 * p01_minus_p21 - t0 * p11_minus_p21 | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fmul  xstepdenominv       # r_lstepx | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fxch  st(1)
	 fmul  ystepdenominv       # r_lstepy | r_lstepx
	 fxch  st(1)               # r_lstepx | r_lstepy
	 fistp dword ptr [r_lstepx]
	 fistp dword ptr [r_lstepy]

'	 	/*
'	** put FPU back into extended precision chop mode
'	*/
'//	__asm fldcw word ptr [fpu_chop_cw]
'
''	/*
'	t0 = r_p0[2] - r_p2[2];
'	t1 = r_p1[2] - r_p2[2];
'	r_sstepx = (int)((t1 * p01_minus_p21 - t0 * p11_minus_p21) *
'			xstepdenominv);
'	r_sstepy = (int)((t1 * p00_minus_p20 - t0* p10_minus_p20) *
'			ystepdenominv);
'	*/
	 mov eax, dword ptr [r_p0+8]
	 mov ebx, dword ptr [r_p1+8]
	 sub eax, dword ptr [r_p2+8]
	 sub ebx, dword ptr [r_p2+8]
	 mov   t0_int, eax
	 mov   t1_int, ebx
	 fild  t0_int              # t0
	 fild  t1_int              # t1 | t0
	 fxch  st(1)               # t0 | t1
	 fstp  t0                  # t1
	 fst   t1                  # (empty)

	 fmul  p01_minus_p21       # t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p01_minus_p21
	 fmul  p11_minus_p21       # t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t1                  # t1 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p00_minus_p20       # t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p10_minus_p20       # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fxch  st(2)               # t0 * p11_minus_p21 | t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21
	 fsubp st(3), st           # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fsubrp st(1), st           # t1 * p00_minus_p20 - t0 * p10_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fxch  st(1)               # t1 * p01_minus_p21 - t0 * p11_minus_p21 | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fmul  xstepdenominv       # r_lstepx | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fxch  st(1)
	 fmul  ystepdenominv       # r_lstepy | r_lstepx
	 fxch  st(1)               # r_lstepx | r_lstepy
	 fistp dword ptr [r_sstepx]
	 fistp dword ptr [r_sstepy]
	 
	' /*
	't0 = r_p0[3] - r_p2[3];
	't1 = r_p1[3] - r_p2[3];
	'r_tstepx = (int)((t1 * p01_minus_p21 - t0 * p11_minus_p21) *
	'		xstepdenominv);
	'r_tstepy = (int)((t1 * p00_minus_p20 - t0 * p10_minus_p20) *
	'		ystepdenominv);
	'*/
	 mov eax, dword ptr [r_p0+12]
	 mov ebx, dword ptr [r_p1+12]
	 sub eax, dword ptr [r_p2+12]
	 sub ebx, dword ptr [r_p2+12]

	 mov   t0_int, eax
	 mov   t1_int, ebx
	 fild  t0_int              # t0
	 fild  t1_int              # t1 | t0
	 fxch  st(1)               # t0 | t1
	 fstp  t0                  # t1
	 fst   t1                  # (empty)

	 fmul  p01_minus_p21       # t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p01_minus_p21
	 fmul  p11_minus_p21       # t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t1                  # t1 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p00_minus_p20       # t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p10_minus_p20       # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fxch  st(2)               # t0 * p11_minus_p21 | t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21
	 fsubp st(3), st           # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fsubrp st(1), st           # t1 * p00_minus_p20 - t0 * p10_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fxch  st(1)               # t1 * p01_minus_p21 - t0 * p11_minus_p21 | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fmul  xstepdenominv       # r_lstepx | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fxch  st(1)
	 fmul  ystepdenominv       # r_lstepy | r_lstepx
	 fxch  st(1)               # r_lstepx | r_lstepy
	 fistp dword ptr [r_tstepx]
	 fistp dword ptr [r_tstepy]
	 
	' 	/*
	't0 = r_p0[5] - r_p2[5];
	't1 = r_p1[5] - r_p2[5];
	'r_zistepx = (int)((t1 * p01_minus_p21 - t0 * p11_minus_p21) *
	'		xstepdenominv);
	'r_zistepy = (int)((t1 * p00_minus_p20 - t0 * p10_minus_p20) *
	'		ystepdenominv);
	'*/
	 mov eax, dword ptr [r_p0+20]
	 mov ebx, dword ptr [r_p1+20]
	 sub eax, dword ptr [r_p2+20]
	 sub ebx, dword ptr [r_p2+20]

	 mov   t0_int, eax
	 mov   t1_int, ebx
	 fild  t0_int              # t0
	 fild  t1_int              # t1 | t0
	 fxch  st(1)               # t0 | t1
	 fstp  t0                  # t1
	 fst   t1                  # (empty)

	 fmul  p01_minus_p21       # t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p01_minus_p21
	 fmul  p11_minus_p21       # t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t1                  # t1 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p00_minus_p20       # t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fld   t0                  # t0 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fmul  p10_minus_p20       # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t0 * p11_minus_p21 | t1 * p01_minus_p21
	 fxch  st(2)               # t0 * p11_minus_p21 | t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21
	 fsubp st(3), st           # t0 * p10_minus_p20 | t1 * p00_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fsubrp st(1), st           # t1 * p00_minus_p20 - t0 * p10_minus_p20 | t1 * p01_minus_p21 - t0 * p11_minus_p21
	 fxch  st(1)               # t1 * p01_minus_p21 - t0 * p11_minus_p21 | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fmul  xstepdenominv       # r_lstepx | t1 * p00_minus_p20 - t0 * p10_minus_p20
	 fxch  st(1)
	 fmul  ystepdenominv       # r_lstepy | r_lstepx
	 fxch  st(1)               # r_lstepx | r_lstepy
	 fistp dword ptr [r_zistepx]
	 fistp dword ptr [r_zistepy]
	 
	 	/'
#if	id386ALIAS
	a_sstepxfrac = r_sstepx << 16;
	a_tstepxfrac = r_tstepx << 16;
#else
	a_sstepxfrac = r_sstepx & 0xFFFF;
	a_tstepxfrac = r_tstepx & 0xFFFF;
#endif
	'/
	 mov eax, d_pdrawspans
	 cmp eax, offset R_PolysetDrawSpans8_Opaque
	 mov eax, r_sstepx
	 mov ebx, r_tstepx
	 jne translucent
'//#if id386ALIAS
	 shl eax, 16
	 shl ebx, 16
	 jmp done_with_steps
'//#else
translucent:
	 and eax, 0x0ffff 
	 and ebx, 0x0ffff 
'//#endif
done_with_steps:
	 mov a_sstepxfrac, eax
	 mov a_tstepxfrac, ebx

	/'
	a_ststepxwhole = skinwidth * (r_tstepx >> 16) + (r_sstepx >> 16);
	'/
	 mov ebx, r_tstepx
	 mov ecx, r_sstepx
	 sar ebx, 16
	 mov eax, skinwidth
	 mul ebx
	 sar ecx, 16
	 add eax, ecx
	 mov a_ststepxwhole, eax
	 
end asm

end sub
#endif



