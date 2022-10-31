#Include "FB_Ref_Soft\r_local.bi"

 
dim shared as qboolean		insubmodel 

dim shared as vec3_t			modelorg 		' modelorg is the viewpoint reletive to
dim shared as entity_t   ptr currententity 

dim shared as float			entity_rotation(3,3) 

dim shared as vec3_t r_entorigin 


/'
================
R_RotateBmodel
================
'/
sub R_RotateBmodel ()
 
	dim as float	angle, s, c, temp1(3,3), temp2(3,3), temp3(3,3) 

'// TODO: should use a look-up table
'// TODO: should really be stored with the entity instead of being reconstructed
'// TODO: could cache lazily, stored in the entity
'// TODO: share work with R_SetUpAliasTransform

'// yaw
	angle = currententity->angles(YAW) 		
	angle = angle * M_PI*2 / 360 
	s = sin(angle) 
	c = cos(angle) 

	temp1(0,0) = c 
	temp1(0,1) = s 
	temp1(0,2) = 0 
	temp1(1,0) = -s 
	temp1(1,1) = c 
	temp1(1,2) = 0 
	temp1(2,0) = 0 
	temp1(2,1) = 0 
	temp1(2,2) = 1 


'// pitch
	angle = currententity->angles(PITCH) 		
	angle = angle * M_PI*2 / 360 
	s = sin(angle) 
	c = cos(angle) 

	temp2(0,0) = c 
	temp2(0,1) = 0 
	temp2(0,2) = -s 
	temp2(1,0) = 0 
	temp2(1,1) = 1 
	temp2(1,2) = 0 
	temp2(2,0) = s 
	temp2(2,1) = 0 
	temp2(2,2) = c 

	R_ConcatRotations (temp2(), temp1(), temp3()) 

'// roll
 	angle = currententity->angles(ROLL)		
 	angle = angle * M_PI*2 / 360 
 	s = sin(angle) 
 	c = cos(angle) 
 
	temp1(0,0) = 1 
	temp1(0,1) = 0 
	temp1(0,2) = 0 
	temp1(1,0) = 0 
	temp1(1,1) = c 
	temp1(1,2) = s 
	temp1(2,0) = 0 
	temp1(2,1) = -s 
	temp1(2,2) = c 

	 R_ConcatRotations (temp1(), temp3(), entity_rotation()) 

'//
'// rotate modelorg and the transformation matrix
'//
	'R_EntityRotate(modelorg) 
	'R_EntityRotate (vpn) 
	'R_EntityRotate (vright) 
	'R_EntityRotate (vup) 

	'R_TransformFrustum () 
end sub

/'
================
R_DrawSubmodelPolygons

All in one leaf
================
'/
sub R_DrawSubmodelPolygons (pmodel as model_t ptr,clipflags as integer ,topnode as mnode_t ptr)
	
End Sub

sub  R_DrawSolidClippedSubmodelPolygons(pmodel as model_t ptr,topnode as mnode_t ptr)	
End Sub

 sub R_RenderWorld ()
 	
 End Sub
