	.intel_syntax noprefix

.section .text
.balign 16

.globl _VID_CREATEWINDOW@12
_VID_CREATEWINDOW@12:
push ebp
mov ebp, esp
sub esp, 88
.Lt_0B66:
lea eax, [ebp-40]
push eax
push edi
mov edi, eax
xor eax, eax
mov ecx, 10
rep stosd
pop edi
pop eax
mov dword ptr [ebp-56], 0
mov dword ptr [ebp-52], 0
mov dword ptr [ebp-48], 0
mov dword ptr [ebp-44], 0
mov dword ptr [ebp-60], 0
mov dword ptr [ebp-64], 0
mov dword ptr [ebp-68], 0
mov dword ptr [ebp-72], 0
mov dword ptr [ebp-76], 0
mov dword ptr [ebp-80], 0
mov dword ptr [ebp-84], 0
mov dword ptr [ebp-88], 0
push 0
push offset _Lt_0B69
push offset _Lt_0B68
call dword ptr [_RI+44]
mov dword ptr [ebp-60], eax
push 0
push offset _Lt_0B69
push offset _Lt_0B6A
call dword ptr [_RI+44]
mov dword ptr [ebp-64], eax
push 1
push offset _Lt_0B69
push offset _Lt_0B6B
call dword ptr [_RI+44]
mov dword ptr [ebp-68], eax
mov eax, dword ptr [ebp-68]
fld dword ptr [eax+20]
fcomp dword ptr [_Lt_0B74]
fnstsw ax
test ah, 0b01000000
jnz .Lt_0B6D
mov dword ptr [ebp-88], 8
jmp .Lt_0B6C
.Lt_0B6D:
mov dword ptr [ebp-88], 0
.Lt_0B6C:
mov dword ptr [ebp-40], 0
mov eax, dword ptr [_SWW_STATE+4]
mov dword ptr [ebp-36], eax
mov dword ptr [ebp-32], 0
mov dword ptr [ebp-28], 0
mov eax, dword ptr [_SWW_STATE]
mov dword ptr [ebp-24], eax
mov dword ptr [ebp-20], 0
push 32512
push 0
call _LoadCursorA@8
mov dword ptr [ebp-16], eax
mov dword ptr [ebp-12], 17
mov dword ptr [ebp-8], 0
mov eax, offset _Lt_0B6E
mov dword ptr [ebp-4], eax
lea eax, [ebp-40]
push eax
call _RegisterClassA@4
movzx eax, ax
test eax, eax
jne .Lt_0B70
push offset _Lt_0B71
push 0
call dword ptr [_RI+28]
add esp, 8
.Lt_0B70:
.Lt_0B6F:
mov dword ptr [ebp-56], 0
mov dword ptr [ebp-52], 0
mov eax, dword ptr [ebp+8]
mov dword ptr [ebp-48], eax
mov eax, dword ptr [ebp+12]
mov dword ptr [ebp-44], eax
push 0
push dword ptr [ebp+16]
lea eax, [ebp-56]
push eax
call _AdjustWindowRect@12
mov eax, dword ptr [ebp-48]
sub eax, dword ptr [ebp-56]
mov dword ptr [ebp-80], eax
mov eax, dword ptr [ebp-44]
sub eax, dword ptr [ebp-52]
mov dword ptr [ebp-84], eax
mov eax, dword ptr [ebp-60]
fld dword ptr [eax+20]
fistp dword ptr [ebp-72]
mov eax, dword ptr [ebp-64]
fld dword ptr [eax+20]
fistp dword ptr [ebp-76]
push 0
push dword ptr [_SWW_STATE]
push 0
push 0
push dword ptr [ebp-84]
push dword ptr [ebp-80]
push dword ptr [ebp-76]
push dword ptr [ebp-72]
push dword ptr [ebp+16]
push offset _Lt_0B6E
push offset _Lt_0B6E
push dword ptr [ebp-88]
call _CreateWindowExA@48
mov dword ptr [_SWW_STATE+12], eax
cmp dword ptr [_SWW_STATE+12], 0
jne .Lt_0B73
.Lt_0B73:
.Lt_0B72:
push 1
push dword ptr [_SWW_STATE+12]
call _ShowWindow@8
push dword ptr [_SWW_STATE+12]
call _UpdateWindow@4
push dword ptr [_SWW_STATE+12]
call _SetForegroundWindow@4
push dword ptr [_SWW_STATE+12]
call _SetFocus@4
push dword ptr [ebp+12]
push dword ptr [ebp+8]
call dword ptr [_RI+64]
.Lt_0B67:
mov esp, ebp
pop ebp
ret 12
.balign 16

