.386
.model flat,stdcall
option casemap:none
include Seh.inc

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
	invoke MessageBox,NULL,addr szbuf,addr sztit,40h+1000h
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	call SetUnhandledExceptionFilter
	xor ebx,ebx
	mov eax,200
	cdq
	div ebx
	invoke MessageBox,0,addr sztmp1,addr sztit,40h
	xor eax,eax
	mov [eax],ebx
	invoke ExitProcess,0
_final_xHandler0:
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	mov esi,[eax]
	mov edi,[eax+4]
	test dword ptr [esi+4],1
	jnz @_final_cantdo
	test dword ptr [esi+4],6
	jnz @_final_unwind
	cmp dword ptr[esi],0C0000094h
	jnz @_final_cantdo
	mov dword ptr [edi+0a4h],10
	call dispMsg
	mov eax,EXCEPTION_CONTINUE_EXECUTION
	jmp @_final
@_final_unwind:
	invoke MessageBox,0,addr sztmp2,addr sztit,0
@_final_cantdo:
	mov eax,EXCEPTION_CONTINUE_SEARCH
	invoke MessageBox,0,addr szcantdo,addr sztit,0
	jmp @_final
@_final:
	mov esp,ebp
	pop ebp
	ret

dispMsg proc
	
	pushad
	mov eax,[esi]
	mov ebx,[esi+4]
	mov ecx,[edi+0b8h]
	mov edx,[edi+0a4h]
	invoke wsprintf,addr szbuf,addr fmt,ecx,edx,eax,ebx
	invoke MessageBox,0,addr szbuf,addr sztit,0
	popad
	ret

dispMsg endp
end start