	.intel_syntax noprefix
 
#ifdef id386

 .section .data
Ltemp: .long 0	
// 1.0/(float)0x100000
//0x035800000 
float_1_div_0100000h: .long  1
	//0.999
float_point_999: .long 	1
//1.001
float_1_point_001: .long 	1


.balign 4
.include "fqasm.inc"





.section .text
edgestoadd	=		4+8		
edgelist	=		8+12	

.global _R_EdgeCodeStart
_R_EdgeCodeStart:

// note odd stack offsets because of interleaving
// with pushes


.global _R_InsertNewEdges	
_R_InsertNewEdges: 

 // preserve register variables
 push edi	
 push esi	
 mov edx,ds:dword ptr[edgestoadd+esp]
 push ebx	
 mov ecx,ds:dword ptr[edgelist+esp]	

LDoNextEdge:	
 mov eax,ds:dword ptr[et_u+edx]	
 mov edi,edx	

LContinueSearch:	
 mov ebx,ds:dword ptr[et_u+ecx]	
 mov esi,ds:dword ptr[et_next+ecx]	
 cmp eax,ebx	
 jle LAddedge	
   mov ebx,ds:dword ptr[et_u+esi]	
   mov ecx,ds:dword ptr[et_next+esi]	
   cmp eax,ebx	
   jle LAddedge2	
   mov ebx,ds:dword ptr[et_u+ecx]	
   mov esi,ds:dword ptr[et_next+ecx]	
   cmp eax,ebx	
 jle LAddedge	
   mov ebx,ds:dword ptr[et_u+esi]	
   mov ecx,ds:dword ptr[et_next+esi]	
   cmp eax,ebx	
  jg LContinueSearch	

LAddedge2:	
 mov edx,ds:dword ptr[et_next+edx]	
 mov ebx,ds:dword ptr[et_prev+esi]	
 mov ds:dword ptr[et_next+edi],esi	
 mov ds:dword ptr[et_prev+edi],ebx	
 mov ds:dword ptr[et_next+ebx],edi	
 mov ds:dword ptr[et_prev+esi],edi	
 mov ecx,esi	

 cmp edx,0	
 jnz LDoNextEdge	
 jmp LDone	

 .align 4	
LAddedge:	
 mov edx,ds:dword ptr[et_next+edx]	
 mov ebx,ds:dword ptr[et_prev+ecx]	
 mov ds:dword ptr[et_next+edi],ecx	
 mov ds:dword ptr[et_prev+edi],ebx	
 mov ds:dword ptr[et_next+ebx],edi	
 mov ds:dword ptr[et_prev+ecx],edi	

 cmp edx,0	
 jnz LDoNextEdge	

LDone:	
//; restore register variables
 pop ebx	
 pop esi	
 pop edi	

 ret

 


predge	=	4+4

.global _R_RemoveEdges	
_R_RemoveEdges:	
 push ebx	
 mov eax,ds:dword ptr[predge+esp]	

Lre_loop:	
 mov ecx,ds:dword ptr[et_next+eax]	
 mov ebx,ds:dword ptr[et_nextremove+eax]	
 mov edx,ds:dword ptr[et_prev+eax]	
 test ebx,ebx	
 mov ds:dword ptr[et_prev+ecx],edx	
 jz Lre_done	
 mov ds:dword ptr[et_next+edx],ecx	

 mov ecx,ds:dword ptr[et_next+ebx]	
 mov edx,ds:dword ptr[et_prev+ebx]	
 mov eax,ds:dword ptr[et_nextremove+ebx]	
 mov ds:dword ptr[et_prev+ecx],edx	
 test eax,eax	
 mov ds:dword ptr[et_next+edx],ecx	
 jnz Lre_loop	

 pop ebx	
 ret	

Lre_done:	
 mov ds:dword ptr[et_next+edx],ecx	
 pop ebx
 ret


// note odd stack offset because of interleaving
// with pushes
pedgelist	=		4+4		
							

 .global _R_StepActiveU	
