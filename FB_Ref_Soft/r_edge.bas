#Include "FB_Ref_Soft\r_local.bi"



 dim shared  as espan_t	ptr span_p,  max_span_p 
 
 
dim  shared as edge_t	ptr auxedges 
dim  shared as edge_t	ptr r_edges,  edge_p,  edge_max 
 
dim shared current_iv as integer


  dim shared  as integer	edge_head_u_shift20, edge_tail_u_shift20 
 
 dim shared  as surf_t ptr  surfaces,  surface_p,  surf_max 
 

 
  dim shared edge_tail  as edge_t
  dim shared edge_head  as edge_t
  dim shared edge_aftertail as edge_t
  
  
  dim shared fv as float
 
 

 'extern fv alias "fv" as float
   
	
	

 
 
' extern "c"

'end extern
 sub R_ScanEdges
 	
 	
 	
 End Sub



 sub R_BeginEdgeFrame ()
 	
 	
 	
 End Sub
 
 dim shared as integer ubasestep, errorterm, erroradjustup, erroradjustdown


 dim shared as edge_t	 newedges(MAXHEIGHT) 
 dim shared as edge_t	 removeedges(MAXHEIGHT) 
  
 

#ifndef id386
sub R_SurfacePatch ()
	
End Sub
 
sub R_EdgeCodeStart ()
	
End Sub

sub R_EdgeCodeEnd ()
	
	
	
End Sub



#endif


''TEMPORARY HERE UNTIL ASM FILES CREATED
'sub R_SurfacePatch ()
'	
'End Sub
' 
'sub R_EdgeCodeStart ()
'	
'End Sub
'
'sub R_EdgeCodeEnd ()
'	
'	
'	
'End Sub

 'end extern