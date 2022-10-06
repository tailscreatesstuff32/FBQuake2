	.intel_syntax noprefix

.section .text
.balign 16

.globl _DIB_INIT@8
_DIB_INIT@8:
push ebp
mov ebp, esp
sub esp, 1080
push ebx
mov dword ptr [ebp-4], 0
.Lt_09A3:
lea eax, [ebp-1072]
push eax
push edi
mov edi, eax
xor eax, eax
mov ecx, 267
rep stosd
pop edi
pop eax
lea eax, [ebp-1072]
mov dword ptr [ebp-1076], eax
mov dword ptr [ebp-1080], 0
push 1068
push 0
lea eax, [ebp-1072]
push eax
call _memset
add esp, 12
cmp dword ptr [_SWW_STATE+8], 0
je .Lt_09A6
push dword ptr [_SWW_STATE+12]
call _GetDC@4
cmp dword ptr [_SWW_STATE+8], eax
je .Lt_09A8
mov dword ptr [ebp-4], 0
jmp .Lt_09A4
.Lt_09A8:
.Lt_09A7:
.Lt_09A6:
.Lt_09A5:
push 38
push dword ptr [_SWW_STATE+8]
call _GetDeviceCaps@8
and eax, 256
je .Lt_09AA
mov dword ptr [_SWW_STATE+144], -1
cmp dword ptr [_S_SYSTEMCOLORS_SAVED], 0
jne .Lt_09AC
call _DIB_SAVESYSTEMCOLORS@0
mov dword ptr [_S_SYSTEMCOLORS_SAVED], -1
.Lt_09AC:
.Lt_09AB:
jmp .Lt_09A9
.Lt_09AA:
mov dword ptr [_SWW_STATE+144], 0
.Lt_09A9:
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax], 40
mov eax, dword ptr [ebp-1076]
mov ebx, dword ptr [_VID+16]
mov dword ptr [eax+4], ebx
mov ebx, dword ptr [ebp-1076]
mov eax, dword ptr [_VID+20]
mov dword ptr [ebx+8], eax
mov eax, dword ptr [ebp-1076]
mov word ptr [eax+12], 1
mov eax, dword ptr [ebp-1076]
mov word ptr [eax+14], 8
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+16], 0
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+20], 0
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+24], 0
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+28], 0
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+32], 256
mov eax, dword ptr [ebp-1076]
mov dword ptr [eax+36], 256
mov dword ptr [ebp-1080], 0
.Lt_09B0:
mov eax, dword ptr [ebp-1080]
mov ebx, dword ptr [_D_8TO24TABLE+eax*4]
and ebx, 255
mov al, bl
lea ebx, [ebp-1072]
mov ecx, dword ptr [ebp-1080]
sal ecx, 2
add ebx, ecx
mov byte ptr [ebx+42], al
mov eax, dword ptr [ebp-1080]
mov ebx, dword ptr [_D_8TO24TABLE+eax*4]
shr ebx, 8
and ebx, 255
mov al, bl
lea ebx, [ebp-1072]
mov ecx, dword ptr [ebp-1080]
sal ecx, 2
add ebx, ecx
mov byte ptr [ebx+41], al
mov eax, dword ptr [ebp-1080]
mov ebx, dword ptr [_D_8TO24TABLE+eax*4]
shr ebx, 16
and ebx, 255
mov al, bl
lea ebx, [ebp-1072]
mov ecx, dword ptr [ebp-1080]
sal ecx, 2
add ebx, ecx
mov byte ptr [ebx+40], al
.Lt_09AE:
inc dword ptr [ebp-1080]
.Lt_09AD:
cmp dword ptr [ebp-1080], 255
jle .Lt_09B0
.Lt_09AF:
push 0
push 0
lea eax, [_SWW_STATE+24]
push eax
push 0
push dword ptr [ebp-1076]
push dword ptr [_SWW_STATE+8]
call _CreateDIBSection@24
mov dword ptr [_SWW_STATE+20], eax
cmp dword ptr [_SWW_STATE+20], 0
jne .Lt_09B2
push offset _Lt_09B3
push 0
call dword ptr [_RI+4]
add esp, 8
jmp .Lt_09B4
.Lt_09B2:
.Lt_09B1:
mov eax, dword ptr [ebp-1076]
cmp dword ptr [eax+8], 0
jle .Lt_09B6
mov eax, dword ptr [_VID+20]
dec eax
imul eax, dword ptr [_VID+16]
mov ebx, dword ptr [_SWW_STATE+24]
add ebx, eax
mov eax, dword ptr [ebp+8]
mov dword ptr [eax], ebx
mov ebx, dword ptr [_VID+16]
neg ebx
mov eax, dword ptr [ebp+12]
mov dword ptr [eax], ebx
jmp .Lt_09B5
.Lt_09B6:
mov ebx, dword ptr [ebp+8]
mov eax, dword ptr [_SWW_STATE+24]
mov dword ptr [ebx], eax
mov eax, dword ptr [ebp+12]
mov ebx, dword ptr [_VID+16]
mov dword ptr [eax], ebx
.Lt_09B5:
mov ebx, dword ptr [_VID+16]
imul ebx, dword ptr [_VID+20]
mov eax, ebx
push eax
push 255
push dword ptr [_SWW_STATE+24]
call _memset
add esp, 12
push dword ptr [_SWW_STATE+8]
call _CreateCompatibleDC@4
mov dword ptr [_SWW_STATE+16], eax
cmp dword ptr [_SWW_STATE+16], 0
jne .Lt_09B8
push offset _Lt_09B9
push 0
call dword ptr [_RI+4]
add esp, 8
jmp .Lt_09B4
.Lt_09B8:
.Lt_09B7:
push dword ptr [_SWW_STATE+20]
push dword ptr [_SWW_STATE+16]
call _SelectObject@8
mov dword ptr [_PREVIOUSLY_SELECTED_GDI_OBJ], eax
cmp dword ptr [_PREVIOUSLY_SELECTED_GDI_OBJ], 0
jne .Lt_09BB
push offset _Lt_09BC
push 0
call dword ptr [_RI+4]
add esp, 8
jmp .Lt_09B4
.Lt_09BB:
.Lt_09BA:
mov dword ptr [ebp-4], -1
jmp .Lt_09A4
.Lt_09B4:
call _DIB_SHUTDOWN@0
mov dword ptr [ebp-4], 0
.Lt_09A4:
mov eax, dword ptr [ebp-4]
pop ebx
mov esp, ebp
pop ebp
ret 8
.balign 16