_R_StepActiveU:	
 push edi	
 mov edx,ds:dword ptr[pedgelist+esp]	
 // preserve register variables
 push esi	
 push ebx	

 mov esi,ds:dword ptr[et_prev+edx]	

LNewEdge:	
 mov edi,ds:dword ptr[et_u+esi]	

LNextEdge:	
 mov eax,ds:dword ptr[et_u+edx]	
 mov ebx,ds:dword ptr[et_u_step+edx]	
 add eax,ebx	
 mov esi,ds:dword ptr[et_next+edx]	
 mov ds:dword ptr[et_u+edx],eax	
 cmp eax,edi	
 jl LPushBack	

 mov edi,ds:dword ptr[et_u+esi]	
 mov ebx,ds:dword ptr[et_u_step+esi]	
 add edi,ebx	
 mov edx,ds:dword ptr[et_next+esi]	
 mov ds:dword ptr[et_u+esi],edi	
 cmp edi,eax	
 jl LPushBack2	

 mov eax,ds:dword ptr[et_u+edx]	
 mov ebx,ds:dword ptr[et_u_step+edx]	
 add eax,ebx	
 mov esi,ds:dword ptr[et_next+edx]	
 mov ds:dword ptr[et_u+edx],eax	
 cmp eax,edi	
 jl LPushBack	

 mov edi,ds:dword ptr[et_u+esi]	
 mov ebx,ds:dword ptr[et_u_step+esi]	
 add edi,ebx	
 mov edx,ds:dword ptr[et_next+esi]	
 mov ds:dword ptr[et_u+esi],edi	
 cmp edi,eax	
 jnl LNextEdge	

LPushBack2:	
 mov ebx,edx	
 mov eax,edi	
 mov edx,esi	
 mov esi,ebx	

LPushBack:	
// push it back to keep it sorted
 mov ecx,ds:dword ptr[et_prev+edx]	
 mov ebx,ds:dword ptr[et_next+edx]	

// done if the -1 in edge_aftertail triggered this
 cmp edx,offset _edge_aftertail
 jz LUDone	

// pull the edge out of the edge list
 mov edi,ds:dword ptr[et_prev+ecx]	
 mov ds:dword ptr[et_prev+esi],ecx	
 mov ds:dword ptr[et_next+ecx],ebx	

// find out where the edge goes in the edge list
LPushBackLoop:	
 mov ecx,ds:dword ptr[et_prev+edi]	
 mov ebx,ds:dword ptr[et_u+edi]	
 cmp eax,ebx	
 jnl LPushBackFound	

 mov edi,ds:dword ptr[et_prev+ecx]	
 mov ebx,ds:dword ptr[et_u+ecx]	
 cmp eax,ebx	
 jl LPushBackLoop	

 mov edi,ecx	

// put the edge back into the edge list
LPushBackFound:	
 mov ebx,ds:dword ptr[et_next+edi]	
 mov ds:dword ptr[et_prev+edx],edi	
 mov ds:dword ptr[et_next+edx],ebx	
 mov ds:dword ptr[et_next+edi],edx	
 mov ds:dword ptr[et_prev+ebx],edx	

 mov edx,esi	
 mov esi,ds:dword ptr[et_prev+esi]	

 cmp edx,offset _edge_tail
 jnz LNewEdge	

LUDone:	
// restore register variables
 pop ebx	
 pop esi	
 pop edi	

 ret	


// note this is loaded before any pushes
surf	=	4		

 .align 4		
TrailingEdge:	
// check for edge inversion
 mov eax,ds:dword ptr[st_spanstate+esi]	
 dec eax	
 jnz LInverted	 

 mov ds:dword ptr[st_spanstate+esi],eax	
 mov ecx,ds:dword ptr[st_insubmodel+esi]	
// surfaces[1].st_next
 mov edx,ds:dword ptr[0x12345678 ]	
LPatch0:	
 mov eax,ds:dword ptr[_r_bmodelactive]	
 sub eax,ecx	
 cmp edx,esi	
 mov ds:dword ptr[_r_bmodelactive],eax	
