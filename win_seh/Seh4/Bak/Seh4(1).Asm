.386
.model flat,stdcall
option casemap:none
include Seh4.inc

.data
sztit db "exception mess by Sapphire",0
fmt db "the result of div is %d",0
szbuf db 200 dup(0)
sztmp1 db "it is now in the perthread handler",0
sztmp2 db "it would never get here in normal",0
szcantdo db "cantdo",0
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
WouldBeOmit:
	add eax,100
ExecuteHere:
	div ecx
	invoke wsprintf,addr szbuf,addr fmt,eax
	invoke MessageBox,0,addr szbuf,addr sztit,40h+1000h
	pop fs:[0]
	add esp,4
	invoke ExitProcess,0
perThread_Handler proc\
uses ebx pExcept:DWORD,pFrame:DWORD,pContext:DWORD,pDispatch:DWORD
	mov eax,pContext
	assume eax:ptr CONTEXT
	mov [eax].regEcx,20
	lea ebx,ExecuteHere
	mov [eax].regEip,ebx
	mov eax,0
	ret

perThread_Handler endp
end start
