.586p
.model flat,stdcall
option casemap:none
include user32.inc
include kernel32.inc
include Seh.inc
includelib user32.lib
includelib kernel32.lib
.data
szCap db "By Sapphire",0
szMsgOk db "Ok,The exception has been handled",0
szMsgErr1 db "It would never get there",0
.code
start:
push offset Final_Handler
call SetUnhandledExceptionFilter
	xor ecx,ecx
	mov eax,200
	cdq
	div ecx
	invoke MessageBox,0,addr szMsgErr1,addr szCap,30h+1000h
	invoke ExitProcess,0
Final_Handler:
	invoke MessageBox,0,addr szMsgOk,addr szCap,30h
	mov eax,0
ret 4
end start