// surface isn't on top, just remove
 jnz LNoEmit	

// emit a span (current top going away)
 mov eax,ds:dword ptr[et_u+ebx]	
 // iu = integral pixel u
 shr eax,20	
 mov edx,ds:dword ptr[st_last_u+esi]	
 mov ecx,ds:dword ptr[st_next+esi]	
 cmp eax,edx	
 // iu <= surf->last_u, so nothing to emit
 jle LNoEmit2	
//surf->next->last_u = iu;
 mov ds:dword ptr[st_last_u+ecx],eax	
 sub eax,edx	
 // span->u = surf->last_u;
 mov ds:dword ptr[espan_t_u+ebp],edx	
//span->count = iu - span->u;
 mov ds:dword ptr[espan_t_count+ebp],eax	
 mov eax,ds:dword ptr[_current_iv]	
 // span->v = current_iv;
 mov ds:dword ptr[espan_t_v+ebp],eax	
 mov eax,ds:dword ptr[st_spans+esi]	
// span->pnext = surf->spans;
 mov ds:dword ptr[espan_t_pnext+ebp],eax	
 // surf->spans = span;
 mov ds:dword ptr[st_spans+esi],ebp	
 add ebp,offset espan_t_size	
// remove the surface from the surface
 mov edx,ds:dword ptr[st_next+esi]	
 //; stack
 mov esi,ds:dword ptr[st_prev+esi]	

 mov ds:dword ptr[st_next+esi],edx	
 mov ds:dword ptr[st_prev+edx],esi	
 ret	

LNoEmit2:	
// surf->next->last_u = iu;
 mov ds:dword ptr[st_last_u+ecx],eax	
// remove the surface from the surface
 mov edx,ds:dword ptr[st_next+esi]	
// stack
 mov esi,ds:dword ptr[st_prev+esi]	

 mov ds:dword ptr[st_next+esi],edx	
 mov ds:dword ptr[st_prev+edx],esi	
 ret	

LNoEmit:
	// remove the surface from the surface
 mov edx,ds:dword ptr[st_next+esi]	
 // stack
 mov esi,ds:dword ptr[st_prev+esi]	

 mov ds:dword ptr[st_next+esi],edx	
 mov ds:dword ptr[st_prev+edx],esi	
 ret	

LInverted:	
 mov ds:dword ptr[st_spanstate+esi],eax	
 ret


// trailing edge only
Lgs_trailing:	
 push offset Lgs_nextedge	
 jmp TrailingEdge	


 .global _R_GenerateSpans	
_R_GenerateSpans:	
// preserve caller's stack frame
 push ebp	
 push edi	
 // preserve register variables
 push esi	
 push ebx	

// clear active surfaces to just the background surface
 mov eax,ds:dword ptr[_surfaces]	
 mov edx,ds:dword ptr[_edge_head_u_shift20]	
 add eax,offset st_size	
// %ebp = span_p throughout
 mov ebp,ds:dword ptr[_span_p]	

 mov ds:dword ptr[_r_bmodelactive],0	

 mov ds:dword ptr[st_next+eax],eax	
 mov ds:dword ptr[st_prev+eax],eax	
 mov ds:dword ptr[st_last_u+eax],edx	
 mov ebx,ds:dword ptr[_edge_head+et_next]	; edge=edge_head.next

// generate spans

 //done if empty list
 cmp ebx,offset _edge_tail	
 jz Lgs_lastspan	

Lgs_edgeloop:	

 mov edi,ds:dword ptr[et_surfs+ebx]	
 mov eax,ds:dword ptr[_surfaces]	
 mov esi,edi	
 and edi,0x0FFFF0000 
 and esi,0x0FFFF 
 // not a trailing edge
 jz Lgs_leading	

// it has a left surface, so a surface is going away for this span
 shl esi,offset SURF_T_SHIFT	
 add esi,eax	
 test edi,edi	
 jz Lgs_trailing	

// both leading and trailing
 call near ptr TrailingEdge	
 mov eax,ds:dword ptr[_surfaces]	



