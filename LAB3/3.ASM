	.model small
	.486
	.stack 100h
	.data
n	db	4 ; stolbec
m	db	4 ; stroka
matrix	dw	2, 1, 0, -4 
	dw	2, 3, -7, 5 
	dw	-4, 9, 4, 6
	dw	1, 2, 3, 4
	.code
	mov ax, @data
	mov ds, ax	
	mov es, ax
	cmp n, 0
	jle @er
	cmp m, 0
	jle @er
	movsx cx, m
	xor ax, ax
	xor bx, bx
	@loop_start:
	movsx ax, n
	shr ax, 1
	movsx dx, n
	push cx
	push ax
	xor ax, ax
	pop cx
	@loop2:
	push cx
	dec dx
	shl bx, 1
	shl ax, 1
	shl dx, 1
	add bx, ax
	mov cx, WORD PTR matrix[bx]
	push bx
	sub bx, ax
	add bx, dx
	xchg cx, WORD PTR matrix[bx]
	pop bx
	mov WORD PTR matrix[bx], cx
	sub bx, ax
	shr bx, 1
	shr ax, 1
	shr dx, 1
	inc ax	
	pop cx
	loop @loop2
	pop cx
	movsx ax, n 
	add bx, ax
	loop @loop_start
	mov ax, 4c00h
	@ex:
	int 21h
	@er:
	mov ax, 4c01h
	JMP @ex
	end