.globl _DIB_SETPALETTE@4
_DIB_SETPALETTE@4:
push ebp
mov ebp, esp
sub esp, 1088
push ebx
.Lt_09BD:
mov eax, dword ptr [ebp+8]
mov dword ptr [ebp-4], eax
mov eax, offset _S_IPAL
mov dword ptr [ebp-8], eax
lea eax, [ebp-1036]
push eax
push edi
mov edi, eax
xor eax, eax
mov ecx, 257
rep stosd
pop edi
pop eax
lea eax, [ebp-1036]
mov dword ptr [ebp-1068], eax
lea eax, [ebp-1036]
mov dword ptr [ebp-1064], eax
mov dword ptr [ebp-1060], 1028
mov dword ptr [ebp-1056], 4
mov dword ptr [ebp-1052], 1
mov dword ptr [ebp-1048], 257
mov dword ptr [ebp-1044], 0
mov dword ptr [ebp-1040], 256
mov dword ptr [ebp-1072], 0
mov dword ptr [ebp-1076], 0
mov eax, dword ptr [_SWW_STATE+8]
mov dword ptr [ebp-1080], eax
cmp dword ptr [_SWW_STATE+16], 0
je .Lt_09C1
mov dword ptr [ebp-1072], 0
.Lt_09C2:
cmp dword ptr [ebp-1072], 255
jge .Lt_09C3
mov eax, dword ptr [ebp-4]
mov ebx, dword ptr [ebp-1072]
mov cl, byte ptr [eax]
mov byte ptr [ebp+ebx*4-1034], cl
mov ecx, dword ptr [ebp-4]
mov ebx, dword ptr [ebp-1072]
mov al, byte ptr [ecx+1]
mov byte ptr [ebp+ebx*4-1035], al
mov eax, dword ptr [ebp-4]
mov ebx, dword ptr [ebp-1072]
mov cl, byte ptr [eax+2]
mov byte ptr [ebp+ebx*4-1036], cl
mov ecx, dword ptr [ebp-1072]
mov byte ptr [ebp+ecx*4-1033], 0
inc dword ptr [ebp-1072]
inc dword ptr [ebp-4]
jmp .Lt_09C2
.Lt_09C3:
mov byte ptr [ebp-1034], 0
mov byte ptr [ebp-1035], 0
mov byte ptr [ebp-1036], 0
mov byte ptr [ebp-14], 255
mov byte ptr [ebp-15], 255
mov byte ptr [ebp-16], 255
lea ecx, [ebp-1036]
push ecx
push 256
push 0
push dword ptr [_SWW_STATE+16]
call _SetDIBColorTable@16
test eax, eax
jne .Lt_09C5
push offset _Lt_09C6
push 0
call dword ptr [_RI+4]
add esp, 8
.Lt_09C5:
.Lt_09C4:
.Lt_09C1:
.Lt_09C0:
cmp dword ptr [_SWW_STATE+144], 0
je .Lt_09C8
mov dword ptr [ebp-1084], 0
mov dword ptr [ebp-1088], 0
push 2
push dword ptr [ebp-1080]
call _SetSystemPaletteUse@8
test eax, eax
jne .Lt_09CA
push offset _Lt_09CB
push 0
call dword ptr [_RI+28]
add esp, 8
.Lt_09CA:
.Lt_09C9:
cmp dword ptr [_SWW_STATE+28], 0
je .Lt_09CD
push dword ptr [_SWW_STATE+28]
call _DeleteObject@4
mov dword ptr [_SWW_STATE+28], 0
.Lt_09CD:
.Lt_09CC:
mov eax, dword ptr [ebp-8]
mov word ptr [eax], 768
mov eax, dword ptr [ebp-8]
mov word ptr [eax+2], 256
mov dword ptr [ebp-1084], 0
mov eax, dword ptr [ebp+8]
mov dword ptr [ebp-4], eax
.Lt_09CE:
cmp dword ptr [ebp-1084], 256
jge .Lt_09CF
mov eax, dword ptr [ebp-4]
mov ecx, dword ptr [ebp-1084]
sal ecx, 2
mov ebx, dword ptr [ebp-8]
add ebx, ecx
mov cl, byte ptr [eax]
mov byte ptr [ebx+4], cl
mov ecx, dword ptr [ebp-4]
mov ebx, dword ptr [ebp-1084]
sal ebx, 2
mov eax, dword ptr [ebp-8]
add eax, ebx
mov bl, byte ptr [ecx+1]
mov byte ptr [eax+5], bl
mov ebx, dword ptr [ebp-4]
mov eax, dword ptr [ebp-1084]
sal eax, 2
mov ecx, dword ptr [ebp-8]
add ecx, eax
mov al, byte ptr [ebx+2]
mov byte ptr [ecx+6], al
mov eax, dword ptr [ebp-1084]
sal eax, 2
mov ecx, dword ptr [ebp-8]
add ecx, eax
mov byte ptr [ecx+7], 5
inc dword ptr [ebp-1084]
add dword ptr [ebp-4], 4
jmp .Lt_09CE
.Lt_09CF:
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+4], 0
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+5], 0
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+6], 0
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+7], 0
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+1024], 255
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+1025], 255
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+1026], 255
mov ecx, dword ptr [ebp-8]
mov byte ptr [ecx+1027], 0
push dword ptr [ebp-8]
call _CreatePalette@4
mov dword ptr [_SWW_STATE+28], eax
cmp dword ptr [_SWW_STATE+28], 0
jne .Lt_09D1
call _GetLastError@0
push eax
push offset _Lt_09D2
push 0
call dword ptr [_RI+28]
add esp, 12
.Lt_09D1:
.Lt_09D0:
push 0
push dword ptr [_SWW_STATE+28]
push dword ptr [ebp-1080]
call _SelectPalette@12
cmp dword ptr [ebp-1088], eax
je .Lt_09D4
call _GetLastError@0
push eax
push offset _Lt_09D5
push 0
call dword ptr [_RI+28]
add esp, 12
.Lt_09D4:
.Lt_09D3:
cmp dword ptr [_SWW_STATE+32], 0
jne .Lt_09D7
mov eax, dword ptr [ebp-1088]
mov dword ptr [_SWW_STATE+32], eax
.Lt_09D7:
.Lt_09D6:
push dword ptr [ebp-1080]
call _RealizePalette@4
mov dword ptr [ebp-1076], eax
mov eax, dword ptr [ebp-8]
movzx ecx, word ptr [eax+2]
cmp dword ptr [ebp-1076], ecx
je .Lt_09D9
push dword ptr [ebp-1076]
push offset _Lt_09DA
push 0
call dword ptr [_RI+28]
add esp, 12
.Lt_09D9:
.Lt_09D8:
.Lt_09C8:
.Lt_09C7:
.Lt_09BE:
pop ebx
mov esp, ebp
pop ebp
ret 4
.balign 16