// ; ---------------------------------------------------------------
// ; handle a leading edge
// ; ---------------------------------------------------------------

Lgs_leading:	
 shr edi,16-SURF_T_SHIFT	
 mov eax,ds:dword ptr[_surfaces]	
 add edi,eax	
// surf2 = surfaces[1].next;
 mov esi,ds:dword ptr[0x12345678]	
LPatch2:	
 mov edx,ds:dword ptr[st_spanstate+edi]	
 mov eax,ds:dword ptr[st_insubmodel+edi]	
 test eax,eax	
 jnz Lbmodel_leading	

// handle a leading non-bmodel edge

// don't start a span if this is an inverted span, with the end edge preceding
// the start edge (that is, we've already seen the end edge)
 test edx,edx	
 jnz Lxl_done	


// if (surf->key < surf2->key)
//		goto newtop;
 inc edx	
 mov eax,ds:dword ptr[st_key+edi]	
 mov ds:dword ptr[st_spanstate+edi],edx	
 mov ecx,ds:dword ptr[st_key+esi]	
 cmp eax,ecx	
 jl Lnewtop	

// main sorting loop to search through surface stack until insertion point
// found. Always terminates because background surface is sentinel
// do
// {
// 		surf2 = surf2->next;
// } while (surf->key >= surf2->key);
Lsortloopnb:	
 mov esi,ds:dword ptr[st_next+esi]	
 mov ecx,ds:dword ptr[st_key+esi]	
 cmp eax,ecx	
 jge Lsortloopnb	

 jmp LInsertAndExit	


// handle a leading bmodel edge
 .align 4	
Lbmodel_leading:	

// don't start a span if this is an inverted span, with the end edge preceding
// the start edge (that is, we've already seen the end edge)
 test edx,edx	
 jnz Lxl_done	

 mov ecx,ds:dword ptr[_r_bmodelactive]	
 inc edx	
 inc ecx	
 mov ds:dword ptr[st_spanstate+edi],edx	
 mov ds:dword ptr[_r_bmodelactive],ecx	

// if (surf->key < surf2->key)
//		goto newtop;
 mov eax,ds:dword ptr[st_key+edi]	
 mov ecx,ds:dword ptr[st_key+esi]	
 cmp eax,ecx	
 jl Lnewtop	

// if ((surf->key == surf2->key) && surf->insubmodel)
// {
 jz Lzcheck_for_newtop	

// main sorting loop to search through surface stack until insertion point
//found. Always terminates because background surface is sentinel
// do
// {
// 		surf2 = surf2->next;
// } while (surf->key > surf2->key);
Lsortloop:	
 mov esi,ds:dword ptr[st_next+esi]	
 mov ecx,ds:dword ptr[st_key+esi]	
 cmp eax,ecx	
 jg Lsortloop	

 jne LInsertAndExit	

// Do 1/z sorting to see if we've arrived in the right position
 mov eax,ds:dword ptr[et_u+ebx]	
 sub eax,0x0FFFFF 	
 mov ds:dword ptr[Ltemp],eax	
 fild ds:dword ptr[Ltemp]	

// fu = (float)(edge->u - 0xFFFFF) *
 fmul ds:dword ptr[float_1_div_0100000h]	
//     (1.0 / 0x100000);

// fu | fu
 fld st(0)	
// fu*surf->d_zistepu | fu
 fmul ds:dword ptr[st_d_zistepu+edi]

// fv | fu*surf->d_zistepu | fu
    fld ds:dword ptr[_fv]	
    // fv*surf->d_zistepv | fu*surf->d_zistepu | fu
     fmul ds:dword ptr[st_d_zistepv+edi]
     	// fu*surf->d_zistepu | fv*surf->d_zistepv | fu
   fxch st(1)	
//; fu*surf->d_zistepu + surf->d_ziorigin |
 fadd ds:dword ptr[st_d_ziorigin+edi]	
// ;  fv*surf->d_zistepv | fu

// surf2->d_zistepu |
   fld ds:dword ptr[st_d_zistepu+esi]	
