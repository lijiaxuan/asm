.586
.model flat,stdcall
option casemap:none
include Seh5.inc
.data
	count dd 0
	Msg0 db "Eax==",0
	DispEax dd 0,0
.code
start:
	assume fs:nothing
	push offset singlestep_xHandler
	mov fs:[0]
	mov fs:[0],esp
	xor eax,eax
	pushfd
	pushfd
	or dword ptr [esp],100h
	popfd
	nop
	inc eax
	inc eax
	inc eax
	pop fd
	add eax,30h
	mov DispEax,eax
	invoke MessageBox,0,addr Msg0,ddd("The Eax equal to"),0
	pop fs:[0]
	add esp,4
	invoke ExitProcess,0
singlestep_xHandler proc\
	pExcept:DWORD,pFrame:DWORD,pContext:DWORD,pDispatch:DWORD
	pushad
	assume edi:ptr CONTEXT
	assume esi:ptr EXCEPTION_RECORD
	mov esi,pExcept
	mov edi,pContext
	test dword ptr [esi+4],1
commom_stuff
	jnz @final
	test dword ptr [esi+4],6
	jnz @final
	cmp dword ptr [esi],80000004h
	jnz @final
	inc [edi].regEax
	mov ebx,[edi].regEip
	cmp byte ptr [ebx],9dh
	jz @finish_singlestep
	or [edi].regFlag,100h
@finish_singlestep:
	mov dword ptr [esp+7*4],0
	popad
	ret
@final:
	mov dword ptr [esp+7*4],1
	popad
	ret
singlestep_xHandler endp
end start