.globl _DIB_SHUTDOWN@0
_DIB_SHUTDOWN@0:
.Lt_09DB:
mov eax, dword ptr [_S_SYSTEMCOLORS_SAVED]
and eax, dword ptr [_SWW_STATE+144]
je .Lt_09DE
call _DIB_RESTORESYSTEMCOLORS@0
.Lt_09DE:
.Lt_09DD:
cmp dword ptr [_SWW_STATE+28], 0
je .Lt_09E0
push dword ptr [_SWW_STATE+28]
call _DeleteObject@4
mov dword ptr [_SWW_STATE+28], 0
.Lt_09E0:
.Lt_09DF:
cmp dword ptr [_SWW_STATE+32], 0
je .Lt_09E2
push 0
push dword ptr [_SWW_STATE+32]
push dword ptr [_SWW_STATE+8]
call _SelectPalette@12
push dword ptr [_SWW_STATE+8]
call _RealizePalette@4
mov dword ptr [_SWW_STATE+32], 0
.Lt_09E2:
.Lt_09E1:
cmp dword ptr [_SWW_STATE+16], 0
je .Lt_09E4
push dword ptr [_PREVIOUSLY_SELECTED_GDI_OBJ]
push dword ptr [_SWW_STATE+16]
call _SelectObject@8
push dword ptr [_SWW_STATE+16]
call _DeleteDC@4
mov dword ptr [_SWW_STATE+16], 0
.Lt_09E4:
.Lt_09E3:
cmp dword ptr [_SWW_STATE+20], 0
je .Lt_09E6
push dword ptr [_SWW_STATE+20]
call _DeleteObject@4
mov dword ptr [_SWW_STATE+20], 0
mov dword ptr [_SWW_STATE+24], 0
.Lt_09E6:
.Lt_09E5:
cmp dword ptr [_SWW_STATE+8], 0
je .Lt_09E8
push dword ptr [_SWW_STATE+8]
push dword ptr [_SWW_STATE+12]
call _ReleaseDC@8
mov dword ptr [_SWW_STATE+8], 0
.Lt_09E8:
.Lt_09E7:
.Lt_09DC:
ret
.balign 16