// ;  fu*surf->d_zistepu + surf->d_ziorigin |
// ;  fv*surf->d_zistepv | fu
   //; fu*surf2->d_zistepu |
   fmul st(0),st(3)	
// ;  fu*surf->d_zistepu + surf->d_ziorigin |
// ;  fv*surf->d_zistepv | fu

   //; fu*surf->d_zistepu + surf->d_ziorigin |

   fxch st(1)	
// ;  fu*surf2->d_zistepu |
// ;  fv*surf->d_zistepv | fu

//; fu*surf2->d_zistepu | newzi | fu
   faddp st(2),st(0)	

//; fv | fu*surf2->d_zistepu | newzi | fu
    fld ds:dword ptr[_fv]	
    //	; fv*surf2->d_zistepv |
   fmul ds:dword ptr[st_d_zistepv+esi]
// ;  fu*surf2->d_zistepu | newzi | fu
   // newzi | fv*surf2->d_zistepv |
   fld st(2)	
// ;  fu*surf2->d_zistepu | newzi | fu

  // ; newzibottom | fv*surf2->d_zistepv |
  fmul ds:dword ptr[float_point_999]	
// ;  fu*surf2->d_zistepu | newzi | fu

// fu*surf2->d_zistepu | fv*surf2->d_zistepv |
   fxch st(2)	
// ;  newzibottom | newzi | fu
  	// fu*surf2->d_zistepu + surf2->d_ziorigin |
   fadd ds:dword ptr[st_d_ziorigin+esi]
// ;  fv*surf2->d_zistepv | newzibottom | newzi |
// ;  fu
 // ; testzi | newzibottom | newzi | fu
   faddp st(1),st(0)	
  // ; newzibottom | testzi | newzi | fu
   fxch st(1)	

// ; if (newzibottom >= testzi)
// ;     goto Lgotposition;
//	; testzi | newzi | fu
   fcomp st(1)

//; newzi | testzi | fu
  fxch st(1)	
 // ; newzitop | testzi | fu
   fmul ds:dword ptr[float_1_point_001]	
//   ; testzi | newzitop | fu
   fxch st(1)	

   fnstsw ax	
   test ah,0x001 	
   jz Lgotposition_fpop3	

// ; if (newzitop >= testzi)
// ; {
//; newzitop | fu
  fcomp st(1)	
   fnstsw ax	
   test ah,0x045 	
   jz Lsortloop_fpop2	

// ; if (surf->d_zistepu >= surf2->d_zistepu)
// ;     goto newtop;

// surf->d_zistepu | newzitop| fu
   fld ds:dword ptr[st_d_zistepu+edi]	
   //; newzitop | fu
   fcomp ds:dword ptr[st_d_zistepu+esi]	
   fnstsw ax	
   test ah,0x001 	
  jz Lgotposition_fpop2	
// clear the FPstack
 fstp st(0)	
 fstp st(0)	
 mov eax,ds:dword ptr[st_key+edi]	
  jmp Lsortloop	


  Lgotposition_fpop3:	
   fstp st(0)	
  Lgotposition_fpop2:	
   fstp st(0)	
   fstp st(0)	
    jmp LInsertAndExit	


// ; emit a span (obscures current top)

  Lnewtop_fpop3:	
   fstp st(0)	
  Lnewtop_fpop2:	
    fstp st(0)	
    fstp st(0)	
   // reload the sorting key
   mov eax,ds:dword ptr[st_key+edi]	

  Lnewtop:	
 mov eax,ds:dword ptr[et_u+ebx]	
 mov edx,ds:dword ptr[st_last_u+esi]	
 // iu = integral pixel u
 shr eax,20	
// surf->last_u = iu;
 mov ds:dword ptr[st_last_u+edi],eax	
 cmp eax,edx	
 // iu <= surf->last_u, so nothing to emit
 jle LInsertAndExit	

 sub eax,edx	
 // span->u = surf->last_u;
 mov ds:dword ptr[espan_t_u+ebp],edx	
 
 //span->count = iu - span->u;
 mov ds:dword ptr[espan_t_count+ebp],eax 
 mov eax,ds:dword ptr[_current_iv]	
 // span->v = current_iv;
 mov ds:dword ptr[espan_t_v+ebp],eax	
 mov eax,ds:dword ptr[st_spans+esi]	
