.386
.model flat,stdcall
option casemap:none
include Seh2.inc

.data
szCap db "By Sapphire",0
szMsgOk db "It is now in the thread handler",0
szMsgErr1 db "It would never get here",0

.code
start:
assume fs:nothing
push offset perThread_Handler
push fs:[0]
mov fs:[0],esp
xor ecx,ecx
mov eax,200
cdq
div ecx
invoke MessageBox,0,addr szMsgErr1,addr szCap,10h+1000h
pop fs:[0]
add esp,4
invoke ExitProcess,0
;--------------------------
perThread_Handler:
invoke MessageBox,0,addr szMsgOk,addr szCap,MB_OK
mov eax,1
end start