.globl _DIB_RESTORESYSTEMCOLORS@0
_DIB_RESTORESYSTEMCOLORS@0:
.Lt_09E9:
push 1
push dword ptr [_SWW_STATE+8]
call _SetSystemPaletteUse@8
push offset _S_OLDSYSCOLORS
push offset _S_SYSPALINDICES
push 19
call _SetSysColors@12
.Lt_09EA:
ret
.balign 16

.globl _DIB_SAVESYSTEMCOLORS@0
_DIB_SAVESYSTEMCOLORS@0:
push ebx
.Lt_09EB:
mov dword ptr [_Lt_09F1], 0
.Lt_09F0:
mov eax, dword ptr [_Lt_09F1]
push dword ptr [_S_SYSPALINDICES+eax*4]
call _GetSysColor@4
mov ebx, dword ptr [_Lt_09F1]
mov dword ptr [_S_OLDSYSCOLORS+ebx*4], eax
.Lt_09EE:
inc dword ptr [_Lt_09F1]
.Lt_09ED:
cmp dword ptr [_Lt_09F1], 18
jle .Lt_09F0
.Lt_09EF:
.Lt_09EC:
pop ebx
ret

.section .bss
.balign 4
	.lcomm	_Lt_09F1,4

.section .text
.balign 16
_fb_ctor__rw_dib:
.Lt_0002:
.Lt_0003:
ret