// span->pnext = surf->spans;
 mov ds:dword ptr[espan_t_pnext+ebp],eax  
// surf->spans = span;
 mov ds:dword ptr[st_spans+esi],ebp	
 add ebp,offset espan_t_size	

LInsertAndExit:	
// insert before surf2
// surf->next = surf2;
 mov ds:dword ptr[st_next+edi],esi	
 mov eax,ds:dword ptr[st_prev+esi]	
 // surf->prev = surf2->prev;
 mov ds:dword ptr[st_prev+edi],eax	
 // surf2->prev = surf;
 mov ds:dword ptr[st_prev+esi],edi	
 // surf2->prev->next = surf;
 mov ds:dword ptr[st_next+eax],edi	


// ---------------------------------------------------------------
// leading edge done
// ---------------------------------------------------------------








// ---------------------------------------------------------------
// see if there are any more edges
// ---------------------------------------------------------------

Lgs_nextedge:	
 mov ebx,ds:dword ptr[et_next+ebx]	
 cmp ebx,offset _edge_tail
 jnz Lgs_edgeloop	

// clean up at the right edge
Lgs_lastspan:	

// now that we've reached the right edge of the screen, we're done with any
// unfinished surfaces, so emit a span for whatever's on top
// surfaces[1].st_next
 mov esi,ds:dword ptr[0x12345678]	
LPatch3:	
 mov eax,ds:dword ptr[_edge_tail_u_shift20]	
 xor ecx,ecx	
 mov edx,ds:dword ptr[st_last_u+esi]	
 sub eax,edx	
 jle Lgs_resetspanstate	

 mov ds:dword ptr[espan_t_u+ebp],edx	
 mov ds:dword ptr[espan_t_count+ebp],eax	
 mov eax,ds:dword ptr[_current_iv]	
 mov ds:dword ptr[espan_t_v+ebp],eax	
 mov eax,ds:dword ptr[st_spans+esi]	
 mov ds:dword ptr[espan_t_pnext+ebp],eax	
 mov ds:dword ptr[st_spans+esi],ebp	
 add ebp,offset espan_t_size	

// reset spanstate for all surfaces in the surface stack
Lgs_resetspanstate:	
 mov ds:dword ptr[st_spanstate+esi],ecx	
 mov esi,ds:dword ptr[st_next+esi]	
// &surfaces[1]
 cmp esi,0x012345678 	
LPatch4:	
 jnz Lgs_resetspanstate	

// store the final span_p
 mov ds:dword ptr[_span_p],ebp	

// restore register variables
 pop ebx	
 pop esi	
 pop edi	
 // restore the caller's stack frame
 pop ebp	
 ret	

// ; ---------------------------------------------------------------
// ; 1/z sorting for bmodels in the same leaf
// ; ---------------------------------------------------------------
 .align 4	
Lxl_done:	
 inc edx	
 mov ds:dword ptr[st_spanstate+edi],edx	

 jmp Lgs_nextedge	


 .align 4	
Lzcheck_for_newtop:	
   mov eax,ds:dword ptr[et_u+ebx]	
   sub eax,0x0FFFFF 	
   mov ds:dword ptr[Ltemp],eax	
   fild ds:dword ptr[Ltemp]	

//; fu = (float)(edge->u - 0xFFFFF) *
   fmul ds:dword ptr[float_1_div_0100000h]	
// ;      (1.0 / 0x100000);

//; fu | fu
   fld st(0)	
   //; fu*surf->d_zistepu | fu
   fmul ds:dword ptr[st_d_zistepu+edi]	
   // fv | fu*surf->d_zistepu | fu
   fld ds:dword ptr[_fv]	
  // fv*surf->d_zistepv | fu*surf->d_zistepu | fu
 fmul ds:dword ptr[st_d_zistepv+edi]	
 // fu*surf->d_zistepu | fv*surf->d_zistepv | fu
 fxch st(1)	
