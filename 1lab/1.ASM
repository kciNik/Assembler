	.model small
	.stack 100h
	.486
	.data
a db 10
b db 20
c db -10
d db 5
e db 10
	.code
	mov ax, @data
	mov ds, ax
	movsx ax, b
	movsx bx, a
	add ax, bx
	push ax
	imul ax
	idiv bx
	mov bx, 3
	pop cx
	imul cx
	idiv bx
	push ax
	movsx ax, d
	imul ax
	movsx cx, d
	imul cx
	push eax
	movsx ax, c
	imul bx
	cwde
	pop ebx
	sub eax, ebx
	push eax
	movsx ax, e
	imul ax
	sal ax, 1
	mov bx, ax
	xor eax, eax
	xor edx, edx
	pop ax
	pop dx
	idiv bx
	movsx bx, a
	imul bx
	cwde
	mov ebx, eax
	pop ax
	cwde
	add eax, ebx
	mov ax, 4C00h
	int 21h
	end
	