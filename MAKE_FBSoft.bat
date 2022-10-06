@echo off


rem echo    %~n1  

set path=C:\Program Files (x86)\FreeBASIC107;C:\Program Files (x86)\FreeBASIC107\bin\win32;%PATH%
 


 rem as.exe -v -alsm=%~n1.lst  -o %~n1.o   %~n1.asm

 as.exe -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_R_edgea.lst"  -o "FB_Ref_Soft\FQ_R_edgea.o"   "FB_Ref_Soft\FQ_R_edgea.asm"

pause


fbc -w pendantic -v -C -R  -dll "FB_Ref_Soft\R_Main.bas" "FB_Ref_Soft\R_model.bas" "FB_Ref_Soft\r_image.bas" "FB_Ref_Soft\r_draw.bas" "win32\rw_imp.bas" "FB_Ref_Soft\r_surf.bas" "win32\q_shwin.bas" "Game\qshared.bas" "win32\rw_dib.bas" "FB_Ref_Soft\r_aclip.bas" "FB_Ref_Soft\r_alias.bas" "FB_Ref_Soft\r_bsp.bas" "FB_Ref_Soft\r_edge.bas" "FB_Ref_Soft\r_light.bas" "FB_Ref_Soft\r_misc.bas" "FB_Ref_Soft\r_part.bas" "FB_Ref_Soft\r_poly.bas" "FB_Ref_Soft\r_polyse.bas" "FB_Ref_Soft\r_rast.bas" "FB_Ref_Soft\r_scan.bas" "FB_Ref_Soft\r_sprite.bas" "FB_Ref_Soft\r_ddraw.bas" "FB_Ref_Soft\FQ_R_edgea.o" -x "debug\FBRef_Soft.dll" 
  Debug\FBRef_Soft.exe

pause

 