.globl _SWIMP_INIT@8
_SWIMP_INIT@8:
push ebp
mov ebp, esp
sub esp, 4
mov dword ptr [ebp-4], 0
.Lt_0B75:
mov eax, dword ptr [ebp+8]
mov dword ptr [_SWW_STATE], eax
mov eax, dword ptr [ebp+12]
mov dword ptr [_SWW_STATE+4], eax
mov dword ptr [ebp-4], 0
.Lt_0B76:
mov eax, dword ptr [ebp-4]
mov esp, ebp
pop ebp
ret 8
.balign 16

.globl _SWIMP_INITGRAPHICS@4
_SWIMP_INITGRAPHICS@4:
push ebp
mov ebp, esp
sub esp, 4
mov dword ptr [ebp-4], 0
.Lt_0B77:
call _SWIMP_SHUTDOWN@0
push 281018368
push dword ptr [_VID+20]
push dword ptr [_VID+16]
call _VID_CREATEWINDOW@12
cmp dword ptr [ebp+8], 0
je .Lt_0B7A
.Lt_0B7A:
.Lt_0B79:
mov dword ptr [ebp-4], 1
.Lt_0B78:
mov eax, dword ptr [ebp-4]
mov esp, ebp
pop ebp
ret 4
.balign 16

.globl _SWIMP_SETMODE@16
_SWIMP_SETMODE@16:
push ebp
mov ebp, esp
sub esp, 52
mov dword ptr [ebp-4], 0
.Lt_0B7B:
lea eax, [ebp-16]
mov dword ptr [ebp-48], eax
lea eax, [ebp-16]
mov dword ptr [ebp-44], eax
mov dword ptr [ebp-40], 12
mov dword ptr [ebp-36], 4
mov dword ptr [ebp-32], 1
mov dword ptr [ebp-28], 3
mov dword ptr [ebp-24], 0
mov dword ptr [ebp-20], 2
mov eax, offset _Lt_0B7E
mov dword ptr [ebp-16], eax
mov eax, offset _Lt_0B7F
mov dword ptr [ebp-12], eax
mov dword ptr [ebp-8], 0
mov dword ptr [ebp-52], 0
push dword ptr [ebp+16]
push offset _Lt_0B80
push 0
call dword ptr [_RI+4]
add esp, 12
push dword ptr [ebp+16]
push dword ptr [ebp+12]
push dword ptr [ebp+8]
call dword ptr [_RI+56]
test eax, eax
jne .Lt_0B82
push offset _Lt_0B83
push 0
call dword ptr [_RI+4]
add esp, 8
mov dword ptr [ebp-4], 2
jmp .Lt_0B7C
.Lt_0B82:
.Lt_0B81:
mov eax, dword ptr [ebp+20]
push dword ptr [ebp+eax*4-16]
mov eax, dword ptr [ebp+12]
push dword ptr [eax]
mov eax, dword ptr [ebp+8]
push dword ptr [eax]
push offset _Lt_0B84
push 0
call dword ptr [_RI+4]
add esp, 20
mov dword ptr [_SWW_STATE+152], -1
cmp dword ptr [ebp+20], 0
je .Lt_0B86
push 1
call _SWIMP_INITGRAPHICS@4
test eax, eax
jne .Lt_0B88
push 0
call _SWIMP_INITGRAPHICS@4
test eax, eax
je .Lt_0B8A
mov dword ptr [ebp+20], 0
mov dword ptr [ebp-52], 1
jmp .Lt_0B89
.Lt_0B8A:
mov dword ptr [ebp-52], 3
.Lt_0B89:
.Lt_0B88:
.Lt_0B87:
jmp .Lt_0B85
.Lt_0B86:
push dword ptr [ebp+20]
call _SWIMP_INITGRAPHICS@4
test eax, eax
jne .Lt_0B8C
mov dword ptr [_SWW_STATE+152], -1
mov dword ptr [ebp-4], 3
jmp .Lt_0B7C
.Lt_0B8C:
.Lt_0B8B:
.Lt_0B85:
mov eax, dword ptr [ebp+20]
mov dword ptr [_SW_STATE], eax
mov dword ptr [_SWW_STATE+152], -1
mov eax, dword ptr [ebp-52]
mov dword ptr [ebp-4], eax
.Lt_0B7C:
mov eax, dword ptr [ebp-4]
mov esp, ebp
pop ebp
ret 16
.balign 16

.globl _SWIMP_SHUTDOWN@0
_SWIMP_SHUTDOWN@0:
.Lt_0B8D:
push offset _Lt_0B8F
push 0
call dword ptr [_RI+4]
add esp, 8
cmp dword ptr [_SWW_STATE+12], 0
je .Lt_0B91
push offset _Lt_0B92
push 0
call dword ptr [_RI+4]
add esp, 8
push 1
push dword ptr [_SWW_STATE+12]
call _ShowWindow@8
push dword ptr [_SWW_STATE+12]
call _DestroyWindow@4
mov dword ptr [_SWW_STATE+12], 0
push dword ptr [_SWW_STATE]
push offset _Lt_0B6E
call _UnregisterClassA@8
.Lt_0B91:
.Lt_0B90:
.Lt_0B8E:
ret
.balign 16

