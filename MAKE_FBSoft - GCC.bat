@echo off


rem echo    %~n1  

 set path=C:\Program Files (x86)\FreeBASIC107;C:\Program Files (x86)\FreeBASIC107\bin\win32;%PATH%
 
rem set path=C:\Program Files (x86)\FreeBASIC;C:\Program Files (x86)\FreeBASIC;%PATH%

rem fbc32 -gen gcc

rem pause


 rem as.exe -v -alsm=%~n1.lst  -o %~n1.o   %~n1.asm

 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\r_aclipa.lst"  -o "FB_Ref_Soft\FQ_R_aclipa.o"   "FB_Ref_Soft\FQ_R_aclipa.asm"
 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_R_edgea.lst"  -o "FB_Ref_Soft\FQ_R_edgea.o"   "FB_Ref_Soft\FQ_R_edgea.asm"
 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_R_scana.lst"  -o "FB_Ref_Soft\FQ_R_scana.o"   "FB_Ref_Soft\FQ_R_scana.asm"
 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_r_varsa.lst"  -o "FB_Ref_Soft\FQ_r_varsa.o"   "FB_Ref_Soft\FQ_r_varsa.asm"
 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_r_draw16.lst"  -o "FB_Ref_Soft\FQ_r_draw16.o"   "FB_Ref_Soft\FQ_r_draw16.asm"
 rem as.exe --32 -I"C:\Users\Gamer\Desktop\FB_CIN_VIWER\FB_Quake2\FB_Ref_Soft"  -v -alsm="FB_Ref_Soft\FQ_r_drawa.lst"  -o "FB_Ref_Soft\FQ_r_drawa.o"   "FB_Ref_Soft\FQ_r_drawa.asm"




rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\test_stuff.c"    -o "FB_Ref_Soft\test_stuff.S" 
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\test_stuff2.c"    -o "FB_Ref_Soft\test_stuff2.S"



rem gcc -m32 -march=i486 -c "FB_Ref_Soft\test_stuff.S"  -o "FB_Ref_Soft\test_stuff.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\test_stuff2.S"  -o "FB_Ref_Soft\test_stuff2.o"

rem fbc  -v  "FB_Ref_Soft\test_stuff.o" "FB_Ref_Soft\test_stuff2.o"




rem pause

ECHO COMPILING ASM FILES////////////////////////////////////
 	gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_r_draw16.S" -o "FB_Ref_Soft\FQ_r_draw16.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_r_drawa.S"  -o "FB_Ref_Soft\FQ_r_drawa.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_R_aclipa.S" -o "FB_Ref_Soft\FQ_R_aclipa.o"
 	gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_R_edgea.S"  -o "FB_Ref_Soft\FQ_R_edgea.o" 
gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_R_scana.S"  -o "FB_Ref_Soft\FQ_R_scana.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_r_varsa.S"  -o "FB_Ref_Soft\FQ_r_varsa.o"
	gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_r_spr8.S"  -o "FB_Ref_Soft\FQ_r_spr8.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_d_polysa.S"  -o "FB_Ref_Soft\FQ_d_polysa.o"
	gcc -m32 -march=i486 -c "FB_Ref_Soft\FQ_r_surf8.S"  -o "FB_Ref_Soft\FQ_r_surf8.o"

ECHO DONE.

REM gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_d_copy.S"  -o "FB_Ref_Soft\NOTDONE\FQ_d_copy.o"
REM gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_d_polysa.S"  -o "FB_Ref_Soft\NOTDONE\FQ_d_polysa.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_math.S"  -o "FB_Ref_Soft\NOTDONE\FQ_math.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_r_spr8.S"  -o "FB_Ref_Soft\NOTDONE\FQ_r_spr8.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_r_surf8.S"  -o "FB_Ref_Soft\NOTDONE\FQ_r_surf8.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_sys_dosa.S"  -o "FB_Ref_Soft\NOTDONE\FQ_sys_dosa.o"
rem gcc -m32 -march=i486 -c "FB_Ref_Soft\NOTDONE\FQ_snd_mixa.S"  -o "FB_Ref_Soft\NOTDONE\FQ_snd_mixa.o"

pause