.section .bss
.balign 4
	.lcomm	_Lt_0117,32
.balign 4
	.lcomm	_Lt_011B,32
.balign 4
	.lcomm	_Lt_011C,32
.balign 4
	.lcomm	_Lt_0139,32
.balign 4
	.lcomm	_Lt_013A,32
.balign 4
	.lcomm	_Lt_013B,32
.balign 4
	.lcomm	_Lt_013C,32
.balign 4
	.lcomm	_Lt_013D,32
.balign 4
	.lcomm	_Lt_013E,32
.balign 4
	.lcomm	_Lt_013F,32
.balign 4
	.lcomm	_Lt_0140,32
.balign 4
	.lcomm	_Lt_0141,32
.balign 4
	.lcomm	_Lt_0142,32
.balign 4
	.lcomm	_Lt_0143,32
.balign 4
	.lcomm	_Lt_0144,32
.balign 4
	.lcomm	_Lt_0145,32
.balign 4
	.lcomm	_Lt_0146,32
.balign 4
	.lcomm	_AFFINETRIDESC_T,4
.balign 4
	.lcomm	_S_SYSTEMCOLORS_SAVED,4
.balign 4
	.lcomm	_PREVIOUSLY_SELECTED_GDI_OBJ,4

.section .data
.balign 4
_S_SYSPALINDICES:
.int 10
.int 2
.int 12
.int 1
.int 15
.int 16
.int 18
.int 9
.int 17
.int 13
.int 14
.int 11
.int 3
.int 4
.int 7
.int 0
.int 5
.int 6
.int 8
.skip 4,0

.section .bss
.balign 4
	.lcomm	_S_OLDSYSCOLORS,80
.balign 4
	.lcomm	_S_IPAL,1032

.section .data
.balign 4
_Lt_09B3:	.ascii	"DIB_Init() - CreateDIBSection failed\n\0"
.balign 4
_Lt_09B9:	.ascii	"DIB_Init() - CreateCompatibleDC failed\n\0"
.balign 4
_Lt_09BC:	.ascii	"DIB_Init() - SelectObject failed\n\0"
.balign 4
_Lt_09C6:	.ascii	"DIB_SetPalette() - SetDIBColorTable failed\n\0"
.balign 4
_Lt_09CB:	.ascii	"DIB_SetPalette() - SetSystemPaletteUse() failed\n\0"
.balign 4
_Lt_09D2:	.ascii	"DIB_SetPalette() - CreatePalette failed(%x)\n\0"
.balign 4
_Lt_09D5:	.ascii	"DIB_SetPalette() - SelectPalette failed(%x)\n\0"
.balign 4
_Lt_09DA:	.ascii	"DIB_SetPalette() - RealizePalette set %d entries\n\0"

.section .ctors
.int _fb_ctor__rw_dib