.globl _SYS_MAKECODEWRITEABLE@8
_SYS_MAKECODEWRITEABLE@8:
push ebp
mov ebp, esp
sub esp, 4
.Lt_0B93:
mov dword ptr [ebp-4], 0
lea eax, [ebp-4]
push eax
push 4
push dword ptr [ebp+12]
push dword ptr [ebp+8]
call _VirtualProtect@16
test eax, eax
jne .Lt_0B96
push offset _Lt_0B97
push 0
call dword ptr [_RI+28]
add esp, 8
.Lt_0B96:
.Lt_0B95:
.Lt_0B94:
mov esp, ebp
pop ebp
ret 8
.balign 16

.globl _SWIMP_SETPALETTE@4
_SWIMP_SETPALETTE@4:
push ebp
mov ebp, esp
.Lt_0B98:
cmp dword ptr [ebp+8], 0
jne .Lt_0B9B
lea eax, [_SW_STATE+265]
mov dword ptr [ebp+8], eax
.Lt_0B9B:
.Lt_0B9A:
cmp dword ptr [_SW_STATE], 0
jne .Lt_0B9D
push dword ptr [ebp+8]
call _DIB_SETPALETTE@4
jmp .Lt_0B9C
.Lt_0B9D:
push dword ptr [ebp+8]
call _DDRAW_SETPALETTE@4
.Lt_0B9C:
.Lt_0B99:
mov esp, ebp
pop ebp
ret 4
.balign 16

.globl _SYS_SETFPCW@0
_SYS_SETFPCW@0:
push ebx
push esi
push edi
.Lt_0B9E:
xor eax, eax
fnstcw  word ptr _FPU_CW
mov ax, word ptr _FPU_CW
and ah, 0x0f0
or  ah, 0x003          
mov _FPU_FULL_CW, eax
and ah, 0x0f0 
or  ah, 0x00f           
mov _FPU_CHOP_CW, eax
and ah, 0x0f0
or  ah, 0x00b          
mov _FPU_CEIL_CW, eax
and ah, 0x0f0          
mov _FPU_SP24_CW, eax
and ah, 0x0f0          
or  ah, 0x008           
mov _FPU_SP24_CEIL_CW, eax
.Lt_0B9F:
pop edi
pop esi
pop ebx
ret
.balign 16

.globl _SWIMP_ENDFRAME@0
_SWIMP_ENDFRAME@0:
.Lt_0BA0:
.Lt_0BA1:
ret
.balign 16

.globl _SWIMP_APPACTIVATE@4
_SWIMP_APPACTIVATE@4:
push ebp
mov ebp, esp
.Lt_0BA2:
.Lt_0BA3:
mov esp, ebp
pop ebp
ret 4
.balign 16
_fb_ctor__rw_imp:
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

.globl _SWW_STATE
.balign 4
	.lcomm	_SWW_STATE,156

.section .data
.balign 4
_Lt_0B68:	.ascii	"vid_xpos\0"
.balign 4
_Lt_0B69:	.ascii	"0\0"
.balign 4
_Lt_0B6A:	.ascii	"vid_ypos\0"
.balign 4
_Lt_0B6B:	.ascii	"vid_fullscreen\0"
.balign 4
_Lt_0B6E:	.ascii	"Quake 2\0"
.balign 4
_Lt_0B71:	.ascii	"Couldn't register window class\0"
.balign 4
_Lt_0B74:	.long	0x00000000
.balign 4
_Lt_0B7E:	.ascii	"W\0"
.balign 4
_Lt_0B7F:	.ascii	"FS\0"
.balign 4
_Lt_0B80:	.ascii	"setting mode %d:\0"
.balign 4
_Lt_0B83:	.ascii	" invalid mode\n\0"
.balign 4
_Lt_0B84:	.ascii	" %d %d %s\n\0"
.balign 4
_Lt_0B8F:	.ascii	"Shutting down SW imp\n\0"
.balign 4
_Lt_0B92:	.ascii	"...destroying window\n\0"
.balign 4
_Lt_0B97:	.ascii	"Protection change failed\n\0"

.section .bss
.balign 4
	.lcomm	_FPU_CEIL_CW,4
.balign 4
	.lcomm	_FPU_CHOP_CW,4
.balign 4
	.lcomm	_FPU_FULL_CW,4
.balign 4
	.lcomm	_FPU_CW,4
.balign 4
	.lcomm	_FPU_PUSHED_CW,4
.balign 4
	.lcomm	_FPU_SP24_CW,4
.balign 4
	.lcomm	_FPU_SP24_CEIL_CW,4

.section .ctors
.int _fb_ctor__rw_imp