// fu*surf->d_zistepu + surf->d_ziorigin |
 fadd ds:dword ptr[st_d_ziorigin+edi]	
 // fv*surf->d_zistepv | fu

//; surf2->d_zistepu |
   fld ds:dword ptr[st_d_zistepu+esi]	
// ;  fu*surf->d_zistepu + surf->d_ziorigin |
// ;  fv*surf->d_zistepv | fu
  // ; fu*surf2->d_zistepu |
    fmul st(0),st(3)	
// ;  fu*surf->d_zistepu + surf->d_ziorigin |
// ;  fv*surf->d_zistepv | fu
   // ; fu*surf->d_zistepu + surf->d_ziorigin |
   fxch st(1)	
// ;  fu*surf2->d_zistepu |
// ;  fv*surf->d_zistepv | fu
  // ; fu*surf2->d_zistepu | newzi | fu
   faddp st(2),st(0)	

//; fv | fu*surf2->d_zistepu | newzi | fu
   fld ds:dword ptr[_fv]	
   //; fv*surf2->d_zistepv |
     fmul ds:dword ptr[st_d_zistepv+esi]	
// ;  fu*surf2->d_zistepu | newzi | fu

   //; newzi | fv*surf2->d_zistepv |
   fld st(2)	
// ;  fu*surf2->d_zistepu | newzi | fu

  // newzibottom | fv*surf2->d_zistepv |
   fmul ds:dword ptr[float_point_999]	
// ;  fu*surf2->d_zistepu | newzi | fu

// fu*surf2->d_zistepu | fv*surf2->d_zistepv |
   fxch st(2)	
// ;  newzibottom | newzi | fu
//; fu*surf2->d_zistepu + surf2->d_ziorigin |
   fadd ds:dword ptr[st_d_ziorigin+esi]	

// ;  fv*surf2->d_zistepv | newzibottom | newzi |
// ;  fu
 //  ; testzi | newzibottom | newzi | fu
   faddp st(1),st(0)	
  // ; newzibottom | testzi | newzi | fu
  fxch st(1)	

// ; if (newzibottom >= testzi)
// ;     goto newtop;

//testzi | newzi | fu
   fcomp st(1)	
//; newzi | testzi | fu
   fxch st(1)	
   //; newzitop | testzi | fu
  fmul ds:dword ptr[float_1_point_001]	
 // ; testzi | newzitop | fu
   fxch st(1)	

    fnstsw ax	
    test ah,0x001 	
    jz Lnewtop_fpop3	

// ; if (newzitop >= testzi)
// ; {
   ///; newzitop | fu
    fcomp st(1)	
    fnstsw ax	
    test ah,0x045 	
    jz Lsortloop_fpop2	

// ; if (surf->d_zistepu >= surf2->d_zistepu)
// ;     goto newtop;

//; surf->d_zistepu | newzitop | fu
   fld ds:dword ptr[st_d_zistepu+edi]	
  // 	; newzitop | fu
   fcomp ds:dword ptr[st_d_zistepu+esi]
    fnstsw ax	
   test ah,0x001	
   jz Lnewtop_fpop2	

  Lsortloop_fpop2:	
// clear the FP stack
  fstp st(0)	
  fstp st(0)	
   mov eax,ds:dword ptr[st_key+edi]	
   jmp Lsortloop	


.global _R_EdgeCodeEnd	
_R_EdgeCodeEnd:	


 .align 4	
 .global _R_SurfacePatch	
_R_SurfacePatch:	

 mov eax,ds:dword ptr[_surfaces]	
 add eax,offset st_size	
 mov ds:dword ptr[LPatch4-4],eax	

 add eax,offset st_next	
 mov ds:dword ptr[LPatch0-4],eax	
 mov ds:dword ptr[LPatch2-4],eax	
 mov ds:dword ptr[LPatch3-4],eax	

ret

//id386
#endif
.end