rem fbc -gen gcc -asm intel -w pendantic  -v -C -rr -R  -s  -dll "FB_Ref_Soft\R_Main.bas" "FB_Ref_Soft\R_model.bas" "FB_Ref_Soft\r_image.bas" "FB_Ref_Soft\r_draw.bas" "win32\rw_imp.bas" "FB_Ref_Soft\r_surf.bas" "win32\q_shwin.bas" "Game\qshared.bas" "win32\rw_dib.bas" "FB_Ref_Soft\r_aclip.bas" "FB_Ref_Soft\r_alias.bas" "FB_Ref_Soft\r_bsp.bas" "FB_Ref_Soft\r_edge.bas" "FB_Ref_Soft\r_light.bas" "FB_Ref_Soft\r_misc.bas" "FB_Ref_Soft\r_part.bas" "FB_Ref_Soft\r_poly.bas" "FB_Ref_Soft\r_polyse.bas" "FB_Ref_Soft\r_rast.bas" "FB_Ref_Soft\r_scan.bas" "FB_Ref_Soft\r_sprite.bas" "FB_Ref_Soft\r_ddraw.bas" "FB_Ref_Soft\FQ_R_aclipa.o" "FB_Ref_Soft\FQ_R_edgea.o" "FB_Ref_Soft\FQ_R_scana.o" "FB_Ref_Soft\FQ_r_varsa.o" "FB_Ref_Soft\FQ_r_draw16.o" "FB_Ref_Soft\FQ_r_drawa.o" -x "debug\FBRef_Soft.dll" 

 
fbc -gen gcc -asm intel -w none -v   -r -R  -dll "FB_Ref_Soft\R_Main.bas" "FB_Ref_Soft\R_model.bas" "FB_Ref_Soft\r_image.bas" "FB_Ref_Soft\r_draw.bas" "win32\rw_imp.bas" "FB_Ref_Soft\r_surf.bas" "win32\q_shwin.bas" "Game\qshared.bas" "win32\rw_dib.bas" "FB_Ref_Soft\r_aclip.bas" "FB_Ref_Soft\r_alias.bas" "FB_Ref_Soft\r_bsp.bas" "FB_Ref_Soft\r_edge.bas" "FB_Ref_Soft\r_light.bas" "FB_Ref_Soft\r_misc.bas" "FB_Ref_Soft\r_part.bas" "FB_Ref_Soft\r_poly.bas" "FB_Ref_Soft\r_polyse.bas" "FB_Ref_Soft\r_rast.bas" "FB_Ref_Soft\r_scan.bas" "FB_Ref_Soft\r_sprite.bas" "FB_Ref_Soft\r_ddraw.bas"   -x "debug\FBRef_Soft.dll" 


 rem fbc -gen gcc -asm intel -w pendantic -v   -r -R  -dll "FB_Ref_Soft\R_Main.bas" "FB_Ref_Soft\R_model.bas" "FB_Ref_Soft\r_image.bas" "FB_Ref_Soft\r_draw.bas" "win32\rw_imp.bas" "FB_Ref_Soft\r_surf.bas" "win32\q_shwin.bas" "Game\qshared.bas" "win32\rw_dib.bas" "FB_Ref_Soft\r_aclip.bas" "FB_Ref_Soft\r_alias.bas" "FB_Ref_Soft\r_bsp.bas" "FB_Ref_Soft\r_edge.bas" "FB_Ref_Soft\r_light.bas" "FB_Ref_Soft\r_misc.bas" "FB_Ref_Soft\r_part.bas" "FB_Ref_Soft\r_poly.bas" "FB_Ref_Soft\r_polyse.bas" "FB_Ref_Soft\r_rast.bas" "FB_Ref_Soft\r_scan.bas" "FB_Ref_Soft\r_sprite.bas" "FB_Ref_Soft\r_ddraw.bas"   -x "debug\FBRef_Soft.dll" 
 rem fbc -gen gcc -asm att -w pendantic -v   -r -R  -dll "FB_Ref_Soft\R_Main.bas" "FB_Ref_Soft\R_model.bas" "FB_Ref_Soft\r_image.bas" "FB_Ref_Soft\r_draw.bas" "win32\rw_imp.bas" "FB_Ref_Soft\r_surf.bas" "win32\q_shwin.bas" "Game\qshared.bas" "win32\rw_dib.bas" "FB_Ref_Soft\r_aclip.bas" "FB_Ref_Soft\r_alias.bas" "FB_Ref_Soft\r_bsp.bas" "FB_Ref_Soft\r_edge.bas" "FB_Ref_Soft\r_light.bas" "FB_Ref_Soft\r_misc.bas" "FB_Ref_Soft\r_part.bas" "FB_Ref_Soft\r_poly.bas" "FB_Ref_Soft\r_polyse.bas" "FB_Ref_Soft\r_rast.bas" "FB_Ref_Soft\r_scan.bas" "FB_Ref_Soft\r_sprite.bas" "FB_Ref_Soft\r_ddraw.bas"   -x "debug\FBRef_Soft.dll" 



rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\R_Main.c"   -o "FB_Ref_Soft\R_Main.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\R_model.c"  -o "FB_Ref_Soft\R_model.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_image.c"  -o "FB_Ref_Soft\r_image.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_draw.c"   -o "FB_Ref_Soft\r_draw.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "win32\rw_imp.c"         -o "win32\rw_imp.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_surf.c"   -o "FB_Ref_Soft\r_surf.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "win32\q_shwin.c"        -o "win32\q_shwin.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "Game\qshared.c"         -o "Game\qshared.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "win32\rw_dib.c"         -o "win32\rw_dib.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_aclip.c"  -o "FB_Ref_Soft\r_aclip.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_alias.c"  -o "FB_Ref_Soft\r_alias.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_bsp.c"    -o "FB_Ref_Soft\r_bsp.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_edge.c"    -o "FB_Ref_Soft\r_edge.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_rast.c"    -o "FB_Ref_Soft\r_rast.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_light.c"  -o "FB_Ref_Soft\r_light.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_misc.c"   -o "FB_Ref_Soft\r_misc.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_part.c"   -o "FB_Ref_Soft\r_part.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_poly.c"   -o "FB_Ref_Soft\r_poly.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_polyse.c" -o "FB_Ref_Soft\r_polyse.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_scan.c"   -o "FB_Ref_Soft\r_scan.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_sprite.c" -o "FB_Ref_Soft\r_sprite.S"
rem gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=att "FB_Ref_Soft\r_ddraw.c"  -o "FB_Ref_Soft\r_ddraw.S"
 

Echo COMPILING TO ASM FILES////////////////////////////////////

gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\R_Main.c"   -o "FB_Ref_Soft\R_Main.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\R_model.c"  -o "FB_Ref_Soft\R_model.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_image.c"  -o "FB_Ref_Soft\r_image.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_draw.c"   -o "FB_Ref_Soft\r_draw.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "win32\rw_imp.c"         -o "win32\rw_imp.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_surf.c"   -o "FB_Ref_Soft\r_surf.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "win32\q_shwin.c"        -o "win32\q_shwin.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "Game\qshared.c"         -o "Game\qshared.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "win32\rw_dib.c"         -o "win32\rw_dib.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_aclip.c"  -o "FB_Ref_Soft\r_aclip.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_alias.c"  -o "FB_Ref_Soft\r_alias.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_bsp.c"    -o "FB_Ref_Soft\r_bsp.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_edge.c"    -o "FB_Ref_Soft\r_edge.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_rast.c"    -o "FB_Ref_Soft\r_rast.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_light.c"  -o "FB_Ref_Soft\r_light.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_misc.c"   -o "FB_Ref_Soft\r_misc.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_part.c"   -o "FB_Ref_Soft\r_part.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_poly.c"   -o "FB_Ref_Soft\r_poly.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_polyse.c" -o "FB_Ref_Soft\r_polyse.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_scan.c"   -o "FB_Ref_Soft\r_scan.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_sprite.c" -o "FB_Ref_Soft\r_sprite.S"
gcc -m32 -march=i486 -S -nostdlib -nostdinc -Wall -Wno-unused -Wno-main -Werror-implicit-function-declaration -O0 -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -Wno-format -masm=intel "FB_Ref_Soft\r_ddraw.c"  -o "FB_Ref_Soft\r_ddraw.S"

ECHO DONE.








Echo COMPILING TO OBJ FILES////////////////////////////////////





gcc -m32 -march=i486 -c "FB_Ref_Soft\R_main.S"   -o "FB_Ref_Soft\R_main.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\R_model.S"  -o "FB_Ref_Soft\R_model.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_image.S"  -o "FB_Ref_Soft\r_image.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_draw.S"   -o "FB_Ref_Soft\r_draw.o"
gcc -m32 -march=i486 -c "win32\rw_imp.S"         -o "win32\rw_imp.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_surf.S"   -o "FB_Ref_Soft\r_surf.o"
gcc -m32 -march=i486 -c "win32\q_shwin.S"        -o "win32\q_shwin.o"
gcc -m32 -march=i486 -c "Game\qshared.S"         -o "Game\qshared.o"
gcc -m32 -march=i486 -c "win32\rw_dib.S"  		 -o "win32\rw_dib.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_aclip.S"  -o "FB_Ref_Soft\r_aclip.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_alias.S"  -o "FB_Ref_Soft\r_alias.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_bsp.S"    -o "FB_Ref_Soft\r_bsp.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_edge.S"   -o "FB_Ref_Soft\r_edge.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_rast.S"   -o "FB_Ref_Soft\r_rast.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_light.S"  -o "FB_Ref_Soft\r_light.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_misc.S"   -o "FB_Ref_Soft\r_misc.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_part.S"   -o "FB_Ref_Soft\r_part.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_poly.S"   -o "FB_Ref_Soft\r_poly.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_polyse.S" -o "FB_Ref_Soft\r_polyse.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_scan.S"   -o "FB_Ref_Soft\r_scan.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_sprite.S" -o "FB_Ref_Soft\r_sprite.o"
gcc -m32 -march=i486 -c "FB_Ref_Soft\r_ddraw.S"  -o "FB_Ref_Soft\r_ddraw.o"
ECHO DONE.

Echo LINKING////////////////////////////////////
 

rem fbc  -v  "FB_Ref_Soft\R_Main.o" "FB_Ref_Soft\R_model.o" "FB_Ref_Soft\r_image.o" "FB_Ref_Soft\r_draw.o" "win32\rw_imp.o" "FB_Ref_Soft\r_surf.o" "win32\q_shwin.o" "Game\qshared.o" "win32\rw_dib.o" "FB_Ref_Soft\r_aclip.o" "FB_Ref_Soft\r_alias.o" "FB_Ref_Soft\r_bsp.o" "FB_Ref_Soft\r_edge.o" "FB_Ref_Soft\r_light.o" "FB_Ref_Soft\r_misc.o" "FB_Ref_Soft\r_part.o" "FB_Ref_Soft\r_poly.o" "FB_Ref_Soft\r_polyse.o" "FB_Ref_Soft\r_rast.o" "FB_Ref_Soft\r_scan.o" "FB_Ref_Soft\r_sprite.o" "FB_Ref_Soft\r_ddraw.o" "FB_Ref_Soft\FQ_r_varsa.o"  "FB_Ref_Soft\FQ_R_edgea.o" -x "debug\FBRef_Soft.dll" 
ld.exe -m i386pe -o "debug\FBRef_Soft.dll" -subsystem console --dll --enable-stdcall-fixup -e _DllMainCRTStartup@12 "C:\Program Files (x86)\FreeBASIC107\lib\win32\fbextra.x" --stack 1048576,1048576 --output-def "debug\FBRef_Soft.def" -s -L "C:\Program Files (x86)\FreeBASIC107\lib\win32" -L "." "C:\Program Files (x86)\FreeBASIC107\lib\win32\dllcrt2.o" "C:\Program Files (x86)\FreeBASIC107\lib\win32\crtbegin.o" "C:\Program Files (x86)\FreeBASIC107\lib\win32\fbrt0.o" "FB_Ref_Soft\R_Main.o" "FB_Ref_Soft\R_model.o" "FB_Ref_Soft\r_image.o" "FB_Ref_Soft\r_draw.o" "win32\rw_imp.o" "FB_Ref_Soft\r_surf.o" "win32\q_shwin.o" "Game\qshared.o" "win32\rw_dib.o" "FB_Ref_Soft\r_aclip.o" "FB_Ref_Soft\r_alias.o" "FB_Ref_Soft\r_bsp.o" "FB_Ref_Soft\r_edge.o" "FB_Ref_Soft\r_light.o" "FB_Ref_Soft\r_misc.o" "FB_Ref_Soft\r_part.o" "FB_Ref_Soft\r_poly.o" "FB_Ref_Soft\r_polyse.o" "FB_Ref_Soft\r_rast.o" "FB_Ref_Soft\r_scan.o" "FB_Ref_Soft\r_sprite.o" "FB_Ref_Soft\r_ddraw.o" "FB_Ref_Soft\FQ_r_draw16.o" "FB_Ref_Soft\FQ_r_drawa.o" "FB_Ref_Soft\FQ_R_aclipa.o" "FB_Ref_Soft\FQ_R_edgea.o"  "FB_Ref_Soft\FQ_R_scana.o" "FB_Ref_Soft\FQ_r_varsa.o" "FB_Ref_Soft\FQ_r_spr8.o" "FB_Ref_Soft\FQ_d_polysa.o" "FB_Ref_Soft\FQ_r_surf8.o" "-(" -lkernel32 -lgdi32 -lmsimg32 -luser32 -lversion -ladvapi32 -limm32 -lmsvcrt -lddraw -ldxguid -luuid -lole32 -loleaut32 -lwinmm -ldsound -lfb -lgcc -lmingw32 -lmingwex -lmoldname -lgcc_eh "-)" "C:\Program Files (x86)\FreeBASIC107\lib\win32\crtend.o" 
ECHO DONE.





  Debug\FBRef_Soft.exe

pause

 